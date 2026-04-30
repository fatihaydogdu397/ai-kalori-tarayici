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

  /// No description provided for @errorAuthInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı.'**
  String get errorAuthInvalidCredentials;

  /// No description provided for @errorAuthSignInAgain.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen tekrar giriş yap.'**
  String get errorAuthSignInAgain;

  /// No description provided for @errorAuthOauthFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılamadı. Tekrar dene.'**
  String get errorAuthOauthFailed;

  /// No description provided for @errorAuthEmailInUse.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta zaten kayıtlı. Giriş yapmayı dene.'**
  String get errorAuthEmailInUse;

  /// No description provided for @errorAuthEmailProviderConflict.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta için ilk kullandığın yöntemle giriş yap.'**
  String get errorAuthEmailProviderConflict;

  /// No description provided for @errorAuthInvalidOtp.
  ///
  /// In tr, this message translates to:
  /// **'Kod geçersiz veya süresi dolmuş.'**
  String get errorAuthInvalidOtp;

  /// No description provided for @errorAuthTooManyAttempts.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla başarısız deneme. Yeni bir kod iste.'**
  String get errorAuthTooManyAttempts;

  /// No description provided for @errorPremiumRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bu özellik için Premium gerekli.'**
  String get errorPremiumRequired;

  /// No description provided for @errorFoodScanLimit.
  ///
  /// In tr, this message translates to:
  /// **'Günlük tarama limitine ulaştın. Sınırsız tarama için Premium\'a geç.'**
  String get errorFoodScanLimit;

  /// No description provided for @errorFoodNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Yemek bulunamadı.'**
  String get errorFoodNotFound;

  /// No description provided for @errorNotOwner.
  ///
  /// In tr, this message translates to:
  /// **'Bu öğeye erişimin yok.'**
  String get errorNotOwner;

  /// No description provided for @errorFoodDeleteOnlyToday.
  ///
  /// In tr, this message translates to:
  /// **'Sadece bugün eklenen yemekleri silebilirsin.'**
  String get errorFoodDeleteOnlyToday;

  /// No description provided for @errorFoodInvalidBarcode.
  ///
  /// In tr, this message translates to:
  /// **'Bu barkod geçersiz görünüyor.'**
  String get errorFoodInvalidBarcode;

  /// No description provided for @errorFoodMacroLimit.
  ///
  /// In tr, this message translates to:
  /// **'Her makro değeri 1000\'den az olmalı.'**
  String get errorFoodMacroLimit;

  /// No description provided for @errorDietPlanWeeklyLimit.
  ///
  /// In tr, this message translates to:
  /// **'Bu hafta için tüm planlarını kullandın.'**
  String get errorDietPlanWeeklyLimit;

  /// No description provided for @errorDietPlanMacrosNotSet.
  ///
  /// In tr, this message translates to:
  /// **'Önce günlük makro hedeflerini ayarla.'**
  String get errorDietPlanMacrosNotSet;

  /// No description provided for @errorDietPlanNotActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif bir planın yok.'**
  String get errorDietPlanNotActive;

  /// No description provided for @errorDietPlanMealNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Öğün bulunamadı.'**
  String get errorDietPlanMealNotFound;

  /// No description provided for @errorBloodTestInvalidFile.
  ///
  /// In tr, this message translates to:
  /// **'Dosya bozuk.'**
  String get errorBloodTestInvalidFile;

  /// No description provided for @errorBloodTestTooLarge.
  ///
  /// In tr, this message translates to:
  /// **'Dosya 10 MB\'den küçük olmalı.'**
  String get errorBloodTestTooLarge;

  /// No description provided for @errorBloodTestMimeMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Bu dosya türü desteklenmiyor.'**
  String get errorBloodTestMimeMismatch;

  /// No description provided for @errorBloodTestNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Kan tahlili bulunamadı.'**
  String get errorBloodTestNotFound;

  /// No description provided for @errorNutritionNoCandidates.
  ///
  /// In tr, this message translates to:
  /// **'Öneri oluşturulamadı. Beslenme tercihlerini gözden geçir.'**
  String get errorNutritionNoCandidates;

  /// No description provided for @errorWaterInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Su miktarı 0–3 litre arasında olmalı.'**
  String get errorWaterInvalid;

  /// No description provided for @errorWeightInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Kilo 30–300 kg arasında olmalı.'**
  String get errorWeightInvalid;

  /// No description provided for @errorRateLimited.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla istek. Biraz sonra dene.'**
  String get errorRateLimited;

  /// No description provided for @errorInvalidInput.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen girdileri kontrol et.'**
  String get errorInvalidInput;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı yok.'**
  String get errorNetwork;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @healthDataSection.
  ///
  /// In tr, this message translates to:
  /// **'SAĞLIK VERİLERİ'**
  String get healthDataSection;

  /// No description provided for @bloodTestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kan Tahlili'**
  String get bloodTestTitle;

  /// No description provided for @bloodTestHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık raporunu yükle'**
  String get bloodTestHeadline;

  /// No description provided for @bloodTestSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kan tahlilini yüklersen diyet planın ve önerilerimiz sana daha özel olur. Opsiyoneldir, istediğin zaman profilinden ekleyebilirsin.'**
  String get bloodTestSubtitle;

  /// No description provided for @bloodTestPickFile.
  ///
  /// In tr, this message translates to:
  /// **'Dosya seç'**
  String get bloodTestPickFile;

  /// No description provided for @bloodTestReplaceFile.
  ///
  /// In tr, this message translates to:
  /// **'Değiştirmek için dokun'**
  String get bloodTestReplaceFile;

  /// No description provided for @bloodTestFileTypesHint.
  ///
  /// In tr, this message translates to:
  /// **'PDF veya görsel (JPG/PNG)'**
  String get bloodTestFileTypesHint;

  /// No description provided for @bloodTestDateOptional.
  ///
  /// In tr, this message translates to:
  /// **'Test tarihi (opsiyonel)'**
  String get bloodTestDateOptional;

  /// No description provided for @bloodTestUpload.
  ///
  /// In tr, this message translates to:
  /// **'Yükle'**
  String get bloodTestUpload;

  /// No description provided for @bloodTestUploadAndContinue.
  ///
  /// In tr, this message translates to:
  /// **'Yükle ve devam et'**
  String get bloodTestUploadAndContinue;

  /// No description provided for @bloodTestsScreenTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kan Tahlillerim'**
  String get bloodTestsScreenTitle;

  /// No description provided for @bloodTestAdd.
  ///
  /// In tr, this message translates to:
  /// **'Ekle'**
  String get bloodTestAdd;

  /// No description provided for @bloodTestEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz yüklenmiş kan tahlili yok'**
  String get bloodTestEmptyTitle;

  /// No description provided for @bloodTestEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Sağ alttaki + ile PDF veya görsel olarak ekleyebilirsin.'**
  String get bloodTestEmptyBody;

  /// No description provided for @bloodTestDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kan tahlilini sil'**
  String get bloodTestDeleteTitle;

  /// No description provided for @bloodTestDeleteBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu kayıt kalıcı olarak silinecek.'**
  String get bloodTestDeleteBody;

  /// No description provided for @bloodTestStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'AI analiz bekliyor'**
  String get bloodTestStatusPending;

  /// No description provided for @bloodTestStatusCompleted.
  ///
  /// In tr, this message translates to:
  /// **'Analiz tamamlandı'**
  String get bloodTestStatusCompleted;

  /// No description provided for @bloodTestStatusFailed.
  ///
  /// In tr, this message translates to:
  /// **'Analiz başarısız'**
  String get bloodTestStatusFailed;

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

  /// No description provided for @backToHome.
  ///
  /// In tr, this message translates to:
  /// **'Tamam, Ana Sayfaya Dön'**
  String get backToHome;

  /// No description provided for @mealAutoSaved.
  ///
  /// In tr, this message translates to:
  /// **'Öğün otomatik olarak kaydedildi.'**
  String get mealAutoSaved;

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

  /// No description provided for @noWeightData.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kilo geçmişi yok.'**
  String get noWeightData;

  /// No description provided for @noWeightDataHint.
  ///
  /// In tr, this message translates to:
  /// **'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.'**
  String get noWeightDataHint;

  /// No description provided for @streakDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} Günlük Seri'**
  String streakDays(int count);

  /// No description provided for @streakMotivation.
  ///
  /// In tr, this message translates to:
  /// **'Her gün kayıt yaparak serisini koru!'**
  String get streakMotivation;

  /// No description provided for @streakMilestone7.
  ///
  /// In tr, this message translates to:
  /// **'1 haftalık seri! Harika gidiyorsun. 🎉'**
  String get streakMilestone7;

  /// No description provided for @streakMilestone30.
  ///
  /// In tr, this message translates to:
  /// **'1 aylık seri! İnanılmaz bir başarı. 🏆'**
  String get streakMilestone30;

  /// No description provided for @activityLevel.
  ///
  /// In tr, this message translates to:
  /// **'Ne kadar hareketlisin?'**
  String get activityLevel;

  /// No description provided for @activityLevelSub.
  ///
  /// In tr, this message translates to:
  /// **'Günlük aktivite seviyeni seç'**
  String get activityLevelSub;

  /// No description provided for @activitySedentary.
  ///
  /// In tr, this message translates to:
  /// **'Masa Başı'**
  String get activitySedentary;

  /// No description provided for @activitySedentarySub.
  ///
  /// In tr, this message translates to:
  /// **'Çok az egzersiz veya ofis işi'**
  String get activitySedentarySub;

  /// No description provided for @activityLight.
  ///
  /// In tr, this message translates to:
  /// **'Hafif Hareketli'**
  String get activityLight;

  /// No description provided for @activityLightSub.
  ///
  /// In tr, this message translates to:
  /// **'Haftada 1-3 gün hafif egzersiz'**
  String get activityLightSub;

  /// No description provided for @activityActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get activityActive;

  /// No description provided for @activityActiveSub.
  ///
  /// In tr, this message translates to:
  /// **'Haftada 3-5 gün orta egzersiz'**
  String get activityActiveSub;

  /// No description provided for @activityVery.
  ///
  /// In tr, this message translates to:
  /// **'Çok Aktif'**
  String get activityVery;

  /// No description provided for @activityVerySub.
  ///
  /// In tr, this message translates to:
  /// **'Haftada 6-7 gün ağır egzersiz'**
  String get activityVerySub;

  /// No description provided for @onboardingSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hazırsın! 🎉'**
  String get onboardingSummaryTitle;

  /// No description provided for @onboardingSummarySub.
  ///
  /// In tr, this message translates to:
  /// **'İşte sana özel günlük hedefin.'**
  String get onboardingSummarySub;

  /// No description provided for @onboardingRecommend.
  ///
  /// In tr, this message translates to:
  /// **'Önerilen Günlük Kalori'**
  String get onboardingRecommend;

  /// No description provided for @onboardingGender.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyetin nedir?'**
  String get onboardingGender;

  /// No description provided for @onboardingGenderSub.
  ///
  /// In tr, this message translates to:
  /// **'Metabolizma hızını hesaplamak için gerekli.'**
  String get onboardingGenderSub;

  /// No description provided for @onboardingAge.
  ///
  /// In tr, this message translates to:
  /// **'Kaç yaşındasın?'**
  String get onboardingAge;

  /// No description provided for @onboardingAgeSub.
  ///
  /// In tr, this message translates to:
  /// **'Metabolizma hızını hesaplamak için gerekli.'**
  String get onboardingAgeSub;

  /// No description provided for @onboardingHeightWeight.
  ///
  /// In tr, this message translates to:
  /// **'Boy ve Kilo'**
  String get onboardingHeightWeight;

  /// No description provided for @onboardingHeightWeightSub.
  ///
  /// In tr, this message translates to:
  /// **'VKI ve günlük kalori ihtiyacın için gerekli.'**
  String get onboardingHeightWeightSub;

  /// No description provided for @waterToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü Su'**
  String get waterToday;

  /// No description provided for @reset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get reset;

  /// No description provided for @confirmDelete.
  ///
  /// In tr, this message translates to:
  /// **'Tüm veriler sıfırlanacak. Emin misiniz?'**
  String get confirmDelete;

  /// No description provided for @dailySummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günün Özeti 📊'**
  String get dailySummaryTitle;

  /// No description provided for @dailySummaryBody.
  ///
  /// In tr, this message translates to:
  /// **'Bugün {cal}/{goal} kcal ve {water}L su tükettin. Harika gidiyorsun!'**
  String dailySummaryBody(String cal, String goal, String water);

  /// No description provided for @dailySummaryEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugün hiç giriş yok'**
  String get dailySummaryEmptyTitle;

  /// No description provided for @dailySummaryEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı tarama? İlk öğününü kaydetmek için dokun.'**
  String get dailySummaryEmptyBody;

  /// No description provided for @dailySummaryUnderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bugünkü ilerleme'**
  String get dailySummaryUnderTitle;

  /// No description provided for @dailySummaryUnderBody.
  ///
  /// In tr, this message translates to:
  /// **'{cal}/{goal} kcal — kaydetmeye devam'**
  String dailySummaryUnderBody(String cal, String goal);

  /// No description provided for @goalAchievement.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Başarımı'**
  String get goalAchievement;

  /// No description provided for @consistency.
  ///
  /// In tr, this message translates to:
  /// **'İstikrar'**
  String get consistency;

  /// No description provided for @topDay.
  ///
  /// In tr, this message translates to:
  /// **'Zirve Gün'**
  String get topDay;

  /// No description provided for @avgWater.
  ///
  /// In tr, this message translates to:
  /// **'Ort. Su'**
  String get avgWater;

  /// No description provided for @weeklyInsight.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık Analiz'**
  String get weeklyInsight;

  /// No description provided for @monthlyInsight.
  ///
  /// In tr, this message translates to:
  /// **'Aylık Analiz'**
  String get monthlyInsight;

  /// No description provided for @mostConsumedMeal.
  ///
  /// In tr, this message translates to:
  /// **'En Yoğun Öğün'**
  String get mostConsumedMeal;

  /// No description provided for @splashTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kalori takibi artık çok kolay'**
  String get splashTitle;

  /// No description provided for @onboardingBirthDate.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Tarihiniz'**
  String get onboardingBirthDate;

  /// No description provided for @onboardingBirthDateSub.
  ///
  /// In tr, this message translates to:
  /// **'Yaşınıza göre metabolizma hızınızı hesaplayacağız'**
  String get onboardingBirthDateSub;

  /// No description provided for @onboardingTargetWeight.
  ///
  /// In tr, this message translates to:
  /// **'Hangi kiloya ulaşmak istiyorsunuz?'**
  String get onboardingTargetWeight;

  /// No description provided for @onboardingTargetWeightSub.
  ///
  /// In tr, this message translates to:
  /// **'Hedef kilonuzu girin'**
  String get onboardingTargetWeightSub;

  /// No description provided for @onboardingWeeklyPace.
  ///
  /// In tr, this message translates to:
  /// **'Hedefinize ne kadar hızlı ulaşmak istiyorsunuz?'**
  String get onboardingWeeklyPace;

  /// No description provided for @onboardingWeeklyPaceSub.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık kilo değişim hızı'**
  String get onboardingWeeklyPaceSub;

  /// No description provided for @onboardingDietType.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme Türünüzü Seçin'**
  String get onboardingDietType;

  /// No description provided for @onboardingDietTypeSub.
  ///
  /// In tr, this message translates to:
  /// **'Size uygun makro oranlarını hesaplayalım'**
  String get onboardingDietTypeSub;

  /// No description provided for @onboardingDietTypeRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen en az bir beslenme türü seçin'**
  String get onboardingDietTypeRequired;

  /// No description provided for @dietPlanIAteThis.
  ///
  /// In tr, this message translates to:
  /// **'Bunu yedim'**
  String get dietPlanIAteThis;

  /// No description provided for @dietPlanMarkNotEaten.
  ///
  /// In tr, this message translates to:
  /// **'Yenmedi olarak işaretle'**
  String get dietPlanMarkNotEaten;

  /// No description provided for @dietPlanEatenLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yendi'**
  String get dietPlanEatenLabel;

  /// No description provided for @onboardingAllergiesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Alerjiler & Kısıtlamalar'**
  String get onboardingAllergiesTitle;

  /// No description provided for @onboardingAllergiesSub.
  ///
  /// In tr, this message translates to:
  /// **'Uyumsuz yiyeceklerde seni uyaralım'**
  String get onboardingAllergiesSub;

  /// No description provided for @onboardingAllergiesReligious.
  ///
  /// In tr, this message translates to:
  /// **'Dini & Yaşam Tarzı'**
  String get onboardingAllergiesReligious;

  /// No description provided for @onboardingAllergiesAllergens.
  ///
  /// In tr, this message translates to:
  /// **'Alerji & İntoleranslar'**
  String get onboardingAllergiesAllergens;

  /// No description provided for @dietStandard.
  ///
  /// In tr, this message translates to:
  /// **'Standart Beslenme'**
  String get dietStandard;

  /// No description provided for @dietLowCarb.
  ///
  /// In tr, this message translates to:
  /// **'Düşük Karbonhidrat'**
  String get dietLowCarb;

  /// No description provided for @dietKeto.
  ///
  /// In tr, this message translates to:
  /// **'Ketojenik'**
  String get dietKeto;

  /// No description provided for @dietHighProtein.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek Protein'**
  String get dietHighProtein;

  /// No description provided for @dietCustom.
  ///
  /// In tr, this message translates to:
  /// **'Özel Beslenme'**
  String get dietCustom;

  /// No description provided for @onboardingNotifTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get onboardingNotifTitle;

  /// No description provided for @onboardingNotifSub.
  ///
  /// In tr, this message translates to:
  /// **'Hedeflerinize ulaşmanız için size hatırlatmalar gönderelim'**
  String get onboardingNotifSub;

  /// No description provided for @notifMealReminder.
  ///
  /// In tr, this message translates to:
  /// **'Öğün hatırlatmaları'**
  String get notifMealReminder;

  /// No description provided for @notifWaterReminder.
  ///
  /// In tr, this message translates to:
  /// **'Su içme hatırlatmaları'**
  String get notifWaterReminder;

  /// No description provided for @notifGoalReminder.
  ///
  /// In tr, this message translates to:
  /// **'Hedef başarı bildirimleri'**
  String get notifGoalReminder;

  /// No description provided for @enableNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimleri Aç'**
  String get enableNotifications;

  /// No description provided for @skipForNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdilik Geç'**
  String get skipForNow;

  /// No description provided for @navDaily.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get navDaily;

  /// No description provided for @navProgram.
  ///
  /// In tr, this message translates to:
  /// **'Program'**
  String get navProgram;

  /// No description provided for @stepsToday.
  ///
  /// In tr, this message translates to:
  /// **'Adım'**
  String get stepsToday;

  /// No description provided for @stepsGoal.
  ///
  /// In tr, this message translates to:
  /// **'{steps} / {goal}'**
  String stepsGoal(String steps, String goal);

  /// No description provided for @caloriesBurned.
  ///
  /// In tr, this message translates to:
  /// **'yakıldı'**
  String get caloriesBurned;

  /// No description provided for @thirtyDays.
  ///
  /// In tr, this message translates to:
  /// **'30 Days'**
  String get thirtyDays;

  /// No description provided for @avgPerDay.
  ///
  /// In tr, this message translates to:
  /// **'avg / day'**
  String get avgPerDay;

  /// No description provided for @mealsLoggedLabel.
  ///
  /// In tr, this message translates to:
  /// **'meals logged'**
  String get mealsLoggedLabel;

  /// No description provided for @caloriesChartTitle.
  ///
  /// In tr, this message translates to:
  /// **'Calories'**
  String get caloriesChartTitle;

  /// No description provided for @noDataYet.
  ///
  /// In tr, this message translates to:
  /// **'No data yet'**
  String get noDataYet;

  /// No description provided for @recentLogs.
  ///
  /// In tr, this message translates to:
  /// **'Recent Logs'**
  String get recentLogs;

  /// No description provided for @currentLabel.
  ///
  /// In tr, this message translates to:
  /// **'current'**
  String get currentLabel;

  /// No description provided for @targetLabel.
  ///
  /// In tr, this message translates to:
  /// **'target'**
  String get targetLabel;

  /// No description provided for @noGoalSet.
  ///
  /// In tr, this message translates to:
  /// **'No goal set'**
  String get noGoalSet;

  /// No description provided for @kcalRemainingGoal.
  ///
  /// In tr, this message translates to:
  /// **'{remaining} kcal remaining · goal {goal}'**
  String kcalRemainingGoal(String remaining, String goal);

  /// No description provided for @weightLostLabel.
  ///
  /// In tr, this message translates to:
  /// **'↓ {amount} {unit} lost'**
  String weightLostLabel(String amount, String unit);

  /// No description provided for @weightGainedLabel.
  ///
  /// In tr, this message translates to:
  /// **'↑ {amount} {unit} gained'**
  String weightGainedLabel(String amount, String unit);

  /// No description provided for @weightStable.
  ///
  /// In tr, this message translates to:
  /// **'Stable weight'**
  String get weightStable;

  /// No description provided for @foodSearch.
  ///
  /// In tr, this message translates to:
  /// **'Food Search'**
  String get foodSearch;

  /// No description provided for @searchFoodsHint.
  ///
  /// In tr, this message translates to:
  /// **'Search foods...'**
  String get searchFoodsHint;

  /// No description provided for @noFoodsFound.
  ///
  /// In tr, this message translates to:
  /// **'No foods found'**
  String get noFoodsFound;

  /// No description provided for @addToLog.
  ///
  /// In tr, this message translates to:
  /// **'Add to Log'**
  String get addToLog;

  /// No description provided for @foodAddedToLog.
  ///
  /// In tr, this message translates to:
  /// **'{name} added to log'**
  String foodAddedToLog(String name);

  /// No description provided for @portionGrams.
  ///
  /// In tr, this message translates to:
  /// **'Portion: {grams} g'**
  String portionGrams(String grams);

  /// No description provided for @foodCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} foods'**
  String foodCount(int count);

  /// No description provided for @categoryAll.
  ///
  /// In tr, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryDairy.
  ///
  /// In tr, this message translates to:
  /// **'Dairy'**
  String get categoryDairy;

  /// No description provided for @categoryFruit.
  ///
  /// In tr, this message translates to:
  /// **'Fruit'**
  String get categoryFruit;

  /// No description provided for @categoryFats.
  ///
  /// In tr, this message translates to:
  /// **'Fats'**
  String get categoryFats;

  /// No description provided for @categoryVegetables.
  ///
  /// In tr, this message translates to:
  /// **'Vegetables'**
  String get categoryVegetables;

  /// No description provided for @categoryFastFood.
  ///
  /// In tr, this message translates to:
  /// **'Fast Food'**
  String get categoryFastFood;

  /// No description provided for @categorySnacks.
  ///
  /// In tr, this message translates to:
  /// **'Snacks'**
  String get categorySnacks;

  /// No description provided for @aiDietitian.
  ///
  /// In tr, this message translates to:
  /// **'AI Dietitian'**
  String get aiDietitian;

  /// No description provided for @aiPoweredBy.
  ///
  /// In tr, this message translates to:
  /// **'Powered by eatiq AI'**
  String get aiPoweredBy;

  /// No description provided for @onlineLabel.
  ///
  /// In tr, this message translates to:
  /// **'Online'**
  String get onlineLabel;

  /// No description provided for @askNutritionHint.
  ///
  /// In tr, this message translates to:
  /// **'Ask about nutrition...'**
  String get askNutritionHint;

  /// No description provided for @quickPromptProtein.
  ///
  /// In tr, this message translates to:
  /// **'How much protein do I need?'**
  String get quickPromptProtein;

  /// No description provided for @quickPromptFatLoss.
  ///
  /// In tr, this message translates to:
  /// **'Best foods for fat loss?'**
  String get quickPromptFatLoss;

  /// No description provided for @quickPromptCalories.
  ///
  /// In tr, this message translates to:
  /// **'Should I count calories?'**
  String get quickPromptCalories;

  /// No description provided for @quickPromptMealPrep.
  ///
  /// In tr, this message translates to:
  /// **'Meal prep tips?'**
  String get quickPromptMealPrep;

  /// No description provided for @aiGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Hi! I\'m your AI Dietitian powered by eatiq. Ask me anything about nutrition, meal planning, or how to reach your health goals. 🥗'**
  String get aiGreeting;

  /// No description provided for @signInToEatiq.
  ///
  /// In tr, this message translates to:
  /// **'Sign in to eatiq'**
  String get signInToEatiq;

  /// No description provided for @signInSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Sync your progress across devices and unlock personalised nutrition insights.'**
  String get signInSubtitle;

  /// No description provided for @continueWithApple.
  ///
  /// In tr, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithoutSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Continue without signing in'**
  String get continueWithoutSignIn;

  /// No description provided for @legalAgreementNote.
  ///
  /// In tr, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get legalAgreementNote;

  /// No description provided for @subscriptionLegal.
  ///
  /// In tr, this message translates to:
  /// **'Subscription & Legal'**
  String get subscriptionLegal;

  /// No description provided for @restorePurchases.
  ///
  /// In tr, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @termsOfService.
  ///
  /// In tr, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @searchLabel.
  ///
  /// In tr, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @dietitianLabel.
  ///
  /// In tr, this message translates to:
  /// **'Dietitian'**
  String get dietitianLabel;

  /// No description provided for @targetWeight.
  ///
  /// In tr, this message translates to:
  /// **'Target Weight'**
  String get targetWeight;

  /// No description provided for @goalHitBadge.
  ///
  /// In tr, this message translates to:
  /// **'Goal {pct}% hit'**
  String goalHitBadge(String pct);

  /// No description provided for @consistencyBadge.
  ///
  /// In tr, this message translates to:
  /// **'{pct}% consistent'**
  String consistencyBadge(String pct);

  /// No description provided for @waterAdd250.
  ///
  /// In tr, this message translates to:
  /// **'+250 ml'**
  String get waterAdd250;

  /// No description provided for @waterAdd500.
  ///
  /// In tr, this message translates to:
  /// **'+500 ml'**
  String get waterAdd500;

  /// No description provided for @waterAdd700.
  ///
  /// In tr, this message translates to:
  /// **'+700 ml'**
  String get waterAdd700;

  /// No description provided for @aiNote.
  ///
  /// In tr, this message translates to:
  /// **'AI Notu'**
  String get aiNote;

  /// No description provided for @additionalNotes.
  ///
  /// In tr, this message translates to:
  /// **'Ek Notlar'**
  String get additionalNotes;

  /// No description provided for @avgWaterLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ort. Su'**
  String get avgWaterLabel;

  /// No description provided for @caloriesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kalori'**
  String get caloriesLabel;

  /// No description provided for @carbsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Karb'**
  String get carbsLabel;

  /// No description provided for @consistencyLabel.
  ///
  /// In tr, this message translates to:
  /// **'İstikrar'**
  String get consistencyLabel;

  /// No description provided for @cookingTime.
  ///
  /// In tr, this message translates to:
  /// **'Pişirme Süresi'**
  String get cookingTime;

  /// No description provided for @cuisinePreferences.
  ///
  /// In tr, this message translates to:
  /// **'Mutfak Tercihleri'**
  String get cuisinePreferences;

  /// No description provided for @dietitianNav.
  ///
  /// In tr, this message translates to:
  /// **'Diyetisyen'**
  String get dietitianNav;

  /// No description provided for @editPreferences.
  ///
  /// In tr, this message translates to:
  /// **'Tercihleri Düzenle'**
  String get editPreferences;

  /// No description provided for @fatLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yağ'**
  String get fatLabel;

  /// No description provided for @foodRestrictions.
  ///
  /// In tr, this message translates to:
  /// **'Yemek Kısıtlamaları'**
  String get foodRestrictions;

  /// No description provided for @foodDislikesHint.
  ///
  /// In tr, this message translates to:
  /// **'Sevmediğin yiyecekler, alerjiler veya özel istekler...'**
  String get foodDislikesHint;

  /// No description provided for @goalAchievementLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hedef Başarımı'**
  String get goalAchievementLabel;

  /// No description provided for @groceryBudget.
  ///
  /// In tr, this message translates to:
  /// **'Market Bütçesi'**
  String get groceryBudget;

  /// No description provided for @mealsPerDay.
  ///
  /// In tr, this message translates to:
  /// **'Günlük Öğün Sayısı'**
  String get mealsPerDay;

  /// No description provided for @monthlyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aylık'**
  String get monthlyLabel;

  /// No description provided for @proteinLabel.
  ///
  /// In tr, this message translates to:
  /// **'Protein'**
  String get proteinLabel;

  /// No description provided for @regeneratePlan.
  ///
  /// In tr, this message translates to:
  /// **'Planı Yenile'**
  String get regeneratePlan;

  /// No description provided for @sharePlan.
  ///
  /// In tr, this message translates to:
  /// **'Planı Paylaş'**
  String get sharePlan;

  /// No description provided for @thisWeekLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu Hafta'**
  String get thisWeekLabel;

  /// No description provided for @topMealLabel.
  ///
  /// In tr, this message translates to:
  /// **'En Yoğun Öğün'**
  String get topMealLabel;

  /// No description provided for @waterLabel.
  ///
  /// In tr, this message translates to:
  /// **'Su'**
  String get waterLabel;

  /// No description provided for @weightLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kilo'**
  String get weightLabel;

  /// No description provided for @yearlyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yıllık'**
  String get yearlyLabel;

  /// No description provided for @solidFood.
  ///
  /// In tr, this message translates to:
  /// **'🍽️  Katı Gıda'**
  String get solidFood;

  /// No description provided for @askNutritionHint2.
  ///
  /// In tr, this message translates to:
  /// **'Beslenme hakkında sor...'**
  String get askNutritionHint2;

  /// No description provided for @continueWithApple2.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile Devam Et'**
  String get continueWithApple2;

  /// No description provided for @continueWithGoogle2.
  ///
  /// In tr, this message translates to:
  /// **'Google ile Devam Et'**
  String get continueWithGoogle2;

  /// No description provided for @searchLabel2.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get searchLabel2;

  /// No description provided for @searchFoodsHint2.
  ///
  /// In tr, this message translates to:
  /// **'Yiyecek ara...'**
  String get searchFoodsHint2;
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
