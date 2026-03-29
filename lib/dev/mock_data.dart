import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_analysis.dart';
import '../services/database_service.dart';

// ============================================================
//  MOCK DATA KONTROLÜ
//  true  → uygulama başlarken otomatik seed eder
//  false → hiçbir şeye dokunmaz
// ============================================================
const bool kUseMockData = true;

Future<void> seedIfNeeded(DatabaseService db) async {
  if (!kUseMockData) return;

  // Zaten veri varsa tekrar ekleme
  final existing = await db.getAllAnalyses();
  if (existing.isNotEmpty) return;

  // Profil seed
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userName', 'Fatih');
  await prefs.setInt('age', 28);
  await prefs.setDouble('height', 178);
  await prefs.setDouble('weight', 75);
  await prefs.setString('gender', 'male');
  await prefs.setString('goal', 'maintain');
  await prefs.setBool('onboardingDone', true);

  final now = DateTime.now();

  final meals = [
    // Bugün
    _mock('Menemen', MealCategory.breakfast, _dt(now, 0, 8, 30), 320, 18, 22, 14),
    _mock('Izgara Tavuk + Pilav', MealCategory.lunch, _dt(now, 0, 12, 45), 580, 42, 55, 12),
    _mock('Elma', MealCategory.snack, _dt(now, 0, 16, 0), 95, 0, 25, 0),
    _mock('Mercimek Çorbası', MealCategory.dinner, _dt(now, 0, 19, 30), 210, 12, 30, 4),
    // Dün
    _mock('Yulaf Ezmesi', MealCategory.breakfast, _dt(now, 1, 9, 0), 280, 10, 48, 6),
    _mock('Döner Dürüm', MealCategory.lunch, _dt(now, 1, 13, 15), 620, 35, 58, 18),
    _mock('Fındık', MealCategory.snack, _dt(now, 1, 17, 0), 180, 4, 5, 17),
    _mock('Tavuk Şiş + Salata', MealCategory.dinner, _dt(now, 1, 20, 0), 450, 48, 12, 16),
    // 2 gün önce
    _mock('Sahanda Yumurta', MealCategory.breakfast, _dt(now, 2, 8, 0), 210, 14, 2, 16),
    _mock('Karnıyarık', MealCategory.lunch, _dt(now, 2, 12, 30), 510, 22, 38, 28),
    _mock('Baklava', MealCategory.snack, _dt(now, 2, 15, 30), 360, 5, 45, 18),
    _mock('Balık (Levrek)', MealCategory.dinner, _dt(now, 2, 19, 0), 380, 44, 4, 18),
    // 3 gün önce
    _mock('Simit + Peynir', MealCategory.breakfast, _dt(now, 3, 9, 30), 390, 15, 55, 10),
    _mock('Kuru Fasulye + Pilav', MealCategory.lunch, _dt(now, 3, 13, 0), 540, 24, 88, 8),
    _mock('Muz', MealCategory.snack, _dt(now, 3, 16, 30), 120, 1, 27, 0),
    _mock('Izgara Köfte', MealCategory.dinner, _dt(now, 3, 20, 0), 520, 45, 18, 28),
    // 4 gün önce
    _mock('Smoothie Bowl', MealCategory.breakfast, _dt(now, 4, 8, 45), 340, 8, 62, 7),
    _mock('Tavuk Wrap', MealCategory.lunch, _dt(now, 4, 12, 0), 490, 38, 48, 14),
    _mock('Çikolata', MealCategory.snack, _dt(now, 4, 15, 0), 220, 3, 26, 12),
    _mock('Makarna Bolonez', MealCategory.dinner, _dt(now, 4, 19, 30), 680, 32, 78, 22),
    // 5 gün önce
    _mock('Peynirli Omlet', MealCategory.breakfast, _dt(now, 5, 9, 0), 380, 28, 4, 28),
    _mock('Pide', MealCategory.lunch, _dt(now, 5, 13, 30), 720, 30, 90, 20),
    _mock('Yoğurt', MealCategory.snack, _dt(now, 5, 16, 0), 150, 10, 18, 4),
    _mock('Izgara Sebze + Bulgur', MealCategory.dinner, _dt(now, 5, 19, 0), 420, 14, 68, 10),
    // 6 gün önce
    _mock('Avokadolu Tost', MealCategory.breakfast, _dt(now, 6, 8, 30), 440, 14, 38, 26),
    _mock('Lahmacun', MealCategory.lunch, _dt(now, 6, 12, 45), 560, 28, 65, 18),
    _mock('Ceviz', MealCategory.snack, _dt(now, 6, 17, 0), 196, 5, 4, 19),
    _mock('Hindi Rosto', MealCategory.dinner, _dt(now, 6, 20, 0), 460, 52, 8, 22),
  ];

  for (final m in meals) {
    await db.saveAnalysis(m);
  }
}

DateTime _dt(DateTime base, int daysBack, int hour, int minute) {
  final d = base.subtract(Duration(days: daysBack));
  return DateTime(d.year, d.month, d.day, hour, minute);
}

FoodAnalysis _mock(String name, MealCategory cat, DateTime dt, double cal, double prot, double carbs, double fat) {
  return FoodAnalysis(
    id: '${name.hashCode}_${dt.millisecondsSinceEpoch}',
    imagePath: '',
    foods: [],
    totalNutrients: NutrientInfo(calories: cal, protein: prot, carbs: carbs, fat: fat, fiber: 2, sugar: 5),
    summary: name,
    advice: '',
    analyzedAt: dt,
    mealCategory: cat,
  );
}
