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
  String get retry => 'إعادة المحاولة';

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
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

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
  String get dailySummaryTitle => 'Günün Özeti 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Bugün $cal/$goal kcal ve ${water}L su tükettin. Harika gidiyorsun!';
  }

  @override
  String get goalAchievement => 'Hedef Başarımı';

  @override
  String get consistency => 'İstikrar';

  @override
  String get topDay => 'Zirve Gün';

  @override
  String get avgWater => 'Ort. Su';

  @override
  String get weeklyInsight => 'Haftalık Analiz';

  @override
  String get monthlyInsight => 'Aylık Analiz';

  @override
  String get mostConsumedMeal => 'En Yoğun Öğün';
}
