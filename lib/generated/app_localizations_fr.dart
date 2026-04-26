// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Prenez une photo. Connaissez ce que vous mangez.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get skip => 'Passer';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get letsGo => 'C\'est parti';

  @override
  String get back => 'Retour';

  @override
  String get save => 'Enregistrer';

  @override
  String get done => 'Terminé';

  @override
  String get cancel => 'Annuler';

  @override
  String get onboardingHello => 'Bonjour ! 👋';

  @override
  String get onboardingNameSub =>
      'Faisons connaissance. Quel est votre prénom ?';

  @override
  String get onboardingNameHint => 'Tapez votre prénom...';

  @override
  String get onboardingNameRequired => 'Veuillez entrer votre prénom';

  @override
  String get onboardingBody => 'Connaissez votre corps';

  @override
  String get onboardingBodySub => 'Calculons votre objectif calorique.';

  @override
  String get onboardingGoal => 'Quel est votre objectif ?';

  @override
  String get onboardingGoalSub =>
      'Nous ajusterons votre cible calorique en conséquence.';

  @override
  String get onboardingTheme => 'Apparence';

  @override
  String get onboardingThemeSub => 'Vous pouvez changer cela plus tard.';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get age => 'Âge';

  @override
  String get height => 'Taille';

  @override
  String get weight => 'Poids';

  @override
  String get ageUnit => 'ans';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Perdre du poids';

  @override
  String get goalLoseSub => 'Lentement avec un déficit calorique';

  @override
  String get goalMaintain => 'Maintenir le poids';

  @override
  String get goalMaintainSub => 'Alimentation équilibrée et saine';

  @override
  String get goalGain => 'Prendre du poids';

  @override
  String get goalGainSub => 'Construire de la masse musculaire';

  @override
  String get dark => 'Sombre';

  @override
  String get light => 'Clair';

  @override
  String greeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get defaultName => 'vous';

  @override
  String get caloriestoday => 'Calories aujourd\'hui';

  @override
  String get todaysMeals => 'Repas d\'aujourd\'hui';

  @override
  String get noMeals =>
      'Aucun repas enregistré.\nAppuyez sur la caméra pour scanner votre premier repas !';

  @override
  String get protein => 'Protéines';

  @override
  String get carbs => 'Glucides';

  @override
  String get fat => 'Lipides';

  @override
  String get water => 'Eau';

  @override
  String get analyzing => 'Analyse en cours...';

  @override
  String get analyzingSub => 'L\'IA calcule vos nutriments';

  @override
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get home => 'Accueil';

  @override
  String get scan => 'Scanner';

  @override
  String get progress => 'Progrès';

  @override
  String get profile => 'Profil';

  @override
  String get weeklyCalories => 'Calories hebdomadaires';

  @override
  String get macroBreakdown => 'Répartition des macros';

  @override
  String get avgCalories => 'Moy. Calories';

  @override
  String get totalScans => 'Scans totaux';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfile => 'Modifier';

  @override
  String get calorieGoal => 'Objectif calorique';

  @override
  String get language => 'Langue';

  @override
  String get appearance => 'Apparence';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Scans illimités & fonctionnalités';

  @override
  String get waterAdd => 'Ajouter de l\'eau';

  @override
  String get waterGoal => 'Objectif eau';

  @override
  String waterGlasses(int count) {
    return '$count verres';
  }

  @override
  String get limitReached => 'Limite quotidienne atteinte';

  @override
  String get limitReachedSub =>
      'Vous avez utilisé 5 scans gratuits aujourd\'hui.\nScannez sans limite avec eatiq Pro.';

  @override
  String get unlimitedScans => 'Scans IA illimités';

  @override
  String get unlimitedHistory => 'Historique illimité';

  @override
  String get weeklyReport => 'Rapport IA hebdomadaire';

  @override
  String get turkishDB => 'Base de données cuisine turque';

  @override
  String get goProBtn => 'Passer Pro — ₺149/mois';

  @override
  String get yearlyDiscount => 'Économisez 44% avec ₺999/an';

  @override
  String minutesAgo(int min) {
    return 'il y a $min min';
  }

  @override
  String hoursAgo(int hr) {
    return 'il y a $hr h';
  }

  @override
  String daysAgo(int count) {
    return 'Il y a $count jours';
  }

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mer';

  @override
  String get thursday => 'Jeu';

  @override
  String get friday => 'Ven';

  @override
  String get saturday => 'Sam';

  @override
  String get sunday => 'Dim';

  @override
  String get errorGeneric => 'Une erreur s\'est produite';

  @override
  String get retry => 'Réessayer';

  @override
  String get mealBreakfast => 'Petit-déjeuner';

  @override
  String get mealLunch => 'Déjeuner';

  @override
  String get mealDinner => 'Dîner';

  @override
  String get mealSnack => 'Collation';

  @override
  String get settings => 'Paramètres';

  @override
  String get unitSystem => 'Système d\'unités';

  @override
  String get reminders => 'Rappels';

  @override
  String get notifications => 'Notifications';

  @override
  String get dailyCalorieGoal => 'Objectif calorique journalier';

  @override
  String get calorieRange => 'Entre 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get manual => 'Manuel';

  @override
  String get analysisResult => 'Résultat de l\'analyse';

  @override
  String get detectedIngredients => 'Ingrédients détectés';

  @override
  String get addedToLog => 'Ajouté au journal ✓';

  @override
  String get backToHome => 'OK, Retour à l\'accueil';

  @override
  String get mealAutoSaved => 'Repas enregistré automatiquement.';

  @override
  String get historyTitle => 'Historique';

  @override
  String get noScansYet => 'Aucun scan pour l\'instant';

  @override
  String get scanFirstMeal => 'Scannez votre premier repas !';

  @override
  String scanCount(int count) {
    return '$count scans';
  }

  @override
  String get bodyAnalysis => 'Analyse corporelle';

  @override
  String get idealWeight => 'Poids idéal';

  @override
  String get gender => 'Genre';

  @override
  String get goalLabel => 'Objectif';

  @override
  String get basalMetabolicRate => 'Métabolisme de base';

  @override
  String get dailyNeeds => 'Objectif quotidien';

  @override
  String get bodyInfo => 'Informations corporelles';

  @override
  String get mealNameLabel => 'Nom du repas';

  @override
  String get categoryLabel => 'Catégorie';

  @override
  String get portionWeightLabel => 'Poids de la portion (g) — optionnel';

  @override
  String get portionHint =>
      'Si vous entrez des données, les macros seront vérifiés';

  @override
  String get macrosLabel => 'Macros (g) — optionnel';

  @override
  String get editMeal => 'Modifier le repas';

  @override
  String get addManualMeal => 'Ajouter un repas manuellement';

  @override
  String get update => 'Mettre à jour';

  @override
  String get bmiLabel => 'IMC';

  @override
  String get bmiUnderweight => 'Insuffisance pondérale';

  @override
  String get bmiNormal => 'Poids idéal';

  @override
  String get bmiOverweight => 'Surpoids';

  @override
  String get bmiObese => 'Obésité';

  @override
  String get bmiMorbidObese => 'Obésité sévère';

  @override
  String get bmiUnderweightDesc => 'Légèrement en dessous de votre poids idéal';

  @override
  String get bmiNormalDesc =>
      'Super ! Vous êtes dans une fourchette de poids saine 🎯';

  @override
  String get bmiOverweightDesc => 'Légèrement au-dessus du poids sain';

  @override
  String get bmiObeseDesc =>
      'Nous recommandons de perdre du poids pour votre santé';

  @override
  String get bmiMorbidObeseDesc =>
      'Veuillez consulter un professionnel de santé';

  @override
  String get addMeal => '+ Ajouter';

  @override
  String get favorites => 'FAVORIS';

  @override
  String get addMealShort => '+ Ajouter';

  @override
  String get mealFallback => 'Repas';

  @override
  String get month01 => 'Jan';

  @override
  String get month02 => 'Fév';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Avr';

  @override
  String get month05 => 'Mai';

  @override
  String get month06 => 'Jun';

  @override
  String get month07 => 'Jul';

  @override
  String get month08 => 'Aoû';

  @override
  String get month09 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Déc';

  @override
  String get validRequired => 'Champ obligatoire';

  @override
  String get validNumber => 'Entrer un nombre valide';

  @override
  String get validPositive => 'Doit être supérieur à zéro';

  @override
  String get validNegative => 'Ne peut pas être négatif';

  @override
  String get validPortionRange => 'Doit être entre 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro ne peut pas dépasser 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro ne peut pas dépasser le poids de la portion (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'Les macros totales (${total}g) dépassent le poids de la portion';
  }

  @override
  String get validCalRequired => 'Calories requises';

  @override
  String get validCalMax => 'Un seul repas ne peut pas dépasser 5000 kcal';

  @override
  String validCalInconsistent(String estimated) {
    return 'Incohérent avec les macros (estimé ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'ex. Flocons d\'avoine, Poulet...';

  @override
  String get hintCalories => 'ex. 350';

  @override
  String get hintPortion => 'ex. 200';

  @override
  String get hintProtein => 'Protéines';

  @override
  String get hintCarbs => 'Glucides';

  @override
  String get hintFat => 'Lipides';

  @override
  String get unitMetric => 'Métrique';

  @override
  String get unitImperial => 'Impérial';

  @override
  String get userFallback => 'Toi';

  @override
  String get mealNameRequired => 'Nom du repas requis';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get appleHealth => 'Apple Santé';

  @override
  String get appleHealthSub => 'Synchroniser repas & eau';

  @override
  String get appleHealthDenied =>
      'Accès Apple Santé refusé. Ouvrez Réglages → Confidentialité → Santé → Eatiq.';

  @override
  String get goToSettings => 'Ouvrir Réglages';

  @override
  String get barcode => 'Code-barres';

  @override
  String get barcodeHint => 'Alignez le code-barres dans le cadre';

  @override
  String get barcodeSearching => 'Recherche du produit...';

  @override
  String get barcodeNotFound =>
      'Produit introuvable. Essayez la saisie manuelle.';

  @override
  String get noWeightData => 'Aucune donnée de poids encore.';

  @override
  String get noWeightDataHint =>
      'Saisissez votre poids dans la section Profil.';

  @override
  String streakDays(int count) {
    return '$count Jours de série';
  }

  @override
  String get streakMotivation => 'Enregistrez chaque jour !';

  @override
  String get streakMilestone7 => '1 semaine de série ! Super. 🎉';

  @override
  String get streakMilestone30 => '1 mois de série ! Incroyable. 🏆';

  @override
  String get activityLevel => 'Quel est ton niveau d\'activité ?';

  @override
  String get activityLevelSub => 'Choisis ton niveau d\'activité quotidien';

  @override
  String get activitySedentary => 'Sédentaire';

  @override
  String get activitySedentarySub => 'Peu ou pas d\'exercice';

  @override
  String get activityLight => 'Légèrement actif';

  @override
  String get activityLightSub => 'Exercice léger 1-3 jours/semaine';

  @override
  String get activityActive => 'Actif';

  @override
  String get activityActiveSub => 'Exercice modéré 3-5 jours/semaine';

  @override
  String get activityVery => 'Très actif';

  @override
  String get activityVerySub => 'Exercice intense 6-7 jours/semaine';

  @override
  String get onboardingSummaryTitle => 'C\'est parti ! 🎉';

  @override
  String get onboardingSummarySub =>
      'Voici ton objectif quotidien personnalisé.';

  @override
  String get onboardingRecommend => 'Calories quotidiennes recommandées';

  @override
  String get onboardingGender => 'Quel est ton sexe ?';

  @override
  String get onboardingGenderSub => 'Utilisé pour calculer ton métabolisme.';

  @override
  String get onboardingAge => 'Quel âge as-tu ?';

  @override
  String get onboardingAgeSub => 'Utilisé pour calculer ton métabolisme.';

  @override
  String get onboardingHeightWeight => 'Taille et poids';

  @override
  String get onboardingHeightWeightSub =>
      'Requis pour l\'IMC et les calories quotidiennes.';

  @override
  String get waterToday => 'Eau aujourd\'hui';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get confirmDelete =>
      'Toutes les données seront réinitialisées. Êtes-vous sûr ?';

  @override
  String get dailySummaryTitle => 'Résumé du jour 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Aujourd\'hui vous avez consommé $cal/$goal kcal et ${water}L d\'eau. Continuez comme ça !';
  }

  @override
  String get goalAchievement => 'Atteinte des objectifs';

  @override
  String get consistency => 'Régularité';

  @override
  String get topDay => 'Meilleur jour';

  @override
  String get avgWater => 'Eau moy.';

  @override
  String get weeklyInsight => 'Analyse hebdomadaire';

  @override
  String get monthlyInsight => 'Analyse mensuelle';

  @override
  String get mostConsumedMeal => 'Repas le plus consommé';

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
  String get navDaily => 'Quotidien';

  @override
  String get navProgram => 'Programme';

  @override
  String get stepsToday => 'Pas';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'brûlées';

  @override
  String get thirtyDays => '30 Jours';

  @override
  String get avgPerDay => 'moy. / jour';

  @override
  String get mealsLoggedLabel => 'repas enregistrés';

  @override
  String get caloriesChartTitle => 'Calories';

  @override
  String get noDataYet => 'Pas encore de données';

  @override
  String get recentLogs => 'Dernières entrées';

  @override
  String get currentLabel => 'actuel';

  @override
  String get targetLabel => 'cible';

  @override
  String get noGoalSet => 'Aucun objectif défini';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return '$remaining kcal restantes · objectif $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit perdu';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit pris';
  }

  @override
  String get weightStable => 'Poids stable';

  @override
  String get foodSearch => 'Recherche alimentaire';

  @override
  String get searchFoodsHint => 'Rechercher des aliments...';

  @override
  String get noFoodsFound => 'Aucun aliment trouvé';

  @override
  String get addToLog => 'Ajouter au journal';

  @override
  String foodAddedToLog(String name) {
    return '$name ajouté au journal';
  }

  @override
  String portionGrams(String grams) {
    return 'Portion : $grams g';
  }

  @override
  String foodCount(int count) {
    return '$count aliments';
  }

  @override
  String get categoryAll => 'Tout';

  @override
  String get categoryDairy => 'Produits laitiers';

  @override
  String get categoryFruit => 'Fruits';

  @override
  String get categoryFats => 'Lipides';

  @override
  String get categoryVegetables => 'Légumes';

  @override
  String get categoryFastFood => 'Restauration rapide';

  @override
  String get categorySnacks => 'Collations';

  @override
  String get aiDietitian => 'Diététicien IA';

  @override
  String get aiPoweredBy => 'Propulsé par eatiq AI';

  @override
  String get onlineLabel => 'En ligne';

  @override
  String get askNutritionHint => 'Posez une question sur la nutrition...';

  @override
  String get quickPromptProtein => 'De combien de protéines ai-je besoin ?';

  @override
  String get quickPromptFatLoss =>
      'Meilleurs aliments pour perdre de la graisse ?';

  @override
  String get quickPromptCalories => 'Dois-je compter les calories ?';

  @override
  String get quickPromptMealPrep => 'Conseils pour préparer les repas ?';

  @override
  String get aiGreeting =>
      'Bonjour ! Je suis votre Diététicien IA powered by eatiq. Posez-moi toutes vos questions sur la nutrition, la planification des repas ou comment atteindre vos objectifs santé. 🥗';

  @override
  String get signInToEatiq => 'Se connecter à eatiq';

  @override
  String get signInSubtitle =>
      'Synchronisez vos progrès sur tous les appareils et obtenez des analyses nutritionnelles personnalisées.';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithoutSignIn => 'Continuer sans se connecter';

  @override
  String get legalAgreementNote =>
      'En continuant, vous acceptez nos Conditions d\'utilisation et notre Politique de confidentialité.';

  @override
  String get subscriptionLegal => 'Abonnement & Légal';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get searchLabel => 'Rechercher';

  @override
  String get dietitianLabel => 'Diététicien';

  @override
  String get targetWeight => 'Poids cible';

  @override
  String goalHitBadge(String pct) {
    return 'Objectif $pct% atteint';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% régulier';
  }

  @override
  String get waterAdd250 => '+250 ml';

  @override
  String get waterAdd500 => '+500 ml';

  @override
  String get waterAdd700 => '+700 ml';

  @override
  String get aiNote => 'Note IA';

  @override
  String get additionalNotes => 'Notes supplémentaires';

  @override
  String get avgWaterLabel => 'Eau moy.';

  @override
  String get caloriesLabel => 'Calories';

  @override
  String get carbsLabel => 'Glucides';

  @override
  String get consistencyLabel => 'Régularité';

  @override
  String get cookingTime => 'Temps de cuisson';

  @override
  String get cuisinePreferences => 'Préférences culinaires';

  @override
  String get dietitianNav => 'Diététicien';

  @override
  String get editPreferences => 'Modifier les préférences';

  @override
  String get fatLabel => 'Lipides';

  @override
  String get foodRestrictions => 'Restrictions alimentaires';

  @override
  String get foodDislikesHint =>
      'Aversions alimentaires, allergies ou demandes spéciales...';

  @override
  String get goalAchievementLabel => 'Atteinte des objectifs';

  @override
  String get groceryBudget => 'Budget courses';

  @override
  String get mealsPerDay => 'Repas par jour';

  @override
  String get monthlyLabel => 'Mensuel';

  @override
  String get proteinLabel => 'Protéines';

  @override
  String get regeneratePlan => 'Régénérer le plan';

  @override
  String get sharePlan => 'Partager le plan';

  @override
  String get thisWeekLabel => 'Cette semaine';

  @override
  String get topMealLabel => 'Repas principal';

  @override
  String get waterLabel => 'Eau';

  @override
  String get weightLabel => 'Poids';

  @override
  String get yearlyLabel => 'Annuel';

  @override
  String get solidFood => '🍽️  Nourriture solide';

  @override
  String get askNutritionHint2 => 'Posez une question sur la nutrition...';

  @override
  String get continueWithApple2 => 'Continuer avec Apple';

  @override
  String get continueWithGoogle2 => 'Continuer avec Google';

  @override
  String get searchLabel2 => 'Rechercher';

  @override
  String get searchFoodsHint2 => 'Rechercher des aliments...';
}
