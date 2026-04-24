import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../offline/mutation_queue.dart';
import 'api_exception.dart';
import 'token_storage.dart';

typedef LogoutCallback = Future<void> Function();

/// Merkezi GraphQL client. Tüm query/mutation buradan geçer.
/// - Token'ı otomatik Authorization header'a ekler
/// - 401/UNAUTHENTICATED gelirse refreshToken ile 1 kez retry dener
/// - Refresh başarısızsa onLogout callback'i tetikler
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final TokenStorage _storage = TokenStorage();
  final http.Client _http = http.Client();

  /// AppProvider.logout()'u buraya bağlayacağız (auth bootstrap'ta).
  LogoutCallback? onLogout;

  /// Re-entrancy guard: onLogout callback'i içinden yapılan istek de 401
  /// alırsa ikinci kez tetiklenip logout→logout sonsuz döngüsüne girmesin.
  bool _handlingAuthFailure = false;

  // EAT-123: endpoint compile-time'da `--dart-define=API_BASE_URL=...` ile
  // inject edilir. Bundled .env kaldırıldı — hiçbir secret APK/IPA'ya girmez.
  //
  // Dev convenience: `--dart-define` geçilmediyse debug build'de otomatik
  // `http://localhost:4000/graphql` fallback kullanılır. Release build'de
  // fallback yok → explicit `--dart-define=API_BASE_URL=...` zorunlu.
  static const String _apiBaseUrlEnv = String.fromEnvironment('API_BASE_URL');
  static const String _devFallbackUrl = 'http://localhost:4000/graphql';

  Uri get _uri {
    final url = _apiBaseUrlEnv.isNotEmpty
        ? _apiBaseUrlEnv
        : (kReleaseMode ? '' : _devFallbackUrl);
    if (url.isEmpty) {
      throw ApiException(
        'API_BASE_URL not set. Build with --dart-define=API_BASE_URL=<url>.',
        code: 'CONFIG_ERROR',
      );
    }
    return Uri.parse(url);
  }

  Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic>? variables,
    String? operationName,
    bool requiresAuth = true,
  }) {
    return _execute(
      document: document,
      variables: variables,
      operationName: operationName,
      requiresAuth: requiresAuth,
    );
  }

  Future<Map<String, dynamic>> mutate(
    String document, {
    Map<String, dynamic>? variables,
    String? operationName,
    bool requiresAuth = true,
  }) {
    return _execute(
      document: document,
      variables: variables,
      operationName: operationName,
      requiresAuth: requiresAuth,
    );
  }

  Future<Map<String, dynamic>> _execute({
    required String document,
    Map<String, dynamic>? variables,
    String? operationName,
    required bool requiresAuth,
    bool isRetry = false,
  }) async {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
    }

    final body = jsonEncode({
      'query': document,
      if (variables != null) 'variables': variables,
      if (operationName != null) 'operationName': operationName,
    });

    _logRequest(operationName, document, variables);
    final sw = Stopwatch()..start();

    http.Response res;
    try {
      res = await _http
          .post(_uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
    } on SocketException catch (e) {
      _logError(operationName, 'SocketException: ${e.message}', sw.elapsed);
      throw await _networkFailure(
        operationName: operationName,
        document: document,
        variables: variables,
        requiresAuth: requiresAuth,
        isRetry: isRetry,
        message: 'Connection failed: ${e.message}',
      );
    } on TimeoutException {
      _logError(operationName, 'TimeoutException', sw.elapsed);
      throw await _networkFailure(
        operationName: operationName,
        document: document,
        variables: variables,
        requiresAuth: requiresAuth,
        isRetry: isRetry,
        message: 'Request timed out',
      );
    } catch (e) {
      _logError(operationName, 'Network error: $e', sw.elapsed);
      throw await _networkFailure(
        operationName: operationName,
        document: document,
        variables: variables,
        requiresAuth: requiresAuth,
        isRetry: isRetry,
        message: 'Network error: $e',
      );
    }

    _logResponse(operationName, res.statusCode, res.body, sw.elapsed);

    if (res.statusCode == 401 || res.statusCode == 403) {
      if (requiresAuth && !isRetry && await _tryRefreshToken()) {
        return _execute(
          document: document,
          variables: variables,
          operationName: operationName,
          requiresAuth: requiresAuth,
          isRetry: true,
        );
      }
      if (requiresAuth) {
        await _handleAuthFailure();
      }
      throw ApiException('Authentication required',
          code: 'UNAUTHENTICATED', statusCode: res.statusCode);
    }

    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Invalid server response (${res.statusCode})',
          statusCode: res.statusCode);
    }

    if (decoded['errors'] is List && (decoded['errors'] as List).isNotEmpty) {
      final first = (decoded['errors'] as List).first as Map<String, dynamic>;
      final message = first['message']?.toString() ?? 'GraphQL error';
      final ext = first['extensions'] as Map<String, dynamic>?;
      final code = ext?['code']?.toString();

      if (code == 'UNAUTHENTICATED' && requiresAuth && !isRetry) {
        if (await _tryRefreshToken()) {
          return _execute(
            document: document,
            variables: variables,
            operationName: operationName,
            requiresAuth: requiresAuth,
            isRetry: true,
          );
        }
        await _handleAuthFailure();
      }

      throw ApiException(message,
          code: code, statusCode: res.statusCode, extensions: ext);
    }

    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException('Missing data in response', statusCode: res.statusCode);
    }
    return data;
  }

  // ── Debug logging ──────────────────────────────────────────────────────────
  // kDebugMode dışında no-op. `debugPrint` VS Code Debug Console'da,
  // `flutter run` terminalinde ve Xcode/adb log'unda görünür.

  static const String _tag = 'ApiClient';

  String _opLabel(String? operationName, String document) {
    if (operationName != null && operationName.isNotEmpty) return operationName;
    final m = RegExp(r'(query|mutation)\s+(\w+)').firstMatch(document);
    if (m != null) return m.group(2)!;
    return 'anonymous';
  }

  void _log(String message) {
    if (!kDebugMode) return;
    for (var i = 0; i < message.length; i += 900) {
      final end = (i + 900 < message.length) ? i + 900 : message.length;
      debugPrint('[$_tag] ${message.substring(i, end)}');
    }
  }

  void _logRequest(
    String? operationName,
    String document,
    Map<String, dynamic>? variables,
  ) {
    final op = _opLabel(operationName, document);
    final vars = variables == null ? '' : ' vars=${jsonEncode(_redact(variables))}';
    _log('→ $op$vars');
  }

  // EAT-124 (2f): request variables log'larında sensitive alanları redact et.
  // Nested input objeleri için recursive (ör. `{input: {password: ...}}`).
  // Release build'de _log zaten no-op — bu ek guard debug sızıntısı regression'ı
  // için.
  static const Set<String> _redactedKeys = {
    'password',
    'newPassword',
    'currentPassword',
    'refreshToken',
    'idToken',
    'accessToken',
    'token',
    'code',
    'otp',
    'imageBase64',
    'base64',
  };

  dynamic _redact(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(
            k,
            _redactedKeys.contains(k) ? '***REDACTED***' : _redact(v),
          ));
    }
    if (value is List) {
      return value.map(_redact).toList();
    }
    return value;
  }

  void _logResponse(
    String? operationName,
    int status,
    String body,
    Duration elapsed,
  ) {
    final op = _opLabel(operationName, '');
    _log('← $op [$status] ${elapsed.inMilliseconds}ms $body');
  }

  void _logError(String? operationName, String message, Duration elapsed) {
    final op = _opLabel(operationName, '');
    _log('✗ $op ${elapsed.inMilliseconds}ms $message');
  }

  /// EAT-141 — if the operation is whitelisted and this isn't already a retry,
  /// persist the failed mutation so it can be replayed when connectivity
  /// returns. Returns an `ApiException` with code `QUEUED` on success,
  /// `NETWORK_ERROR` on any fall-through.
  Future<ApiException> _networkFailure({
    required String? operationName,
    required String document,
    required Map<String, dynamic>? variables,
    required bool requiresAuth,
    required bool isRetry,
    required String message,
  }) async {
    final name = _opLabel(operationName, document);
    if (requiresAuth && !isRetry && MutationQueue.isWhitelisted(name)) {
      try {
        await MutationQueue.instance.enqueue(
          operationName: name,
          document: document,
          variables: variables ?? const {},
        );
        return ApiException('Queued for sync', code: 'QUEUED');
      } catch (_) {
        // Fall through — caller will see a normal network error.
      }
    }
    return ApiException(message, code: 'NETWORK_ERROR');
  }

  /// EAT-141 — replay every pending mutation in FIFO order. Stops early on the
  /// first `NETWORK_ERROR` (still offline). Called on reconnect and at
  /// bootstrap after a successful login.
  Future<void> replayPendingMutations() async {
    final queue = MutationQueue.instance;
    await queue.purgeOld();
    final items = await queue.pending();
    for (final item in items) {
      try {
        await _execute(
          document: item.document,
          variables: item.variables,
          operationName: item.operationName,
          requiresAuth: true,
          isRetry: true,
        );
        await queue.markSuccess(item.id);
      } on ApiException catch (e) {
        if (e.code == 'NETWORK_ERROR' || e.code == 'QUEUED') {
          // Still offline — leave the rest of the queue intact.
          break;
        }
        await queue.markFailed(item.id, e.message);
      } catch (e) {
        await queue.markFailed(item.id, e.toString());
      }
    }
  }

  Future<bool> _tryRefreshToken() async {
    final refresh = await _storage.readRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    const mutation = r'''
      mutation RefreshToken($token: String!) {
        refreshToken(token: $token) {
          accessToken
          refreshToken
        }
      }
    ''';

    try {
      final res = await _http.post(
        _uri,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          'query': mutation,
          'variables': {'token': refresh},
        }),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode != 200) return false;
      final decoded = jsonDecode(res.body) as Map<String, dynamic>;
      if (decoded['errors'] != null) return false;
      final data = decoded['data']?['refreshToken'] as Map<String, dynamic>?;
      if (data == null) return false;

      final newAccess = data['accessToken']?.toString();
      final newRefresh = data['refreshToken']?.toString();
      if (newAccess == null || newRefresh == null) return false;

      await _storage.save(accessToken: newAccess, refreshToken: newRefresh);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _handleAuthFailure() async {
    if (_handlingAuthFailure) return;
    _handlingAuthFailure = true;
    try {
      await _storage.clear();
      final cb = onLogout;
      if (cb != null) {
        await cb();
      }
    } finally {
      _handlingAuthFailure = false;
    }
  }

  void dispose() {
    _http.close();
  }
}
