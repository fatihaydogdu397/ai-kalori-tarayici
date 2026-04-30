import 'api_client.dart';
import 'token_storage.dart';

/// Backend auth endpoint'lerini saran servis.
/// Başarılı login/signup/socialLogin sonrası token'ı TokenStorage'a yazar.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final ApiClient _api = ApiClient.instance;
  final TokenStorage _storage = TokenStorage();

  // NOTE: `cuisinePreferences` geçici olarak query'den çıkarıldı. BE'de kolon
  // non-nullable (@Field([String]) nullable:true yok) ama legacy user satırlarında
  // DB'de NULL değerler var → GraphQL `Cannot return null for non-nullable field`
  // atıp tüm login/me response'unu bozuyordu. Backfill (EAT-128) + mutation tarafı
  // `updateProfile` send'i korunuyor; backfill merge olunca aşağı geri eklenecek.
  static const String _userFields = '''
    id email name surname avatarUrl
    age height weight gender goal activityLevel
    dietType dietTypes allergens
    dietCookingTime dietBudget dietNotes
    mealsPerDay
    dailyCalorieGoal dailyProteinGoal dailyCarbsGoal dailyFatGoal
    idealWeightMin idealWeightMax
    waterGoal unitSystem locale isPremium streak
    createdAt updatedAt
  ''';

  // ── Email / Password ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _api.mutate(
      '''
      mutation Login(\$input: LoginInput!) {
        login(input: \$input) {
          accessToken
          refreshToken
          user { $_userFields }
        }
      }
      ''',
      variables: {
        'input': {'email': email, 'password': password},
      },
      requiresAuth: false,
    );
    return _persistAuth(data['login']);
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final data = await _api.mutate(
      '''
      mutation Signup(\$input: SignupInput!) {
        signup(input: \$input) {
          accessToken
          refreshToken
          user { $_userFields }
        }
      }
      ''',
      variables: {
        'input': {
          'name': name,
          'surname': surname,
          'email': email,
          'password': password,
        },
      },
      requiresAuth: false,
    );
    return _persistAuth(data['signup']);
  }

  // ── Social (Google / Apple / Facebook) ─────────────────────────────────────

  /// provider: "GOOGLE" | "APPLE" | "FACEBOOK"
  /// idToken: OAuth idToken (provider SDK'sından alınır)
  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String idToken,
  }) async {
    final data = await _api.mutate(
      '''
      mutation SocialLogin(\$input: SocialLoginInput!) {
        socialLogin(input: \$input) {
          accessToken
          refreshToken
          user { $_userFields }
        }
      }
      ''',
      variables: {
        'input': {'provider': provider.toUpperCase(), 'idToken': idToken},
      },
      requiresAuth: false,
    );
    return _persistAuth(data['socialLogin']);
  }

  // ── Forgot / Verify / Reset ────────────────────────────────────────────────

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final data = await _api.mutate(
      '''
      mutation ForgotPassword(\$input: ForgotPasswordInput!) {
        forgotPassword(input: \$input) {
          success
          retryAfterSeconds
        }
      }
      ''',
      variables: {
        'input': {'email': email},
      },
      requiresAuth: false,
    );
    return Map<String, dynamic>.from(data['forgotPassword'] as Map);
  }

  Future<bool> verifyOtp({required String email, required String code}) async {
    final data = await _api.mutate(
      '''
      mutation VerifyOtp(\$input: VerifyOtpInput!) {
        verifyOtp(input: \$input)
      }
      ''',
      variables: {
        'input': {'email': email, 'code': code},
      },
      requiresAuth: false,
    );
    return data['verifyOtp'] == true;
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    final data = await _api.mutate(
      '''
      mutation ResetPassword(\$input: ResetPasswordInput!) {
        resetPassword(input: \$input)
      }
      ''',
      variables: {
        'input': {
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      },
      requiresAuth: false,
    );
    return data['resetPassword'] == true;
  }

  // ── Me / Logout ────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> me() async {
    final data = await _api.query(
      '''
      query Me { me { $_userFields } }
      ''',
    );
    return Map<String, dynamic>.from(data['me'] as Map);
  }

  Future<void> logout() async {
    // Logout token'sız da çağrılabilmeli — aksi halde 401 → onLogout → logout
    // sonsuz döngüsüne girer. `requiresAuth: false` ile ApiClient 401 handler'ı
    // tetikleme yolunu kapatıyoruz; BE yine de gelen Bearer'ı (varsa) görür.
    try {
      await _api.mutate(r'mutation Logout { logout }', requiresAuth: false);
    } catch (_) {
      // Server tarafı başarısız olsa bile client oturumu temizle.
    } finally {
      await _storage.clear();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _persistAuth(dynamic payload) async {
    final map = Map<String, dynamic>.from(payload as Map);
    await _storage.save(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
    return map;
  }
}
