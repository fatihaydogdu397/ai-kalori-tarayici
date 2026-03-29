import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ka.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ka'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'eatiq'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf çek. Ne yediğini öğren.'**
  String get tagline;

  /// No description provided for @getStarted.
  ///
  /// In tr, this message translates to:
  /// **'Başla'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabın var mı?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get signIn;

  /// No description provided for @skip.
  ///
  /// In tr, this message translates to:
  /// **'Atla'**
  String get skip;

  /// No description provided for @continueBtn.
  ///
  /// In tr, this message translates to:
  /// **'Devam'**
  String get continueBtn;

  /// No description provided for @letsGo.
  ///
  /// In tr, this message translates to:
  /// **'Başlayalım'**
  String get letsGo;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @done.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @onboardingHello.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba! 👋'**
  String get onboardingHello;

  /// No description provided for @onboardingNameSub.
  ///
  /// In tr, this message translates to:
  /// **'Seni tanıyalım. Adın ne?'**
  String get onboardingNameSub;

  /// No description provided for @onboardingNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Adını yaz...'**
  String get onboardingNameHint;

  /// No description provided for @onboardingNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen adını gir'**
  String get onboardingNameRequired;

  /// No description provided for @onboardingBody.
  ///
  /// In tr, this message translates to:
  /// **'Vücudunu tanı'**
  String get onboardingBody;

  /// No description provided for @onboardingBodySub.
  ///
  /// In tr, this message translates to:
  /// **'Kalori hedefini hesaplayalım.'**
  String get onboardingBodySub;

  /// No description provided for @onboardingGoal.
  ///
  /// In tr, this message translates to:
  /// **'Hedefin ne?'**
  String get onboardingGoal;

  /// No description provided for @onboardingGoalSub.
  ///
  /// In tr, this message translates to:
  /// **'Kalori hedefini buna göre ayarlayacağız.'**
  String get onboardingGoalSub;

  /// No description provided for @onboardingTheme.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get onboardingTheme;

  /// No description provided for @onboardingThemeSub.
  ///
  /// In tr, this message translates to:
  /// **'İstersen sonra da değiştirebilirsin.'**
  String get onboardingThemeSub;

  /// No description provided for @male.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get male;

  /// No description provided for @female.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get female;

  /// No description provided for @age.
  ///
  /// In tr, this message translates to:
  /// **'Yaş'**
  String get age;

  /// No description provided for @height.
  ///
  /// In tr, this message translates to:
  /// **'Boy'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In tr, this message translates to:
  /// **'Kilo'**
  String get weight;

  /// No description provided for @ageUnit.
  ///
  /// In tr, this message translates to:
  /// **'yaş'**
  String get ageUnit;

  /// No description provided for @heightUnit.
  ///
  /// In tr, this message translates to:
  /// **'cm'**
  String get heightUnit;

  /// No description provided for @weightUnit.
  ///
  /// In tr, this message translates to:
  /// **'kg'**
  String get weightUnit;

  /// No description provided for @goalLose.
  ///
  /// In tr, this message translates to:
  /// **'Kilo ver'**
  String get goalLose;

  /// No description provided for @goalLoseSub.
  ///
  /// In tr, this message translates to:
  /// **'Kalori açığıyla yavaş yavaş'**
  String get goalLoseSub;

  /// No description provided for @goalMaintain.
  ///
  /// In tr, this message translates to:
  /// **'Kilonu koru'**
  String get goalMaintain;

  /// No description provided for @goalMaintainSub.
  ///
  /// In tr, this message translates to:
  /// **'Dengeli ve sağlıklı beslen'**
  String get goalMaintainSub;

  /// No description provided for @goalGain.
  ///
  /// In tr, this message translates to:
  /// **'Kilo al'**
  String get goalGain;

  /// No description provided for @goalGainSub.
  ///
  /// In tr, this message translates to:
  /// **'Kas kütlesi kazan'**
  String get goalGainSub;

  /// No description provided for @dark.
  ///
  /// In tr, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In tr, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @greeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}'**
  String greeting(String name);

  /// No description provided for @defaultName.
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get defaultName;

  /// No description provided for @caloriestoday.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü kalori'**
  String get caloriestoday;

  /// No description provided for @todaysMeals.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü öğünler'**
  String get todaysMeals;

  /// No description provided for @noMeals.
  ///
  /// In tr, this message translates to:
  /// **'Henüz öğün eklenmedi.\nKamerayı açarak ilk yemeğini tara!'**
  String get noMeals;

  /// No description provided for @protein.
  ///
  /// In tr, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In tr, this message translates to:
  /// **'Karb'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In tr, this message translates to:
  /// **'Yağ'**
  String get fat;

  /// No description provided for @water.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get water;

  /// No description provided for @analyzing.
  ///
  /// In tr, this message translates to:
  /// **'Analiz ediliyor...'**
  String get analyzing;

  /// No description provided for @analyzingSub.
  ///
  /// In tr, this message translates to:
  /// **'AI besin değerlerini hesaplıyor'**
  String get analyzingSub;

  /// No description provided for @camera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeri'**
  String get gallery;

  /// No description provided for @home.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// No description provided for @scan.
  ///
  /// In tr, this message translates to:
  /// **'Tara'**
  String get scan;

  /// No description provided for @progress.
  ///
  /// In tr, this message translates to:
  /// **'İlerleme'**
  String get progress;

  /// No description provided for @profile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @weeklyCalories.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Kalori'**
  String get weeklyCalories;

  /// No description provided for @macroBreakdown.
  ///
  /// In tr, this message translates to:
  /// **'Makro Dağılım'**
  String get macroBreakdown;

  /// No description provided for @avgCalories.
  ///
  /// In tr, this message translates to:
  /// **'Ort. Kalori'**
  String get avgCalories;

  /// No description provided for @totalScans.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Tarama'**
  String get totalScans;

  /// No description provided for @thisWeek.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get thisWeek;

  /// No description provided for @profileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get editProfile;

  /// No description provided for @calorieGoal.
  ///
  /// In tr, this message translates to:
  /// **'Kalori Hedefi'**
  String get calorieGoal;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get appearance;

  /// No description provided for @premium.
  ///
  /// In tr, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @premiumSub.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız tarama & özellikler'**
  String get premiumSub;

  /// No description provided for @waterAdd.
  ///
  /// In tr, this message translates to:
  /// **'Su ekle'**
  String get waterAdd;

  /// No description provided for @waterGoal.
  ///
  /// In tr, this message translates to:
  /// **'Su Hedefi'**
  String get waterGoal;

  /// No description provided for @waterGlasses.
  ///
  /// In tr, this message translates to:
  /// **'{count} bardak'**
  String waterGlasses(int count);

  /// No description provided for @limitReached.
  ///
  /// In tr, this message translates to:
  /// **'Günlük limitine ulaştın'**
  String get limitReached;

  /// No description provided for @limitReachedSub.
  ///
  /// In tr, this message translates to:
  /// **'Bugün 5 ücretsiz taramayı kullandın.\neatiq Pro ile sınırsız tara.'**
  String get limitReachedSub;

  /// No description provided for @unlimitedScans.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız AI tarama'**
  String get unlimitedScans;

  /// No description provided for @unlimitedHistory.
  ///
  /// In tr, this message translates to:
  /// **'Sınırsız geçmiş'**
  String get unlimitedHistory;

  /// No description provided for @weeklyReport.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık AI raporu'**
  String get weeklyReport;

  /// No description provided for @turkishDB.
  ///
  /// In tr, this message translates to:
  /// **'Türk yemek veritabanı'**
  String get turkishDB;

  /// No description provided for @goProBtn.
  ///
  /// In tr, this message translates to:
  /// **'₺149/ay — Pro\'ya Geç'**
  String get goProBtn;

  /// No description provided for @yearlyDiscount.
  ///
  /// In tr, this message translates to:
  /// **'₺999/yıl ile %44 tasarruf et'**
  String get yearlyDiscount;

  /// No description provided for @minutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{min} dk önce'**
  String minutesAgo(int min);

  /// No description provided for @hoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{hr} sa önce'**
  String hoursAgo(int hr);

  /// No description provided for @daysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün önce'**
  String daysAgo(int count);

  /// No description provided for @monday.
  ///
  /// In tr, this message translates to:
  /// **'Pzt'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In tr, this message translates to:
  /// **'Sal'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In tr, this message translates to:
  /// **'Çar'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In tr, this message translates to:
  /// **'Per'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In tr, this message translates to:
  /// **'Cum'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In tr, this message translates to:
  /// **'Cmt'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In tr, this message translates to:
  /// **'Paz'**
  String get sunday;

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// No description provided for @mealBreakfast.
  ///
  /// In tr, this message translates to:
  /// **'Kahvaltı'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In tr, this message translates to:
  /// **'Öğle'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In tr, this message translates to:
  /// **'Akşam'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In tr, this message translates to:
  /// **'Atıştırmalık'**
  String get mealSnack;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @unitSystem.
  ///
  /// In tr, this message translates to:
  /// **'Ölçü Birimi'**
  String get unitSystem;

  /// No description provided for @reminders.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcılar'**
  String get reminders;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// No description provided for @dailyCalorieGoal.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Kalori Hedefi'**
  String get dailyCalorieGoal;

  /// No description provided for @calorieRange.
  ///
  /// In tr, this message translates to:
  /// **'1200 – 4000 kcal arasında'**
  String get calorieRange;

  /// No description provided for @selectLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seç'**
  String get selectLanguage;

  /// No description provided for @manual.
  ///
  /// In tr, this message translates to:
  /// **'Manuel'**
  String get manual;

  /// No description provided for @analysisResult.
  ///
  /// In tr, this message translates to:
  /// **'Analiz Sonucu'**
  String get analysisResult;

  /// No description provided for @detectedIngredients.
  ///
  /// In tr, this message translates to:
  /// **'Tespit edilen malzemeler'**
  String get detectedIngredients;

  /// No description provided for @addedToLog.
  ///
  /// In tr, this message translates to:
  /// **'Günlüğe Eklendi ✓'**
  String get addedToLog;

  /// No description provided for @historyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get historyTitle;

  /// No description provided for @noScansYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz tarama yok'**
  String get noScansYet;

  /// No description provided for @scanFirstMeal.
  ///
  /// In tr, this message translates to:
  /// **'İlk yemeğini tara!'**
  String get scanFirstMeal;

  /// No description provided for @scanCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} tarama'**
  String scanCount(int count);

  /// No description provided for @bodyAnalysis.
  ///
  /// In tr, this message translates to:
  /// **'Vücut Analizi'**
  String get bodyAnalysis;

  /// No description provided for @idealWeight.
  ///
  /// In tr, this message translates to:
  /// **'İdeal Kilo'**
  String get idealWeight;

  /// No description provided for @gender.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet'**
  String get gender;

  /// No description provided for @goalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hedef'**
  String get goalLabel;

  /// No description provided for @basalMetabolicRate.
  ///
  /// In tr, this message translates to:
  /// **'Bazal Metabolizma'**
  String get basalMetabolicRate;

  /// No description provided for @dailyNeeds.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Hedef'**
  String get dailyNeeds;

  /// No description provided for @bodyInfo.
  ///
  /// In tr, this message translates to:
  /// **'Vücut Bilgileri'**
  String get bodyInfo;

  /// No description provided for @mealNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Öğün Adı'**
  String get mealNameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kategori'**
  String get categoryLabel;

  /// No description provided for @portionWeightLabel.
  ///
  /// In tr, this message translates to:
  /// **'Porsiyon Ağırlığı (g) — opsiyonel'**
  String get portionWeightLabel;

  /// No description provided for @portionHint.
  ///
  /// In tr, this message translates to:
  /// **'Girersen makrolar buna göre kontrol edilir'**
  String get portionHint;

  /// No description provided for @macrosLabel.
  ///
  /// In tr, this message translates to:
  /// **'Makrolar (g) — opsiyonel'**
  String get macrosLabel;

  /// No description provided for @editMeal.
  ///
  /// In tr, this message translates to:
  /// **'Öğünü Düzenle'**
  String get editMeal;

  /// No description provided for @addManualMeal.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Öğün Ekle'**
  String get addManualMeal;

  /// No description provided for @update.
  ///
  /// In tr, this message translates to:
  /// **'Güncelle'**
  String get update;

  /// No description provided for @bmiLabel.
  ///
  /// In tr, this message translates to:
  /// **'VKİ'**
  String get bmiLabel;

  /// No description provided for @bmiUnderweight.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In tr, this message translates to:
  /// **'İdeal Kilo'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In tr, this message translates to:
  /// **'Fazla Kilolu'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In tr, this message translates to:
  /// **'Obezite'**
  String get bmiObese;

  /// No description provided for @bmiMorbidObese.
  ///
  /// In tr, this message translates to:
  /// **'Ciddi Obezite'**
  String get bmiMorbidObese;

  /// No description provided for @bmiUnderweightDesc.
  ///
  /// In tr, this message translates to:
  /// **'İdeal kilonun biraz altındasınız'**
  String get bmiUnderweightDesc;

  /// No description provided for @bmiNormalDesc.
  ///
  /// In tr, this message translates to:
  /// **'Harika! Sağlıklı kilo aralığındasınız 🎯'**
  String get bmiNormalDesc;

  /// No description provided for @bmiOverweightDesc.
  ///
  /// In tr, this message translates to:
  /// **'Sağlıklı kiloya biraz uzaktasınız'**
  String get bmiOverweightDesc;

  /// No description provided for @bmiObeseDesc.
  ///
  /// In tr, this message translates to:
  /// **'Sağlığın için kilo vermenizi öneririz'**
  String get bmiObeseDesc;

  /// No description provided for @bmiMorbidObeseDesc.
  ///
  /// In tr, this message translates to:
  /// **'Bir sağlık uzmanına danışmanızı öneririz'**
  String get bmiMorbidObeseDesc;

  /// No description provided for @addMeal.
  ///
  /// In tr, this message translates to:
  /// **'+ Ekle'**
  String get addMeal;

  /// No description provided for @favorites.
  ///
  /// In tr, this message translates to:
  /// **'FAVORİLER'**
  String get favorites;

  /// No description provided for @addMealShort.
  ///
  /// In tr, this message translates to:
  /// **'+ Ekle'**
  String get addMealShort;

  /// No description provided for @mealFallback.
  ///
  /// In tr, this message translates to:
  /// **'Öğün'**
  String get mealFallback;

  /// No description provided for @month01.
  ///
  /// In tr, this message translates to:
  /// **'Oca'**
  String get month01;

  /// No description provided for @month02.
  ///
  /// In tr, this message translates to:
  /// **'Şub'**
  String get month02;

  /// No description provided for @month03.
  ///
  /// In tr, this message translates to:
  /// **'Mar'**
  String get month03;

  /// No description provided for @month04.
  ///
  /// In tr, this message translates to:
  /// **'Nis'**
  String get month04;

  /// No description provided for @month05.
  ///
  /// In tr, this message translates to:
  /// **'May'**
  String get month05;

  /// No description provided for @month06.
  ///
  /// In tr, this message translates to:
  /// **'Haz'**
  String get month06;

  /// No description provided for @month07.
  ///
  /// In tr, this message translates to:
  /// **'Tem'**
  String get month07;

  /// No description provided for @month08.
  ///
  /// In tr, this message translates to:
  /// **'Ağu'**
  String get month08;

  /// No description provided for @month09.
  ///
  /// In tr, this message translates to:
  /// **'Eyl'**
  String get month09;

  /// No description provided for @month10.
  ///
  /// In tr, this message translates to:
  /// **'Eki'**
  String get month10;

  /// No description provided for @month11.
  ///
  /// In tr, this message translates to:
  /// **'Kas'**
  String get month11;

  /// No description provided for @month12.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get month12;

  /// No description provided for @validRequired.
  ///
  /// In tr, this message translates to:
  /// **'Gerekli alan'**
  String get validRequired;

  /// No description provided for @validNumber.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli sayı gir'**
  String get validNumber;

  /// No description provided for @validPositive.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırdan büyük olmalı'**
  String get validPositive;

  /// No description provided for @validNegative.
  ///
  /// In tr, this message translates to:
  /// **'Negatif olamaz'**
  String get validNegative;

  /// No description provided for @validPortionRange.
  ///
  /// In tr, this message translates to:
  /// **'1–5000g arası olmalı'**
  String get validPortionRange;

  /// No description provided for @validMacroMax.
  ///
  /// In tr, this message translates to:
  /// **'{macro} 1000g\'ı geçemez'**
  String validMacroMax(String macro);

  /// No description provided for @validMacroPortion.
  ///
  /// In tr, this message translates to:
  /// **'{macro} porsiyon ağırlığını ({portion}g) geçemez'**
  String validMacroPortion(String macro, String portion);

  /// No description provided for @validMacroTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam makro ({total}g) porsiyon ağırlığını aşıyor'**
  String validMacroTotal(String total);

  /// No description provided for @validCalRequired.
  ///
  /// In tr, this message translates to:
  /// **'Kalori gerekli'**
  String get validCalRequired;

  /// No description provided for @validCalMax.
  ///
  /// In tr, this message translates to:
  /// **'Tek öğün 5000 kcal\'yi geçemez'**
  String get validCalMax;

  /// No description provided for @validCalInconsistent.
  ///
  /// In tr, this message translates to:
  /// **'Makrolarla tutarsız (tahmini ~{estimated} kcal)'**
  String validCalInconsistent(String estimated);

  /// No description provided for @hintMealName.
  ///
  /// In tr, this message translates to:
  /// **'ör. Yulaf ezmesi, Tavuk...'**
  String get hintMealName;

  /// No description provided for @hintCalories.
  ///
  /// In tr, this message translates to:
  /// **'ör. 350'**
  String get hintCalories;

  /// No description provided for @hintPortion.
  ///
  /// In tr, this message translates to:
  /// **'ör. 200'**
  String get hintPortion;

  /// No description provided for @hintProtein.
  ///
  /// In tr, this message translates to:
  /// **'Protein'**
  String get hintProtein;

  /// No description provided for @hintCarbs.
  ///
  /// In tr, this message translates to:
  /// **'Karb'**
  String get hintCarbs;

  /// No description provided for @hintFat.
  ///
  /// In tr, this message translates to:
  /// **'Yağ'**
  String get hintFat;

  /// No description provided for @unitMetric.
  ///
  /// In tr, this message translates to:
  /// **'Metrik'**
  String get unitMetric;

  /// No description provided for @unitImperial.
  ///
  /// In tr, this message translates to:
  /// **'İmperial'**
  String get unitImperial;

  /// No description provided for @userFallback.
  ///
  /// In tr, this message translates to:
  /// **'Sen'**
  String get userFallback;

  /// No description provided for @mealNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Öğün adı gerekli'**
  String get mealNameRequired;

  /// No description provided for @themeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get themeLight;

  /// No description provided for @today.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get yesterday;

  /// No description provided for @appleHealth.
  ///
  /// In tr, this message translates to:
  /// **'Apple Health'**
  String get appleHealth;

  /// No description provided for @appleHealthSub.
  ///
  /// In tr, this message translates to:
  /// **'Öğün ve su senkronizasyonu'**
  String get appleHealthSub;

  /// No description provided for @appleHealthDenied.
  ///
  /// In tr, this message translates to:
  /// **'Apple Health izni reddedildi. Lütfen Ayarlar → Gizlilik → Sağlık → Eatiq yolundan erişime izin verin.'**
  String get appleHealthDenied;

  /// No description provided for @goToSettings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarları Aç'**
  String get goToSettings;

  /// No description provided for @barcode.
  ///
  /// In tr, this message translates to:
  /// **'Barkod'**
  String get barcode;

  /// No description provided for @barcodeHint.
  ///
  /// In tr, this message translates to:
  /// **'Barkodu çerçeve içine hizalayın'**
  String get barcodeHint;

  /// No description provided for @barcodeSearching.
  ///
  /// In tr, this message translates to:
  /// **'Ürün aranıyor...'**
  String get barcodeSearching;

  /// No description provided for @barcodeNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Ürün bulunamadı. Manuel giriş deneyin.'**
  String get barcodeNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ka',
    'pt',
    'ru',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ka':
      return AppLocalizationsKa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
