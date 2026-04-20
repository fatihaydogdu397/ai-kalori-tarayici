import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
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
      if (!isRetry && await _tryRefreshToken()) {
        return _execute(
          document: document,
          variables: variables,
          operationName: operationName,
          requiresAuth: requiresAuth,
          isRetry: true,
        );
      }
      await _handleAuthFailure();
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

      if (code == 'UNAUTHENTICATED' && !isRetry) {
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
  // kDebugMode dışında no-op. `developer.log` Flutter DevTools Network
  // panelinde ve Xcode/adb log'unda görünür.

  static const String _tag = 'ApiClient';

  String _opLabel(String? operationName, String document) {
    if (operationName != null && operationName.isNotEmpty) return operationName;
    // Anonymous query/mutation → first meaningful word after `query`/`mutation`.
    final m = RegExp(r'(query|mutation)\s+(\w+)').firstMatch(document);
    if (m != null) return m.group(2)!;
    return 'anonymous';
  }

  void _logRequest(
    String? operationName,
    String document,
    Map<String, dynamic>? variables,
  ) {
    if (!kDebugMode) return;
    final op = _opLabel(operationName, document);
    final vars = variables == null ? '' : ' vars=${jsonEncode(variables)}';
    developer.log('→ $op$vars', name: _tag);
  }

  void _logResponse(
    String? operationName,
    int status,
    String body,
    Duration elapsed,
  ) {
    if (!kDebugMode) return;
    final op = _opLabel(operationName, '');
    final ms = elapsed.inMilliseconds;
    final trimmed = body.length > 800 ? '${body.substring(0, 800)}…' : body;
    developer.log('← $op [${status}] ${ms}ms $trimmed', name: _tag);
  }

  void _logError(String? operationName, String message, Duration elapsed) {
    if (!kDebugMode) return;
    final op = _opLabel(operationName, '');
    developer.log('✗ $op ${elapsed.inMilliseconds}ms $message', name: _tag);
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
    await _storage.clear();
    final cb = onLogout;
    if (cb != null) {
      await cb();
    }
  }

  void dispose() {
    _http.close();
  }
}
