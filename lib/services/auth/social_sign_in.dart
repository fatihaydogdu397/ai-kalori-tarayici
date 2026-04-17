import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Native social sign-in entry points. Her metot başarı halinde backend'in
/// `socialLogin` mutation'ına geçilecek idToken'ı döndürür. Kullanıcı iptal
/// ederse `null` döner; gerçek hatalar exception olarak yukarı çıkar.
class SocialSignIn {
  SocialSignIn._();

  // ── Google ────────────────────────────────────────────────────────────────

  static final GoogleSignIn _google = GoogleSignIn(
    scopes: const ['email', 'profile'],
  );

  static Future<String?> google() async {
    // Önceki oturumu temizle, account picker'ı her seferinde göster.
    await _google.signOut();
    final account = await _google.signIn();
    if (account == null) return null; // user cancelled
    final auth = await account.authentication;
    return auth.idToken;
  }

  // ── Apple ─────────────────────────────────────────────────────────────────

  /// Apple Sign In iOS 13+ ve macOS 10.15+. Android için webview fallback —
  /// bu akışta backend `sign_in_with_apple` web redirect yapılandırması ister;
  /// şimdilik yalnızca iOS/macOS çağırıyoruz.
  static Future<String?> apple() async {
    if (!(Platform.isIOS || Platform.isMacOS)) {
      throw UnsupportedError('Apple Sign In only supported on iOS/macOS');
    }
    final rawNonce = _randomNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      return credential.identityToken;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static String _randomNonce({int length = 32}) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._';
    final r = Random.secure();
    return List.generate(length, (_) => charset[r.nextInt(charset.length)])
        .join();
  }
}
