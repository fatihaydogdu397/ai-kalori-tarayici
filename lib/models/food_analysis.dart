class NutrientInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;

  NutrientInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
  });

  factory NutrientInfo.fromMap(Map<String, dynamic> map) {
    return NutrientInfo(
      calories: (map['calories'] as num?)?.toDouble() ?? 0,
      protein: (map['protein'] as num?)?.toDouble() ?? 0,
      carbs: (map['carbs'] as num?)?.toDouble() ?? 0,
      fat: (map['fat'] as num?)?.toDouble() ?? 0,
      fiber: (map['fiber'] as num?)?.toDouble() ?? 0,
      sugar: (map['sugar'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'fiber': fiber,
        'sugar': sugar,
      };
}

class FoodItem {
  final String name;
  final String nameTr;
  final double portion;
  final String portionUnit;
  final NutrientInfo nutrients;
  final String healthScore;
  final List<String> tags;

  FoodItem({
    required this.name,
    required this.nameTr,
    required this.portion,
    required this.portionUnit,
    required this.nutrients,
    required this.healthScore,
    required this.tags,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'] ?? '',
      nameTr: map['name_tr'] ?? map['name'] ?? '',
      portion: (map['portion'] as num?)?.toDouble() ?? 100,
      portionUnit: map['portion_unit'] ?? 'g',
      nutrients: NutrientInfo.fromMap(
          Map<String, dynamic>.from(map['nutrients'] ?? {})),
      healthScore: map['health_score'] ?? 'Orta',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }
}

class FoodAnalysis {
  final String id;
  final String imagePath;
  final List<FoodItem> foods;
  final NutrientInfo totalNutrients;
  final String summary;
  final String advice;
  final DateTime analyzedAt;

  FoodAnalysis({
    required this.id,
    required this.imagePath,
    required this.foods,
    required this.totalNutrients,
    required this.summary,
    required this.advice,
    required this.analyzedAt,
  });

  double get totalCalories => totalNutrients.calories;

  Map<String, dynamic> toMap() => {
        'id': id,
        'imagePath': imagePath,
        'summary': summary,
        'advice': advice,
        'analyzedAt': analyzedAt.toIso8601String(),
        'totalCalories': totalNutrients.calories,
        'totalProtein': totalNutrients.protein,
        'totalCarbs': totalNutrients.carbs,
        'totalFat': totalNutrients.fat,
        'totalFiber': totalNutrients.fiber,
        'totalSugar': totalNutrients.sugar,
      };

  factory FoodAnalysis.fromMap(Map<String, dynamic> map) {
    return FoodAnalysis(
      id: map['id'] ?? '',
      imagePath: map['imagePath'] ?? '',
      foods: [],
      totalNutrients: NutrientInfo(
        calories: (map['totalCalories'] as num?)?.toDouble() ?? 0,
        protein: (map['totalProtein'] as num?)?.toDouble() ?? 0,
        carbs: (map['totalCarbs'] as num?)?.toDouble() ?? 0,
        fat: (map['totalFat'] as num?)?.toDouble() ?? 0,
        fiber: (map['totalFiber'] as num?)?.toDouble() ?? 0,
        sugar: (map['totalSugar'] as num?)?.toDouble() ?? 0,
      ),
      summary: map['summary'] ?? '',
      advice: map['advice'] ?? '',
      analyzedAt: DateTime.parse(map['analyzedAt']),
    );
  }
}
