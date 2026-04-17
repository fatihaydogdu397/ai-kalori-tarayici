import 'api_client.dart';

/// Backend nutrition endpoint'lerini saran servis.
/// `foods` query'si BE tarafında USDA FDC veritabanını döner
/// (per 100g nutrition değerleri).
class NutritionService {
  NutritionService._();
  static final NutritionService instance = NutritionService._();

  final ApiClient _api = ApiClient.instance;

  static const String _foodFields = '''
    id fdcId name category
    calories protein fat carbs fiber sugar
  ''';

  /// [search] bulanık arama, [category] tam kategori eşleşmesi.
  Future<List<Map<String, dynamic>>> foods({
    String? search,
    String? category,
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
    return list
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);
  }

  Future<List<String>> foodCategories() async {
    final data = await _api.query(r'query FoodCategories { foodCategories }');
    return List<String>.from(data['foodCategories'] as List? ?? const []);
  }
}
