// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Mach ein Foto. Wisse, was du isst.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get alreadyHaveAccount => 'Hast du schon ein Konto?';

  @override
  String get signIn => 'Anmelden';

  @override
  String get skip => 'Überspringen';

  @override
  String get continueBtn => 'Weiter';

  @override
  String get letsGo => 'Los geht\'s';

  @override
  String get back => 'Zurück';

  @override
  String get save => 'Speichern';

  @override
  String get done => 'Fertig';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get onboardingHello => 'Hallo! 👋';

  @override
  String get onboardingNameSub => 'Lernen wir uns kennen. Wie heißt du?';

  @override
  String get onboardingNameHint => 'Deinen Namen eingeben...';

  @override
  String get onboardingNameRequired => 'Bitte gib deinen Namen ein';

  @override
  String get onboardingBody => 'Kenne deinen Körper';

  @override
  String get onboardingBodySub => 'Berechnen wir dein Kalorienziel.';

  @override
  String get onboardingGoal => 'Was ist dein Ziel?';

  @override
  String get onboardingGoalSub =>
      'Wir passen dein Kalorienziel entsprechend an.';

  @override
  String get onboardingTheme => 'Erscheinungsbild';

  @override
  String get onboardingThemeSub => 'Du kannst das später ändern.';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get age => 'Alter';

  @override
  String get height => 'Größe';

  @override
  String get weight => 'Gewicht';

  @override
  String get ageUnit => 'J.';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Abnehmen';

  @override
  String get goalLoseSub => 'Langsam mit Kaloriendefizit';

  @override
  String get goalMaintain => 'Gewicht halten';

  @override
  String get goalMaintainSub => 'Ausgewogene und gesunde Ernährung';

  @override
  String get goalGain => 'Zunehmen';

  @override
  String get goalGainSub => 'Muskelmasse aufbauen';

  @override
  String get dark => 'Dunkel';

  @override
  String get light => 'Hell';

  @override
  String greeting(String name) {
    return 'Hallo, $name';
  }

  @override
  String get defaultName => 'du';

  @override
  String get caloriestoday => 'Kalorien heute';

  @override
  String get todaysMeals => 'Heutige Mahlzeiten';

  @override
  String get noMeals =>
      'Noch keine Mahlzeiten.\nTippe die Kamera, um deine erste Mahlzeit zu scannen!';

  @override
  String get protein => 'Eiweiß';

  @override
  String get carbs => 'Kohlenhydrate';

  @override
  String get fat => 'Fett';

  @override
  String get water => 'Wasser';

  @override
  String get analyzing => 'Analysiere...';

  @override
  String get analyzingSub => 'KI berechnet deine Nährstoffe';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String get home => 'Startseite';

  @override
  String get scan => 'Scannen';

  @override
  String get progress => 'Fortschritt';

  @override
  String get profile => 'Profil';

  @override
  String get weeklyCalories => 'Wöchentliche Kalorien';

  @override
  String get macroBreakdown => 'Makro-Aufschlüsselung';

  @override
  String get avgCalories => 'Ø Kalorien';

  @override
  String get totalScans => 'Gesamt-Scans';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfile => 'Bearbeiten';

  @override
  String get calorieGoal => 'Kalorienziel';

  @override
  String get language => 'Sprache';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Unbegrenzte Scans & Funktionen';

  @override
  String get waterAdd => 'Wasser hinzufügen';

  @override
  String get waterGoal => 'Wasserзiel';

  @override
  String waterGlasses(int count) {
    return '$count Gläser';
  }

  @override
  String get limitReached => 'Tageslimit erreicht';

  @override
  String get limitReachedSub =>
      'Du hast heute 5 kostenlose Scans verwendet.\nScanne unbegrenzt mit eatiq Pro.';

  @override
  String get unlimitedScans => 'Unbegrenzte KI-Scans';

  @override
  String get unlimitedHistory => 'Unbegrenzte Historie';

  @override
  String get weeklyReport => 'Wöchentlicher KI-Bericht';

  @override
  String get turkishDB => 'Türkische Lebensmitteldatenbank';

  @override
  String get goProBtn => 'Pro werden — ₺149/Monat';

  @override
  String get yearlyDiscount => '44% sparen mit ₺999/Jahr';

  @override
  String minutesAgo(int min) {
    return 'vor $min Min.';
  }

  @override
  String hoursAgo(int hr) {
    return 'vor $hr Std.';
  }

  @override
  String daysAgo(int count) {
    return 'Vor $count Tagen';
  }

  @override
  String get monday => 'Mo';

  @override
  String get tuesday => 'Di';

  @override
  String get wednesday => 'Mi';

  @override
  String get thursday => 'Do';

  @override
  String get friday => 'Fr';

  @override
  String get saturday => 'Sa';

  @override
  String get sunday => 'So';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get retry => 'Nochmal versuchen';

  @override
  String get mealBreakfast => 'Frühstück';

  @override
  String get mealLunch => 'Mittagessen';

  @override
  String get mealDinner => 'Abendessen';

  @override
  String get mealSnack => 'Snack';

  @override
  String get settings => 'Einstellungen';

  @override
  String get unitSystem => 'Maßsystem';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get dailyCalorieGoal => 'Tägliches Kalorienziel';

  @override
  String get calorieRange => 'Zwischen 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get manual => 'Manuell';

  @override
  String get analysisResult => 'Analyseergebnis';

  @override
  String get detectedIngredients => 'Erkannte Zutaten';

  @override
  String get addedToLog => 'Zum Tagebuch hinzugefügt ✓';

  @override
  String get backToHome => 'OK, Zurück zur Startseite';

  @override
  String get mealAutoSaved => 'Mahlzeit automatisch gespeichert.';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get noScansYet => 'Noch keine Scans';

  @override
  String get scanFirstMeal => 'Scanne deine erste Mahlzeit!';

  @override
  String scanCount(int count) {
    return '$count Scans';
  }

  @override
  String get bodyAnalysis => 'Körperanalyse';

  @override
  String get idealWeight => 'Idealgewicht';

  @override
  String get gender => 'Geschlecht';

  @override
  String get goalLabel => 'Ziel';

  @override
  String get basalMetabolicRate => 'Grundumsatz';

  @override
  String get dailyNeeds => 'Tagesziel';

  @override
  String get bodyInfo => 'Körperinformationen';

  @override
  String get mealNameLabel => 'Mahlzeitenname';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get portionWeightLabel => 'Portionsgewicht (g) — optional';

  @override
  String get portionHint => 'Bei Eingabe werden Makros überprüft';

  @override
  String get macrosLabel => 'Makros (g) — optional';

  @override
  String get editMeal => 'Mahlzeit bearbeiten';

  @override
  String get addManualMeal => 'Mahlzeit manuell hinzufügen';

  @override
  String get update => 'Aktualisieren';

  @override
  String get bmiLabel => 'BMI';

  @override
  String get bmiUnderweight => 'Untergewicht';

  @override
  String get bmiNormal => 'Idealgewicht';

  @override
  String get bmiOverweight => 'Übergewicht';

  @override
  String get bmiObese => 'Fettleibigkeit';

  @override
  String get bmiMorbidObese => 'Starke Fettleibigkeit';

  @override
  String get bmiUnderweightDesc => 'Leicht unter deinem Idealgewicht';

  @override
  String get bmiNormalDesc => 'Super! Du bist im gesunden Gewichtsbereich 🎯';

  @override
  String get bmiOverweightDesc => 'Leicht über dem gesunden Gewicht';

  @override
  String get bmiObeseDesc =>
      'Wir empfehlen dir, für deine Gesundheit Gewicht zu verlieren';

  @override
  String get bmiMorbidObeseDesc => 'Bitte konsultiere einen Arzt';

  @override
  String get addMeal => '+ Hinzufügen';

  @override
  String get favorites => 'FAVORITEN';

  @override
  String get addMealShort => '+ Hinzufügen';

  @override
  String get mealFallback => 'Mahlzeit';

  @override
  String get month01 => 'Jan';

  @override
  String get month02 => 'Feb';

  @override
  String get month03 => 'Mär';

  @override
  String get month04 => 'Apr';

  @override
  String get month05 => 'Mai';

  @override
  String get month06 => 'Jun';

  @override
  String get month07 => 'Jul';

  @override
  String get month08 => 'Aug';

  @override
  String get month09 => 'Sep';

  @override
  String get month10 => 'Okt';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dez';

  @override
  String get validRequired => 'Pflichtfeld';

  @override
  String get validNumber => 'Gültige Zahl eingeben';

  @override
  String get validPositive => 'Muss größer als null sein';

  @override
  String get validNegative => 'Darf nicht negativ sein';

  @override
  String get validPortionRange => 'Muss zwischen 1–5000g liegen';

  @override
  String validMacroMax(String macro) {
    return '$macro darf 1000g nicht überschreiten';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro darf das Portionsgewicht (${portion}g) nicht überschreiten';
  }

  @override
  String validMacroTotal(String total) {
    return 'Gesamte Makros (${total}g) überschreiten das Portionsgewicht';
  }

  @override
  String get validCalRequired => 'Kalorien erforderlich';

  @override
  String get validCalMax =>
      'Eine einzelne Mahlzeit darf 5000 kcal nicht überschreiten';

  @override
  String validCalInconsistent(String estimated) {
    return 'Inkonsistent mit Makros (geschätzt ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'z.B. Haferflocken, Hähnchen...';

  @override
  String get hintCalories => 'z.B. 350';

  @override
  String get hintPortion => 'z.B. 200';

  @override
  String get hintProtein => 'Eiweiß';

  @override
  String get hintCarbs => 'Kohlenhydrate';

  @override
  String get hintFat => 'Fett';

  @override
  String get unitMetric => 'Metrisch';

  @override
  String get unitImperial => 'Imperial';

  @override
  String get userFallback => 'Du';

  @override
  String get mealNameRequired => 'Mahlzeitenname erforderlich';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'Mahlzeiten & Wasser synchronisieren';

  @override
  String get appleHealthDenied =>
      'Apple Health-Berechtigung verweigert. Öffne Einstellungen → Datenschutz → Health → Eatiq.';

  @override
  String get goToSettings => 'Einstellungen öffnen';

  @override
  String get barcode => 'Barcode';

  @override
  String get barcodeHint => 'Barcode im Rahmen ausrichten';

  @override
  String get barcodeSearching => 'Produkt wird gesucht...';

  @override
  String get barcodeNotFound =>
      'Produkt nicht gefunden. Manuelle Eingabe versuchen.';

  @override
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

  @override
  String streakDays(int count) {
    return '$count Tage in Folge';
  }

  @override
  String get streakMotivation => 'Täglich loggen, um den Streak zu halten!';

  @override
  String get streakMilestone7 => '1 Woche am Stück! Weiter so. 🎉';

  @override
  String get streakMilestone30 => '1 Monat! Unglaublich! 🏆';

  @override
  String get activityLevel => 'Wie aktiv bist du?';

  @override
  String get activityLevelSub => 'Wähle dein tägliches Aktivitätslevel';

  @override
  String get activitySedentary => 'Sitzend';

  @override
  String get activitySedentarySub => 'Kaum oder keine Bewegung';

  @override
  String get activityLight => 'Leicht aktiv';

  @override
  String get activityLightSub => '1-3 Tage/Woche leichtes Training';

  @override
  String get activityActive => 'Aktiv';

  @override
  String get activityActiveSub => '3-5 Tage/Woche moderates Training';

  @override
  String get activityVery => 'Sehr aktiv';

  @override
  String get activityVerySub => '6-7 Tage/Woche hartes Training';

  @override
  String get onboardingSummaryTitle => 'Fertig! 🎉';

  @override
  String get onboardingSummarySub => 'Hier ist dein tägliches Ziel.';

  @override
  String get onboardingRecommend => 'Empfohlene tägliche Kalorien';

  @override
  String get onboardingGender => 'Was ist dein Geschlecht?';

  @override
  String get onboardingGenderSub =>
      'Wird zur Berechnung der Stoffwechselrate benötigt.';

  @override
  String get onboardingAge => 'Wie alt bist du?';

  @override
  String get onboardingAgeSub =>
      'Wird zur Berechnung der Stoffwechselrate benötigt.';

  @override
  String get onboardingHeightWeight => 'Größe & Gewicht';

  @override
  String get onboardingHeightWeightSub =>
      'Erforderlich für BMI und Tageskalorien.';

  @override
  String get waterToday => 'Wasser heute';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get confirmDelete =>
      'Alle Daten werden zurückgesetzt. Bist du sicher?';

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
  String get navDaily => 'Günlük';

  @override
  String get navProgram => 'Program';

  @override
  String get stepsToday => 'Adım';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'yakıldı';
}
