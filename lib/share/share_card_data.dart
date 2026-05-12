import '../models/food_analysis.dart';

/// Payload passed to every share-card template widget.
class ShareCardData {
  final DateTime date;
  final List<FoodAnalysis> meals;
  final String handle;
  final String cta;

  ShareCardData({
    required this.date,
    required this.meals,
    this.handle = '@eatiq',
    this.cta = 'Sen de dene →',
  });

  int get mealCount => meals.length;
  bool get isSingle => meals.length == 1;

  double get totalCalories =>
      meals.fold(0, (s, m) => s + m.totalNutrients.calories);
  double get totalProtein =>
      meals.fold(0, (s, m) => s + m.totalNutrients.protein);
  double get totalCarbs => meals.fold(0, (s, m) => s + m.totalNutrients.carbs);
  double get totalFat => meals.fold(0, (s, m) => s + m.totalNutrients.fat);
}

/// Weekly variant — 7 day rows, each with up to 5 meals.
class WeeklyShareCardData {
  final DateTime weekStart;
  final List<List<FoodAnalysis>> days;
  final String handle;
  final String cta;

  WeeklyShareCardData({
    required this.weekStart,
    required this.days,
    this.handle = '@eatiq',
    this.cta = 'Sen de dene →',
  }) : assert(days.length == 7, 'Weekly share needs exactly 7 days');

  int get recordedDayCount => days.where((d) => d.isNotEmpty).length;

  double get weekTotalCalories =>
      days.expand((d) => d).fold(0, (s, m) => s + m.totalNutrients.calories);
}
