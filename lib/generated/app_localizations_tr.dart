// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Fotoğraf çek. Ne yediğini öğren.';

  @override
  String get getStarted => 'Başla';

  @override
  String get alreadyHaveAccount => 'Zaten hesabın var mı?';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get skip => 'Atla';

  @override
  String get continueBtn => 'Devam';

  @override
  String get letsGo => 'Başlayalım';

  @override
  String get back => 'Geri';

  @override
  String get save => 'Kaydet';

  @override
  String get done => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get onboardingHello => 'Merhaba! 👋';

  @override
  String get onboardingNameSub => 'Seni tanıyalım. Adın ne?';

  @override
  String get onboardingNameHint => 'Adını yaz...';

  @override
  String get onboardingNameRequired => 'Lütfen adını gir';

  @override
  String get onboardingBody => 'Vücudunu tanı';

  @override
  String get onboardingBodySub => 'Kalori hedefini hesaplayalım.';

  @override
  String get onboardingGoal => 'Hedefin ne?';

  @override
  String get onboardingGoalSub => 'Kalori hedefini buna göre ayarlayacağız.';

  @override
  String get onboardingTheme => 'Görünüm';

  @override
  String get onboardingThemeSub => 'İstersen sonra da değiştirebilirsin.';

  @override
  String get male => 'Erkek';

  @override
  String get female => 'Kadın';

  @override
  String get age => 'Yaş';

  @override
  String get height => 'Boy';

  @override
  String get weight => 'Kilo';

  @override
  String get ageUnit => 'yaş';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Kilo ver';

  @override
  String get goalLoseSub => 'Kalori açığıyla yavaş yavaş';

  @override
  String get goalMaintain => 'Kilonu koru';

  @override
  String get goalMaintainSub => 'Dengeli ve sağlıklı beslen';

  @override
  String get goalGain => 'Kilo al';

  @override
  String get goalGainSub => 'Kas kütlesi kazan';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String greeting(String name) {
    return 'Merhaba, $name';
  }

  @override
  String get defaultName => 'Sen';

  @override
  String get caloriestoday => 'Bugünkü kalori';

  @override
  String get todaysMeals => 'Bugünkü öğünler';

  @override
  String get noMeals =>
      'Henüz öğün eklenmedi.\nKamerayı açarak ilk yemeğini tara!';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Karb';

  @override
  String get fat => 'Yağ';

  @override
  String get water => 'Su';

  @override
  String get analyzing => 'Analiz ediliyor...';

  @override
  String get analyzingSub => 'AI besin değerlerini hesaplıyor';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get scan => 'Tara';

  @override
  String get progress => 'İlerleme';

  @override
  String get profile => 'Profil';

  @override
  String get weeklyCalories => 'Haftalık Kalori';

  @override
  String get macroBreakdown => 'Makro Dağılım';

  @override
  String get avgCalories => 'Ort. Kalori';

  @override
  String get totalScans => 'Toplam Tarama';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfile => 'Düzenle';

  @override
  String get calorieGoal => 'Kalori Hedefi';

  @override
  String get language => 'Dil';

  @override
  String get appearance => 'Görünüm';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Sınırsız tarama & özellikler';

  @override
  String get waterAdd => 'Su ekle';

  @override
  String get waterGoal => 'Su Hedefi';

  @override
  String waterGlasses(int count) {
    return '$count bardak';
  }

  @override
  String get limitReached => 'Günlük limitine ulaştın';

  @override
  String get limitReachedSub =>
      'Bugün 5 ücretsiz taramayı kullandın.\neatiq Pro ile sınırsız tara.';

  @override
  String get unlimitedScans => 'Sınırsız AI tarama';

  @override
  String get unlimitedHistory => 'Sınırsız geçmiş';

  @override
  String get weeklyReport => 'Haftalık AI raporu';

  @override
  String get turkishDB => 'Türk yemek veritabanı';

  @override
  String get goProBtn => '₺149/ay — Pro\'ya Geç';

  @override
  String get yearlyDiscount => '₺999/yıl ile %44 tasarruf et';

  @override
  String minutesAgo(int min) {
    return '$min dk önce';
  }

  @override
  String hoursAgo(int hr) {
    return '$hr sa önce';
  }

  @override
  String daysAgo(int count) {
    return '$count gün önce';
  }

  @override
  String get monday => 'Pzt';

  @override
  String get tuesday => 'Sal';

  @override
  String get wednesday => 'Çar';

  @override
  String get thursday => 'Per';

  @override
  String get friday => 'Cum';

  @override
  String get saturday => 'Cmt';

  @override
  String get sunday => 'Paz';

  @override
  String get errorGeneric => 'Bir hata oluştu';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get mealBreakfast => 'Kahvaltı';

  @override
  String get mealLunch => 'Öğle';

  @override
  String get mealDinner => 'Akşam';

  @override
  String get mealSnack => 'Atıştırmalık';

  @override
  String get settings => 'Ayarlar';

  @override
  String get unitSystem => 'Ölçü Birimi';

  @override
  String get reminders => 'Hatırlatıcılar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get dailyCalorieGoal => 'Günlük Kalori Hedefi';

  @override
  String get calorieRange => '1200 – 4000 kcal arasında';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String get manual => 'Manuel';

  @override
  String get analysisResult => 'Analiz Sonucu';

  @override
  String get detectedIngredients => 'Tespit edilen malzemeler';

  @override
  String get addedToLog => 'Günlüğe Eklendi ✓';

  @override
  String get historyTitle => 'Geçmiş';

  @override
  String get noScansYet => 'Henüz tarama yok';

  @override
  String get scanFirstMeal => 'İlk yemeğini tara!';

  @override
  String scanCount(int count) {
    return '$count tarama';
  }

  @override
  String get bodyAnalysis => 'Vücut Analizi';

  @override
  String get idealWeight => 'İdeal Kilo';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get goalLabel => 'Hedef';

  @override
  String get basalMetabolicRate => 'Bazal Metabolizma';

  @override
  String get dailyNeeds => 'Günlük Hedef';

  @override
  String get bodyInfo => 'Vücut Bilgileri';

  @override
  String get mealNameLabel => 'Öğün Adı';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get portionWeightLabel => 'Porsiyon Ağırlığı (g) — opsiyonel';

  @override
  String get portionHint => 'Girersen makrolar buna göre kontrol edilir';

  @override
  String get macrosLabel => 'Makrolar (g) — opsiyonel';

  @override
  String get editMeal => 'Öğünü Düzenle';

  @override
  String get addManualMeal => 'Manuel Öğün Ekle';

  @override
  String get update => 'Güncelle';

  @override
  String get bmiLabel => 'VKİ';

  @override
  String get bmiUnderweight => 'Zayıf';

  @override
  String get bmiNormal => 'İdeal Kilo';

  @override
  String get bmiOverweight => 'Fazla Kilolu';

  @override
  String get bmiObese => 'Obezite';

  @override
  String get bmiMorbidObese => 'Ciddi Obezite';

  @override
  String get bmiUnderweightDesc => 'İdeal kilonun biraz altındasınız';

  @override
  String get bmiNormalDesc => 'Harika! Sağlıklı kilo aralığındasınız 🎯';

  @override
  String get bmiOverweightDesc => 'Sağlıklı kiloya biraz uzaktasınız';

  @override
  String get bmiObeseDesc => 'Sağlığın için kilo vermenizi öneririz';

  @override
  String get bmiMorbidObeseDesc => 'Bir sağlık uzmanına danışmanızı öneririz';

  @override
  String get addMeal => '+ Ekle';

  @override
  String get favorites => 'FAVORİLER';

  @override
  String get addMealShort => '+ Ekle';

  @override
  String get mealFallback => 'Öğün';

  @override
  String get month01 => 'Oca';

  @override
  String get month02 => 'Şub';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Nis';

  @override
  String get month05 => 'May';

  @override
  String get month06 => 'Haz';

  @override
  String get month07 => 'Tem';

  @override
  String get month08 => 'Ağu';

  @override
  String get month09 => 'Eyl';

  @override
  String get month10 => 'Eki';

  @override
  String get month11 => 'Kas';

  @override
  String get month12 => 'Ara';

  @override
  String get validRequired => 'Gerekli alan';

  @override
  String get validNumber => 'Geçerli sayı gir';

  @override
  String get validPositive => 'Sıfırdan büyük olmalı';

  @override
  String get validNegative => 'Negatif olamaz';

  @override
  String get validPortionRange => '1–5000g arası olmalı';

  @override
  String validMacroMax(String macro) {
    return '$macro 1000g\'ı geçemez';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro porsiyon ağırlığını (${portion}g) geçemez';
  }

  @override
  String validMacroTotal(String total) {
    return 'Toplam makro (${total}g) porsiyon ağırlığını aşıyor';
  }

  @override
  String get validCalRequired => 'Kalori gerekli';

  @override
  String get validCalMax => 'Tek öğün 5000 kcal\'yi geçemez';

  @override
  String validCalInconsistent(String estimated) {
    return 'Makrolarla tutarsız (tahmini ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'ör. Yulaf ezmesi, Tavuk...';

  @override
  String get hintCalories => 'ör. 350';

  @override
  String get hintPortion => 'ör. 200';

  @override
  String get hintProtein => 'Protein';

  @override
  String get hintCarbs => 'Karb';

  @override
  String get hintFat => 'Yağ';

  @override
  String get unitMetric => 'Metrik';

  @override
  String get unitImperial => 'İmperial';

  @override
  String get userFallback => 'Sen';

  @override
  String get mealNameRequired => 'Öğün adı gerekli';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeLight => 'Açık';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'Öğün ve su senkronizasyonu';

  @override
  String get appleHealthDenied =>
      'Apple Health izni reddedildi. Lütfen Ayarlar → Gizlilik → Sağlık → Eatiq yolundan erişime izin verin.';

  @override
  String get goToSettings => 'Ayarları Aç';

  @override
  String get barcode => 'Barkod';

  @override
  String get barcodeHint => 'Barkodu çerçeve içine hizalayın';

  @override
  String get barcodeSearching => 'Ürün aranıyor...';

  @override
  String get barcodeNotFound => 'Ürün bulunamadı. Manuel giriş deneyin.';

  @override
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';
}
