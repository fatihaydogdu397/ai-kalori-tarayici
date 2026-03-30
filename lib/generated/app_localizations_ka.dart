// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'გადაიღე ფოტო. გაიგე რას ჭამ.';

  @override
  String get getStarted => 'დაწყება';

  @override
  String get alreadyHaveAccount => 'უკვე გაქვს ანგარიში?';

  @override
  String get signIn => 'შესვლა';

  @override
  String get skip => 'გამოტოვება';

  @override
  String get continueBtn => 'გაგრძელება';

  @override
  String get letsGo => 'დავიწყოთ';

  @override
  String get back => 'უკან';

  @override
  String get save => 'შენახვა';

  @override
  String get done => 'მზადაა';

  @override
  String get cancel => 'გაუქმება';

  @override
  String get onboardingHello => 'გამარჯობა! 👋';

  @override
  String get onboardingNameSub => 'გავიცნოთ ერთმანეთი. შენი სახელი?';

  @override
  String get onboardingNameHint => 'დაწერე სახელი...';

  @override
  String get onboardingNameRequired => 'გთხოვ შეიყვანო სახელი';

  @override
  String get onboardingBody => 'შეიცანი შენი სხეული';

  @override
  String get onboardingBodySub => 'გამოვთვალოთ კალორიების მიზანი.';

  @override
  String get onboardingGoal => 'შენი მიზანი?';

  @override
  String get onboardingGoalSub => 'კალორიების მიზანი ამის მიხედვით დაიყენება.';

  @override
  String get onboardingTheme => 'გარეგნობა';

  @override
  String get onboardingThemeSub => 'მოგვიანებით შეგიძლია შეცვალო.';

  @override
  String get male => 'მამრობითი';

  @override
  String get female => 'მდედრობითი';

  @override
  String get age => 'ასაკი';

  @override
  String get height => 'სიმაღლე';

  @override
  String get weight => 'წონა';

  @override
  String get ageUnit => 'წ.';

  @override
  String get heightUnit => 'სმ';

  @override
  String get weightUnit => 'კგ';

  @override
  String get goalLose => 'წონის დაკლება';

  @override
  String get goalLoseSub => 'ნელ-ნელა კალორიების დეფიციტით';

  @override
  String get goalMaintain => 'წონის შენარჩუნება';

  @override
  String get goalMaintainSub => 'დაბალანსებული და ჯანსაღი კვება';

  @override
  String get goalGain => 'წონის მომატება';

  @override
  String get goalGainSub => 'კუნთის მასის მომატება';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String greeting(String name) {
    return 'გამარჯობა, $name';
  }

  @override
  String get defaultName => 'შენ';

  @override
  String get caloriestoday => 'დღევანდელი კალორიები';

  @override
  String get todaysMeals => 'დღევანდელი კვება';

  @override
  String get noMeals =>
      'კვება ჯერ არ არის დამატებული.\nდაასკანირე პირველი საჭმელი!';

  @override
  String get protein => 'ცილა';

  @override
  String get carbs => 'ნახშირწყლები';

  @override
  String get fat => 'ცხიმი';

  @override
  String get water => 'წყალი';

  @override
  String get analyzing => 'ანალიზი...';

  @override
  String get analyzingSub => 'AI ითვლის საკვებ ღირებულებებს';

  @override
  String get camera => 'კამერა';

  @override
  String get gallery => 'გალერეა';

  @override
  String get home => 'მთავარი';

  @override
  String get scan => 'სკანირება';

  @override
  String get progress => 'პროგრესი';

  @override
  String get profile => 'პროფილი';

  @override
  String get weeklyCalories => 'კვირის კალორიები';

  @override
  String get macroBreakdown => 'მაკრო განაწილება';

  @override
  String get avgCalories => 'საშ. კალორია';

  @override
  String get totalScans => 'სულ სკანირება';

  @override
  String get thisWeek => 'ამ კვირაში';

  @override
  String get profileTitle => 'პროფილი';

  @override
  String get editProfile => 'რედაქტირება';

  @override
  String get calorieGoal => 'კალორიების მიზანი';

  @override
  String get language => 'ენა';

  @override
  String get appearance => 'გარეგნობა';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'შეუზღუდავი სკანირება და ფუნქციები';

  @override
  String get waterAdd => 'წყლის დამატება';

  @override
  String get waterGoal => 'წყლის მიზანი';

  @override
  String waterGlasses(int count) {
    return '$count ჭიქა';
  }

  @override
  String get limitReached => 'დღიური ლიმიტი ამოიწურა';

  @override
  String get limitReachedSub =>
      'დღეს გამოიყენე 5 უფასო სკანირება.\nსკანირე შეუზღუდავად eatiq Pro-ით.';

  @override
  String get unlimitedScans => 'შეუზღუდავი AI სკანირება';

  @override
  String get unlimitedHistory => 'შეუზღუდავი ისტორია';

  @override
  String get weeklyReport => 'AI კვირის ანგარიში';

  @override
  String get turkishDB => 'თურქული საჭმლის მონაცემთა ბაზა';

  @override
  String get goProBtn => 'Pro-ზე გადასვლა — ₺149/თვ';

  @override
  String get yearlyDiscount => 'დაზოგე 44% ₺999/წელიწადით';

  @override
  String minutesAgo(int min) {
    return '$min წუთის წინ';
  }

  @override
  String hoursAgo(int hr) {
    return '$hr სთ წინ';
  }

  @override
  String daysAgo(int count) {
    return '$count დღის წინ';
  }

  @override
  String get monday => 'ორშ';

  @override
  String get tuesday => 'სამ';

  @override
  String get wednesday => 'ოთხ';

  @override
  String get thursday => 'ხუთ';

  @override
  String get friday => 'პარ';

  @override
  String get saturday => 'შაბ';

  @override
  String get sunday => 'კვი';

  @override
  String get errorGeneric => 'შეცდომა მოხდა';

  @override
  String get retry => 'სცადე თავიდან';

  @override
  String get mealBreakfast => 'საუზმე';

  @override
  String get mealLunch => 'სადილი';

  @override
  String get mealDinner => 'ვახშამი';

  @override
  String get mealSnack => 'სნეკი';

  @override
  String get settings => 'პარამეტრები';

  @override
  String get unitSystem => 'საზომი სისტემა';

  @override
  String get reminders => 'შეხსენებები';

  @override
  String get notifications => 'შეტყობინებები';

  @override
  String get dailyCalorieGoal => 'დღიური კალორიების მიზანი';

  @override
  String get calorieRange => '1200 – 4000 კკალ შორის';

  @override
  String get selectLanguage => 'ენის არჩევა';

  @override
  String get manual => 'ხელით';

  @override
  String get analysisResult => 'ანალიზის შედეგი';

  @override
  String get detectedIngredients => 'გამოვლენილი ინგრედიენტები';

  @override
  String get addedToLog => 'დღიურში დაემატა ✓';

  @override
  String get backToHome => 'კარგი, მთავარ გვერდზე დაბრუნება';

  @override
  String get mealAutoSaved => 'კვება ავტომატურად შეინახა.';

  @override
  String get historyTitle => 'ისტორია';

  @override
  String get noScansYet => 'სკანირება ჯერ არ ყოფილა';

  @override
  String get scanFirstMeal => 'დაასკანირე პირველი საჭმელი!';

  @override
  String scanCount(int count) {
    return '$count სკანირება';
  }

  @override
  String get bodyAnalysis => 'სხეულის ანალიზი';

  @override
  String get idealWeight => 'იდეალური წონა';

  @override
  String get gender => 'სქესი';

  @override
  String get goalLabel => 'მიზანი';

  @override
  String get basalMetabolicRate => 'ბაზალური მეტაბოლიზმი';

  @override
  String get dailyNeeds => 'დღიური მიზანი';

  @override
  String get bodyInfo => 'სხეულის მონაცემები';

  @override
  String get mealNameLabel => 'კვების სახელი';

  @override
  String get categoryLabel => 'კატეგორია';

  @override
  String get portionWeightLabel => 'პორციის წონა (გ) — სურვილისამებრ';

  @override
  String get portionHint => 'თუ შეიყვანთ, მაკროები გადამოწმდება';

  @override
  String get macrosLabel => 'მაკროები (გ) — სურვილისამებრ';

  @override
  String get editMeal => 'კვების რედაქტირება';

  @override
  String get addManualMeal => 'კვების ხელით დამატება';

  @override
  String get update => 'განახლება';

  @override
  String get bmiLabel => 'სმი';

  @override
  String get bmiUnderweight => 'წონის ნაკლებობა';

  @override
  String get bmiNormal => 'იდეალური წონა';

  @override
  String get bmiOverweight => 'ჭარბი წონა';

  @override
  String get bmiObese => 'სიმსუქნე';

  @override
  String get bmiMorbidObese => 'მძიმე სიმსუქნე';

  @override
  String get bmiUnderweightDesc => 'იდეალურ წონაზე ოდნავ ქვემოთ ხარ';

  @override
  String get bmiNormalDesc => 'შესანიშნავია! ჯანსაღი წონის დიაპაზონში ხარ 🎯';

  @override
  String get bmiOverweightDesc => 'ჯანსაღ წონაზე ოდნავ მეტი გაქვს';

  @override
  String get bmiObeseDesc => 'ჯანმრთელობისთვის წონის დაკლება გირჩევ';

  @override
  String get bmiMorbidObeseDesc => 'გთხოვ, ექიმს მიმართო';

  @override
  String get addMeal => '+ დამატება';

  @override
  String get favorites => 'რჩეულები';

  @override
  String get addMealShort => '+ დამატება';

  @override
  String get mealFallback => 'კვება';

  @override
  String get month01 => 'იან';

  @override
  String get month02 => 'თებ';

  @override
  String get month03 => 'მარ';

  @override
  String get month04 => 'აპრ';

  @override
  String get month05 => 'მაი';

  @override
  String get month06 => 'ივნ';

  @override
  String get month07 => 'ივლ';

  @override
  String get month08 => 'აგვ';

  @override
  String get month09 => 'სექ';

  @override
  String get month10 => 'ოქტ';

  @override
  String get month11 => 'ნოვ';

  @override
  String get month12 => 'დეკ';

  @override
  String get validRequired => 'სავალდებულო ველი';

  @override
  String get validNumber => 'შეიყვანეთ სწორი რიცხვი';

  @override
  String get validPositive => 'ნულზე მეტი უნდა იყოს';

  @override
  String get validNegative => 'არ შეიძლება იყოს უარყოფითი';

  @override
  String get validPortionRange => '1–5000გ შორის უნდა იყოს';

  @override
  String validMacroMax(String macro) {
    return '$macro 1000გ-ს არ შეიძლება გადააჭარბოს';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro პორციის წონას ($portionგ) არ შეიძლება გადააჭარბოს';
  }

  @override
  String validMacroTotal(String total) {
    return 'მთლიანი მაკრო ($totalგ) პორციის წონას აღემატება';
  }

  @override
  String get validCalRequired => 'კალორიები სავალდებულოა';

  @override
  String get validCalMax => 'ერთი კვება 5000 კკალ-ს არ შეიძლება გადააჭარბოს';

  @override
  String validCalInconsistent(String estimated) {
    return 'მაკრონებთან შეუსაბამო (სავარაუდო ~$estimated კკალ)';
  }

  @override
  String get hintMealName => 'მაგ. შვრია, ქათამი...';

  @override
  String get hintCalories => 'მაგ. 350';

  @override
  String get hintPortion => 'მაგ. 200';

  @override
  String get hintProtein => 'ცილა';

  @override
  String get hintCarbs => 'ნახშირწყლები';

  @override
  String get hintFat => 'ცხიმი';

  @override
  String get unitMetric => 'მეტრული';

  @override
  String get unitImperial => 'საიმპერიო';

  @override
  String get userFallback => 'შენ';

  @override
  String get mealNameRequired => 'კვების სახელი სავალდებულოა';

  @override
  String get themeDark => 'მუქი';

  @override
  String get themeLight => 'ღია';

  @override
  String get today => 'დღეს';

  @override
  String get yesterday => 'გუშინ';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'კვება და წყალი სინქრონი';

  @override
  String get appleHealthDenied =>
      'Apple Health წვდომა უარყოფილია. გახსენით პარამეტრები → კონფიდენციალურობა → ჯანმრთელობა → Eatiq.';

  @override
  String get goToSettings => 'პარამეტრების გახსნა';

  @override
  String get barcode => 'შტრიხკოდი';

  @override
  String get barcodeHint => 'შტრიხკოდი ჩარჩოში მოათავსეთ';

  @override
  String get barcodeSearching => 'პროდუქტი ეძებება...';

  @override
  String get barcodeNotFound => 'პროდუქტი ვერ მოიძებნა. სცადეთ ხელით შეყვანა.';

  @override
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

  @override
  String streakDays(int count) {
    return '$count დღე მიჯრით';
  }

  @override
  String get streakMotivation => 'შეიყვანეთ ყოველდღე!';

  @override
  String get streakMilestone7 => '1 კვირა მიჯრით! ყოჩაღ. 🎉';

  @override
  String get streakMilestone30 => '1 თვე მიჯრით! საოცარია! 🏆';

  @override
  String get activityLevel => 'რამდენად აქტიური ხართ?';

  @override
  String get activityLevelSub => 'აირჩიეთ ყოველდღიური აქტივობის დონე';

  @override
  String get activitySedentary => 'მჯდომარე';

  @override
  String get activitySedentarySub => 'მცირე ან ვარჯიშის გარეშე';

  @override
  String get activityLight => 'მსუბუქი აქტიური';

  @override
  String get activityLightSub => 'მსუბუქი ვარჯიში 1-3 დღე/კვირა';

  @override
  String get activityActive => 'აქტიური';

  @override
  String get activityActiveSub => 'საშუალო ვარჯიში 3-5 დღე/კვირა';

  @override
  String get activityVery => 'ძალიან აქტიური';

  @override
  String get activityVerySub => 'მძიმე ვარჯიში 6-7 დღე/კვირა';

  @override
  String get onboardingSummaryTitle => 'თქვენ მზად ხართ! 🎉';

  @override
  String get onboardingSummarySub =>
      'აქ არის თქვენი პერსონალური ყოველდღიური მიზანი.';

  @override
  String get onboardingRecommend => 'რეკომენდებული ყოველდღიური კალორიები';

  @override
  String get onboardingGender => 'რა სქესის ხართ?';

  @override
  String get onboardingGenderSub =>
      'გამოიყენება მეტაბოლიზმის სიჩქარის გამოსათვლელად.';

  @override
  String get onboardingAge => 'რამდენი წლის ხართ?';

  @override
  String get onboardingAgeSub =>
      'გამოიყენება მეტაბოლიზმის სიჩქარის გამოსათვლელად.';

  @override
  String get onboardingHeightWeight => 'სიმაღლე და წონა';

  @override
  String get onboardingHeightWeightSub => 'საჭიროა BMI და კალორიებისთვის.';
}
