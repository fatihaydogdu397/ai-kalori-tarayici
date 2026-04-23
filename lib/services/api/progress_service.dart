import 'api_client.dart';

class ProgressService {
  ProgressService._();
  static final ProgressService instance = ProgressService._();

  final ApiClient _api = ApiClient.instance;

  // EAT-131 / EAT-133: cihazın UTC'ye uzaklığını BE'ye geçir ki "bugün"
  // kullanıcının lokal takvim günü üzerinden hesaplansın.
  int get _tzOffset => DateTime.now().timeZoneOffset.inMinutes;

  Future<Map<String, dynamic>> todayStats() async {
    final data = await _api.query(
      r'''
      query TodayStats($tz: Int) {
        todayStats(timezoneOffsetMinutes: $tz) {
          totalCalories totalProtein totalCarbs totalFat
          totalFiber totalSugar
          waterLiters waterGoal scanCount
          mealBreakdown { category calories count }
        }
      }
      ''',
      variables: {'tz': _tzOffset},
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
      '''query WeeklyStats(\$tz: Int) { weeklyStats(timezoneOffsetMinutes: \$tz) { $_periodFields } }''',
      variables: {'tz': _tzOffset},
    );
    return Map<String, dynamic>.from(data['weeklyStats'] as Map);
  }

  Future<Map<String, dynamic>> monthlyStats() async {
    final data = await _api.query(
      '''query MonthlyStats(\$tz: Int) { monthlyStats(timezoneOffsetMinutes: \$tz) { $_periodFields } }''',
      variables: {'tz': _tzOffset},
    );
    return Map<String, dynamic>.from(data['monthlyStats'] as Map);
  }

  Future<int> remainingScans() async {
    final data = await _api.query(
      r'query RemainingScans($tz: Int) { remainingScans(timezoneOffsetMinutes: $tz) }',
      variables: {'tz': _tzOffset},
    );
    return (data['remainingScans'] as num).toInt();
  }
}
