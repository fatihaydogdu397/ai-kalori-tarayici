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
  String get errorAuthInvalidCredentials => 'E-mail o password errata.';

  @override
  String get errorAuthSignInAgain => 'Per favore, accedi di nuovo.';

  @override
  String get errorAuthOauthFailed => 'Accesso non riuscito. Riprova.';

  @override
  String get errorAuthEmailInUse =>
      'Questa e-mail è già registrata. Prova ad accedere.';

  @override
  String get errorAuthEmailProviderConflict =>
      'Accedi con il metodo che hai usato originariamente per questa e-mail.';

  @override
  String get errorAuthInvalidOtp => 'Il codice non è valido o è scaduto.';

  @override
  String get errorAuthTooManyAttempts =>
      'Troppi tentativi falliti. Richiedi un nuovo codice.';

  @override
  String get errorPremiumRequired => 'Abbonamento Premium richiesto.';

  @override
  String get errorFoodScanLimit =>
      'Limite giornaliero di scansioni raggiunto. Passa a Premium per scansioni illimitate.';

  @override
  String get errorFoodNotFound => 'Pasto non trovato.';

  @override
  String get errorNotOwner => 'Non hai accesso a questo elemento.';

  @override
  String get errorFoodDeleteOnlyToday =>
      'Puoi eliminare solo i pasti registrati oggi.';

  @override
  String get errorFoodInvalidBarcode => 'Questo codice a barre sembra errato.';

  @override
  String get errorFoodMacroLimit => 'Ogni macro deve essere 1000 o meno.';

  @override
  String get errorDietPlanWeeklyLimit =>
      'Hai usato tutti i tuoi piani questa settimana.';

  @override
  String get errorDietPlanMacrosNotSet =>
      'Imposta prima i tuoi obiettivi giornalieri di macro.';

  @override
  String get errorDietPlanNotActive => 'Non hai un piano attivo.';

  @override
  String get errorDietPlanMealNotFound => 'Pasto non trovato.';

  @override
  String get errorBloodTestInvalidFile => 'Il file è danneggiato.';

  @override
  String get errorBloodTestTooLarge => 'I file devono essere 10 MB o meno.';

  @override
  String get errorBloodTestMimeMismatch =>
      'Questo formato di file non è supportato.';

  @override
  String get errorBloodTestNotFound => 'Esame del sangue non trovato.';

  @override
  String get errorNutritionNoCandidates =>
      'Impossibile generare un consiglio. Modifica le tue preferenze alimentari.';

  @override
  String get errorWaterInvalid => 'L\'acqua deve essere tra 0 e 3 litri.';

  @override
  String get errorWeightInvalid => 'Il peso deve essere tra 30 e 300 kg.';

  @override
  String get errorRateLimited => 'Troppe richieste. Riprova tra un momento.';

  @override
  String get errorInvalidInput => 'Controlla i tuoi dati.';

  @override
  String get errorNetwork => 'Nessuna connessione internet. Controlla la rete.';

  @override
  String get retry => 'Riprova';

  @override
  String get delete => 'Elimina';

  @override
  String get healthDataSection => 'DATI SANITARI';

  @override
  String get bloodTestTitle => 'Esame del sangue';

  @override
  String get bloodTestHeadline => 'Carica il tuo referto medico';

  @override
  String get bloodTestSubtitle =>
      'Caricando il tuo referto, possiamo personalizzare meglio il tuo piano e i nostri consigli. Opzionale — puoi aggiungerlo in qualsiasi momento dal profilo.';

  @override
  String get bloodTestPickFile => 'Scegli file';

  @override
  String get bloodTestReplaceFile => 'Tocca per sostituire';

  @override
  String get bloodTestFileTypesHint => 'PDF o immagine (JPG/PNG)';

  @override
  String get bloodTestDateOptional => 'Data del test (opzionale)';

  @override
  String get bloodTestUpload => 'Carica';

  @override
  String get bloodTestUploadAndContinue => 'Carica e continua';

  @override
  String get bloodTestsScreenTitle => 'I miei esami del sangue';

  @override
  String get bloodTestAdd => 'Aggiungi';

  @override
  String get bloodTestEmptyTitle => 'Nessun esame del sangue caricato';

  @override
  String get bloodTestEmptyBody =>
      'Tocca il pulsante + per aggiungere un PDF o un\'immagine.';

  @override
  String get bloodTestDeleteTitle => 'Elimina esame del sangue';

  @override
  String get bloodTestDeleteBody =>
      'Questo record verrà eliminato definitivamente.';

  @override
  String get bloodTestStatusPending => 'Analisi IA in attesa';

  @override
  String get bloodTestStatusCompleted => 'Analisi completata';

  @override
  String get bloodTestStatusFailed => 'Analisi fallita';

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
  String get noWeightData => 'Nessun dato di peso ancora.';

  @override
  String get noWeightDataHint => 'Inserisci il peso dalla sezione Profilo.';

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
  String get dailySummaryTitle => 'Riepilogo giornaliero 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Oggi hai consumato $cal/$goal kcal e ${water}L d\'acqua. Continua così!';
  }

  @override
  String get dailySummaryEmptyTitle => 'Nessun registro oggi';

  @override
  String get dailySummaryEmptyBody =>
      'Scansione rapida? Tocca per registrare il tuo primo pasto.';

  @override
  String get dailySummaryUnderTitle => 'Progresso di oggi';

  @override
  String dailySummaryUnderBody(String cal, String goal) {
    return '$cal/$goal kcal — continua a registrare';
  }

  @override
  String get goalAchievement => 'Raggiungimento obiettivo';

  @override
  String get consistency => 'Costanza';

  @override
  String get topDay => 'Giorno top';

  @override
  String get avgWater => 'Acqua media';

  @override
  String get weeklyInsight => 'Analisi settimanale';

  @override
  String get monthlyInsight => 'Analisi mensile';

  @override
  String get mostConsumedMeal => 'Pasto più consumato';

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
  String get onboardingDietTypeRequired => 'Seleziona almeno un tipo di dieta';

  @override
  String get dietPlanIAteThis => 'L\'ho mangiato';

  @override
  String get dietPlanMarkNotEaten => 'Segna come non mangiato';

  @override
  String get dietPlanEatenLabel => 'Mangiato';

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
  String get navDaily => 'Giornaliero';

  @override
  String get navProgram => 'Programma';

  @override
  String get stepsToday => 'Passi';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'bruciate';

  @override
  String get thirtyDays => '30 Giorni';

  @override
  String get avgPerDay => 'media / giorno';

  @override
  String get mealsLoggedLabel => 'pasti registrati';

  @override
  String get caloriesChartTitle => 'Calorie';

  @override
  String get noDataYet => 'Nessun dato ancora';

  @override
  String get recentLogs => 'Registrazioni recenti';

  @override
  String get currentLabel => 'attuale';

  @override
  String get targetLabel => 'obiettivo';

  @override
  String get noGoalSet => 'Nessun obiettivo impostato';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return '$remaining kcal rimanenti · obiettivo $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit persi';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit guadagnati';
  }

  @override
  String get weightStable => 'Peso stabile';

  @override
  String get foodSearch => 'Cerca alimenti';

  @override
  String get searchFoodsHint => 'Cerca alimenti...';

  @override
  String get noFoodsFound => 'Nessun alimento trovato';

  @override
  String get addToLog => 'Aggiungi al diario';

  @override
  String foodAddedToLog(String name) {
    return '$name aggiunto al diario';
  }

  @override
  String portionGrams(String grams) {
    return 'Porzione: $grams g';
  }

  @override
  String foodCount(int count) {
    return '$count alimenti';
  }

  @override
  String get categoryAll => 'Tutti';

  @override
  String get categoryDairy => 'Latticini';

  @override
  String get categoryFruit => 'Frutta';

  @override
  String get categoryFats => 'Grassi';

  @override
  String get categoryVegetables => 'Verdure';

  @override
  String get categoryFastFood => 'Fast food';

  @override
  String get categorySnacks => 'Snack';

  @override
  String get aiDietitian => 'Dietologo IA';

  @override
  String get aiPoweredBy => 'Powered by eatiq AI';

  @override
  String get onlineLabel => 'Online';

  @override
  String get askNutritionHint => 'Chiedi informazioni sulla nutrizione...';

  @override
  String get quickPromptProtein => 'Quante proteine ho bisogno?';

  @override
  String get quickPromptFatLoss => 'Migliori alimenti per perdere grasso?';

  @override
  String get quickPromptCalories => 'Devo contare le calorie?';

  @override
  String get quickPromptMealPrep => 'Consigli per preparare i pasti?';

  @override
  String get aiGreeting =>
      'Ciao! Sono il tuo Dietologo IA powered by eatiq. Chiedimi tutto su nutrizione, pianificazione dei pasti o come raggiungere i tuoi obiettivi di salute. 🥗';

  @override
  String get signInToEatiq => 'Accedi a eatiq';

  @override
  String get signInSubtitle =>
      'Sincronizza i tuoi progressi su tutti i dispositivi e sblocca analisi nutrizionali personalizzate.';

  @override
  String get continueWithApple => 'Continua con Apple';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get continueWithoutSignIn => 'Continua senza accedere';

  @override
  String get legalAgreementNote =>
      'Continuando, accetti i nostri Termini di servizio e l\'Informativa sulla privacy.';

  @override
  String get subscriptionLegal => 'Abbonamento e Legale';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get searchLabel => 'Cerca';

  @override
  String get dietitianLabel => 'Dietologo';

  @override
  String get targetWeight => 'Peso obiettivo';

  @override
  String goalHitBadge(String pct) {
    return 'Obiettivo $pct% raggiunto';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% costante';
  }

  @override
  String get waterAdd250 => '+250 ml';

  @override
  String get waterAdd500 => '+500 ml';

  @override
  String get waterAdd700 => '+700 ml';

  @override
  String get aiNote => 'Nota IA';

  @override
  String get additionalNotes => 'Note aggiuntive';

  @override
  String get avgWaterLabel => 'Acqua media';

  @override
  String get caloriesLabel => 'Calorie';

  @override
  String get carbsLabel => 'Carboidrati';

  @override
  String get consistencyLabel => 'Costanza';

  @override
  String get cookingTime => 'Tempo di cottura';

  @override
  String get cuisinePreferences => 'Preferenze culinarie';

  @override
  String get dietitianNav => 'Dietologo';

  @override
  String get editPreferences => 'Modifica preferenze';

  @override
  String get fatLabel => 'Grassi';

  @override
  String get foodRestrictions => 'Restrizioni alimentari';

  @override
  String get foodDislikesHint =>
      'Avversioni alimentari, allergie o richieste speciali...';

  @override
  String get goalAchievementLabel => 'Raggiungimento obiettivo';

  @override
  String get groceryBudget => 'Budget alimentare';

  @override
  String get mealsPerDay => 'Pasti al giorno';

  @override
  String get monthlyLabel => 'Mensile';

  @override
  String get proteinLabel => 'Proteine';

  @override
  String get regeneratePlan => 'Rigenera piano';

  @override
  String get sharePlan => 'Condividi piano';

  @override
  String get thisWeekLabel => 'Questa settimana';

  @override
  String get topMealLabel => 'Pasto principale';

  @override
  String get waterLabel => 'Acqua';

  @override
  String get weightLabel => 'Peso';

  @override
  String get yearlyLabel => 'Annuale';

  @override
  String get solidFood => '🍽️  Cibo solido';

  @override
  String get askNutritionHint2 => 'Chiedi informazioni sulla nutrizione...';

  @override
  String get continueWithApple2 => 'Continua con Apple';

  @override
  String get continueWithGoogle2 => 'Continua con Google';

  @override
  String get searchLabel2 => 'Cerca';

  @override
  String get searchFoodsHint2 => 'Cerca alimenti...';
}
