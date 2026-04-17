import 'api_client.dart';

class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  final ApiClient _api = ApiClient.instance;

  Future<Map<String, dynamic>> todayStats() async {
    final data = await _api.query(
      r'''
      query TodayStats {
        todayStats {
          totalCalories totalProtein totalCarbs totalFat
          totalFiber totalSugar
          waterLiters waterGoal scanCount
          mealBreakdown { category calories count }
        }
      }
      ''',
    );
    return Map<String, dynamic>.from(data['todayStats'] as Map);
  }

  static const String _periodFields = '''
    avgCalories avgProtein avgCarbs avgFat
    goalAchievementPercent topMealCategory
    days {
      date totalCalories totalProtein totalCarbs totalFat
      waterLiters scanCount
    }
  ''';

  Future<Map<String, dynamic>> weeklyStats() async {
    final data = await _api.query(
      '''query WeeklyStats { weeklyStats { $_periodFields } }''',
    );
    return Map<String, dynamic>.from(data['weeklyStats'] as Map);
  }

  Future<Map<String, dynamic>> monthlyStats() async {
    final data = await _api.query(
      '''query MonthlyStats { monthlyStats { $_periodFields } }''',
    );
    return Map<String, dynamic>.from(data['monthlyStats'] as Map);
  }

  Future<int> remainingScans() async {
    final data = await _api.query(r'query RemainingScans { remainingScans }');
    return (data['remainingScans'] as num).toInt();
  }
}
