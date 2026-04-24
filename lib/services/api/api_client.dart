import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  Uri get _uri {
    final url = dotenv.env['API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw ApiException('API_BASE_URL missing in .env', code: 'CONFIG_ERROR');
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
      throw ApiException('Connection failed: ${e.message}',
          code: 'NETWORK_ERROR');
    } on TimeoutException {
      _logError(operationName, 'TimeoutException', sw.elapsed);
      throw ApiException('Request timed out', code: 'NETWORK_ERROR');
    } catch (e) {
      _logError(operationName, 'Network error: $e', sw.elapsed);
      throw ApiException('Network error: $e', code: 'NETWORK_ERROR');
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
    final vars = variables == null ? '' : ' vars=${jsonEncode(variables)}';
    _log('→ $op$vars');
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
