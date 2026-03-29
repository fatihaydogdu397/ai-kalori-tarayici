import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_analysis.dart';
import '../widgets/portion_picker_sheet.dart';
import 'ai_service.dart';
import 'database_service.dart';
import 'health_service.dart';
import 'widget_service.dart';

enum AnalysisState { idle, loading, success, error }

enum UnitSystem { metric, imperial }

extension UnitSystemX on UnitSystem {
  bool get isMetric => this == UnitSystem.metric;
  String weightUnit(double kg) => isMetric ? '${kg.toStringAsFixed(1)} kg' : '${(kg * 2.20462).toStringAsFixed(1)} lb';
  String heightUnit(double cm) => isMetric ? '${cm.toStringAsFixed(0)} cm' : _cmToFtIn(cm);
  static String _cmToFtIn(double cm) {
    final totalIn = cm / 2.54;
    final ft = totalIn ~/ 12;
    final inch = (totalIn % 12).round();
    return "$ft'$inch\"";
  }
}

class AppProvider extends ChangeNotifier {
  final _claudeService = AIService();
  final _dbService = DatabaseService();
  final _healthService = HealthService();

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? true;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
    notifyListeners();
  }

  AnalysisState _state = AnalysisState.idle;
  FoodAnalysis? _currentAnalysis;
  List<FoodAnalysis> _history = [];
  Map<String, double> _todayStats = {};
  String _errorMessage = '';
  double _dailyCalorieGoal = 2000;

  AnalysisState get state => _state;
  FoodAnalysis? get currentAnalysis => _currentAnalysis;
  List<FoodAnalysis> get history => _history;
  List<FoodAnalysis> get favorites => _history.where((a) => a.isFavorite).toList();
  Map<String, double> get todayStats => _todayStats;
  String get errorMessage => _errorMessage;
  double get dailyCalorieGoal => _dailyCalorieGoal;

  double get todayCalories => _todayStats['calories'] ?? 0;
  double get calorieProgress =>
      (todayCalories / _dailyCalorieGoal).clamp(0.0, 1.0);

  Future<void> analyzeImage(
    String imagePath, {
    int? portionGrams,
    CookingMethod? cooking,
  }) async {
    if (!await canScan()) {
      _errorMessage = 'limit_reached';
      _state = AnalysisState.error;
      notifyListeners();
      return;
    }

    _state = AnalysisState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final profile = <String, dynamic>{
        'age': _age,
        'gender': _gender,
        'weight': _weight,
        'height': _height,
        'goal': _goal,
      };
      final analysis = await _claudeService.analyzeFood(
        imagePath,
        portionGrams: portionGrams,
        cooking: cooking,
        userProfile: profile,
      );
      _currentAnalysis = analysis;
      await _dbService.saveAnalysis(analysis);
      await _incrementScanCount();
      await _updateStreak();
      await loadHistory();
      await loadTodayStats();
      unawaited(_healthService.logMeal(
        calories: analysis.totalNutrients.calories,
        protein: analysis.totalNutrients.protein,
        carbs: analysis.totalNutrients.carbs,
        fat: analysis.totalNutrients.fat,
        time: analysis.analyzedAt,
      ));
      _state = AnalysisState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AnalysisState.error;
    }

    notifyListeners();
  }

  Future<void> loadHistory() async {
    _history = await _dbService.getAllAnalyses();
    await loadTodayWater();
    notifyListeners();
  }

  Future<void> loadTodayStats() async {
    _todayStats = await _dbService.getTodayStats();
    notifyListeners();
    unawaited(_syncWidget());
  }

  Future<void> saveManualEntry(FoodAnalysis analysis) async {
    await _dbService.saveAnalysis(analysis);
    await loadHistory();
    await loadTodayStats();
    unawaited(_healthService.logMeal(
      calories: analysis.totalNutrients.calories,
      protein: analysis.totalNutrients.protein,
      carbs: analysis.totalNutrients.carbs,
      fat: analysis.totalNutrients.fat,
      time: analysis.analyzedAt,
    ));
  }

  Future<void> updateAnalysis(FoodAnalysis analysis) async {
    await _dbService.saveAnalysis(analysis);
    await loadHistory();
    await loadTodayStats();
  }

  Future<void> toggleFavorite(FoodAnalysis analysis) async {
    final newVal = !analysis.isFavorite;
    await _dbService.setFavorite(analysis.id, newVal);
    final idx = _history.indexWhere((a) => a.id == analysis.id);
    if (idx != -1) {
      _history[idx] = analysis.copyWith(isFavorite: newVal);
      notifyListeners();
    }
  }

  Future<void> deleteAnalysis(String id) async {
    await _dbService.deleteAnalysis(id);
    await loadHistory();
    await loadTodayStats();
  }

  void resetState() {
    _state = AnalysisState.idle;
    _currentAnalysis = null;
    notifyListeners();
  }

  void setCalorieGoal(double goal) {
    _dailyCalorieGoal = goal;
    notifyListeners();
  }

  Future<void> setCalorieGoalAndSave(double goal) async {
    _dailyCalorieGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('calorieGoal', goal);
    notifyListeners();
  }

  // Unit system
  UnitSystem _unitSystem = UnitSystem.metric;
  UnitSystem get unitSystem => _unitSystem;

  Future<void> setUnitSystem(UnitSystem system) async {
    _unitSystem = system;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unitSystem', system.name);
    notifyListeners();
  }

  // Profile
  String _userName = '';
  int _age = 0;
  double _height = 0;
  double _weight = 0;
  String _gender = '';
  String _goal = '';
  
  // Weight tracking history
  List<Map<String, dynamic>> _weightLogs = [];
  List<Map<String, dynamic>> get weightLogs => _weightLogs;

  String get userName => _userName;
  int get age => _age;
  double get height => _height; 
  double get weight => _weight;
  String get gender => _gender;
  String get goal => _goal;

  double get bmi => (_height > 0 && _weight > 0) ? _weight / ((_height / 100) * (_height / 100)) : 0;

  double get bmr {
    if (_weight <= 0 || _height <= 0 || _age <= 0) return 0;
    if (_gender == 'male') return 10 * _weight + 6.25 * _height - 5 * _age + 5;
    return 10 * _weight + 6.25 * _height - 5 * _age - 161;
  }

  double get tdee => bmr > 0 ? bmr * 1.375 : 0;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? '';
    _dailyCalorieGoal = prefs.getDouble('calorieGoal') ?? 2000;
    _waterGoal = prefs.getDouble('waterGoal') ?? 2.0;
    _streak = prefs.getInt('streak') ?? 0;
    _unitSystem = (prefs.getString('unitSystem') == 'imperial') ? UnitSystem.imperial : UnitSystem.metric;
    _age = prefs.getInt('age') ?? 0;
    _height = prefs.getDouble('height') ?? 0;
    _weight = prefs.getDouble('weight') ?? 0;
    _gender = prefs.getString('gender') ?? '';
    _goal = prefs.getString('goal') ?? '';
    _healthEnabled = await _healthService.isEnabled();
    await loadWeightLogs();
    notifyListeners();
  }

  Future<void> loadWeightLogs() async {
    _weightLogs = await _dbService.getWeightLogs();
    notifyListeners();
  }

  Future<void> logWeight(double newWeight, DateTime date) async {
    // Profildeki güncel kiloyu da değiştir
    _weight = newWeight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', newWeight);
    
    // DB'ye logla
    await _dbService.saveWeight(newWeight, date);
    
    // Geçmişi RAM'de tazele
    await loadWeightLogs();
    
    // TODO: Apple Health / Google Fit aktarımı yapılabilir
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String goal,
  }) async {
    // Mifflin-St Jeor BMR
    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    double tdee = bmr * 1.375;
    if (goal == 'lose') tdee -= 400;
    if (goal == 'gain') tdee += 300;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setDouble('calorieGoal', tdee);
    await prefs.setBool('onboardingDone', true);
    await prefs.setInt('age', age);
    await prefs.setDouble('height', height);
    await prefs.setDouble('weight', weight);
    await prefs.setString('gender', gender);
    await prefs.setString('goal', goal);

    _userName = name;
    _dailyCalorieGoal = tdee;
    _age = age;
    _height = height;
    _weight = weight;
    _gender = gender;
    _goal = goal;
    
    // Ayrıca bu değişikliği (veya mevcut kiloyu) DB'de Kilo Logu olarak sakla
    await logWeight(weight, DateTime.now());
    
    notifyListeners();
  }

  // Apple Health
  bool _healthEnabled = false;
  bool get healthEnabled => _healthEnabled;

  Future<void> loadHealthEnabled() async {
    _healthEnabled = await _healthService.isEnabled();
    notifyListeners();
  }

  Future<bool> setHealthEnabled(bool value) async {
    if (value) {
      final granted = await _healthService.requestPermissions();
      if (!granted) return false;
    }
    await _healthService.setEnabled(value);
    _healthEnabled = value;
    notifyListeners();
    return true;
  }

  // Dil
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('locale');
    if (code != null) _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingDone') ?? false;
  }

  // Freemium — günlük 5 ücretsiz tarama
  static const int freeDailyLimit = 5;
  final bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<int> _getTodayScanCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString('scanDate') ?? '';
    if (savedDate != today) {
      await prefs.setString('scanDate', today);
      await prefs.setInt('scanCount', 0);
      return 0;
    }
    return prefs.getInt('scanCount') ?? 0;
  }

  Future<void> _incrementScanCount() async {
    final prefs = await SharedPreferences.getInstance();
    final count = await _getTodayScanCount();
    await prefs.setInt('scanCount', count + 1);
  }

  Future<int> remainingScans() async {
    if (_isPremium) return 999;
    final count = await _getTodayScanCount();
    return (freeDailyLimit - count).clamp(0, freeDailyLimit);
  }

  Future<bool> canScan() async {
    if (_isPremium) return true;
    final count = await _getTodayScanCount();
    return count < freeDailyLimit;
  }

  // ---------------------------------------------------------------------------
  // Streak
  // ---------------------------------------------------------------------------

  int _streak = 0;
  int get streak => _streak;

  Future<void> loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    _streak = prefs.getInt('streak') ?? 0;
    notifyListeners();
  }

  Future<void> _updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastScan = prefs.getString('streakLastDate') ?? '';

    if (lastScan == today) {
      // Already scanned today, no change
      return;
    }

    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
    if (lastScan == yesterday) {
      _streak = (_streak) + 1;
    } else {
      _streak = 1; // reset
    }

    await prefs.setInt('streak', _streak);
    await prefs.setString('streakLastDate', today);
    notifyListeners();
    unawaited(_syncWidget());
  }

  Future<void> _syncWidget() async {
    await WidgetService.updateData(
      calories: _todayStats['calories'] ?? 0,
      water: _waterToday,
      streak: _streak,
    );
  }

  // ---------------------------------------------------------------------------
  // Water tracking
  // ---------------------------------------------------------------------------

  double _waterToday = 0.0;
  double get waterToday => _waterToday;

  double _waterGoal = 2.0;
  double get waterGoal => _waterGoal;

  Future<void> loadWaterGoal() async {
    final prefs = await SharedPreferences.getInstance();
    _waterGoal = prefs.getDouble('waterGoal') ?? 2.0;
    notifyListeners();
  }

  Future<void> setWaterGoal(double liters) async {
    _waterGoal = liters;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('waterGoal', liters);
    notifyListeners();
  }

  /// Loads today's water total from the database.
  Future<void> loadTodayWater() async {
    _waterToday = await _dbService.getTodayWater();
    notifyListeners();
    unawaited(_syncWidget());
  }

  /// Adds [liters] to today's running total and persists the new value.
  Future<void> addWater(double liters) async {
    _waterToday += liters;
    await _dbService.saveWater(_waterToday, DateTime.now());
    unawaited(_healthService.logWater(liters: liters, time: DateTime.now()));
    notifyListeners();
    unawaited(_syncWidget());
  }

  // ---------------------------------------------------------------------------
  // Weekly stats
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> _weeklyStats = [];
  List<Map<String, dynamic>> get weeklyStats => _weeklyStats;

  /// Loads the last 7 days of aggregated nutrition data from the database.
  Future<void> loadWeeklyStats() async {
    _weeklyStats = await _dbService.getWeeklyStats();
    notifyListeners();
  }

  List<Map<String, dynamic>> _monthlyStats = [];
  List<Map<String, dynamic>> get monthlyStats => _monthlyStats;

  /// Loads the last 30 days of aggregated nutrition data from the database.
  Future<void> loadMonthlyStats() async {
    _monthlyStats = await _dbService.getMonthlyStats();
    notifyListeners();
  }
}
