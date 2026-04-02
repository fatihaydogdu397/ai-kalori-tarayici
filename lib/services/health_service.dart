import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthService {
  static const _prefKey = 'healthEnabled';

  // Write types
  static final _writeTypes = [
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
    HealthDataType.WATER,
  ];

  // Read types
  static final _readTypes = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
  ];

  static final _writePermissions =
      _writeTypes.map((_) => HealthDataAccess.WRITE).toList();

  static final _readPermissions =
      _readTypes.map((_) => HealthDataAccess.READ).toList();

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

  Future<bool> requestPermissions() async {
    try {
      final health = Health();
      await health.configure();
      final allTypes = [..._writeTypes, ..._readTypes];
      final allPerms = [..._writePermissions, ..._readPermissions];
      return await health.requestAuthorization(allTypes, permissions: allPerms);
    } catch (_) {
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // Read helpers
  // -------------------------------------------------------------------------

  /// Bugünkü aktif kalori (kcal) — Apple Watch / Fitness ring
  Future<double> getTodayActiveCalories() async {
    if (!await isEnabled()) return 0;
    try {
      final health = Health();
      await health.configure();
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final data = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );
      return data.fold<double>(
        0,
        (sum, p) => sum + (p.value as NumericHealthValue).numericValue.toDouble(),
      );
    } catch (_) {
      return 0;
    }
  }

  /// Bugünkü adım sayısı
  Future<int> getTodaySteps() async {
    if (!await isEnabled()) return 0;
    try {
      final health = Health();
      await health.configure();
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final steps = await health.getTotalStepsInInterval(start, now);
      return steps ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// En son kaydedilen vücut ağırlığı (kg) — Apple Watch / Withings tartı
  Future<double?> getLatestBodyWeight() async {
    if (!await isEnabled()) return null;
    try {
      final health = Health();
      await health.configure();
      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 30));
      final data = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: [HealthDataType.WEIGHT],
      );
      if (data.isEmpty) return null;
      data.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      return (data.first.value as NumericHealthValue).numericValue.toDouble();
    } catch (_) {
      return null;
    }
  }

  // -------------------------------------------------------------------------
  // Write helpers
  // -------------------------------------------------------------------------

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
    } catch (_) {}
  }

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
    } catch (_) {}
  }
}
