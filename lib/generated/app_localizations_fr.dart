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
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

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
