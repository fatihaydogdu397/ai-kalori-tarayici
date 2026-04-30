// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'التقط صورة. اعرف ما تأكله.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get skip => 'تخطي';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get letsGo => 'هيا نبدأ';

  @override
  String get back => 'رجوع';

  @override
  String get save => 'حفظ';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get onboardingHello => 'مرحباً! 👋';

  @override
  String get onboardingNameSub => 'دعنا نتعرف عليك. ما اسمك؟';

  @override
  String get onboardingNameHint => 'اكتب اسمك...';

  @override
  String get onboardingNameRequired => 'الرجاء إدخال اسمك';

  @override
  String get onboardingBody => 'تعرف على جسمك';

  @override
  String get onboardingBodySub => 'دعنا نحسب هدفك اليومي من السعرات.';

  @override
  String get onboardingGoal => 'ما هو هدفك؟';

  @override
  String get onboardingGoalSub => 'سنضبط هدف السعرات الحرارية وفقاً لذلك.';

  @override
  String get onboardingTheme => 'المظهر';

  @override
  String get onboardingThemeSub => 'يمكنك تغييره لاحقاً.';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get age => 'العمر';

  @override
  String get height => 'الطول';

  @override
  String get weight => 'الوزن';

  @override
  String get ageUnit => 'سنة';

  @override
  String get heightUnit => 'سم';

  @override
  String get weightUnit => 'كغ';

  @override
  String get goalLose => 'خسارة الوزن';

  @override
  String get goalLoseSub => 'بعجز سعري تدريجي';

  @override
  String get goalMaintain => 'الحفاظ على الوزن';

  @override
  String get goalMaintainSub => 'تغذية متوازنة وصحية';

  @override
  String get goalGain => 'زيادة الوزن';

  @override
  String get goalGainSub => 'بناء الكتلة العضلية';

  @override
  String get dark => 'داكن';

  @override
  String get light => 'فاتح';

  @override
  String greeting(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get defaultName => 'أنت';

  @override
  String get caloriestoday => 'سعرات اليوم';

  @override
  String get todaysMeals => 'وجبات اليوم';

  @override
  String get noMeals => 'لم تُضف وجبات بعد.\nافتح الكاميرا وامسح أول طعام!';

  @override
  String get protein => 'بروتين';

  @override
  String get carbs => 'كارب';

  @override
  String get fat => 'دهون';

  @override
  String get water => 'ماء';

  @override
  String get analyzing => 'جارٍ التحليل...';

  @override
  String get analyzingSub => 'يحسب الذكاء الاصطناعي القيم الغذائية';

  @override
  String get camera => 'كاميرا';

  @override
  String get gallery => 'معرض';

  @override
  String get home => 'الرئيسية';

  @override
  String get scan => 'مسح';

  @override
  String get progress => 'التقدم';

  @override
  String get profile => 'الملف';

  @override
  String get weeklyCalories => 'سعرات الأسبوع';

  @override
  String get macroBreakdown => 'توزيع المغذيات';

  @override
  String get avgCalories => 'متوسط السعرات';

  @override
  String get totalScans => 'إجمالي المسح';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل';

  @override
  String get calorieGoal => 'هدف السعرات';

  @override
  String get language => 'اللغة';

  @override
  String get appearance => 'المظهر';

  @override
  String get premium => 'مميز';

  @override
  String get premiumSub => 'مسح غير محدود وميزات إضافية';

  @override
  String get waterAdd => 'إضافة ماء';

  @override
  String get waterGoal => 'هدف الماء';

  @override
  String waterGlasses(int count) {
    return '$count أكواب';
  }

  @override
  String get limitReached => 'وصلت إلى الحد اليومي';

  @override
  String get limitReachedSub =>
      'لقد استخدمت 5 عمليات مسح مجانية اليوم.\nامسح بلا حدود مع eatiq Pro.';

  @override
  String get unlimitedScans => 'مسح ذكاء اصطناعي غير محدود';

  @override
  String get unlimitedHistory => 'سجل غير محدود';

  @override
  String get weeklyReport => 'تقرير أسبوعي بالذكاء الاصطناعي';

  @override
  String get turkishDB => 'قاعدة بيانات الطعام التركي';

  @override
  String get goProBtn => 'Pro — اشترك الآن';

  @override
  String get yearlyDiscount => 'وفّر 44% بالاشتراك السنوي';

  @override
  String minutesAgo(int min) {
    return 'منذ $min دقيقة';
  }

  @override
  String hoursAgo(int hr) {
    return 'منذ $hr ساعة';
  }

  @override
  String daysAgo(int count) {
    return 'منذ $count أيام';
  }

  @override
  String get monday => 'الإثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get errorGeneric => 'حدث خطأ';

  @override
  String get errorAuthInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errorAuthSignInAgain => 'يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorAuthOauthFailed => 'تعذّر تسجيل الدخول. حاول مرة أخرى.';

  @override
  String get errorAuthEmailInUse =>
      'هذا البريد مسجّل بالفعل. حاول تسجيل الدخول.';

  @override
  String get errorAuthEmailProviderConflict =>
      'سجّل الدخول بالطريقة التي استخدمتها أصلًا لهذا البريد.';

  @override
  String get errorAuthInvalidOtp => 'الرمز غير صالح أو منتهي الصلاحية.';

  @override
  String get errorAuthTooManyAttempts =>
      'محاولات فاشلة كثيرة. اطلب رمزًا جديدًا.';

  @override
  String get errorPremiumRequired => 'اشتراك بريميوم مطلوب.';

  @override
  String get errorFoodScanLimit =>
      'تم الوصول إلى الحد اليومي للمسح. ترقَّ إلى بريميوم لمسح غير محدود.';

  @override
  String get errorFoodNotFound => 'لم نعثر على هذه الوجبة.';

  @override
  String get errorNotOwner => 'ليس لديك صلاحية الوصول لهذا العنصر.';

  @override
  String get errorFoodDeleteOnlyToday => 'يمكنك حذف وجبات اليوم فقط.';

  @override
  String get errorFoodInvalidBarcode => 'الباركود يبدو غير صحيح.';

  @override
  String get errorFoodMacroLimit => 'يجب أن يكون كل ماكرو 1000 أو أقل.';

  @override
  String get errorDietPlanWeeklyLimit => 'استخدمت جميع خططك هذا الأسبوع.';

  @override
  String get errorDietPlanMacrosNotSet => 'حدد أهداف الماكرو اليومية أولًا.';

  @override
  String get errorDietPlanNotActive => 'ليس لديك خطة نشطة.';

  @override
  String get errorDietPlanMealNotFound => 'لم نعثر على هذه الوجبة.';

  @override
  String get errorBloodTestInvalidFile => 'الملف تالف.';

  @override
  String get errorBloodTestTooLarge =>
      'يجب أن تكون الملفات 10 ميجابايت أو أقل.';

  @override
  String get errorBloodTestMimeMismatch => 'تنسيق الملف غير مدعوم.';

  @override
  String get errorBloodTestNotFound => 'لم نعثر على فحص الدم.';

  @override
  String get errorNutritionNoCandidates =>
      'تعذّر إنشاء توصية. عدّل تفضيلاتك الغذائية.';

  @override
  String get errorWaterInvalid => 'يجب أن يكون الماء بين 0 و3 لتر.';

  @override
  String get errorWeightInvalid => 'يجب أن يكون الوزن بين 30 و300 كجم.';

  @override
  String get errorRateLimited => 'طلبات كثيرة جدًا. حاول بعد قليل.';

  @override
  String get errorInvalidInput => 'يرجى التحقق من المدخلات.';

  @override
  String get errorNetwork => 'لا يوجد اتصال بالإنترنت. تحقق من الشبكة.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get delete => 'حذف';

  @override
  String get healthDataSection => 'بيانات الصحة';

  @override
  String get bloodTestTitle => 'تحليل دم';

  @override
  String get bloodTestHeadline => 'ارفع تقريرك الصحي';

  @override
  String get bloodTestSubtitle =>
      'رفع تقرير الفحص يساعدنا في تخصيص خطتك ونصائحنا بشكل أفضل. اختياري — يمكنك إضافته في أي وقت من ملفك الشخصي.';

  @override
  String get bloodTestPickFile => 'اختر ملفًا';

  @override
  String get bloodTestReplaceFile => 'انقر للاستبدال';

  @override
  String get bloodTestFileTypesHint => 'PDF أو صورة (JPG/PNG)';

  @override
  String get bloodTestDateOptional => 'تاريخ الفحص (اختياري)';

  @override
  String get bloodTestUpload => 'رفع';

  @override
  String get bloodTestUploadAndContinue => 'رفع ومتابعة';

  @override
  String get bloodTestsScreenTitle => 'تحليلاتي';

  @override
  String get bloodTestAdd => 'إضافة';

  @override
  String get bloodTestEmptyTitle => 'لا توجد تحليلات دم مرفوعة بعد';

  @override
  String get bloodTestEmptyBody => 'اضغط زر + لإضافة PDF أو صورة.';

  @override
  String get bloodTestDeleteTitle => 'حذف تحليل الدم';

  @override
  String get bloodTestDeleteBody => 'سيتم حذف هذا السجل نهائيًا.';

  @override
  String get bloodTestStatusPending => 'تحليل الذكاء الاصطناعي قيد الانتظار';

  @override
  String get bloodTestStatusCompleted => 'تم التحليل';

  @override
  String get bloodTestStatusFailed => 'فشل التحليل';

  @override
  String get mealBreakfast => 'إفطار';

  @override
  String get mealLunch => 'غداء';

  @override
  String get mealDinner => 'عشاء';

  @override
  String get mealSnack => 'وجبة خفيفة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get unitSystem => 'نظام القياس';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get dailyCalorieGoal => 'هدف السعرات اليومي';

  @override
  String get calorieRange => 'بين 1200 – 4000 سعرة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get manual => 'يدوي';

  @override
  String get analysisResult => 'نتيجة التحليل';

  @override
  String get detectedIngredients => 'المكونات المكتشفة';

  @override
  String get addedToLog => 'تمت الإضافة إلى السجل ✓';

  @override
  String get backToHome => 'حسنا، العودة للرئيسية';

  @override
  String get mealAutoSaved => 'تم حفظ الوجبة تلقائيا.';

  @override
  String get historyTitle => 'السجل';

  @override
  String get noScansYet => 'لا توجد عمليات مسح بعد';

  @override
  String get scanFirstMeal => 'امسح وجبتك الأولى!';

  @override
  String scanCount(int count) {
    return '$count عمليات مسح';
  }

  @override
  String get bodyAnalysis => 'تحليل الجسم';

  @override
  String get idealWeight => 'الوزن المثالي';

  @override
  String get gender => 'الجنس';

  @override
  String get goalLabel => 'الهدف';

  @override
  String get basalMetabolicRate => 'معدل الأيض الأساسي';

  @override
  String get dailyNeeds => 'الهدف اليومي';

  @override
  String get bodyInfo => 'معلومات الجسم';

  @override
  String get mealNameLabel => 'اسم الوجبة';

  @override
  String get categoryLabel => 'الفئة';

  @override
  String get portionWeightLabel => 'وزن الحصة (جم) — اختياري';

  @override
  String get portionHint => 'إذا أدخلت، سيتم التحقق من الماكروز';

  @override
  String get macrosLabel => 'الماكروز (جم) — اختياري';

  @override
  String get editMeal => 'تعديل الوجبة';

  @override
  String get addManualMeal => 'إضافة وجبة يدوياً';

  @override
  String get update => 'تحديث';

  @override
  String get bmiLabel => 'مؤشر كتلة الجسم';

  @override
  String get bmiUnderweight => 'نحيف';

  @override
  String get bmiNormal => 'الوزن المثالي';

  @override
  String get bmiOverweight => 'زيادة في الوزن';

  @override
  String get bmiObese => 'سمنة';

  @override
  String get bmiMorbidObese => 'سمنة مفرطة';

  @override
  String get bmiUnderweightDesc => 'أنت أقل قليلاً من وزنك المثالي';

  @override
  String get bmiNormalDesc => 'رائع! أنت في نطاق الوزن الصحي 🎯';

  @override
  String get bmiOverweightDesc => 'أنت بعيد قليلاً عن الوزن الصحي';

  @override
  String get bmiObeseDesc => 'ننصح بفقدان الوزن من أجل صحتك';

  @override
  String get bmiMorbidObeseDesc => 'يرجى استشارة متخصص رعاية صحية';

  @override
  String get addMeal => '+ إضافة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get addMealShort => '+ إضافة';

  @override
  String get mealFallback => 'وجبة';

  @override
  String get month01 => 'يناير';

  @override
  String get month02 => 'فبراير';

  @override
  String get month03 => 'مارس';

  @override
  String get month04 => 'أبريل';

  @override
  String get month05 => 'مايو';

  @override
  String get month06 => 'يونيو';

  @override
  String get month07 => 'يوليو';

  @override
  String get month08 => 'أغسطس';

  @override
  String get month09 => 'سبتمبر';

  @override
  String get month10 => 'أكتوبر';

  @override
  String get month11 => 'نوفمبر';

  @override
  String get month12 => 'ديسمبر';

  @override
  String get validRequired => 'حقل مطلوب';

  @override
  String get validNumber => 'أدخل رقماً صحيحاً';

  @override
  String get validPositive => 'يجب أن يكون أكبر من الصفر';

  @override
  String get validNegative => 'لا يمكن أن يكون سالباً';

  @override
  String get validPortionRange => 'يجب أن يكون بين 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro لا يمكن أن يتجاوز 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro لا يمكن أن يتجاوز وزن الحصة (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'إجمالي المغذيات الكبرى (${total}g) يتجاوز وزن الحصة';
  }

  @override
  String get validCalRequired => 'السعرات الحرارية مطلوبة';

  @override
  String get validCalMax => 'لا يمكن أن تتجاوز وجبة واحدة 5000 سعرة حرارية';

  @override
  String validCalInconsistent(String estimated) {
    return 'غير متسق مع المغذيات الكبرى (المقدر ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'مثال: الشوفان، الدجاج...';

  @override
  String get hintCalories => 'مثال: 350';

  @override
  String get hintPortion => 'مثال: 200';

  @override
  String get hintProtein => 'بروتين';

  @override
  String get hintCarbs => 'كربوهيدرات';

  @override
  String get hintFat => 'دهون';

  @override
  String get unitMetric => 'متري';

  @override
  String get unitImperial => 'إمبريالي';

  @override
  String get userFallback => 'أنت';

  @override
  String get mealNameRequired => 'اسم الوجبة مطلوب';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'مزامنة الوجبات والماء';

  @override
  String get appleHealthDenied =>
      'تم رفض إذن Apple Health. افتح الإعدادات → الخصوصية → الصحة → Eatiq.';

  @override
  String get goToSettings => 'فتح الإعدادات';

  @override
  String get barcode => 'الباركود';

  @override
  String get barcodeHint => 'ضع الباركود داخل الإطار';

  @override
  String get barcodeSearching => 'جارٍ البحث عن المنتج...';

  @override
  String get barcodeNotFound => 'المنتج غير موجود. جرّب الإدخال اليدوي.';

  @override
  String get noWeightData => 'لا توجد بيانات وزن بعد.';

  @override
  String get noWeightDataHint => 'أدخل وزنك من قسم الملف الشخصي.';

  @override
  String streakDays(int count) {
    return '$count أيام متتالية';
  }

  @override
  String get streakMotivation => 'سجل كل يوم للحفاظ على سلسلتك!';

  @override
  String get streakMilestone7 => 'أسبوع متواصل! استمر. 🎉';

  @override
  String get streakMilestone30 => 'شهر متواصل! مذهل. 🏆';

  @override
  String get activityLevel => 'ما مدى نشاطك؟';

  @override
  String get activityLevelSub => 'حدد مستوى نشاطك اليومي';

  @override
  String get activitySedentary => 'خامل';

  @override
  String get activitySedentarySub => 'تمرين قليل أو معدوم';

  @override
  String get activityLight => 'نشط قليلاً';

  @override
  String get activityLightSub => 'تمرين خفيف 1-3 أيام/أسبوع';

  @override
  String get activityActive => 'نشط';

  @override
  String get activityActiveSub => 'تمرين معتدل 3-5 أيام/أسبوع';

  @override
  String get activityVery => 'نشيط جدا';

  @override
  String get activityVerySub => 'تمرين شاق 6-7 أيام/أسبوع';

  @override
  String get onboardingSummaryTitle => 'أنت مستعد! 🎉';

  @override
  String get onboardingSummarySub => 'إليك هدفك اليومي المخصص.';

  @override
  String get onboardingRecommend => 'السعرات الحرارية اليومية الموصى بها';

  @override
  String get onboardingGender => 'ما هو جنسك؟';

  @override
  String get onboardingGenderSub => 'يستخدم لحساب معدل الأيض الخاص بك.';

  @override
  String get onboardingAge => 'كم عمرك؟';

  @override
  String get onboardingAgeSub => 'يستخدم لحساب معدل الأيض الخاص بك.';

  @override
  String get onboardingHeightWeight => 'الطول والوزن';

  @override
  String get onboardingHeightWeightSub =>
      'مطلوب لتحديد مؤشر كتلة الجسم والسعرات.';

  @override
  String get waterToday => 'ماء اليوم';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get confirmDelete => 'سيتم إعادة ضبط جميع البيانات. هل أنت متأكد؟';

  @override
  String get dailySummaryTitle => 'ملخص اليوم 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'اليوم استهلكت $cal/$goal سعرة و$waterل ماء. رائع!';
  }

  @override
  String get dailySummaryEmptyTitle => 'لا توجد سجلات اليوم';

  @override
  String get dailySummaryEmptyBody => 'مسح سريع؟ اضغط لتسجيل وجبتك الأولى.';

  @override
  String get dailySummaryUnderTitle => 'تقدم اليوم';

  @override
  String dailySummaryUnderBody(String cal, String goal) {
    return '$cal/$goal سعرة — استمر في التسجيل';
  }

  @override
  String get goalAchievement => 'تحقيق الهدف';

  @override
  String get consistency => 'الاتساق';

  @override
  String get topDay => 'أفضل يوم';

  @override
  String get avgWater => 'متوسط الماء';

  @override
  String get weeklyInsight => 'تحليل أسبوعي';

  @override
  String get monthlyInsight => 'تحليل شهري';

  @override
  String get mostConsumedMeal => 'الوجبة الأكثر استهلاكاً';

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
      'يرجى اختيار نوع نظام غذائي واحد على الأقل';

  @override
  String get dietPlanIAteThis => 'تناولت هذا';

  @override
  String get dietPlanMarkNotEaten => 'تعليم كغير متناول';

  @override
  String get dietPlanEatenLabel => 'تم تناوله';

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
  String get navDaily => 'يومي';

  @override
  String get navProgram => 'البرنامج';

  @override
  String get stepsToday => 'خطوات';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'محروقة';

  @override
  String get thirtyDays => '30 يوماً';

  @override
  String get avgPerDay => 'متوسط / يوم';

  @override
  String get mealsLoggedLabel => 'وجبات مسجلة';

  @override
  String get caloriesChartTitle => 'سعرات حرارية';

  @override
  String get noDataYet => 'لا توجد بيانات بعد';

  @override
  String get recentLogs => 'السجلات الأخيرة';

  @override
  String get currentLabel => 'الحالي';

  @override
  String get targetLabel => 'الهدف';

  @override
  String get noGoalSet => 'لم يتم تحديد هدف';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return 'متبقي $remaining سعرة · الهدف $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit خسرت';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit زدت';
  }

  @override
  String get weightStable => 'وزن ثابت';

  @override
  String get foodSearch => 'البحث عن طعام';

  @override
  String get searchFoodsHint => 'البحث عن طعام...';

  @override
  String get noFoodsFound => 'لا توجد أطعمة';

  @override
  String get addToLog => 'أضف إلى السجل';

  @override
  String foodAddedToLog(String name) {
    return 'تمت إضافة $name إلى السجل';
  }

  @override
  String portionGrams(String grams) {
    return 'الحصة: $grams جرام';
  }

  @override
  String foodCount(int count) {
    return '$count أطعمة';
  }

  @override
  String get categoryAll => 'الكل';

  @override
  String get categoryDairy => 'منتجات الألبان';

  @override
  String get categoryFruit => 'فواكه';

  @override
  String get categoryFats => 'دهون';

  @override
  String get categoryVegetables => 'خضروات';

  @override
  String get categoryFastFood => 'وجبات سريعة';

  @override
  String get categorySnacks => 'وجبات خفيفة';

  @override
  String get aiDietitian => 'أخصائي تغذية ذكي';

  @override
  String get aiPoweredBy => 'مدعوم بذكاء eatiq';

  @override
  String get onlineLabel => 'متصل';

  @override
  String get askNutritionHint => 'اسأل عن التغذية...';

  @override
  String get quickPromptProtein => 'كم البروتين الذي أحتاجه؟';

  @override
  String get quickPromptFatLoss => 'أفضل الأطعمة لحرق الدهون؟';

  @override
  String get quickPromptCalories => 'هل يجب أن أحسب السعرات؟';

  @override
  String get quickPromptMealPrep => 'نصائح لتحضير الوجبات؟';

  @override
  String get aiGreeting =>
      'مرحباً! أنا خبير التغذية الذكي المدعوم من eatiq. اسألني عن أي شيء يتعلق بالتغذية أو تخطيط الوجبات أو كيفية تحقيق أهدافك الصحية. 🥗';

  @override
  String get signInToEatiq => 'تسجيل الدخول إلى eatiq';

  @override
  String get signInSubtitle =>
      'زامن تقدمك عبر الأجهزة واحصل على رؤى غذائية مخصصة.';

  @override
  String get continueWithApple => 'المتابعة مع Apple';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get continueWithoutSignIn => 'المتابعة بدون تسجيل دخول';

  @override
  String get legalAgreementNote =>
      'بالمتابعة، توافق على شروط الخدمة وسياسة الخصوصية.';

  @override
  String get subscriptionLegal => 'الاشتراك والقانوني';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get searchLabel => 'بحث';

  @override
  String get dietitianLabel => 'أخصائي تغذية';

  @override
  String get targetWeight => 'الوزن المستهدف';

  @override
  String goalHitBadge(String pct) {
    return 'تحقيق الهدف $pct٪';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct٪ اتساق';
  }

  @override
  String get waterAdd250 => '+250 مل';

  @override
  String get waterAdd500 => '+500 مل';

  @override
  String get waterAdd700 => '+700 مل';

  @override
  String get aiNote => 'ملاحظة الذكاء الاصطناعي';

  @override
  String get additionalNotes => 'ملاحظات إضافية';

  @override
  String get avgWaterLabel => 'متوسط الماء';

  @override
  String get caloriesLabel => 'سعرات حرارية';

  @override
  String get carbsLabel => 'كربوهيدرات';

  @override
  String get consistencyLabel => 'الاتساق';

  @override
  String get cookingTime => 'وقت الطهي';

  @override
  String get cuisinePreferences => 'تفضيلات المطبخ';

  @override
  String get dietitianNav => 'أخصائي تغذية';

  @override
  String get editPreferences => 'تعديل التفضيلات';

  @override
  String get fatLabel => 'دهون';

  @override
  String get foodRestrictions => 'القيود الغذائية';

  @override
  String get foodDislikesHint =>
      'الأطعمة غير المرغوبة أو الحساسية أو طلبات خاصة...';

  @override
  String get goalAchievementLabel => 'تحقيق الهدف';

  @override
  String get groceryBudget => 'ميزانية البقالة';

  @override
  String get mealsPerDay => 'وجبات في اليوم';

  @override
  String get monthlyLabel => 'شهري';

  @override
  String get proteinLabel => 'بروتين';

  @override
  String get regeneratePlan => 'إعادة إنشاء الخطة';

  @override
  String get sharePlan => 'مشاركة الخطة';

  @override
  String get thisWeekLabel => 'هذا الأسبوع';

  @override
  String get topMealLabel => 'أبرز وجبة';

  @override
  String get waterLabel => 'ماء';

  @override
  String get weightLabel => 'الوزن';

  @override
  String get yearlyLabel => 'سنوي';

  @override
  String get solidFood => '🍽️  طعام صلب';

  @override
  String get askNutritionHint2 => 'اسأل عن التغذية...';

  @override
  String get continueWithApple2 => 'المتابعة مع Apple';

  @override
  String get continueWithGoogle2 => 'المتابعة مع Google';

  @override
  String get searchLabel2 => 'بحث';

  @override
  String get searchFoodsHint2 => 'البحث عن طعام...';
}
