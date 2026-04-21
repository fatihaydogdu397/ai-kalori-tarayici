import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_analysis.dart';
import '../widgets/portion_picker_sheet.dart';
import 'health_service.dart';
import 'widget_service.dart';
import 'notification_service.dart';
import 'purchase_service.dart';
import 'api/api_client.dart';
import 'api/api_exception.dart';
import 'api/auth_service.dart';
import 'api/food_service.dart';
import 'api/progress_service.dart';
import 'api/token_storage.dart';
import 'api/user_service.dart';
import 'api/water_service.dart';
import 'api/blood_test_service.dart';
import '../models/blood_test.dart';
import '../main.dart' show rootNavigatorKey;
import '../screens/auth/auth_screen.dart';
import 'api/weight_service.dart';
import '../generated/app_localizations.dart';

enum AnalysisState { idle, loading, success, error }

enum UnitSystem { metric, imperial }

extension UnitSystemX on UnitSystem {
  bool get isMetric => this == UnitSystem.metric;
  String weightUnit(double kg) => isMetric
      ? '${kg.toStringAsFixed(1)} kg'
      : '${(kg * 2.20462).toStringAsFixed(1)} lb';
  String heightUnit(double cm) =>
      isMetric ? '${cm.toStringAsFixed(0)} cm' : _cmToFtIn(cm);
  static String _cmToFtIn(double cm) {
    final totalIn = cm / 2.54;
    final ft = totalIn ~/ 12;
    final inch = (totalIn % 12).round();
    return "$ft'$inch\"";
  }
}

class AppProvider extends ChangeNotifier {
  final _healthService = HealthService();
  final FoodService _foodService = FoodService.instance;
  final WaterService _waterService = WaterService.instance;
  final WeightService _weightService = WeightService.instance;
  final ProgressService _progressService = ProgressService.instance;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isDark')) {
      final isDark = prefs.getBool('isDark')!;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system; // First launch uses system
    }
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    bool isCurrentlyDark;
    if (_themeMode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      isCurrentlyDark = brightness == Brightness.dark;
    } else {
      isCurrentlyDark = _themeMode == ThemeMode.dark;
    }

    _themeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    
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
  List<FoodAnalysis> get favorites =>
      _history.where((a) => a.isFavorite).toList();
  Map<String, double> get todayStats => _todayStats;
  String get errorMessage => _errorMessage;
  double get dailyCalorieGoal => _dailyCalorieGoal;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  bool get isTodaySelected {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
           _selectedDate.month == now.month &&
           _selectedDate.day == now.day;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    fetchHistoryByDate(date);
    notifyListeners();
  }

  Future<void> fetchHistoryByDate(DateTime date) async {
    if (!_isLoggedIn) {
      _history = const [];
      notifyListeners();
      return;
    }
    final iso = date.toUtc().toIso8601String().substring(0, 10);
    try {
      final rows = await _foodService.getDailyMeals(iso);
      _history = rows.map(FoodAnalysis.fromBackend).toList(growable: false);
    } on ApiException {
      _history = const [];
    }
    notifyListeners();
  }

  double get todayCalories => _todayStats['calories'] ?? 0;
  double get calorieProgress =>
      (todayCalories / _dailyCalorieGoal).clamp(0.0, 1.0);

  Future<void> analyzeImage(
    String imagePath, {
    int? portionAmount,
    bool isLiquid = false,
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
      // Görseli 1200px/%85 jpeg'e sıkıştır ve base64 encode et. BE kendi DB'sine
      // yazar ve R2'ye upload eder, analysis sonucunu geri döner.
      final srcFile = File(imagePath);
      if (!srcFile.existsSync()) {
        throw ApiException('Seçili dosya bulunamadı', code: 'FILE_NOT_FOUND');
      }

      final compressed = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: 1200,
        minHeight: 1200,
        quality: 85,
        format: CompressFormat.jpeg,
      );
      final bytes = compressed ?? await srcFile.readAsBytes();
      final imageBase64 = base64Encode(bytes);

      final res = await _foodService.analyzeFood(
        imageBase64: imageBase64,
        mealCategory: MealCategoryX.fromTime(DateTime.now()).key,
        portionAmount: portionAmount,
        isLiquid: isLiquid,
        cookingMethod: cooking?.backendKey,
      );
      final analysis = FoodAnalysis.fromBackend(res);

      _currentAnalysis = analysis;
      await _updateStreak();
      await loadHistory();
      await loadTodayStats();

      unawaited(
        _healthService.logMeal(
          calories: analysis.totalNutrients.calories,
          protein: analysis.totalNutrients.protein,
          carbs: analysis.totalNutrients.carbs,
          fat: analysis.totalNutrients.fat,
          time: analysis.analyzedAt,
        ),
      );
      _state = AnalysisState.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AnalysisState.error;
    }

    notifyListeners();
  }

  Future<void> loadHistory() async {
    if (!_isLoggedIn) {
      _history = const [];
      notifyListeners();
      return;
    }
    try {
      final rows = await _foodService.foodHistory(limit: 100);
      _history = rows.map(FoodAnalysis.fromBackend).toList(growable: false);
    } on ApiException {
      _history = const [];
    }
    notifyListeners();
  }

  Future<void> loadTodayStats() async {
    if (!_isLoggedIn) {
      _todayStats = {};
      notifyListeners();
      return;
    }
    try {
      final stats = await _progressService.todayStats();
      _todayStats = {
        'calories': (stats['totalCalories'] as num?)?.toDouble() ?? 0.0,
        'protein': (stats['totalProtein'] as num?)?.toDouble() ?? 0.0,
        'carbs': (stats['totalCarbs'] as num?)?.toDouble() ?? 0.0,
        'fat': (stats['totalFat'] as num?)?.toDouble() ?? 0.0,
        'fiber': (stats['totalFiber'] as num?)?.toDouble() ?? 0.0,
        'sugar': (stats['totalSugar'] as num?)?.toDouble() ?? 0.0,
        'mealCount': (stats['scanCount'] as num?)?.toDouble() ?? 0.0,
      };
      _waterToday = (stats['waterLiters'] as num?)?.toDouble() ?? 0;
      final goal = (stats['waterGoal'] as num?)?.toDouble();
      if (goal != null) _waterGoal = goal;
    } on ApiException {
      _todayStats = {};
    }
    notifyListeners();
    unawaited(_syncWidget());
    unawaited(loadTodaySteps());
  }

  Future<void> saveManualEntry(FoodAnalysis analysis) async {
    // BE ManualFoodInput tekil ürün; birden fazla food item birleştirilmiş
    // makro değerleri tek satır olarak yazıyor.
    final display = analysis.foods.isNotEmpty
        ? analysis.foods.first.name
        : (analysis.summary.isNotEmpty ? analysis.summary : 'Meal');
    final portion = analysis.foods.isNotEmpty
        ? analysis.foods.first.portion
        : 100.0;

    final res = await _foodService.saveFoodAnalysis(
      name: display,
      portion: portion,
      calories: analysis.totalNutrients.calories,
      protein: analysis.totalNutrients.protein,
      carbs: analysis.totalNutrients.carbs,
      fat: analysis.totalNutrients.fat,
      mealCategory: analysis.mealCategory.key,
    );
    final saved = FoodAnalysis.fromBackend(res);

    _history = [saved, ..._history];
    notifyListeners();
    await loadTodayStats();

    unawaited(
      _healthService.logMeal(
        calories: saved.totalNutrients.calories,
        protein: saved.totalNutrients.protein,
        carbs: saved.totalNutrients.carbs,
        fat: saved.totalNutrients.fat,
        time: saved.analyzedAt,
      ),
    );
  }

  Future<void> duplicateAnalysisToToday(FoodAnalysis analysis) async {
    // BE'de updateFoodAnalysis (EAT-118) beklemede — şu an duplicate da
    // saveFoodAnalysis ile yeni kayıt olarak yazılıyor; aynı davranış.
    await saveManualEntry(
      analysis.copyWith(
        analyzedAt: DateTime.now(),
        mealCategory: MealCategoryX.fromTime(DateTime.now()),
      ),
    );
  }

  Future<void> updateAnalysis(FoodAnalysis analysis) async {
    // BE'de updateFoodAnalysis mutation EAT-118 ile geliyor. Henüz yok;
    // şimdilik sadece local history'yi güncelleyip UI'ı tutarlı tut.
    final idx = _history.indexWhere((a) => a.id == analysis.id);
    if (idx != -1) {
      _history[idx] = analysis;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(FoodAnalysis analysis) async {
    try {
      final res = await _foodService.toggleFavoriteMeal(
        analysis.id,
        !analysis.isFavorite,
      );
      final updated = FoodAnalysis.fromBackend(res);
      final idx = _history.indexWhere((a) => a.id == analysis.id);
      if (idx != -1) _history[idx] = updated;
      notifyListeners();
    } on ApiException {
      rethrow;
    }
  }

  Future<void> deleteAnalysis(String id) async {
    final ok = await _foodService.deleteMeal(id);
    if (!ok) return;
    _history = _history.where((a) => a.id != id).toList(growable: false);
    notifyListeners();
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
    notifyListeners();
    if (_isLoggedIn) {
      try {
        await _userService.updateProfile(unitSystem: system.name);
      } on ApiException {
        // Sessiz geç — UI'da kullanıcı görse de zararsız; bir sonraki
        // açılışta `me` ile yeniden senkron olacak.
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('unitSystem', system.name);
  }

  // Profile
  String _userName = '';
  int _age = 0;
  double _height = 0;
  double _weight = 0;
  String _gender = '';
  String _goal = '';
  String _activityLevel = 'active';
  double _targetWeight = 0;
  double _weeklyPace = 0.5;
  String _dietType = 'standard';

  // Dietary anamnesis (program tab)
  List<String> _dietRestrictions = [];
  List<String> _dietCuisines = [];
  int _dietMealsPerDay = 4;
  String _dietCookingTime = 'medium';
  String _dietBudget = 'medium';
  String _dietNotes = '';

  // Weight tracking history
  List<Map<String, dynamic>> _weightLogs = [];
  List<Map<String, dynamic>> get weightLogs => _weightLogs;

  String get userName => _userName;
  int get age => _age;
  double get height => _height;
  double get weight => _weight;
  String get gender => _gender;
  String get goal => _goal;
  String get activityLevel => _activityLevel;
  double get targetWeight => _targetWeight;
  double get weeklyPace => _weeklyPace;
  String get dietType => _dietType;

  List<String> get dietRestrictions => _dietRestrictions;
  List<String> get dietCuisines => _dietCuisines;
  int get dietMealsPerDay => _dietMealsPerDay;
  String get dietCookingTime => _dietCookingTime;
  String get dietBudget => _dietBudget;
  String get dietNotes => _dietNotes;
  bool get hasDietPlan => _dietRestrictions.isNotEmpty || _dietCuisines.isNotEmpty;

  double get bmi => (_height > 0 && _weight > 0)
      ? _weight / ((_height / 100) * (_height / 100))
      : 0;

  double get bmr {
    if (_weight <= 0 || _height <= 0 || _age <= 0) return 0;
    if (_gender == 'male') return 10 * _weight + 6.25 * _height - 5 * _age + 5;
    return 10 * _weight + 6.25 * _height - 5 * _age - 161;
  }

  double get tdee {
    if (bmr <= 0) return 0;
    double multiplier = 1.55; // active
    if (_activityLevel == 'sedentary') {
      multiplier = 1.2;
    } else if (_activityLevel == 'light') {
      multiplier = 1.375;
    } else if (_activityLevel == 'very_active') {
      multiplier = 1.725;
    }
    return bmr * multiplier;
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    // NOT: Backend entegrasyonu mimarisine geçildiği için profil verileri localden
    // değil sunucudan (şu an mock RAM'den) alınıyor. Sadece gerekli flag'ler çekilir.
    _dailyCalorieGoal = prefs.getDouble('calorieGoal') ?? 2000;
    _waterGoal = prefs.getDouble('waterGoal') ?? 2.0;
    _streak = prefs.getInt('streak') ?? 0;
    _unitSystem = (prefs.getString('unitSystem') == 'imperial')
        ? UnitSystem.imperial
        : UnitSystem.metric;
    
    _healthEnabled = await _healthService.isEnabled();
    await loadWeightLogs();
    notifyListeners();
  }

  Future<void> saveAnamnesisProfile({
    required List<String> restrictions,
    required List<String> cuisines,
    required int mealsPerDay,
    required String cookingTime,
    required String budget,
    required String notes,
  }) async {
    _dietRestrictions = restrictions;
    _dietCuisines = cuisines;
    _dietMealsPerDay = mealsPerDay;
    _dietCookingTime = cookingTime;
    _dietBudget = budget;
    _dietNotes = notes;

    try {
      final res = await _userService.updateProfile(
        mealsPerDay: mealsPerDay,
        allergens: restrictions,
        cuisinePreferences: cuisines,
        dietCookingTime: _mapCookingTimeToBackend(cookingTime),
        dietBudget: budget, // BE enum: LOW/MEDIUM/HIGH — UserService uppercase'liyor.
        dietNotes: notes,
      );
      _applyBackendUser(res);
    } on ApiException {
      rethrow;
    }

    notifyListeners();
  }

  /// FE picker değerlerini (`quick/medium/relaxed`) BE `DietCookingTime`
  /// enum'una (`FAST/MEDIUM/SLOW`) çevirir. UserService tarafı uppercase'leme
  /// yaptığı için burada lowercase dönüyoruz.
  String? _mapCookingTimeToBackend(String fe) {
    switch (fe) {
      case 'quick':
        return 'fast';
      case 'relaxed':
        return 'slow';
      case 'medium':
        return 'medium';
    }
    return null;
  }

  // ───── Blood tests ─────────────────────────────────────────────────────────
  final BloodTestService _bloodTestService = BloodTestService.instance;
  List<BloodTest> _bloodTests = const [];
  bool _bloodTestsLoading = false;
  List<BloodTest> get bloodTests => _bloodTests;
  bool get bloodTestsLoading => _bloodTestsLoading;

  Future<void> loadBloodTests() async {
    if (!_isLoggedIn) {
      _bloodTests = const [];
      notifyListeners();
      return;
    }
    _bloodTestsLoading = true;
    notifyListeners();
    try {
      _bloodTests = await _bloodTestService.list(limit: 50);
    } on ApiException {
      _bloodTests = const [];
    } finally {
      _bloodTestsLoading = false;
    }
    notifyListeners();
  }

  Future<BloodTest> uploadBloodTest({
    required String base64,
    required String mimeType,
    String? testDate,
  }) async {
    final created = await _bloodTestService.upload(
      base64: base64,
      mimeType: mimeType,
      testDate: testDate,
    );
    _bloodTests = [created, ..._bloodTests];
    notifyListeners();
    return created;
  }

  Future<void> deleteBloodTest(String id) async {
    final ok = await _bloodTestService.delete(id);
    if (ok) {
      _bloodTests = _bloodTests.where((t) => t.id != id).toList();
      notifyListeners();
    }
  }

  Future<void> loadWeightLogs() async {
    if (!_isLoggedIn) {
      _weightLogs = const [];
      notifyListeners();
      return;
    }
    try {
      _weightLogs = await _weightService.weightLogs(limit: 60);
    } on ApiException {
      _weightLogs = const [];
    }
    notifyListeners();
  }

  Future<void> logWeight(double newWeight, DateTime date) async {
    _weight = newWeight;

    if (_isLoggedIn) {
      final iso = date.toIso8601String().substring(0, 10);
      try {
        await _weightService.logWeight(newWeight, date: iso);
      } on ApiException {
        rethrow;
      }
      // Profilin güncel weight'i de BE'ye yazılsın (silent).
      unawaited(() async {
        try {
          await _userService.updateProfile(weight: newWeight);
        } catch (_) {}
      }());
    }

    await loadWeightLogs();
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required int age,
    required double height,
    required double weight,
    required String gender,
    required String goal,
    String? activityLevel,
    double? targetWeight,
    double? weeklyPace,
    String? dietType,
  }) async {
    final actLevel = activityLevel ?? _activityLevel;

    // Backend updateProfile'a gönder — dailyCalorieGoal ve makro hedefleri
    // BE otomatik hesaplıyor (age+height+weight+activity+goal).
    final res = await _userService.updateProfile(
      name: name,
      age: age,
      height: height,
      weight: weight,
      gender: gender,
      goal: goal,
      activityLevel: actLevel,
      dietType: dietType,
    );
    _applyBackendUser(res);

    // Onboarding flag local tutuluyor (BE'de karşılığı yok, hot-start cache).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', true);

    // EAT-117'de BE'ye taşınana kadar bunlar local (RAM) tutuluyor.
    if (targetWeight != null) _targetWeight = targetWeight;
    if (weeklyPace != null) _weeklyPace = weeklyPace;

    // Kilo değişimini weight log'u olarak da kaydet.
    await logWeight(weight, DateTime.now());

    notifyListeners();
  }

  // Steps (Apple Health, iOS only)
  int _todaySteps = 0;
  double _todayActiveCalories = 0;
  int get todaySteps => _todaySteps;
  double get todayActiveCalories => _todayActiveCalories;

  Future<void> loadTodaySteps() async {
    if (!_healthEnabled) return;
    _todaySteps = await _healthService.getTodaySteps();
    _todayActiveCalories = await _healthService.getTodayActiveCalories();
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

  Future<void> syncNotification(AppLocalizations l) async {
    await NotificationService.updateDailySummary(
      l,
      calories: _todayStats['calories'] ?? 0,
      goal: _dailyCalorieGoal,
      water: _waterToday,
    );
  }

  Future<void> _syncLocaleToBackend(Locale locale) async {
    if (!_isLoggedIn) return;
    try {
      await _userService.updateProfile(locale: locale.languageCode);
    } on ApiException {
      // Fire-and-forget: sonraki açılışta me ile senkron olur.
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
    await _syncLocaleToBackend(locale);
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingDone') ?? false;
  }

  // ---------------------------------------------------------------------------
  // Authentication
  // ---------------------------------------------------------------------------

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  final TokenStorage _tokenStorage = TokenStorage();
  final AuthService _authService = AuthService.instance;
  final UserService _userService = UserService.instance;

  /// App startup'ta çağrılır. Secure storage'da token varsa `me` sorgusuyla
  /// profili yükler ve oturumu açar; yoksa çıkış durumuna kalır.
  Future<void> bootstrapSession() async {
    // ApiClient 401 sonrası otomatik logout tetikleyebilsin.
    ApiClient.instance.onLogout = () async {
      await authLogout();
    };

    if (!await _tokenStorage.hasSession()) {
      _isLoggedIn = false;
      notifyListeners();
      return;
    }
    try {
      final user = await _authService.me();
      _applyBackendUser(user);
      _isLoggedIn = true;
    } on ApiException catch (e) {
      if (e.isUnauthenticated) {
        // Token geçersiz / expire → temizle.
        await _tokenStorage.clear();
        _isLoggedIn = false;
      } else {
        // Ağ hatası, BE down vb. → token dursun; kullanıcı daha sonra
        // tekrar deneyebilsin. Offline-first yok ama ağ hatası ≠ logout.
        _isLoggedIn = false;
      }
    }
    notifyListeners();
  }

  Future<void> loadAuthStatus() => bootstrapSession();

  Future<void> setLoggedIn(bool val) async {
    _isLoggedIn = val;
    notifyListeners();
  }

  Future<void> authLogin(String email, String password) async {
    final res = await _authService.login(email: email, password: password);
    _applyBackendUser(Map<String, dynamic>.from(res['user'] as Map));
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> authRegister(
      String name, String surname, String email, String password) async {
    final res = await _authService.signup(
      name: name,
      surname: surname,
      email: email,
      password: password,
    );
    _applyBackendUser(Map<String, dynamic>.from(res['user'] as Map));

    // Yeni kayıt: onboarding tamamlanmadı.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', false);

    _isLoggedIn = true;
    notifyListeners();
  }

  /// [provider]: "GOOGLE" | "APPLE" | "FACEBOOK"
  /// [idToken]: OAuth id token (native SDK'dan alınır).
  Future<void> authSocialLogin({
    required String provider,
    required String idToken,
  }) async {
    final res = await _authService.socialLogin(
      provider: provider,
      idToken: idToken,
    );
    _applyBackendUser(Map<String, dynamic>.from(res['user'] as Map));
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> authLogout() async {
    // Token yoksa BE'ye logout atmaya gerek yok; ApiClient zaten onLogout'u
    // storage temizledikten sonra çağırıyor, o yüzden burada tekrar istek
    // gönderirsek 401 → onLogout → authLogout döngüsüne girebiliriz.
    if (await _tokenStorage.hasSession()) {
      try {
        await _authService.logout();
      } catch (_) {}
    }
    await _tokenStorage.clear();
    _isLoggedIn = false;
    _userName = '';
    notifyListeners();

    // Refresh de başarısız olmuşsa kullanıcıyı login ekranına yolla. Global
    // navigator key kullanıyoruz çünkü authLogout arkaplanda ApiClient
    // callback'inden de çağrılıyor ve context'e erişimimiz olmayabilir.
    final nav = rootNavigatorKey.currentState;
    if (nav != null) {
      nav.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  Future<void> sendPasswordResetOtp(String email) async {
    await _authService.forgotPassword(email);
  }

  Future<void> verifyPasswordResetOtp(String email, String otp) async {
    final ok = await _authService.verifyOtp(email: email, code: otp);
    if (!ok) {
      throw ApiException('Invalid OTP code', code: 'INVALID_OTP');
    }
  }

  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    final ok = await _authService.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
    if (!ok) {
      throw ApiException('Password reset failed', code: 'RESET_FAILED');
    }
  }

  /// Backend User objesini AppProvider field'larına yayar.
  /// Enum alanları BE'den UPPERCASE gelir (MALE, LOSE, SEDENTARY, vb.);
  /// FE içinde lowercase tutulur.
  void _applyBackendUser(Map<String, dynamic> user) {
    final first = (user['name'] as String?)?.trim() ?? '';
    final last = (user['surname'] as String?)?.trim() ?? '';
    _userName = [first, last].where((s) => s.isNotEmpty).join(' ');

    _isPremium = user['isPremium'] == true;
    _streak = (user['streak'] as num?)?.toInt() ?? _streak;

    _age = (user['age'] as num?)?.toInt() ?? _age;
    _height = (user['height'] as num?)?.toDouble() ?? _height;
    _weight = (user['weight'] as num?)?.toDouble() ?? _weight;

    final gender = (user['gender'] as String?)?.toLowerCase();
    if (gender != null && gender.isNotEmpty) _gender = gender;
    final goal = (user['goal'] as String?)?.toLowerCase();
    if (goal != null && goal.isNotEmpty) _goal = goal;
    final act = (user['activityLevel'] as String?)?.toLowerCase();
    if (act != null && act.isNotEmpty) _activityLevel = act;
    final diet = (user['dietType'] as String?)?.toLowerCase();
    if (diet != null && diet.isNotEmpty) _dietType = diet;
    final mealsPerDay = (user['mealsPerDay'] as num?)?.toInt();
    if (mealsPerDay != null) _dietMealsPerDay = mealsPerDay;

    final allergens = user['allergens'];
    if (allergens is List) {
      _dietRestrictions = allergens.map((e) => e.toString()).toList();
    }
    final cuisines = user['cuisinePreferences'];
    if (cuisines is List) {
      _dietCuisines = cuisines.map((e) => e.toString()).toList();
    }
    final beCookingTime = (user['dietCookingTime'] as String?)?.toLowerCase();
    if (beCookingTime != null && beCookingTime.isNotEmpty) {
      // BE enum (fast/medium/slow) → FE picker (quick/medium/relaxed).
      _dietCookingTime = switch (beCookingTime) {
        'fast' => 'quick',
        'slow' => 'relaxed',
        _ => 'medium',
      };
    }
    final beBudget = (user['dietBudget'] as String?)?.toLowerCase();
    if (beBudget != null && beBudget.isNotEmpty) {
      _dietBudget = beBudget;
    }
    final beNotes = user['dietNotes'] as String?;
    if (beNotes != null) _dietNotes = beNotes;

    final waterGoal = (user['waterGoal'] as num?)?.toDouble();
    if (waterGoal != null) _waterGoal = waterGoal;
    final calorieGoal = (user['dailyCalorieGoal'] as num?)?.toDouble();
    if (calorieGoal != null) _dailyCalorieGoal = calorieGoal;

    final unit = (user['unitSystem'] as String?)?.toLowerCase();
    if (unit == 'imperial') {
      _unitSystem = UnitSystem.imperial;
    } else if (unit == 'metric') {
      _unitSystem = UnitSystem.metric;
    }

    final loc = user['locale'] as String?;
    if (loc != null && loc.isNotEmpty) {
      _locale = Locale(loc);
    }
  }

  // Freemium — günlük 5 ücretsiz tarama
  static const int freeDailyLimit = 5;

  // DEV ONLY: launch öncesi false yap, paywall'ı yeniden aktive eder.
  static const bool kBypassPaywall = true;

  bool _isPremium = false;
  bool get isPremium => kBypassPaywall || _isPremium;

  /// BE `me` query'si + RevenueCat kombinasyonu. BE source of truth.
  /// Webhook (EAT-107) satın alma sonrası user.is_premium'u günceller; FE
  /// paywall/restore sonrası bu metotu çağırıp taze durumu alır.
  Future<void> refreshPremiumStatus() async {
    if (_isLoggedIn) {
      try {
        final user = await _userService.me();
        _applyBackendUser(user);
      } on ApiException {
        // Ağ yoksa RevenueCat cache'ine fallback.
        _isPremium = await PurchaseService.checkPremium();
      }
    } else {
      _isPremium = await PurchaseService.checkPremium();
    }
    notifyListeners();
  }

  Future<bool> restorePurchases() async {
    final restored = await PurchaseService.restore();
    if (restored) {
      // RevenueCat'ten onay geldiyse BE'den de güncel state'i çek.
      await refreshPremiumStatus();
    }
    return restored;
  }

  /// Kalan günlük tarama sayısı. Premium ise `999` (sınırsız göstergesi).
  /// Free kullanıcı için BE `remainingScans` tek source of truth.
  Future<int> remainingScans() async {
    if (isPremium) return 999;
    if (!_isLoggedIn) return freeDailyLimit;
    try {
      return await _progressService.remainingScans();
    } on ApiException {
      return 0;
    }
  }

  Future<bool> canScan() async {
    if (isPremium) return true;
    final left = await remainingScans();
    return left > 0;
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

    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
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
    notifyListeners();
    if (_isLoggedIn) {
      try {
        await _userService.updateProfile(waterGoal: liters);
      } on ApiException {
        // Fire-and-forget; sonraki `me` senkronda güncellenir.
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('waterGoal', liters);
  }

  /// Bugünün su değerini BE todayStats içinden loadTodayStats çekiyor; bu
  /// metot artık ayrı bir BE call değil. Geriye dönük API korunuyor.
  Future<void> loadTodayWater() async {
    // todayStats zaten waterLiters / waterGoal yüklüyor; burada ayrıca iş yok.
    notifyListeners();
  }

  /// Bugünün toplamına [liters] ekle ve BE'ye yaz (absolute toplam gönderilir).
  Future<void> addWater(double liters) async {
    if (!_isLoggedIn) return;
    final newTotal = (_waterToday + liters).clamp(0.0, 3.0);
    try {
      final saved = await _waterService.logWater(newTotal);
      _waterToday = saved;
    } on ApiException {
      rethrow;
    }
    unawaited(_healthService.logWater(liters: liters, time: DateTime.now()));
    notifyListeners();
    unawaited(_syncWidget());
  }

  /// Bugünün su değerini sıfırla (BE).
  Future<void> resetWater() async {
    if (!_isLoggedIn) return;
    try {
      final saved = await _waterService.resetWater();
      _waterToday = saved;
    } on ApiException {
      rethrow;
    }
    notifyListeners();
    unawaited(_syncWidget());
  }

  // ---------------------------------------------------------------------------
  // Weekly stats
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Weekly & Monthly Stats
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> _weeklyStats = [];
  List<Map<String, dynamic>> get weeklyStats => _weeklyStats;

  List<Map<String, dynamic>> _monthlyStats = [];
  List<Map<String, dynamic>> get monthlyStats => _monthlyStats;

  Map<String, dynamic> _weeklyInsights = {};
  Map<String, dynamic> get weeklyInsights => _weeklyInsights;

  Map<String, dynamic> _monthlyInsights = {};
  Map<String, dynamic> get monthlyInsights => _monthlyInsights;

  /// Loads the last 7 days from BE progress.weeklyStats.
  Future<void> loadWeeklyStats() async {
    if (!_isLoggedIn) return;
    try {
      final period = await _progressService.weeklyStats();
      _weeklyStats = _mapDays(period['days'] as List?);
      _weeklyInsights = _mapInsights(period, 7);
    } on ApiException {
      _weeklyStats = const [];
      _weeklyInsights = const {};
    }
    notifyListeners();
  }

  /// Home ekranı açılışta çağırır — `me` query'sini çekip state'i tazeler.
  /// Eskiden mock data dolduruyordu; artık gerçek BE.
  Future<void> syncBackendProfileAndSettings() async {
    if (!_isLoggedIn) return;
    try {
      final user = await _userService.me();
      _applyBackendUser(user);
      notifyListeners();
    } on ApiException {
      // Ağ yoksa sessiz geç — splash/bootstrap'ın önceden yüklediği veri durur.
    }
  }


  /// Loads the last 30 days from BE progress.monthlyStats.
  Future<void> loadMonthlyStats() async {
    if (!_isLoggedIn) return;
    try {
      final period = await _progressService.monthlyStats();
      _monthlyStats = _mapDays(period['days'] as List?);
      _monthlyInsights = _mapInsights(period, 30);
    } on ApiException {
      _monthlyStats = const [];
      _monthlyInsights = const {};
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> _mapDays(List? days) {
    if (days == null) return const [];
    return days.map<Map<String, dynamic>>((raw) {
      final d = Map<String, dynamic>.from(raw as Map);
      return {
        'date': d['date'] as String,
        'calories': (d['totalCalories'] as num?)?.toDouble() ?? 0.0,
        'protein': (d['totalProtein'] as num?)?.toDouble() ?? 0.0,
        'carbs': (d['totalCarbs'] as num?)?.toDouble() ?? 0.0,
        'fat': (d['totalFat'] as num?)?.toDouble() ?? 0.0,
        'water': (d['waterLiters'] as num?)?.toDouble() ?? 0.0,
        'scanCount': (d['scanCount'] as num?)?.toInt() ?? 0,
      };
    }).toList(growable: false);
  }

  Map<String, dynamic> _mapInsights(Map<String, dynamic> period, int days) {
    final avgCal = (period['avgCalories'] as num?)?.toDouble() ?? 0.0;
    final avgWater = ((period['days'] as List?) ?? const [])
            .whereType<Map>()
            .map((d) => (d['waterLiters'] as num?)?.toDouble() ?? 0.0)
            .fold<double>(0, (a, b) => a + b) /
        (days.clamp(1, days));
    final topMealRaw = period['topMealCategory'] as String?;
    return {
      'avgCal': avgCal,
      'avgWater': avgWater,
      'goalAchievement': (period['goalAchievementPercent'] as num?)?.toDouble() ?? 0.0,
      'consistencyScore': (period['goalAchievementPercent'] as num?)?.toDouble() ?? 0.0,
      'topMeal': topMealRaw?.toLowerCase(),
    };
  }

}
