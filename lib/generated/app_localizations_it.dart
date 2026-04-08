// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Scatta una foto. Scopri cosa mangi.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get alreadyHaveAccount => 'Hai già un account?';

  @override
  String get signIn => 'Accedi';

  @override
  String get skip => 'Salta';

  @override
  String get continueBtn => 'Continua';

  @override
  String get letsGo => 'Cominciamo';

  @override
  String get back => 'Indietro';

  @override
  String get save => 'Salva';

  @override
  String get done => 'Ok';

  @override
  String get cancel => 'Annulla';

  @override
  String get onboardingHello => 'Ciao! 👋';

  @override
  String get onboardingNameSub => 'Facciamo conoscenza. Come ti chiami?';

  @override
  String get onboardingNameHint => 'Scrivi il tuo nome...';

  @override
  String get onboardingNameRequired => 'Inserisci il tuo nome';

  @override
  String get onboardingBody => 'Conosci il tuo corpo';

  @override
  String get onboardingBodySub => 'Calcoliamo il tuo obiettivo calorico.';

  @override
  String get onboardingGoal => 'Qual è il tuo obiettivo?';

  @override
  String get onboardingGoalSub =>
      'Regoleremo il tuo obiettivo calorico di conseguenza.';

  @override
  String get onboardingTheme => 'Aspetto';

  @override
  String get onboardingThemeSub => 'Puoi cambiarlo in seguito.';

  @override
  String get male => 'Maschio';

  @override
  String get female => 'Femmina';

  @override
  String get age => 'Età';

  @override
  String get height => 'Altezza';

  @override
  String get weight => 'Peso';

  @override
  String get ageUnit => 'anni';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Perdere peso';

  @override
  String get goalLoseSub => 'Con un deficit calorico graduale';

  @override
  String get goalMaintain => 'Mantenere il peso';

  @override
  String get goalMaintainSub => 'Alimentazione equilibrata e sana';

  @override
  String get goalGain => 'Aumentare peso';

  @override
  String get goalGainSub => 'Guadagnare massa muscolare';

  @override
  String get dark => 'Scuro';

  @override
  String get light => 'Chiaro';

  @override
  String greeting(String name) {
    return 'Ciao, $name';
  }

  @override
  String get defaultName => 'Tu';

  @override
  String get caloriestoday => 'Calorie di oggi';

  @override
  String get todaysMeals => 'Pasti di oggi';

  @override
  String get noMeals =>
      'Nessun pasto aggiunto.\nApri la fotocamera e scansiona il primo pasto!';

  @override
  String get protein => 'Proteine';

  @override
  String get carbs => 'Carb';

  @override
  String get fat => 'Grassi';

  @override
  String get water => 'Acqua';

  @override
  String get analyzing => 'Analisi in corso...';

  @override
  String get analyzingSub => 'L\'IA sta calcolando i valori nutrizionali';

  @override
  String get camera => 'Fotocamera';

  @override
  String get gallery => 'Galleria';

  @override
  String get home => 'Home';

  @override
  String get scan => 'Scansiona';

  @override
  String get progress => 'Progressi';

  @override
  String get profile => 'Profilo';

  @override
  String get weeklyCalories => 'Calorie Settimanali';

  @override
  String get macroBreakdown => 'Distribuzione Macro';

  @override
  String get avgCalories => 'Media Calorie';

  @override
  String get totalScans => 'Scansioni Totali';

  @override
  String get thisWeek => 'Questa Settimana';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get editProfile => 'Modifica';

  @override
  String get calorieGoal => 'Obiettivo Calorico';

  @override
  String get language => 'Lingua';

  @override
  String get appearance => 'Aspetto';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Scansioni illimitate e funzionalità';

  @override
  String get waterAdd => 'Aggiungi acqua';

  @override
  String get waterGoal => 'Obiettivo acqua';

  @override
  String waterGlasses(int count) {
    return '$count bicchieri';
  }

  @override
  String get limitReached => 'Limite giornaliero raggiunto';

  @override
  String get limitReachedSub =>
      'Hai usato 5 scansioni gratuite oggi.\nScansiona illimitatamente con eatiq Pro.';

  @override
  String get unlimitedScans => 'Scansioni IA illimitate';

  @override
  String get unlimitedHistory => 'Cronologia illimitata';

  @override
  String get weeklyReport => 'Report settimanale con IA';

  @override
  String get turkishDB => 'Database cucina turca';

  @override
  String get goProBtn => 'Pro — Abbonati ora';

  @override
  String get yearlyDiscount => 'Risparmia il 44% con il piano annuale';

  @override
  String minutesAgo(int min) {
    return '$min min fa';
  }

  @override
  String hoursAgo(int hr) {
    return '$hr h fa';
  }

  @override
  String daysAgo(int count) {
    return '$count giorni fa';
  }

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Gio';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sab';

  @override
  String get sunday => 'Dom';

  @override
  String get errorGeneric => 'Si è verificato un errore';

  @override
  String get retry => 'Riprova';

  @override
  String get mealBreakfast => 'Colazione';

  @override
  String get mealLunch => 'Pranzo';

  @override
  String get mealDinner => 'Cena';

  @override
  String get mealSnack => 'Spuntino';

  @override
  String get settings => 'Impostazioni';

  @override
  String get unitSystem => 'Sistema di unità';

  @override
  String get reminders => 'Promemoria';

  @override
  String get notifications => 'Notifiche';

  @override
  String get dailyCalorieGoal => 'Obiettivo calorico giornaliero';

  @override
  String get calorieRange => 'Tra 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get manual => 'Manuale';

  @override
  String get analysisResult => 'Risultato analisi';

  @override
  String get detectedIngredients => 'Ingredienti rilevati';

  @override
  String get addedToLog => 'Aggiunto al diario ✓';

  @override
  String get backToHome => 'OK, Torna alla Home';

  @override
  String get mealAutoSaved => 'Pasto salvato automaticamente.';

  @override
  String get historyTitle => 'Cronologia';

  @override
  String get noScansYet => 'Nessuna scansione ancora';

  @override
  String get scanFirstMeal => 'Scansiona il tuo primo pasto!';

  @override
  String scanCount(int count) {
    return '$count scansioni';
  }

  @override
  String get bodyAnalysis => 'Analisi corporea';

  @override
  String get idealWeight => 'Peso ideale';

  @override
  String get gender => 'Sesso';

  @override
  String get goalLabel => 'Obiettivo';

  @override
  String get basalMetabolicRate => 'Metabolismo basale';

  @override
  String get dailyNeeds => 'Obiettivo giornaliero';

  @override
  String get bodyInfo => 'Informazioni corporee';

  @override
  String get mealNameLabel => 'Nome del pasto';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get portionWeightLabel => 'Peso porzione (g) — opzionale';

  @override
  String get portionHint => 'Se inserito, i macros verranno validati';

  @override
  String get macrosLabel => 'Macros (g) — opzionale';

  @override
  String get editMeal => 'Modifica pasto';

  @override
  String get addManualMeal => 'Aggiungi pasto manualmente';

  @override
  String get update => 'Aggiorna';

  @override
  String get bmiLabel => 'IMC';

  @override
  String get bmiUnderweight => 'Sottopeso';

  @override
  String get bmiNormal => 'Peso ideale';

  @override
  String get bmiOverweight => 'Sovrappeso';

  @override
  String get bmiObese => 'Obesità';

  @override
  String get bmiMorbidObese => 'Obesità grave';

  @override
  String get bmiUnderweightDesc => 'Leggermente sotto il tuo peso ideale';

  @override
  String get bmiNormalDesc => 'Ottimo! Sei in un range di peso sano 🎯';

  @override
  String get bmiOverweightDesc => 'Leggermente sopra il peso sano';

  @override
  String get bmiObeseDesc => 'Ti consigliamo di perdere peso per la tua salute';

  @override
  String get bmiMorbidObeseDesc => 'Si prega di consultare un medico';

  @override
  String get addMeal => '+ Aggiungi';

  @override
  String get favorites => 'PREFERITI';

  @override
  String get addMealShort => '+ Aggiungi';

  @override
  String get mealFallback => 'Pasto';

  @override
  String get month01 => 'Gen';

  @override
  String get month02 => 'Feb';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Apr';

  @override
  String get month05 => 'Mag';

  @override
  String get month06 => 'Giu';

  @override
  String get month07 => 'Lug';

  @override
  String get month08 => 'Ago';

  @override
  String get month09 => 'Set';

  @override
  String get month10 => 'Ott';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dic';

  @override
  String get validRequired => 'Campo obbligatorio';

  @override
  String get validNumber => 'Inserire un numero valido';

  @override
  String get validPositive => 'Deve essere maggiore di zero';

  @override
  String get validNegative => 'Non può essere negativo';

  @override
  String get validPortionRange => 'Deve essere tra 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro non può superare 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro non può superare il peso della porzione (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'I macronutrienti totali (${total}g) superano il peso della porzione';
  }

  @override
  String get validCalRequired => 'Calorie obbligatorie';

  @override
  String get validCalMax => 'Un singolo pasto non può superare 5000 kcal';

  @override
  String validCalInconsistent(String estimated) {
    return 'Incoerente con i macronutrienti (stimato ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'es. Avena, Pollo...';

  @override
  String get hintCalories => 'es. 350';

  @override
  String get hintPortion => 'es. 200';

  @override
  String get hintProtein => 'Proteine';

  @override
  String get hintCarbs => 'Carboidrati';

  @override
  String get hintFat => 'Grassi';

  @override
  String get unitMetric => 'Metrico';

  @override
  String get unitImperial => 'Imperiale';

  @override
  String get userFallback => 'Tu';

  @override
  String get mealNameRequired => 'Nome del pasto obbligatorio';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get appleHealth => 'Apple Salute';

  @override
  String get appleHealthSub => 'Sincronizza pasti e acqua';

  @override
  String get appleHealthDenied =>
      'Autorizzazione Apple Salute negata. Apri Impostazioni → Privacy → Salute → Eatiq.';

  @override
  String get goToSettings => 'Apri Impostazioni';

  @override
  String get barcode => 'Codice a barre';

  @override
  String get barcodeHint => 'Allinea il codice a barre nel riquadro';

  @override
  String get barcodeSearching => 'Ricerca prodotto...';

  @override
  String get barcodeNotFound =>
      'Prodotto non trovato. Prova inserimento manuale.';

  @override
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

  @override
  String streakDays(int count) {
    return '$count Giorni consecutivi';
  }

  @override
  String get streakMotivation => 'Registra ogni giorno!';

  @override
  String get streakMilestone7 => '1 settimana di fila! Continua così. 🎉';

  @override
  String get streakMilestone30 => '1 mese di fila! Incredibile! 🏆';

  @override
  String get activityLevel => 'Quanto sei attivo?';

  @override
  String get activityLevelSub =>
      'Seleziona il tuo livello di attività quotidiana';

  @override
  String get activitySedentary => 'Sedentario';

  @override
  String get activitySedentarySub => 'Poco o nessun esercizio';

  @override
  String get activityLight => 'Leggermente attivo';

  @override
  String get activityLightSub => 'Esercizio leggero 1-3 giorni/settimana';

  @override
  String get activityActive => 'Attivo';

  @override
  String get activityActiveSub => 'Esercizio moderato 3-5 giorni/settimana';

  @override
  String get activityVery => 'Molto attivo';

  @override
  String get activityVerySub => 'Esercizio intenso 6-7 giorni/settimana';

  @override
  String get onboardingSummaryTitle => 'Ci sei quasi! 🎉';

  @override
  String get onboardingSummarySub =>
      'Ecco il tuo obiettivo giornaliero personalizzato.';

  @override
  String get onboardingRecommend => 'Calorie giornaliere raccomandate';

  @override
  String get onboardingGender => 'Qual è il tuo sesso?';

  @override
  String get onboardingGenderSub => 'Usato per calcolare il tuo metabolismo.';

  @override
  String get onboardingAge => 'Quanti anni hai?';

  @override
  String get onboardingAgeSub => 'Usato per calcolare il tuo metabolismo.';

  @override
  String get onboardingHeightWeight => 'Altezza e Peso';

  @override
  String get onboardingHeightWeightSub => 'Necessario per BMI e calorie.';

  @override
  String get waterToday => 'Acqua oggi';

  @override
  String get reset => 'Ripristina';

  @override
  String get confirmDelete => 'Tutti i dati verranno ripristinati. Sei sicuro?';

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
