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
  Future<Map<String, dynamic>> analyzeFood({
    required String imageBase64,
    String? mealCategory,
  }) async {
    final input = <String, dynamic>{'imageBase64': imageBase64};
    if (mealCategory != null && mealCategory.isNotEmpty) {
      input['mealCategory'] = mealCategory.toUpperCase();
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

  Future<Map<String, dynamic>> toggleFavorite(String id) async {
    final data = await _api.mutate(
      '''
      mutation ToggleFavorite(\$id: ID!) {
        toggleFavorite(id: \$id) { $_analysisFields }
      }
      ''',
      variables: {'id': id},
    );
    return Map<String, dynamic>.from(data['toggleFavorite'] as Map);
  }

  Future<bool> deleteFoodAnalysis(String id) async {
    final data = await _api.mutate(
      r'''
      mutation DeleteFoodAnalysis($id: ID!) {
        deleteFoodAnalysis(id: $id)
      }
      ''',
      variables: {'id': id},
    );
    return data['deleteFoodAnalysis'] == true;
  }
}
