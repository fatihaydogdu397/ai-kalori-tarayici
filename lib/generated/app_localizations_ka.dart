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
  String get errorAuthInvalidCredentials => 'ელფოსტა ან პაროლი არასწორია.';

  @override
  String get errorAuthSignInAgain => 'გთხოვთ, ხელახლა შეხვიდეთ.';

  @override
  String get errorAuthOauthFailed => 'ვერ შეხვედით. სცადეთ ისევ.';

  @override
  String get errorAuthEmailInUse =>
      'ეს ელფოსტა უკვე რეგისტრირებულია. სცადეთ შესვლა.';

  @override
  String get errorAuthEmailProviderConflict =>
      'შედით იმ მეთოდით, რომელიც თავდაპირველად გამოიყენეთ ამ ელფოსტისთვის.';

  @override
  String get errorAuthInvalidOtp => 'კოდი არასწორია ან ვადაგასულია.';

  @override
  String get errorAuthTooManyAttempts =>
      'ბევრი წარუმატებელი მცდელობა. მოითხოვეთ ახალი კოდი.';

  @override
  String get errorPremiumRequired => 'საჭიროა Premium გამოწერა.';

  @override
  String get errorFoodScanLimit =>
      'ყოველდღიური სკანირების ლიმიტი ამოიწურა. გადადით Premium-ზე შეუზღუდავი სკანირებისთვის.';

  @override
  String get errorFoodNotFound => 'კერძი ვერ მოიძებნა.';

  @override
  String get errorNotOwner => 'ამ ელემენტთან წვდომა არ გაქვთ.';

  @override
  String get errorFoodDeleteOnlyToday =>
      'შეგიძლიათ წაშალოთ მხოლოდ დღეს ჩაწერილი კერძები.';

  @override
  String get errorFoodInvalidBarcode => 'ეს ბარკოდი არასწორად გამოიყურება.';

  @override
  String get errorFoodMacroLimit => 'თითოეული მაკრო უნდა იყოს 1000 ან ნაკლები.';

  @override
  String get errorDietPlanWeeklyLimit => 'ამ კვირის ყველა გეგმა გამოიყენე.';

  @override
  String get errorDietPlanMacrosNotSet =>
      'ჯერ დააყენე ყოველდღიური მაკრო მიზნები.';

  @override
  String get errorDietPlanNotActive => 'აქტიური გეგმა არ გაქვს.';

  @override
  String get errorDietPlanMealNotFound => 'კერძი ვერ მოიძებნა.';

  @override
  String get errorBloodTestInvalidFile => 'ფაილი დაზიანებულია.';

  @override
  String get errorBloodTestTooLarge => 'ფაილები უნდა იყოს 10 მბ ან ნაკლები.';

  @override
  String get errorBloodTestMimeMismatch =>
      'ეს ფაილის ფორმატი არ არის მხარდაჭერილი.';

  @override
  String get errorBloodTestNotFound => 'სისხლის ანალიზი ვერ მოიძებნა.';

  @override
  String get errorNutritionNoCandidates =>
      'რეკომენდაცია ვერ შეიქმნა. შეცვალე დიეტური პრეფერენციები.';

  @override
  String get errorWaterInvalid => 'წყალი უნდა იყოს 0-დან 3 ლიტრამდე.';

  @override
  String get errorWeightInvalid => 'წონა უნდა იყოს 30-დან 300 კგ-მდე.';

  @override
  String get errorRateLimited => 'ძალიან ბევრი მოთხოვნა. სცადე ცოტა ხანში.';

  @override
  String get errorInvalidInput => 'გთხოვთ, შეამოწმოთ შენატანი.';

  @override
  String get errorNetwork => 'ინტერნეტი არ არის. შეამოწმე ქსელი.';

  @override
  String get retry => 'სცადე თავიდან';

  @override
  String get delete => 'წაშლა';

  @override
  String get healthDataSection => 'ჯანდაცვის მონაცემები';

  @override
  String get bloodTestTitle => 'სისხლის ანალიზი';

  @override
  String get bloodTestHeadline => 'ატვირთე ჯანდაცვის ანგარიში';

  @override
  String get bloodTestSubtitle =>
      'ლაბორატორიული ანგარიშის ატვირთვა საშუალებას გვაძლევს გეგმა და რჩევები უკეთ შევარგოთ. არ არის სავალდებულო — შეგიძლია ნებისმიერ დროს დაამატო პროფილიდან.';

  @override
  String get bloodTestPickFile => 'ფაილის არჩევა';

  @override
  String get bloodTestReplaceFile => 'შეცვლისთვის შეახე';

  @override
  String get bloodTestFileTypesHint => 'PDF ან გამოსახულება (JPG/PNG)';

  @override
  String get bloodTestDateOptional => 'ტესტის თარიღი (არასავალდებულო)';

  @override
  String get bloodTestUpload => 'ატვირთვა';

  @override
  String get bloodTestUploadAndContinue => 'ატვირთვა და გაგრძელება';

  @override
  String get bloodTestsScreenTitle => 'ჩემი სისხლის ანალიზები';

  @override
  String get bloodTestAdd => 'დამატება';

  @override
  String get bloodTestEmptyTitle => 'ჯერ ატვირთული სისხლის ანალიზი არ არის';

  @override
  String get bloodTestEmptyBody =>
      'PDF ან გამოსახულების დასამატებლად შეახე + ღილაკი.';

  @override
  String get bloodTestDeleteTitle => 'სისხლის ანალიზის წაშლა';

  @override
  String get bloodTestDeleteBody => 'ეს ჩანაწერი სამუდამოდ წაიშლება.';

  @override
  String get bloodTestStatusPending => 'AI ანალიზი მოლოდინშია';

  @override
  String get bloodTestStatusCompleted => 'ანალიზი დასრულდა';

  @override
  String get bloodTestStatusFailed => 'ანალიზი ვერ მოხერხდა';

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
  String get noWeightData => 'წონის მონაცემები ჯერ არ არის.';

  @override
  String get noWeightDataHint => 'შეიყვანეთ წონა პროფილის განყოფილებაში.';

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

  @override
  String get waterToday => 'დღევანდელი წყალი';

  @override
  String get reset => 'გასუფთავება';

  @override
  String get confirmDelete => 'ყველა მონაცემი წაიშლება. დარწმუნებული ხართ?';

  @override
  String get dailySummaryTitle => 'დღის შეჯამება 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'დღეს მიირთვი $cal/$goal კკალ და $waterლ წყალი. შესანიშნავია!';
  }

  @override
  String get dailySummaryEmptyTitle => 'დღეს ჩანაწერი არ არის';

  @override
  String get dailySummaryEmptyBody =>
      'სწრაფი სკანი? შეახეთ პირველი კერძის ჩასაწერად.';

  @override
  String get dailySummaryUnderTitle => 'დღევანდელი პროგრესი';

  @override
  String dailySummaryUnderBody(String cal, String goal) {
    return '$cal/$goal კკალ — განაგრძე ჩაწერა';
  }

  @override
  String get goalAchievement => 'მიზნის მიღწევა';

  @override
  String get consistency => 'თანმიმდევრულობა';

  @override
  String get topDay => 'საუკეთესო დღე';

  @override
  String get avgWater => 'საშ. წყალი';

  @override
  String get weeklyInsight => 'კვირის ანალიზი';

  @override
  String get monthlyInsight => 'თვის ანალიზი';

  @override
  String get mostConsumedMeal => 'ყველაზე ხშირი კვება';

  @override
  String get splashTitle => 'Calorie tracking made easy';

  @override
  String get onboardingBirthDate => 'Date of Birth';

  @override
  String get onboardingBirthDateSub =>
      'We will calculate your metabolic rate based on your age';

  @override
  String get onboardingTargetWeight => 'What is your target weight?';

  @override
  String get onboardingTargetWeightSub => 'Enter your goal weight';

  @override
  String get onboardingWeeklyPace => 'How fast do you want to reach your goal?';

  @override
  String get onboardingWeeklyPaceSub => 'Weekly weight change pace';

  @override
  String get onboardingDietType => 'Choose Your Diet Type';

  @override
  String get onboardingDietTypeSub =>
      'We will calculate your ideal macro ratios';

  @override
  String get onboardingDietTypeRequired =>
      'გთხოვთ, აირჩიოთ მინიმუმ ერთი დიეტის ტიპი';

  @override
  String get dietPlanIAteThis => 'ეს მე ვჭამე';

  @override
  String get dietPlanMarkNotEaten => 'მონიშნე არ ნაჭამად';

  @override
  String get dietPlanEatenLabel => 'ნაჭამი';

  @override
  String get onboardingAllergiesTitle => 'Allergies & Restrictions';

  @override
  String get onboardingAllergiesSub => 'We will warn you when a food conflicts';

  @override
  String get onboardingAllergiesReligious => 'Religious & Lifestyle';

  @override
  String get onboardingAllergiesAllergens => 'Allergies & Intolerances';

  @override
  String get dietStandard => 'Standard Diet';

  @override
  String get dietLowCarb => 'Low Carbohydrate';

  @override
  String get dietKeto => 'Ketogenic';

  @override
  String get dietHighProtein => 'High Protein';

  @override
  String get dietCustom => 'Custom Diet';

  @override
  String get onboardingNotifTitle => 'Notifications';

  @override
  String get onboardingNotifSub =>
      'We will send you reminders to help reach your goals';

  @override
  String get notifMealReminder => 'Meal reminders';

  @override
  String get notifWaterReminder => 'Water intake reminders';

  @override
  String get notifGoalReminder => 'Goal achievement notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get navDaily => 'ყოველდღიური';

  @override
  String get navProgram => 'პროგრამა';

  @override
  String get stepsToday => 'ნაბიჯი';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'დამწვარი';

  @override
  String get thirtyDays => '30 დღე';

  @override
  String get avgPerDay => 'საშ. / დღე';

  @override
  String get mealsLoggedLabel => 'ჩაწერილი კვება';

  @override
  String get caloriesChartTitle => 'კალორია';

  @override
  String get noDataYet => 'მონაცემები ჯერ არ არის';

  @override
  String get recentLogs => 'ბოლო ჩანაწერები';

  @override
  String get currentLabel => 'მიმდინარე';

  @override
  String get targetLabel => 'სამიზნე';

  @override
  String get noGoalSet => 'მიზანი დაყენებული არ არის';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return 'დარჩა $remaining კკალ · მიზანი $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit მოიკლო';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit მოემატა';
  }

  @override
  String get weightStable => 'სტაბილური წონა';

  @override
  String get foodSearch => 'კვების ძებნა';

  @override
  String get searchFoodsHint => 'კვების ძებნა...';

  @override
  String get noFoodsFound => 'საკვები ვერ მოიძებნა';

  @override
  String get addToLog => 'დღიურში დამატება';

  @override
  String foodAddedToLog(String name) {
    return '$name დღიურში დაემატა';
  }

  @override
  String portionGrams(String grams) {
    return 'პორცია: $grams გ';
  }

  @override
  String foodCount(int count) {
    return '$count კვება';
  }

  @override
  String get categoryAll => 'ყველა';

  @override
  String get categoryDairy => 'რძის პროდუქტები';

  @override
  String get categoryFruit => 'ხილი';

  @override
  String get categoryFats => 'ცხიმები';

  @override
  String get categoryVegetables => 'ბოსტნეული';

  @override
  String get categoryFastFood => 'ფასტ ფუდი';

  @override
  String get categorySnacks => 'სნეკები';

  @override
  String get aiDietitian => 'AI დიეტოლოგი';

  @override
  String get aiPoweredBy => 'eatiq AI-ით უზრუნველყოფილია';

  @override
  String get onlineLabel => 'ონლაინ';

  @override
  String get askNutritionHint => 'დასვი კითხვა კვების შესახებ...';

  @override
  String get quickPromptProtein => 'რამდენი პროტეინი მჭირდება?';

  @override
  String get quickPromptFatLoss => 'საუკეთესო საკვები ცხიმის დასაწვავად?';

  @override
  String get quickPromptCalories => 'კალორიების დათვლა საჭიროა?';

  @override
  String get quickPromptMealPrep => 'კვების მოსამზადებლად რჩევები?';

  @override
  String get aiGreeting =>
      'გამარჯობა! მე ვარ თქვენი AI დიეტოლოგი eatiq-ის მიერ. დამისვით ნებისმიერი კითხვა კვების, კვების გეგმის ან ჯანმრთელობის მიზნების შესახებ. 🥗';

  @override
  String get signInToEatiq => 'eatiq-ში შესვლა';

  @override
  String get signInSubtitle =>
      'სინქრონიზაცია ყველა მოწყობილობაზე და პერსონალიზებული კვებითი რჩევები.';

  @override
  String get continueWithApple => 'Apple-ით გაგრძელება';

  @override
  String get continueWithGoogle => 'Google-ით გაგრძელება';

  @override
  String get continueWithoutSignIn => 'გაგრძელება შესვლის გარეშე';

  @override
  String get legalAgreementNote =>
      'გაგრძელებით ეთანხმებით ჩვენს მომსახურების პირობებსა და კონფიდენციალურობის პოლიტიკას.';

  @override
  String get subscriptionLegal => 'გამოწერა და სამართლებრივი';

  @override
  String get restorePurchases => 'შესყიდვების აღდგენა';

  @override
  String get termsOfService => 'მომსახურების პირობები';

  @override
  String get privacyPolicy => 'კონფიდენციალურობის პოლიტიკა';

  @override
  String get searchLabel => 'ძებნა';

  @override
  String get dietitianLabel => 'დიეტოლოგი';

  @override
  String get targetWeight => 'სამიზნე წონა';

  @override
  String goalHitBadge(String pct) {
    return 'მიზანი $pct%-ით მიღწეულია';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% თანმიმდევრული';
  }

  @override
  String get waterAdd250 => '+250 მლ';

  @override
  String get waterAdd500 => '+500 მლ';

  @override
  String get waterAdd700 => '+700 მლ';

  @override
  String get aiNote => 'AI შენიშვნა';

  @override
  String get additionalNotes => 'დამატებითი შენიშვნები';

  @override
  String get avgWaterLabel => 'საშ. წყალი';

  @override
  String get caloriesLabel => 'კალორია';

  @override
  String get carbsLabel => 'ნახშირწყლები';

  @override
  String get consistencyLabel => 'თანმიმდევრულობა';

  @override
  String get cookingTime => 'მომზადების დრო';

  @override
  String get cuisinePreferences => 'სამზარეულოს პრეფერენციები';

  @override
  String get dietitianNav => 'დიეტოლოგი';

  @override
  String get editPreferences => 'პარამეტრების რედაქტირება';

  @override
  String get fatLabel => 'ცხიმი';

  @override
  String get foodRestrictions => 'კვებითი შეზღუდვები';

  @override
  String get foodDislikesHint =>
      'არასასურველი საკვები, ალერგია ან სპეციალური მოთხოვნები...';

  @override
  String get goalAchievementLabel => 'მიზნის მიღწევა';

  @override
  String get groceryBudget => 'კვებითი ბიუჯეტი';

  @override
  String get mealsPerDay => 'კვება დღეში';

  @override
  String get monthlyLabel => 'თვიური';

  @override
  String get proteinLabel => 'პროტეინი';

  @override
  String get regeneratePlan => 'გეგმის განახლება';

  @override
  String get sharePlan => 'გეგმის გაზიარება';

  @override
  String get thisWeekLabel => 'ამ კვირაში';

  @override
  String get topMealLabel => 'მთავარი კვება';

  @override
  String get waterLabel => 'წყალი';

  @override
  String get weightLabel => 'წონა';

  @override
  String get yearlyLabel => 'წლიური';

  @override
  String get solidFood => '🍽️  მყარი საკვები';

  @override
  String get askNutritionHint2 => 'დასვი კითხვა კვების შესახებ...';

  @override
  String get continueWithApple2 => 'Apple-ით გაგრძელება';

  @override
  String get continueWithGoogle2 => 'Google-ით გაგრძელება';

  @override
  String get searchLabel2 => 'ძებნა';

  @override
  String get searchFoodsHint2 => 'კვების ძებნა...';
}
