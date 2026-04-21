enum MealCategory { breakfast, lunch, dinner, snack }

extension MealCategoryX on MealCategory {
  String get key => name; // 'breakfast', 'lunch', etc.

  static MealCategory fromString(String? s) {
    switch (s) {
      case 'breakfast': return MealCategory.breakfast;
      case 'lunch':     return MealCategory.lunch;
      case 'dinner':    return MealCategory.dinner;
      default:          return MealCategory.snack;
    }
  }

  /// Auto-detect based on hour of day
  static MealCategory fromTime(DateTime dt) {
    final h = dt.hour;
    if (h >= 6 && h < 11)  return MealCategory.breakfast;
    if (h >= 11 && h < 15) return MealCategory.lunch;
    if (h >= 18 && h < 23) return MealCategory.dinner;
    return MealCategory.snack;
  }
}

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

  FoodItem copyWithScaled(double scale) {
    return FoodItem(
      name: name,
      nameTr: nameTr,
      portion: portion * scale,
      portionUnit: portionUnit,
      nutrients: NutrientInfo(
        calories: nutrients.calories * scale,
        protein: nutrients.protein * scale,
        carbs: nutrients.carbs * scale,
        fat: nutrients.fat * scale,
        fiber: nutrients.fiber * scale,
        sugar: nutrients.sugar * scale,
      ),
      healthScore: healthScore,
      tags: tags,
    );
  }

  static String _shortName(String raw) {
    final clean = raw.trim();
    final words = clean.split(RegExp(r'\s+'));
    // Max 4 kelime, max 40 karakter
    final short = words.take(4).join(' ');
    return short.length > 40 ? '${short.substring(0, 37)}...' : short;
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: _shortName(map['name'] ?? ''),
      nameTr: _shortName(map['name_tr'] ?? map['name'] ?? ''),
      portion: (map['portion'] as num?)?.toDouble() ?? 100,
      portionUnit: map['portion_unit'] ?? 'g',
      nutrients: NutrientInfo.fromMap(
          Map<String, dynamic>.from(map['nutrients'] ?? {})),
      healthScore: map['health_score'] ?? 'Orta',
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  /// Backend GraphQL FoodItem objesinden parse et.
  /// BE field'ları düz: calories/protein/carbs/fat/fiber/sugar + portionUnit/healthScore/tags.
  factory FoodItem.fromBackend(Map<String, dynamic> map) {
    return FoodItem(
      name: _shortName((map['name'] ?? '') as String),
      nameTr: _shortName((map['nameTr'] ?? map['name'] ?? '') as String),
      portion: (map['portion'] as num?)?.toDouble() ?? 100,
      portionUnit: (map['portionUnit'] ?? 'g') as String,
      nutrients: NutrientInfo(
        calories: (map['calories'] as num?)?.toDouble() ?? 0,
        protein: (map['protein'] as num?)?.toDouble() ?? 0,
        carbs: (map['carbs'] as num?)?.toDouble() ?? 0,
        fat: (map['fat'] as num?)?.toDouble() ?? 0,
        fiber: (map['fiber'] as num?)?.toDouble() ?? 0,
        sugar: (map['sugar'] as num?)?.toDouble() ?? 0,
      ),
      healthScore: (map['healthScore'] ?? 'Orta') as String,
      tags: List<String>.from((map['tags'] as List?) ?? const []),
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
  final MealCategory mealCategory;
  final bool isFavorite;

  FoodAnalysis({
    required this.id,
    required this.imagePath,
    required this.foods,
    required this.totalNutrients,
    required this.summary,
    required this.advice,
    required this.analyzedAt,
    MealCategory? mealCategory,
    this.isFavorite = false,
  }) : mealCategory = mealCategory ?? MealCategoryX.fromTime(analyzedAt);

  FoodAnalysis copyWith({
    String? id,
    String? imagePath,
    List<FoodItem>? foods,
    NutrientInfo? totalNutrients,
    String? summary,
    String? advice,
    DateTime? analyzedAt,
    MealCategory? mealCategory,
    bool? isFavorite,
  }) =>
      FoodAnalysis(
        id: id ?? this.id,
        imagePath: imagePath ?? this.imagePath,
        foods: foods ?? this.foods,
        totalNutrients: totalNutrients ?? this.totalNutrients,
        summary: summary ?? this.summary,
        advice: advice ?? this.advice,
        analyzedAt: analyzedAt ?? this.analyzedAt,
        mealCategory: mealCategory ?? this.mealCategory,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  FoodAnalysis copyWithScaled(double scaleFactor) {
    if (scaleFactor == 1.0) return this;
    final scaledFoods = foods.map((f) => f.copyWithScaled(scaleFactor)).toList();
    final scaledNutrients = NutrientInfo(
      calories: totalNutrients.calories * scaleFactor,
      protein: totalNutrients.protein * scaleFactor,
      carbs: totalNutrients.carbs * scaleFactor,
      fat: totalNutrients.fat * scaleFactor,
      fiber: totalNutrients.fiber * scaleFactor,
      sugar: totalNutrients.sugar * scaleFactor,
    );
    return copyWith(
      foods: scaledFoods,
      totalNutrients: scaledNutrients,
    );
  }

  double get totalCalories => totalNutrients.calories;

  /// UI label for lists/cards. Prefers the first food item's localized name,
  /// then its canonical name, then the summary. `summary` is already cleaned
  /// of the BE `Manuel giriş:` / `Manual entry:` prefix at parse time
  /// (see [_stripManualPrefix]).
  String get displayName {
    if (foods.isNotEmpty) {
      final nameTr = foods.first.nameTr.trim();
      if (nameTr.isNotEmpty) return nameTr;
      final name = foods.first.name.trim();
      if (name.isNotEmpty) return name;
    }
    return summary.trim();
  }

  /// Removes the BE `saveManualFood` prefix so it never leaks into any UI
  /// surface (result screen, manual-entry text field, favorite cards, etc.).
  /// Permanent fix tracked in EAT-125 on the backend.
  static String _stripManualPrefix(String raw) {
    return raw.replaceFirst(
      RegExp(r'^(manuel giriş|manual entry)\s*:\s*', caseSensitive: false),
      '',
    );
  }

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
        'mealCategory': mealCategory.key,
        'isFavorite': isFavorite ? 1 : 0,
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
      summary: _stripManualPrefix((map['summary'] ?? '') as String),
      advice: map['advice'] ?? '',
      analyzedAt: DateTime.parse(map['analyzedAt']),
      mealCategory: MealCategoryX.fromString(map['mealCategory'] as String?),
      isFavorite: (map['isFavorite'] as int? ?? 0) == 1,
    );
  }

  /// Backend GraphQL yanıtından parse et.
  /// BE alanları: imageUrl (camelCase), isFavorite (bool), mealCategory (UPPERCASE enum),
  /// foods (nested FoodItem listesi, her biri ayrı nutrient field'larıyla).
  factory FoodAnalysis.fromBackend(Map<String, dynamic> map) {
    final foodsList = (map['foods'] as List?) ?? const [];
    final parsedFoods = foodsList
        .map((e) => FoodItem.fromBackend(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);

    final mealCat = (map['mealCategory'] as String?)?.toLowerCase();

    return FoodAnalysis(
      id: (map['id'] ?? '') as String,
      imagePath: (map['imageUrl'] ?? '') as String,
      foods: parsedFoods,
      totalNutrients: NutrientInfo(
        calories: (map['totalCalories'] as num?)?.toDouble() ?? 0,
        protein: (map['totalProtein'] as num?)?.toDouble() ?? 0,
        carbs: (map['totalCarbs'] as num?)?.toDouble() ?? 0,
        fat: (map['totalFat'] as num?)?.toDouble() ?? 0,
        fiber: (map['totalFiber'] as num?)?.toDouble() ?? 0,
        sugar: (map['totalSugar'] as num?)?.toDouble() ?? 0,
      ),
      summary: _stripManualPrefix((map['summary'] ?? '') as String),
      advice: (map['advice'] ?? '') as String,
      analyzedAt: DateTime.parse(map['analyzedAt'] as String),
      mealCategory: MealCategoryX.fromString(mealCat),
      isFavorite: map['isFavorite'] == true,
    );
  }
}
