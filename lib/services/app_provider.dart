import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_analysis.dart';
import '../widgets/portion_picker_sheet.dart';
import 'ai_service.dart';
import 'database_service.dart';
import 'health_service.dart';
import 'widget_service.dart';
import 'notification_service.dart';
import 'purchase_service.dart';
import 'api/api_client.dart';
import 'api/api_exception.dart';
import 'api/auth_service.dart';
import 'api/token_storage.dart';
import 'api/user_service.dart';
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
  final _claudeService = AIService();
  final _dbService = DatabaseService();
  final _healthService = HealthService();

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
    // TODO: Connect to GraphQL getDailyMeals(date) API
    // As a placeholder, we load the whole local history
    await loadHistory();
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
      final profile = <String, dynamic>{
        'age': _age,
        'gender': _gender,
        'weight': _weight,
        'height': _height,
        'goal': _goal,
      };

      // Resim kalıcı kayıt — HEIC dahil her formatı JPEG'e çevirir
      String localPath = imagePath;
      try {
        final srcFile = File(imagePath);
        if (srcFile.existsSync()) {
          final uniqueName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final appDir = await getApplicationDocumentsDirectory();
          localPath = p.join(appDir.path, uniqueName);
          final bytes = await FlutterImageCompress.compressWithFile(
            imagePath,
            minWidth: 1200,
            minHeight: 1200,
            quality: 85,
            format: CompressFormat.jpeg,
          );
          if (bytes != null) {
            await File(localPath).writeAsBytes(bytes);
          } else {
            await srcFile.copy(localPath);
          }
        }
      } catch (e) {
        debugPrint('[IMG] Hata: $e');
      }

      final analysis = await _claudeService.analyzeFood(
        localPath,
        portionAmount: portionAmount,
        isLiquid: isLiquid,
        cooking: cooking,
        userProfile: profile,
      );
      // DB'ye sadece dosya adını kaydet — UUID değişse bile çalışır
      final filename = p.basename(localPath);
      final relAnalysis = analysis.copyWith(imagePath: filename);
      await _dbService.saveAnalysis(relAnalysis);
      // _currentAnalysis tam path tutar (anlık gösterim için)
      _currentAnalysis = analysis.copyWith(imagePath: localPath);
      await _incrementScanCount();
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
    _history = await _dbService.getAllAnalyses();
    await loadTodayWater();
    notifyListeners();
  }

  Future<void> loadTodayStats() async {
    _todayStats = await _dbService.getTodayStats();
    notifyListeners();
    unawaited(_syncWidget());
    unawaited(loadTodaySteps());
  }

  Future<void> saveManualEntry(FoodAnalysis analysis) async {
    await _dbService.saveAnalysis(analysis);
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
  }

  Future<void> duplicateAnalysisToToday(FoodAnalysis analysis) async {
    final newAnalysis = analysis.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      analyzedAt: DateTime.now(),
      mealCategory: MealCategoryX.fromTime(DateTime.now()),
    );
    await saveManualEntry(newAnalysis);
  }

  Future<void> updateAnalysis(FoodAnalysis analysis) async {
    await _dbService.saveAnalysis(analysis);
    await loadHistory();
    await loadTodayStats();
  }

  Future<void> toggleFavorite(FoodAnalysis analysis) async {
    final newVal = !analysis.isFavorite;
    // TODO: Connect to GraphQL toggleFavoriteMeal(mealId, isFavorite)
    // For now we persist it locally as a mock
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

    // Backend'de şu an sadece mealsPerDay + allergens (restrictions) saklanıyor.
    // Geri kalan anamnesis alanları EAT-117 ile backend'e eklenecek.
    try {
      final res = await _userService.updateProfile(
        mealsPerDay: mealsPerDay,
        allergens: restrictions,
      );
      _applyBackendUser(res);
    } on ApiException {
      rethrow;
    }

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

  Future<void> authSocialLogin(String provider) async {
    // Native SDK entegrasyonu (Google/Apple/Facebook) EAT-109 kapsamında
    // ayrı bir alt-task olarak eklenecek. O tamamlanınca buraya
    // idToken geçilip AuthService.socialLogin çağrılacak.
    throw UnimplementedError(
      'Social login native SDK entegrasyonu henüz bağlanmadı (EAT-109)',
    );
  }

  Future<void> authLogout() async {
    try {
      await _authService.logout();
    } catch (_) {}
    await _tokenStorage.clear();
    _isLoggedIn = false;
    _userName = '';
    notifyListeners();
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
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  Future<void> refreshPremiumStatus() async {
    _isPremium = await PurchaseService.checkPremium();
    notifyListeners();
  }

  Future<bool> restorePurchases() async {
    final restored = await PurchaseService.restore();
    if (restored) {
      _isPremium = true;
      notifyListeners();
    }
    return restored;
  }

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

  /// Resets today's water to zero.
  Future<void> resetWater() async {
    _waterToday = 0.0;
    await _dbService.saveWater(0.0, DateTime.now());
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

  /// Loads the last 7 days of aggregated nutrition data and calculates insights.
  Future<void> loadWeeklyStats() async {
    _weeklyStats = await _dbService.getWeeklyStats();
    final topMeal = await _dbService.getTopMealCategory(7);
    _weeklyInsights = _calculateInsights(_weeklyStats, 7, topMeal);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Backend Sync Mock
  // ---------------------------------------------------------------------------
  Future<void> syncBackendProfileAndSettings() async {
    debugPrint('[BackendSync] Profil ve Settings bilgileri senkronize ediliyor...');
    // TODO: Jira EAT-104 && EAT-105 endpoint bağlantıları yapılınca burası değişecek
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Geçici Mock Data: Backend'den gelmiş gibi in-memory set atıyoruz. Local kaydetmiyoruz.
    if (_userName.isEmpty) { // Sadece on-boarding vs sonrası üstüne yazmasın diye basit kontrol
      _userName = "Yapay Zeka (Mock)";
      _age = 26;
      _height = 180.0;
      _weight = 75.0;
      _targetWeight = 70.0;
      _gender = "male";
      _goal = "lose";
      _activityLevel = "active";
      _dietType = "standard";
    }

    notifyListeners();
    debugPrint('[BackendSync] Senkronizasyon tamamlandı, in-memory mock data setlendi.');
  }


  /// Loads the last 30 days of aggregated nutrition data and calculates insights.
  Future<void> loadMonthlyStats() async {
    _monthlyStats = await _dbService.getMonthlyStats();
    final topMeal = await _dbService.getTopMealCategory(30);
    _monthlyInsights = _calculateInsights(_monthlyStats, 30, topMeal);
    notifyListeners();
  }

  Map<String, dynamic> _calculateInsights(List<Map<String, dynamic>> stats, int days, String? topMeal) {
    if (stats.isEmpty) return {};

    double totalCal = 0;
    double totalWater = 0;
    int goalMetDays = 0;
    double maxCal = 0;
    String topDay = '';

    for (final day in stats) {
      final cal = day['calories'] as double;
      final water = day['water'] as double;
      totalCal += cal;
      totalWater += water;

      if (cal > 0 && cal <= _dailyCalorieGoal * 1.1 && cal >= _dailyCalorieGoal * 0.9) {
        goalMetDays++;
      }

      if (cal > maxCal) {
        maxCal = cal;
        topDay = day['date'];
      }
    }

    return {
      'avgCal': totalCal / days,
      'avgWater': totalWater / days,
      'goalAchievement': (totalCal / (days * _dailyCalorieGoal)) * 100,
      'consistencyScore': (goalMetDays / days) * 100,
      'topDay': topDay,
      'topMeal': topMeal,
    };
  }
}
