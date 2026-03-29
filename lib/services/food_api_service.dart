import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_analysis.dart';

class FoodApiService {
  static const _base = 'https://world.openfoodfacts.org/api/v2/product';

  /// Barkoddan ürün bilgisi çeker. Bulunamazsa null döner.
  Future<FoodAnalysis?> fetchByBarcode(String barcode) async {
    try {
      final uri = Uri.parse(
        '$_base/$barcode.json?fields=product_name,nutriments,serving_size,image_url',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return null;

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['status'] != 1) return null;

      final product = json['product'] as Map<String, dynamic>;
      final n = (product['nutriments'] as Map<String, dynamic>?) ?? {};

      double d(String key) => (n[key] as num?)?.toDouble() ?? 0.0;

      // Per 100g değerlerini kullan, serving_size varsa onu dönüştür
      final servingStr = (product['serving_size'] as String?) ?? '';
      final servingG = _parseGrams(servingStr) ?? 100.0;
      final factor = servingG / 100.0;

      final cal  = (d('energy-kcal_100g') > 0 ? d('energy-kcal_100g') : d('energy_100g') / 4.184) * factor;
      final prot = d('proteins_100g') * factor;
      final carb = d('carbohydrates_100g') * factor;
      final fat  = d('fat_100g') * factor;
      final fib  = d('fiber_100g') * factor;
      final sug  = d('sugars_100g') * factor;

      final name = (product['product_name'] as String?)?.trim() ?? 'Ürün ($barcode)';

      return FoodAnalysis(
        id: 'barcode_${barcode}_${DateTime.now().millisecondsSinceEpoch}',
        imagePath: (product['image_url'] as String?) ?? '',
        foods: [
          FoodItem(
            name: name,
            nameTr: name,
            portion: servingG,
            portionUnit: 'g',
            nutrients: NutrientInfo(
              calories: cal,
              protein: prot,
              carbs: carb,
              fat: fat,
              fiber: fib,
              sugar: sug,
            ),
            healthScore: 'Orta',
            tags: ['barcode'],
          ),
        ],
        totalNutrients: NutrientInfo(
          calories: cal,
          protein: prot,
          carbs: carb,
          fat: fat,
          fiber: fib,
          sugar: sug,
        ),
        summary: name,
        advice: '',
        analyzedAt: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }

  double? _parseGrams(String s) {
    if (s.isEmpty) return null;
    final match = RegExp(r'([\d.]+)\s*g', caseSensitive: false).firstMatch(s);
    if (match != null) return double.tryParse(match.group(1)!);
    final num = RegExp(r'[\d.]+').firstMatch(s);
    if (num != null) return double.tryParse(num.group(0)!);
    return null;
  }
}
