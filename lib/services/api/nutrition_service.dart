import 'api_client.dart';

/// Backend nutrition endpoint'lerini saran servis.
/// `foods` query'si BE tarafında USDA FDC veritabanını döner
/// (per 100g nutrition değerleri).
class NutritionService {
  NutritionService._();
  static final NutritionService instance = NutritionService._();

  final ApiClient _api = ApiClient.instance;

  // EAT-92 / EAT-136: dietTags + mealTags + allergens istek üzerine döner.
  static const String _foodFields = '''
    id fdcId name category
    calories protein fat carbs fiber sugar
    dietTags mealTags allergens isIngredient
  ''';

  /// [search] bulanık arama, [category] tam kategori eşleşmesi.
  /// EAT-136 follow-up: BE `FoodsFilterInput`'ta henüz `tags` alanı yok;
  /// chip'ler client-side filter uygular — [dietTagFilter] verilirse bu
  /// metot sonuçları `dietTags ⊇ dietTagFilter` olanlara düşürür.
  Future<List<Map<String, dynamic>>> foods({
    String? search,
    String? category,
    List<String>? dietTagFilter,
    int limit = 50,
    int offset = 0,
  }) async {
    final filter = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      filter['search'] = search.trim();
    }
    if (category != null && category.isNotEmpty) {
      filter['category'] = category;
    }

    final data = await _api.query(
      '''
      query Foods(\$limit: Int!, \$offset: Int!, \$filter: FoodsFilterInput) {
        foods(limit: \$limit, offset: \$offset, filter: \$filter) { $_foodFields }
      }
      ''',
      variables: {
        'limit': limit,
        'offset': offset,
        if (filter.isNotEmpty) 'filter': filter,
      },
    );
    final list = (data['foods'] as List?) ?? const [];
    var rows = list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);

    if (dietTagFilter != null && dietTagFilter.isNotEmpty) {
      final want = dietTagFilter.map((t) => t.toLowerCase()).toSet();
      rows = rows.where((row) {
        final tags = (row['dietTags'] as List?)
                ?.map((e) => (e as String).toLowerCase())
                .toSet() ??
            <String>{};
        return want.every(tags.contains);
      }).toList(growable: false);
    }
    return rows;
  }

  Future<int> foodsCount({String? search, String? category}) async {
    final filter = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      filter['search'] = search.trim();
    }
    if (category != null && category.isNotEmpty) {
      filter['category'] = category;
    }
    final data = await _api.query(
      r'query FoodsCount($filter: FoodsFilterInput) { foodsCount(filter: $filter) }',
      variables: {if (filter.isNotEmpty) 'filter': filter},
    );
    return (data['foodsCount'] as num?)?.toInt() ?? 0;
  }

  Future<List<String>> foodCategories() async {
    final data = await _api.query(r'query FoodCategories { foodCategories }');
    return List<String>.from(data['foodCategories'] as List? ?? const []);
  }

  /// EAT-117: BE'nin kanonik diyet/kısıtlama/allergen listesi.
  /// Client-side hardcoded liste yerine onboarding / anamnez formlarında
  /// bundan beslenir.
  Future<List<DietaryPreferenceOption>> dietaryPreferenceOptions() async {
    final data = await _api.query(
      r'''
      query DietaryPreferenceOptions {
        dietaryPreferenceOptions { key defaultLabel category writeTokens }
      }
      ''',
    );
    final list = (data['dietaryPreferenceOptions'] as List?) ?? const [];
    return list
        .map((e) => DietaryPreferenceOption.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList(growable: false);
  }

  /// EAT-96 / EAT-138: kullanıcının dietType + allergens + dislikes'ına göre
  /// BE'nin önerdiği tek öğünün malzeme kırılımı.
  Future<RecommendedMeal?> recommendMeal(String mealCategory) async {
    final data = await _api.query(
      r'''
      query RecommendMeal($mealCategory: MealCategory!) {
        recommendMeal(mealCategory: $mealCategory) {
          mealCategory
          targetCalories targetProtein targetCarbs targetFat
          actualCalories actualProtein actualCarbs actualFat
          items {
            food { id name category calories protein fat carbs }
            portionGrams calories protein carbs fat role
          }
        }
      }
      ''',
      variables: {'mealCategory': mealCategory.toUpperCase()},
    );
    final raw = data['recommendMeal'];
    if (raw == null) return null;
    return RecommendedMeal.fromJson(Map<String, dynamic>.from(raw as Map));
  }
}

/// EAT-117 → DietaryPreferenceOption.
class DietaryPreferenceOption {
  final String key;
  final String defaultLabel;
  final String category; // DIET_TYPE | RESTRICTION | ALLERGEN
  final List<String> writeTokens;

  const DietaryPreferenceOption({
    required this.key,
    required this.defaultLabel,
    required this.category,
    required this.writeTokens,
  });

  factory DietaryPreferenceOption.fromJson(Map<String, dynamic> j) =>
      DietaryPreferenceOption(
        key: (j['key'] ?? '') as String,
        defaultLabel: (j['defaultLabel'] ?? '') as String,
        category: (j['category'] ?? '') as String,
        writeTokens:
            ((j['writeTokens'] as List?) ?? const []).cast<String>().toList(),
      );
}

/// EAT-138 → RecommendedMeal (ingredient-level plate).
class RecommendedMeal {
  final String mealCategory;
  final double targetCalories;
  final double actualCalories;
  final double actualProtein;
  final double actualCarbs;
  final double actualFat;
  final List<RecommendedFoodItem> items;

  const RecommendedMeal({
    required this.mealCategory,
    required this.targetCalories,
    required this.actualCalories,
    required this.actualProtein,
    required this.actualCarbs,
    required this.actualFat,
    required this.items,
  });

  factory RecommendedMeal.fromJson(Map<String, dynamic> j) => RecommendedMeal(
        mealCategory: (j['mealCategory'] ?? '') as String,
        targetCalories: (j['targetCalories'] as num?)?.toDouble() ?? 0,
        actualCalories: (j['actualCalories'] as num?)?.toDouble() ?? 0,
        actualProtein: (j['actualProtein'] as num?)?.toDouble() ?? 0,
        actualCarbs: (j['actualCarbs'] as num?)?.toDouble() ?? 0,
        actualFat: (j['actualFat'] as num?)?.toDouble() ?? 0,
        items: ((j['items'] as List?) ?? const [])
            .map((e) => RecommendedFoodItem.fromJson(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}

class RecommendedFoodItem {
  final String foodId;
  final String name;
  final double portionGrams;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String role;

  const RecommendedFoodItem({
    required this.foodId,
    required this.name,
    required this.portionGrams,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.role,
  });

  factory RecommendedFoodItem.fromJson(Map<String, dynamic> j) {
    final food = Map<String, dynamic>.from((j['food'] ?? const {}) as Map);
    return RecommendedFoodItem(
      foodId: (food['id'] ?? '') as String,
      name: (food['name'] ?? '') as String,
      portionGrams: (j['portionGrams'] as num?)?.toDouble() ?? 0,
      calories: (j['calories'] as num?)?.toDouble() ?? 0,
      protein: (j['protein'] as num?)?.toDouble() ?? 0,
      carbs: (j['carbs'] as num?)?.toDouble() ?? 0,
      fat: (j['fat'] as num?)?.toDouble() ?? 0,
      role: (j['role'] ?? '') as String,
    );
  }
}
