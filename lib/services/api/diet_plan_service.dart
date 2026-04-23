import '../../screens/weekly_diet_plan_screen.dart';
import 'api_client.dart';
import 'api_exception.dart';

/// Backend `diet-plan` modülünü saran servis (EAT-96).
///
/// BE artık tablo bazlı bir plan üretiyor: DietPlan → days[] → meals[] ile
/// **target makrolar + completed flag** tutar. Meal adı / foods listesi BE'de
/// yok; FE'de kategori adı ve default slot metadata (saat + emoji) ile
/// zenginleştiriyoruz. İleride BE'ye öneri (name + foods) eklenirse burada
/// override edilir.
class DietPlanService {
  DietPlanService._();
  static final DietPlanService instance = DietPlanService._();

  final ApiClient _api = ApiClient.instance;

  static const String _planFields = '''
    id startDate endDate status guidance createdAt
    days {
      id dayNumber date
      meals {
        id mealCategory
        targetCalories targetProtein targetCarbs targetFat
        completed
      }
    }
  ''';

  /// Yeni 7 günlük plan üretir (mevcut active varsa CANCELLED yapılır).
  /// EAT-132: [dislikedFoodIds] verilirse BE o yemekleri planın dışında tutar.
  Future<DietPlan> generatePlan({List<String>? dislikedFoodIds}) async {
    final hasInput = dislikedFoodIds != null && dislikedFoodIds.isNotEmpty;
    final variables = hasInput
        ? {
            'input': {'dislikedFoodIds': dislikedFoodIds},
          }
        : null;
    final data = await _api.mutate(
      '''
      mutation GenerateDietPlan(\$input: GenerateDietPlanInput) {
        generateDietPlan(input: \$input) { $_planFields }
      }
      ''',
      variables: variables,
    );
    return _parse(Map<String, dynamic>.from(data['generateDietPlan'] as Map));
  }

  /// EAT-128: 7 gün içindeki plan üretim kotası (limit / used / remaining / resetAt).
  Future<DietPlanWeeklyLimit> weeklyLimit() async {
    final data = await _api.query(
      r'''
      query DietPlanWeeklyLimit {
        dietPlanWeeklyLimit { limit used remaining resetAt }
      }
      ''',
    );
    final raw = Map<String, dynamic>.from(data['dietPlanWeeklyLimit'] as Map);
    return DietPlanWeeklyLimit(
      limit: (raw['limit'] as num?)?.toInt() ?? 0,
      used: (raw['used'] as num?)?.toInt() ?? 0,
      remaining: (raw['remaining'] as num?)?.toInt() ?? 0,
      resetAt: raw['resetAt'] != null
          ? DateTime.tryParse(raw['resetAt'] as String)
          : null,
    );
  }

  /// Kullanıcının aktif planı (yoksa null).
  Future<DietPlan?> getActivePlan() async {
    final data = await _api.query(
      '''
      query MyDietPlan {
        myDietPlan { $_planFields }
      }
      ''',
    );
    final raw = data['myDietPlan'];
    if (raw == null) return null;
    return _parse(Map<String, dynamic>.from(raw as Map));
  }

  /// Tek bir günün öğünlerini yeniden üretir (dayNumber 1..7).
  Future<DietPlan> regenerateDay(int dayNumber) async {
    final data = await _api.mutate(
      '''
      mutation RegenerateDay(\$input: RegenerateDayInput!) {
        regenerateDay(input: \$input) { $_planFields }
      }
      ''',
      variables: {
        'input': {'dayNumber': dayNumber},
      },
    );
    return _parse(Map<String, dynamic>.from(data['regenerateDay'] as Map));
  }

  /// Bir öğünü "tamamlandı" olarak işaretler (BE completed=true).
  Future<void> completeMeal(String mealId) async {
    await _api.mutate(
      r'''
      mutation CompleteMeal($mealId: ID!) {
        completeMeal(mealId: $mealId) { id completed }
      }
      ''',
      variables: {'mealId': mealId},
    );
  }

  // ── BE DietPlan → FE DietPlan mapping ──────────────────────────────────────

  DietPlan _parse(Map<String, dynamic> raw) {
    final daysRaw = (raw['days'] as List?) ?? const [];
    final sorted = daysRaw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList()
      ..sort((a, b) =>
          (a['dayNumber'] as int).compareTo(b['dayNumber'] as int));

    final days = sorted.map(_parseDay).toList(growable: false);

    final dailyTarget = days.isNotEmpty ? days.first.totalCalories : 0;
    return DietPlan(
      dailyCalorieGoal: dailyTarget,
      days: days,
      generatedAt: DateTime.tryParse((raw['createdAt'] ?? '') as String) ??
          DateTime.now(),
    );
  }

  DietDay _parseDay(Map<String, dynamic> day) {
    final mealsRaw = (day['meals'] as List?) ?? const [];
    final meals = mealsRaw
        .map((e) => _parseMeal(Map<String, dynamic>.from(e as Map)))
        .toList(growable: false);

    final dayNumber = day['dayNumber'] as int;
    final totalCals = meals.fold<int>(0, (s, m) => s + m.calories);

    return DietDay(
      dayName: _dayLabel(dayNumber, (day['date'] ?? '') as String),
      meals: meals,
      totalCalories: totalCals,
    );
  }

  DietMeal _parseMeal(Map<String, dynamic> meal) {
    final categoryRaw = ((meal['mealCategory'] ?? '') as String).toLowerCase();
    final slot = _slotFor(categoryRaw);
    return DietMeal(
      name: slot.label,
      category: slot.label,
      calories: (meal['targetCalories'] as num?)?.toInt() ?? 0,
      protein: (meal['targetProtein'] as num?)?.toInt() ?? 0,
      carbs: (meal['targetCarbs'] as num?)?.toInt() ?? 0,
      fat: (meal['targetFat'] as num?)?.toInt() ?? 0,
      time: slot.time,
      emoji: slot.emoji,
    );
  }

  String _dayLabel(int dayNumber, String isoDate) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final parsed = DateTime.tryParse(isoDate);
    if (parsed != null) {
      return names[(parsed.weekday - 1).clamp(0, 6)];
    }
    return names[(dayNumber - 1).clamp(0, 6)];
  }

  _Slot _slotFor(String category) {
    switch (category) {
      case 'breakfast':
        return const _Slot('Breakfast', '08:00', '🌅');
      case 'lunch':
        return const _Slot('Lunch', '12:30', '☀️');
      case 'dinner':
        return const _Slot('Dinner', '19:00', '🌙');
      case 'snack':
      default:
        return const _Slot('Snack', '15:30', '🍎');
    }
  }
}

class _Slot {
  final String label;
  final String time;
  final String emoji;
  const _Slot(this.label, this.time, this.emoji);
}

/// EAT-128 `dietPlanWeeklyLimit` çıktı modeli.
class DietPlanWeeklyLimit {
  final int limit;
  final int used;
  final int remaining;
  final DateTime? resetAt;
  const DietPlanWeeklyLimit({
    required this.limit,
    required this.used,
    required this.remaining,
    required this.resetAt,
  });

  bool get isBlocked => remaining <= 0;
}

/// EAT-96 BE akışı: önce aktif plan kontrol edilir; yoksa generate edilir.
Future<DietPlan> ensureActiveDietPlan() async {
  final svc = DietPlanService.instance;
  try {
    final active = await svc.getActivePlan();
    if (active != null) return active;
  } on ApiException {
    // getActivePlan başarısız olursa generate'e düş.
  }
  return svc.generatePlan();
}
