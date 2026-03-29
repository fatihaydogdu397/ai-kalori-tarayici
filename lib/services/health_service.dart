import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  static const _prefKey = 'healthEnabled';

  static final _types = [
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
    HealthDataType.WATER,
  ];

  static final _permissions = _types
      .map((_) => HealthDataAccess.WRITE)
      .toList();

  // -------------------------------------------------------------------------
  // Persistence
  // -------------------------------------------------------------------------

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }

  // -------------------------------------------------------------------------
  // Permissions
  // -------------------------------------------------------------------------

  /// Requests HealthKit write permissions. Returns true if granted.
  Future<bool> requestPermissions() async {
    try {
      final health = Health();
      await health.configure();
      return await health.requestAuthorization(_types, permissions: _permissions);
    } catch (_) {
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // Write helpers
  // -------------------------------------------------------------------------

  /// Logs a meal's nutrition data to Apple Health.
  /// Silently swallows errors — Health sync is best-effort.
  Future<void> logMeal({
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required DateTime time,
  }) async {
    if (!await isEnabled()) return;
    try {
      final health = Health();
      await health.configure();
      final end = time.add(const Duration(seconds: 1));
      await Future.wait([
        if (calories > 0)
          health.writeHealthData(
            value: calories,
            type: HealthDataType.DIETARY_ENERGY_CONSUMED,
            startTime: time,
            endTime: end,
            unit: HealthDataUnit.KILOCALORIE,
          ),
        if (protein > 0)
          health.writeHealthData(
            value: protein,
            type: HealthDataType.DIETARY_PROTEIN_CONSUMED,
            startTime: time,
            endTime: end,
            unit: HealthDataUnit.GRAM,
          ),
        if (carbs > 0)
          health.writeHealthData(
            value: carbs,
            type: HealthDataType.DIETARY_CARBS_CONSUMED,
            startTime: time,
            endTime: end,
            unit: HealthDataUnit.GRAM,
          ),
        if (fat > 0)
          health.writeHealthData(
            value: fat,
            type: HealthDataType.DIETARY_FATS_CONSUMED,
            startTime: time,
            endTime: end,
            unit: HealthDataUnit.GRAM,
          ),
      ]);
    } catch (_) {
      // Best-effort — don't block the user
    }
  }

  /// Logs today's cumulative water intake to Apple Health.
  Future<void> logWater({
    required double liters,
    required DateTime time,
  }) async {
    if (!await isEnabled()) return;
    if (liters <= 0) return;
    try {
      final health = Health();
      await health.configure();
      await health.writeHealthData(
        value: liters,
        type: HealthDataType.WATER,
        startTime: time,
        endTime: time.add(const Duration(seconds: 1)),
        unit: HealthDataUnit.LITER,
      );
    } catch (_) {
      // Best-effort
    }
  }
}
