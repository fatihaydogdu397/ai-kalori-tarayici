import 'api_client.dart';
import 'auth_service.dart';

/// Backend user endpoint'lerini saran servis.
/// Profile ve settings senkronizasyonu burada toplanır.
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final ApiClient _api = ApiClient.instance;

  // NOTE: `cuisinePreferences` geçici olarak query'den çıkarıldı. Bkz.
  // auth_service.dart aynı açıklama — backfill EAT-128 merge olunca geri ekle.
  static const String _userFields = '''
    id email name surname avatarUrl
    age height weight gender goal activityLevel
    dietType allergens dietRestrictions
    dietCookingTime dietBudget dietNotes
    mealsPerDay
    dailyCalorieGoal dailyProteinGoal dailyCarbsGoal dailyFatGoal
    waterGoal unitSystem locale isPremium streak
    createdAt updatedAt
  ''';

  Future<Map<String, dynamic>> me() => AuthService.instance.me();

  /// Backend'in `updateProfile` mutation'ını çağırır. Sadece null olmayan
  /// alanları gönderir. Enum alanları (gender/goal/activityLevel/unitSystem/
  /// dietType) backend GraphQL enum'larına uygun UPPERCASE değer ister.
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    int? age,
    double? height,
    double? weight,
    String? gender,
    String? goal,
    String? activityLevel,
    String? dietType,
    List<String>? allergens,
    List<String>? dietRestrictions,
    List<String>? cuisinePreferences,
    List<String>? dislikedFoodIds,
    String? dietCookingTime,
    String? dietBudget,
    String? dietNotes,
    int? mealsPerDay,
    double? dailyProteinGoal,
    double? dailyCarbsGoal,
    double? dailyFatGoal,
    double? waterGoal,
    String? unitSystem,
    String? locale,
  }) async {
    final input = <String, dynamic>{};
    if (name != null && name.isNotEmpty) input['name'] = name;
    if (age != null && age > 0) input['age'] = age;
    if (height != null && height > 0) input['height'] = height;
    if (weight != null && weight > 0) input['weight'] = weight;
    if (gender != null && gender.isNotEmpty) {
      input['gender'] = gender.toUpperCase();
    }
    if (goal != null && goal.isNotEmpty) input['goal'] = goal.toUpperCase();
    if (activityLevel != null && activityLevel.isNotEmpty) {
      input['activityLevel'] = activityLevel.toUpperCase();
    }
    if (dietType != null && dietType.isNotEmpty) {
      input['dietType'] = dietType.toUpperCase();
    }
    if (allergens != null) input['allergens'] = allergens;
    if (dietRestrictions != null) input['dietRestrictions'] = dietRestrictions;
    if (cuisinePreferences != null) {
      input['cuisinePreferences'] = cuisinePreferences;
    }
    if (dislikedFoodIds != null) {
      input['dislikes'] = dislikedFoodIds;
    }
    if (dietCookingTime != null && dietCookingTime.isNotEmpty) {
      input['dietCookingTime'] = dietCookingTime.toUpperCase();
    }
    if (dietBudget != null && dietBudget.isNotEmpty) {
      input['dietBudget'] = dietBudget.toUpperCase();
    }
    if (dietNotes != null) input['dietNotes'] = dietNotes;
    if (mealsPerDay != null && mealsPerDay > 0) {
      input['mealsPerDay'] = mealsPerDay;
    }
    if (dailyProteinGoal != null) input['dailyProteinGoal'] = dailyProteinGoal;
    if (dailyCarbsGoal != null) input['dailyCarbsGoal'] = dailyCarbsGoal;
    if (dailyFatGoal != null) input['dailyFatGoal'] = dailyFatGoal;
    if (waterGoal != null) input['waterGoal'] = waterGoal;
    if (unitSystem != null && unitSystem.isNotEmpty) {
      input['unitSystem'] = unitSystem.toUpperCase();
    }
    if (locale != null && locale.isNotEmpty) input['locale'] = locale;

    if (input.isEmpty) {
      return me();
    }

    final data = await _api.mutate(
      '''
      mutation UpdateProfile(\$input: UpdateProfileInput!) {
        updateProfile(input: \$input) { $_userFields }
      }
      ''',
      variables: {'input': input},
    );
    return Map<String, dynamic>.from(data['updateProfile'] as Map);
  }

  /// EAT-96: kullanıcı hesabını kalıcı olarak sil (GDPR).
  /// BE tüm user_id FK'li satırları cascade ile temizler.
  Future<bool> deleteAccount() async {
    final data = await _api.mutate(
      r'mutation DeleteAccount { deleteAccount }',
    );
    return data['deleteAccount'] == true;
  }
}
