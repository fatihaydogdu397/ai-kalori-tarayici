// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Snap a photo. Know what you eat.';

  @override
  String get getStarted => 'Get started';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign in';

  @override
  String get skip => 'Skip';

  @override
  String get continueBtn => 'Continue';

  @override
  String get letsGo => 'Let\'s go';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get onboardingHello => 'Hello! 👋';

  @override
  String get onboardingNameSub => 'Let\'s get to know you. What\'s your name?';

  @override
  String get onboardingNameHint => 'Type your name...';

  @override
  String get onboardingNameRequired => 'Please enter your name';

  @override
  String get onboardingBody => 'Know your body';

  @override
  String get onboardingBodySub => 'Let\'s calculate your calorie goal.';

  @override
  String get onboardingGoal => 'What\'s your goal?';

  @override
  String get onboardingGoalSub => 'We\'ll set your calorie target accordingly.';

  @override
  String get onboardingTheme => 'Appearance';

  @override
  String get onboardingThemeSub => 'You can change this later.';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get age => 'Age';

  @override
  String get height => 'Height';

  @override
  String get weight => 'Weight';

  @override
  String get ageUnit => 'yrs';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Lose weight';

  @override
  String get goalLoseSub => 'Slow and steady with a calorie deficit';

  @override
  String get goalMaintain => 'Maintain weight';

  @override
  String get goalMaintainSub => 'Balanced and healthy eating';

  @override
  String get goalGain => 'Gain weight';

  @override
  String get goalGainSub => 'Build muscle mass';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String greeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get defaultName => 'there';

  @override
  String get caloriestoday => 'Calories today';

  @override
  String get todaysMeals => 'Today\'s meals';

  @override
  String get noMeals =>
      'No meals logged yet.\nTap the camera to scan your first meal!';

  @override
  String get protein => 'Protein';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Fat';

  @override
  String get water => 'Water';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get analyzingSub => 'AI is calculating your nutrients';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get home => 'Home';

  @override
  String get scan => 'Scan';

  @override
  String get progress => 'Progress';

  @override
  String get profile => 'Profile';

  @override
  String get weeklyCalories => 'Weekly Calories';

  @override
  String get macroBreakdown => 'Macro Breakdown';

  @override
  String get avgCalories => 'Avg. Calories';

  @override
  String get totalScans => 'Total Scans';

  @override
  String get thisWeek => 'This Week';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit';

  @override
  String get calorieGoal => 'Calorie Goal';

  @override
  String get language => 'Language';

  @override
  String get appearance => 'Appearance';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Unlimited scans & features';

  @override
  String get waterAdd => 'Add water';

  @override
  String get waterGoal => 'Water Goal';

  @override
  String waterGlasses(int count) {
    return '$count glasses';
  }

  @override
  String get limitReached => 'Daily limit reached';

  @override
  String get limitReachedSub =>
      'You\'ve used 5 free scans today.\nScan unlimited with eatiq Pro.';

  @override
  String get unlimitedScans => 'Unlimited AI scans';

  @override
  String get unlimitedHistory => 'Unlimited history';

  @override
  String get weeklyReport => 'Weekly AI report';

  @override
  String get turkishDB => 'Turkish food database';

  @override
  String get goProBtn => 'Go Pro — ₺149/mo';

  @override
  String get yearlyDiscount => 'Save 44% with ₺999/year';

  @override
  String minutesAgo(int min) {
    return '${min}m ago';
  }

  @override
  String hoursAgo(int hr) {
    return '${hr}h ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get monday => 'Mon';

  @override
  String get tuesday => 'Tue';

  @override
  String get wednesday => 'Wed';

  @override
  String get thursday => 'Thu';

  @override
  String get friday => 'Fri';

  @override
  String get saturday => 'Sat';

  @override
  String get sunday => 'Sun';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String get settings => 'Settings';

  @override
  String get unitSystem => 'Unit System';

  @override
  String get reminders => 'Reminders';

  @override
  String get notifications => 'Notifications';

  @override
  String get dailyCalorieGoal => 'Daily Calorie Goal';

  @override
  String get calorieRange => 'Between 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get manual => 'Manual';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get detectedIngredients => 'Detected ingredients';

  @override
  String get addedToLog => 'Added to Log ✓';

  @override
  String get backToHome => 'OK, Back to Home';

  @override
  String get mealAutoSaved => 'Meal saved automatically.';

  @override
  String get historyTitle => 'History';

  @override
  String get noScansYet => 'No scans yet';

  @override
  String get scanFirstMeal => 'Scan your first meal!';

  @override
  String scanCount(int count) {
    return '$count scans';
  }

  @override
  String get bodyAnalysis => 'Body Analysis';

  @override
  String get idealWeight => 'Ideal Weight';

  @override
  String get gender => 'Gender';

  @override
  String get goalLabel => 'Goal';

  @override
  String get basalMetabolicRate => 'Basal Metabolic Rate';

  @override
  String get dailyNeeds => 'Daily Target';

  @override
  String get bodyInfo => 'Body Info';

  @override
  String get mealNameLabel => 'Meal Name';

  @override
  String get categoryLabel => 'Category';

  @override
  String get portionWeightLabel => 'Portion Weight (g) — optional';

  @override
  String get portionHint => 'If entered, macros will be validated';

  @override
  String get macrosLabel => 'Macros (g) — optional';

  @override
  String get editMeal => 'Edit Meal';

  @override
  String get addManualMeal => 'Add Meal Manually';

  @override
  String get update => 'Update';

  @override
  String get bmiLabel => 'BMI';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiNormal => 'Ideal Weight';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObese => 'Obese';

  @override
  String get bmiMorbidObese => 'Severely Obese';

  @override
  String get bmiUnderweightDesc => 'Slightly below your ideal weight';

  @override
  String get bmiNormalDesc => 'Great! You\'re in a healthy weight range 🎯';

  @override
  String get bmiOverweightDesc => 'Slightly above a healthy weight';

  @override
  String get bmiObeseDesc => 'We recommend losing weight for your health';

  @override
  String get bmiMorbidObeseDesc => 'Please consult a healthcare professional';

  @override
  String get addMeal => '+ Add';

  @override
  String get favorites => 'FAVORITES';

  @override
  String get addMealShort => '+ Add';

  @override
  String get mealFallback => 'Meal';

  @override
  String get month01 => 'Jan';

  @override
  String get month02 => 'Feb';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Apr';

  @override
  String get month05 => 'May';

  @override
  String get month06 => 'Jun';

  @override
  String get month07 => 'Jul';

  @override
  String get month08 => 'Aug';

  @override
  String get month09 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dec';

  @override
  String get validRequired => 'Required field';

  @override
  String get validNumber => 'Enter a valid number';

  @override
  String get validPositive => 'Must be greater than zero';

  @override
  String get validNegative => 'Cannot be negative';

  @override
  String get validPortionRange => 'Must be between 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro cannot exceed 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro cannot exceed portion weight (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'Total macros (${total}g) exceeds portion weight';
  }

  @override
  String get validCalRequired => 'Calories required';

  @override
  String get validCalMax => 'Single meal cannot exceed 5000 kcal';

  @override
  String validCalInconsistent(String estimated) {
    return 'Inconsistent with macros (estimated ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'e.g. Oatmeal, Chicken...';

  @override
  String get hintCalories => 'e.g. 350';

  @override
  String get hintPortion => 'e.g. 200';

  @override
  String get hintProtein => 'Protein';

  @override
  String get hintCarbs => 'Carbs';

  @override
  String get hintFat => 'Fat';

  @override
  String get unitMetric => 'Metric';

  @override
  String get unitImperial => 'Imperial';

  @override
  String get userFallback => 'You';

  @override
  String get mealNameRequired => 'Meal name required';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'Sync meals & water';

  @override
  String get appleHealthDenied =>
      'Apple Health permission denied. Please open Settings and allow access under Privacy → Health → Eatiq.';

  @override
  String get goToSettings => 'Open Settings';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHint => 'Align the barcode within the frame';

  @override
  String get barcodeSearching => 'Looking up product...';

  @override
  String get barcodeNotFound => 'Product not found. Try manual entry.';

  @override
  String get noWeightData => 'No weight data yet.';

  @override
  String get noWeightDataHint => 'Log your weight to see your progress here.';

  @override
  String streakDays(int count) {
    return '$count Day Streak';
  }

  @override
  String get streakMotivation => 'Log every day to keep your streak!';

  @override
  String get streakMilestone7 => '1 week streak! Keep it up. 🎉';

  @override
  String get streakMilestone30 => '1 month streak! Incredible! 🏆';

  @override
  String get activityLevel => 'How active are you?';

  @override
  String get activityLevelSub => 'Select your daily activity level';

  @override
  String get activitySedentary => 'Sedentary';

  @override
  String get activitySedentarySub => 'Little or no exercise';

  @override
  String get activityLight => 'Lightly Active';

  @override
  String get activityLightSub => 'Light exercise 1-3 days/week';

  @override
  String get activityActive => 'Active';

  @override
  String get activityActiveSub => 'Moderate exercise 3-5 days/week';

  @override
  String get activityVery => 'Very Active';

  @override
  String get activityVerySub => 'Heavy exercise 6-7 days/week';

  @override
  String get onboardingSummaryTitle => 'You\'re set! 🎉';

  @override
  String get onboardingSummarySub => 'Here is your daily personalized goal.';

  @override
  String get onboardingRecommend => 'Recommended Daily Calories';

  @override
  String get onboardingGender => 'What is your gender?';

  @override
  String get onboardingGenderSub => 'Used to calculate your metabolic rate.';

  @override
  String get onboardingAge => 'How old are you?';

  @override
  String get onboardingAgeSub => 'Used to calculate your metabolic rate.';

  @override
  String get onboardingHeightWeight => 'Height & Weight';

  @override
  String get onboardingHeightWeightSub =>
      'Required for BMI and daily calories.';

  @override
  String get waterToday => 'Today\'s Water';

  @override
  String get reset => 'Reset';

  @override
  String get confirmDelete => 'All data will be reset. Are you sure?';

  @override
  String get dailySummaryTitle => 'Daily Summary 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Today you\'ve consumed $cal/$goal kcal and ${water}L water. Great job!';
  }

  @override
  String get goalAchievement => 'Goal Achievement';

  @override
  String get consistency => 'Consistency';

  @override
  String get topDay => 'Top Day';

  @override
  String get avgWater => 'Avg Water';

  @override
  String get weeklyInsight => 'Weekly Analysis';

  @override
  String get monthlyInsight => 'Monthly Analysis';

  @override
  String get mostConsumedMeal => 'Top Meal';

  @override
  String get splashTitle => 'Calorie tracking made easy';

  @override
  String get onboardingBirthDate => 'Date of Birth';

  @override
  String get onboardingBirthDateSub =>
      'We\'ll calculate your metabolic rate based on your age';

  @override
  String get onboardingTargetWeight => 'What\'s your target weight?';

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
      'We\'ll calculate your ideal macro ratios';

  @override
  String get onboardingAllergiesTitle => 'Allergies & Restrictions';

  @override
  String get onboardingAllergiesSub => 'We\'ll warn you when a food conflicts';

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
      'We\'ll send you reminders to help reach your goals';

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
  String get navDaily => 'Daily';

  @override
  String get navProgram => 'Program';

  @override
  String get stepsToday => 'Steps';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'burned';

  @override
  String get thirtyDays => '30 Days';

  @override
  String get avgPerDay => 'avg / day';

  @override
  String get mealsLoggedLabel => 'meals logged';

  @override
  String get caloriesChartTitle => 'Calories';

  @override
  String get noDataYet => 'No data yet';

  @override
  String get recentLogs => 'Recent Logs';

  @override
  String get currentLabel => 'current';

  @override
  String get targetLabel => 'target';

  @override
  String get noGoalSet => 'No goal set';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return '$remaining kcal remaining · goal $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit lost';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit gained';
  }

  @override
  String get weightStable => 'Stable weight';

  @override
  String get foodSearch => 'Food Search';

  @override
  String get searchFoodsHint => 'Search foods...';

  @override
  String get noFoodsFound => 'No foods found';

  @override
  String get addToLog => 'Add to Log';

  @override
  String foodAddedToLog(String name) {
    return '$name added to log';
  }

  @override
  String portionGrams(String grams) {
    return 'Portion: $grams g';
  }

  @override
  String foodCount(int count) {
    return '$count foods';
  }

  @override
  String get categoryAll => 'All';

  @override
  String get categoryDairy => 'Dairy';

  @override
  String get categoryFruit => 'Fruit';

  @override
  String get categoryFats => 'Fats';

  @override
  String get categoryVegetables => 'Vegetables';

  @override
  String get categoryFastFood => 'Fast Food';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get aiDietitian => 'AI Dietitian';

  @override
  String get aiPoweredBy => 'Powered by eatiq AI';

  @override
  String get onlineLabel => 'Online';

  @override
  String get askNutritionHint => 'Ask about nutrition...';

  @override
  String get quickPromptProtein => 'How much protein do I need?';

  @override
  String get quickPromptFatLoss => 'Best foods for fat loss?';

  @override
  String get quickPromptCalories => 'Should I count calories?';

  @override
  String get quickPromptMealPrep => 'Meal prep tips?';

  @override
  String get aiGreeting =>
      'Hi! I\'m your AI Dietitian powered by eatiq. Ask me anything about nutrition, meal planning, or how to reach your health goals. 🥗';

  @override
  String get signInToEatiq => 'Sign in to eatiq';

  @override
  String get signInSubtitle =>
      'Sync your progress across devices and unlock personalised nutrition insights.';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithoutSignIn => 'Continue without signing in';

  @override
  String get legalAgreementNote =>
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get subscriptionLegal => 'Subscription & Legal';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get searchLabel => 'Search';

  @override
  String get dietitianLabel => 'Dietitian';

  @override
  String get targetWeight => 'Target Weight';

  @override
  String goalHitBadge(String pct) {
    return 'Goal $pct% hit';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% consistent';
  }

  @override
  String get waterAdd250 => '+250 ml';

  @override
  String get waterAdd500 => '+500 ml';

  @override
  String get waterAdd700 => '+700 ml';

  @override
  String get aiNote => 'AI Note';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get avgWaterLabel => 'Avg Water';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get carbsLabel => 'Carbs';

  @override
  String get consistencyLabel => 'Consistency';

  @override
  String get cookingTime => 'Cooking Time';

  @override
  String get cuisinePreferences => 'Cuisine Preferences';

  @override
  String get dietitianNav => 'Dietitian';

  @override
  String get editPreferences => 'Edit Preferences';

  @override
  String get fatLabel => 'Fat';

  @override
  String get foodRestrictions => 'Food Restrictions';

  @override
  String get foodDislikesHint =>
      'Food dislikes, allergies, or special requests...';

  @override
  String get goalAchievementLabel => 'Goal Achievement';

  @override
  String get groceryBudget => 'Grocery Budget';

  @override
  String get mealsPerDay => 'Meals Per Day';

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get regeneratePlan => 'Regenerate Plan';

  @override
  String get sharePlan => 'Share Plan';

  @override
  String get thisWeekLabel => 'This Week';

  @override
  String get topMealLabel => 'Top Meal';

  @override
  String get waterLabel => 'Water';

  @override
  String get weightLabel => 'Weight';

  @override
  String get yearlyLabel => 'Yearly';

  @override
  String get solidFood => '🍽️  Solid Food';

  @override
  String get askNutritionHint2 => 'Ask about nutrition...';

  @override
  String get continueWithApple2 => 'Continue with Apple';

  @override
  String get continueWithGoogle2 => 'Continue with Google';

  @override
  String get searchLabel2 => 'Search';

  @override
  String get searchFoodsHint2 => 'Search foods...';
}
