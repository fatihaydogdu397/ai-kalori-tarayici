/// MockBackendService — EAT-23/24/25
///
/// GraphQL-ready interface backed by static mock data.
/// Replace method bodies with real GraphQL/REST calls when backend is live.
/// All methods simulate network latency via Future.delayed.
///
/// Usage:
///   final user = await MockBackendService.getUser();
///   final meals = await MockBackendService.getMealHistory();
library mock_backend_service;

class MockBackendService {
  static const _delay = Duration(milliseconds: 600);

  // ── Auth ─────────────────────────────────────────────────────────────────

  /// Returns the current user profile.
  /// GraphQL equivalent: query { user { id, name, email, createdAt } }
  static Future<Map<String, dynamic>> getUser() async {
    await Future.delayed(_delay);
    return {
      'id': 'mock-user-001',
      'name': 'Demo User',
      'email': 'demo@eatiq.app',
      'isPremium': false,
      'createdAt': '2026-01-01T00:00:00Z',
      'avatarUrl': null,
    };
  }

  // ── Meal History ──────────────────────────────────────────────────────────

  /// Returns paginated meal history.
  /// GraphQL equivalent: query { meals(limit: $limit, offset: $offset) { ... } }
  static Future<List<Map<String, dynamic>>> getMealHistory({
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(_delay);
    final now = DateTime.now();
    return List.generate(limit, (i) {
      final idx = i + offset;
      final dt = now.subtract(Duration(hours: idx * 6));
      return {
        'id': 'meal-$idx',
        'foodName': _sampleFoods[idx % _sampleFoods.length],
        'calories': 200.0 + (idx % 8) * 80,
        'protein': 15.0 + (idx % 5) * 5,
        'carbs': 20.0 + (idx % 6) * 10,
        'fat': 8.0 + (idx % 4) * 3,
        'portionDescription': '${100 + (idx % 3) * 50}g',
        'mealCategory': _mealCategories[idx % 4],
        'timestamp': dt.toIso8601String(),
      };
    });
  }

  // ── Diet Plan ─────────────────────────────────────────────────────────────

  /// Returns the user's current weekly diet plan.
  /// GraphQL equivalent: query { dietPlan { week, days { ... } } }
  static Future<Map<String, dynamic>> getDietPlan() async {
    await Future.delayed(_delay);
    return {
      'id': 'plan-mock-001',
      'weekStart': DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - 1))
          .toIso8601String(),
      'dailyCalorieTarget': 2000,
      'dailyProteinTarget': 150,
      'dailyCarbTarget': 200,
      'dailyFatTarget': 65,
      'days': List.generate(7, (i) => {
        'dayIndex': i,
        'dayName': _dayNames[i],
        'breakfast': _sampleMealPlan('breakfast', i),
        'lunch': _sampleMealPlan('lunch', i),
        'dinner': _sampleMealPlan('dinner', i),
        'snack': _sampleMealPlan('snack', i),
      }),
    };
  }

  // ── Sync ──────────────────────────────────────────────────────────────────

  /// Syncs a meal entry to the backend.
  /// GraphQL equivalent: mutation { logMeal(input: $input) { success, id } }
  static Future<Map<String, dynamic>> syncMeal(
      Map<String, dynamic> meal) async {
    await Future.delayed(_delay);
    return {
      'success': true,
      'id': 'sync-${DateTime.now().millisecondsSinceEpoch}',
      'syncedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Syncs weight log to the backend.
  /// GraphQL equivalent: mutation { logWeight(weight: $weight, date: $date) { success } }
  static Future<Map<String, dynamic>> syncWeight(
      double weight, DateTime date) async {
    await Future.delayed(_delay);
    return {
      'success': true,
      'id': 'weight-${DateTime.now().millisecondsSinceEpoch}',
    };
  }

  // ── Nutrition Insights ────────────────────────────────────────────────────

  /// Returns AI-generated weekly nutrition insights.
  /// GraphQL equivalent: query { weeklyInsights { tips, warnings, score } }
  static Future<Map<String, dynamic>> getWeeklyInsights() async {
    await Future.delayed(_delay);
    return {
      'nutritionScore': 72,
      'tips': [
        'You are consistently low on protein. Try adding eggs or Greek yogurt to breakfast.',
        'Your hydration looks good — keep it up!',
        'Consider adding more fiber-rich vegetables to dinner.',
      ],
      'warnings': [
        'Calorie intake was below goal on 3 days this week.',
      ],
      'weeklyCalories': 13440,
      'weeklyProtein': 630,
      'weeklyCarbs': 1260,
      'weeklyFat': 420,
    };
  }

  // ── Subscription ──────────────────────────────────────────────────────────

  /// Verifies premium status with backend.
  /// GraphQL equivalent: query { subscriptionStatus { isPremium, expiresAt } }
  static Future<Map<String, dynamic>> getSubscriptionStatus() async {
    await Future.delayed(_delay);
    return {
      'isPremium': false,
      'tier': 'free',
      'expiresAt': null,
      'restoreAvailable': false,
    };
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  static const _sampleFoods = [
    'Chicken Breast', 'Greek Yogurt', 'Brown Rice', 'Salmon',
    'Oatmeal', 'Egg', 'Sweet Potato', 'Avocado', 'Tuna',
    'Banana', 'Spinach Salad', 'Pasta', 'Lentil Soup',
  ];

  static const _mealCategories = [
    'breakfast', 'lunch', 'dinner', 'snack'
  ];

  static const _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];

  static Map<String, dynamic> _sampleMealPlan(String meal, int day) {
    const foods = {
      'breakfast': ['Oatmeal + Banana', 'Greek Yogurt + Berries', 'Scrambled Eggs + Toast'],
      'lunch': ['Chicken Breast + Rice', 'Tuna Salad', 'Lentil Soup + Bread'],
      'dinner': ['Salmon + Sweet Potato', 'Beef Stir Fry + Rice', 'Pasta + Chicken'],
      'snack': ['Almonds', 'Protein Bar', 'Apple + Peanut Butter'],
    };
    final list = foods[meal] ?? ['—'];
    return {
      'name': list[day % list.length],
      'calories': 300.0 + (day % 4) * 50,
      'protein': 25.0 + (day % 3) * 5,
    };
  }
}
