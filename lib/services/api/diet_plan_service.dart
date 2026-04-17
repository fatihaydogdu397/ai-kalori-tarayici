import 'dart:convert';

import '../../screens/weekly_diet_plan_screen.dart';
import 'api_client.dart';
import 'api_exception.dart';

class DietPlanService {
  DietPlanService._();
  static final DietPlanService instance = DietPlanService._();

  final ApiClient _api = ApiClient.instance;

  /// BE `generateMealPlan(planType)` — premium-only; 7 günlük plan JSON döner.
  /// Throws [ApiException] (code: PREMIUM_REQUIRED / MEAL_PLAN_LIMIT_REACHED).
  Future<DietPlan> generatePlan({String planType = 'weekly'}) async {
    final data = await _api.mutate(
      r'''
      mutation GenerateMealPlan($planType: String!) {
        generateMealPlan(planType: $planType)
      }
      ''',
      variables: {'planType': planType},
    );

    final raw = data['generateMealPlan'];
    if (raw is! String) {
      throw ApiException('Malformed meal plan response');
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return _parsePlan(decoded, planType);
  }

  // ── BE JSON → FE DietPlan mapping ──────────────────────────────────────────

  static const _weekKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  static const _dayLabels = {
    'monday': 'Monday',
    'tuesday': 'Tuesday',
    'wednesday': 'Wednesday',
    'thursday': 'Thursday',
    'friday': 'Friday',
    'saturday': 'Saturday',
    'sunday': 'Sunday',
    'today': 'Today',
  };

  DietPlan _parsePlan(Map<String, dynamic> decoded, String planType) {
    final plan = Map<String, dynamic>.from(decoded['plan'] as Map);

    final List<DietDay> days;
    if (planType == 'daily') {
      final todayRaw = plan['today'];
      days = todayRaw == null
          ? const []
          : [_parseDay('today', Map<String, dynamic>.from(todayRaw as Map))];
    } else {
      days = _weekKeys
          .where((k) => plan[k] != null)
          .map((k) => _parseDay(k, Map<String, dynamic>.from(plan[k] as Map)))
          .toList(growable: false);
    }

    final dailyGoal = days.isNotEmpty
        ? (days.first.totalCalories)
        : 0;

    return DietPlan(
      dailyCalorieGoal: dailyGoal,
      days: days,
      generatedAt: DateTime.now(),
    );
  }

  DietDay _parseDay(String key, Map<String, dynamic> day) {
    final mealsRaw = (day['meals'] as List?) ?? const [];
    final meals = <DietMeal>[];
    for (var i = 0; i < mealsRaw.length; i++) {
      meals.add(_parseMeal(Map<String, dynamic>.from(mealsRaw[i] as Map), i));
    }

    final total = (day['daily_total'] as Map?)?.cast<String, dynamic>();
    final totalCals = (total?['calories'] as num?)?.toInt() ??
        meals.fold<int>(0, (s, m) => s + m.calories);

    return DietDay(
      dayName: _dayLabels[key] ?? key,
      meals: meals,
      totalCalories: totalCals,
    );
  }

  DietMeal _parseMeal(Map<String, dynamic> meal, int mealIndex) {
    // BE meal objesi meta kategori/saat/emoji vermez — index'e göre
    // breakfast/lunch/snack/dinner/snack düzeninde varsayalım.
    final slot = _mealSlot(mealIndex);
    return DietMeal(
      name: (meal['name'] ?? '') as String,
      category: slot.category,
      calories: (meal['total_calories'] as num?)?.toInt() ?? 0,
      protein: (meal['total_protein'] as num?)?.toInt() ?? 0,
      carbs: (meal['total_carbs'] as num?)?.toInt() ?? 0,
      fat: (meal['total_fat'] as num?)?.toInt() ?? 0,
      time: slot.time,
      emoji: slot.emoji,
    );
  }

  _MealSlot _mealSlot(int index) {
    switch (index) {
      case 0:
        return const _MealSlot('Breakfast', '08:00', '🌅');
      case 1:
        return const _MealSlot('Lunch', '12:30', '☀️');
      case 2:
        return const _MealSlot('Dinner', '19:00', '🌙');
      case 3:
        return const _MealSlot('Snack', '15:30', '🍎');
      default:
        return const _MealSlot('Snack', '21:00', '🥛');
    }
  }
}

class _MealSlot {
  final String category;
  final String time;
  final String emoji;
  const _MealSlot(this.category, this.time, this.emoji);
}
