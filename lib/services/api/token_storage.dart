import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessKey = 'eatiq_access_token';
  static const _refreshKey = 'eatiq_refresh_token';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  Future<void> save({required String accessToken, required String refreshToken}) async {
    try {
      await _storage.write(key: _accessKey, value: accessToken);
      await _storage.write(key: _refreshKey, value: refreshToken);
    } catch (e) {
      debugPrint('[TokenStorage] save failed: $e');
    }
  }

  Future<String?> readAccessToken() async {
    try {
      return await _storage.read(key: _accessKey);
    } catch (e) {
      debugPrint('[TokenStorage] readAccessToken failed: $e');
      return null;
    }
  }

  Future<String?> readRefreshToken() async {
    try {
      return await _storage.read(key: _refreshKey);
    } catch (e) {
      debugPrint('[TokenStorage] readRefreshToken failed: $e');
      return null;
    }
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } catch (e) {
      debugPrint('[TokenStorage] clear failed: $e');
    }
  }

  Future<bool> hasSession() async {
    final t = await readAccessToken();
    return t != null && t.isNotEmpty;
  }
}
