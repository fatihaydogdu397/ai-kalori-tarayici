import 'api_client.dart';

/// Backend food/meal endpoint'lerini saran servis.
/// Tüm yanıtlar `Map<String, dynamic>` olarak döner; parse işi `FoodAnalysis.fromBackend`
/// factory'sinde yapılır.
class FoodService {
  FoodService._();
  static final FoodService instance = FoodService._();

  final ApiClient _api = ApiClient.instance;

  static const String _analysisFields = '''
    id imageUrl summary advice analyzedAt mealCategory isFavorite
    totalCalories totalProtein totalCarbs totalFat totalFiber totalSugar
    createdAt
    foods {
      id name nameTr portion portionUnit
      calories protein carbs fat fiber sugar
      healthScore tags
    }
  ''';

  /// Barkod ile ürün nutrition bilgisi (OpenFoodFacts üzerinden BE).
  Future<Map<String, dynamic>?> lookupBarcode(String barcode) async {
    final data = await _api.query(
      r'''
      query LookupBarcode($barcode: String!) {
        lookupBarcode(barcode: $barcode) {
          barcode name nameTr brand imageUrl
          caloriesPer100g proteinPer100g carbsPer100g fatPer100g
          fiberPer100g sugarPer100g
        }
      }
      ''',
      variables: {'barcode': barcode},
    );
    final r = data['lookupBarcode'];
    if (r == null) return null;
    return Map<String, dynamic>.from(r as Map);
  }

  /// Kamera/galeri'den alınan resmi BE'ye gönder, AI analizini al.
  /// [imageBase64] dataURI prefix OLMADAN saf base64 olmalı.
  /// [mealCategory] null ise BE otomatik belirler.
  /// [portionAmount] gram (solid) veya ml (liquid) cinsinden; 1–5000 arası.
  /// [cookingMethod] BE `CookingMethod` enum değeri (RAW/GRILLED/... büyük harf).
  Future<Map<String, dynamic>> analyzeFood({
    required String imageBase64,
    String? mealCategory,
    int? portionAmount,
    bool? isLiquid,
    String? cookingMethod,
  }) async {
    final input = <String, dynamic>{'imageBase64': imageBase64};
    if (mealCategory != null && mealCategory.isNotEmpty) {
      input['mealCategory'] = mealCategory.toUpperCase();
    }
    if (portionAmount != null) {
      input['portionAmount'] = portionAmount;
    }
    if (isLiquid != null) {
      input['isLiquid'] = isLiquid;
    }
    if (cookingMethod != null && cookingMethod.isNotEmpty) {
      input['cookingMethod'] = cookingMethod;
    }

    final data = await _api.mutate(
      '''
      mutation AnalyzeFood(\$input: AnalyzeFoodInput!) {
        analyzeFood(input: \$input) { $_analysisFields }
      }
      ''',
      variables: {'input': input},
    );
    return Map<String, dynamic>.from(data['analyzeFood'] as Map);
  }

  /// Manuel giriş veya barkod sonrası kullanıcının onayladığı değerleri kaydet.
  Future<Map<String, dynamic>> saveFoodAnalysis({
    required String name,
    required double portion,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required String mealCategory,
  }) async {
    final input = {
      'name': name,
      'portion': portion,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'mealCategory': mealCategory.toUpperCase(),
    };

    final data = await _api.mutate(
      '''
      mutation SaveFoodAnalysis(\$input: ManualFoodInput!) {
        saveFoodAnalysis(input: \$input) { $_analysisFields }
      }
      ''',
      variables: {'input': input},
    );
    return Map<String, dynamic>.from(data['saveFoodAnalysis'] as Map);
  }

  /// Sayfalanabilir tam geçmiş (tarih filtresiz).
  Future<List<Map<String, dynamic>>> foodHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    final data = await _api.query(
      '''
      query FoodHistory(\$limit: Int!, \$offset: Int!) {
        foodHistory(limit: \$limit, offset: \$offset) { $_analysisFields }
      }
      ''',
      variables: {'limit': limit, 'offset': offset},
    );
    final list = (data['foodHistory'] as List?) ?? const [];
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }

  /// Sadece verilen UTC günün yemekleri (EAT-97).
  /// [date] YYYY-MM-DD formatında.
  Future<List<Map<String, dynamic>>> getDailyMeals(String date) async {
    final data = await _api.query(
      '''
      query GetDailyMeals(\$date: String!) {
        getDailyMeals(date: \$date) { $_analysisFields }
      }
      ''',
      variables: {'date': date},
    );
    final list = (data['getDailyMeals'] as List?) ?? const [];
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }

  /// Idempotent favorite toggle (EAT-98). Aynı değeri tekrar göndermek no-op.
  Future<Map<String, dynamic>> toggleFavoriteMeal(
      String mealId, bool isFavorite) async {
    final data = await _api.mutate(
      '''
      mutation ToggleFavoriteMeal(\$mealId: ID!, \$isFavorite: Boolean!) {
        toggleFavoriteMeal(mealId: \$mealId, isFavorite: \$isFavorite) { $_analysisFields }
      }
      ''',
      variables: {'mealId': mealId, 'isFavorite': isFavorite},
    );
    return Map<String, dynamic>.from(data['toggleFavoriteMeal'] as Map);
  }

  /// EAT-99: sadece aynı gün içinde kaydedilen yemekler silinebilir.
  Future<bool> deleteMeal(String mealId) async {
    final data = await _api.mutate(
      r'''
      mutation DeleteMeal($mealId: ID!) {
        deleteMeal(mealId: $mealId)
      }
      ''',
      variables: {'mealId': mealId},
    );
    return data['deleteMeal'] == true;
  }
}
