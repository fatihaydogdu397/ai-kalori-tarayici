// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Tire uma foto. Saiba o que você come.';

  @override
  String get getStarted => 'Começar';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get signIn => 'Entrar';

  @override
  String get skip => 'Pular';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get letsGo => 'Vamos lá';

  @override
  String get back => 'Voltar';

  @override
  String get save => 'Salvar';

  @override
  String get done => 'Ok';

  @override
  String get cancel => 'Cancelar';

  @override
  String get onboardingHello => 'Olá! 👋';

  @override
  String get onboardingNameSub => 'Vamos nos conhecer. Qual é o seu nome?';

  @override
  String get onboardingNameHint => 'Digite seu nome...';

  @override
  String get onboardingNameRequired => 'Por favor, insira seu nome';

  @override
  String get onboardingBody => 'Conheça seu corpo';

  @override
  String get onboardingBodySub => 'Vamos calcular sua meta calórica.';

  @override
  String get onboardingGoal => 'Qual é o seu objetivo?';

  @override
  String get onboardingGoalSub =>
      'Ajustaremos sua meta de calorias com base nisso.';

  @override
  String get onboardingTheme => 'Aparência';

  @override
  String get onboardingThemeSub => 'Você pode mudar isso depois.';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get age => 'Idade';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get ageUnit => 'anos';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Perder peso';

  @override
  String get goalLoseSub => 'Com déficit calórico gradual';

  @override
  String get goalMaintain => 'Manter peso';

  @override
  String get goalMaintainSub => 'Alimentação equilibrada e saudável';

  @override
  String get goalGain => 'Ganhar peso';

  @override
  String get goalGainSub => 'Ganhar massa muscular';

  @override
  String get dark => 'Escuro';

  @override
  String get light => 'Claro';

  @override
  String greeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get defaultName => 'Você';

  @override
  String get caloriestoday => 'Calorias de hoje';

  @override
  String get todaysMeals => 'Refeições de hoje';

  @override
  String get noMeals =>
      'Nenhuma refeição adicionada.\nAbra a câmera e escaneie sua primeira refeição!';

  @override
  String get protein => 'Proteína';

  @override
  String get carbs => 'Carb';

  @override
  String get fat => 'Gordura';

  @override
  String get water => 'Água';

  @override
  String get analyzing => 'Analisando...';

  @override
  String get analyzingSub => 'A IA está calculando os valores nutricionais';

  @override
  String get camera => 'Câmera';

  @override
  String get gallery => 'Galeria';

  @override
  String get home => 'Início';

  @override
  String get scan => 'Escanear';

  @override
  String get progress => 'Progresso';

  @override
  String get profile => 'Perfil';

  @override
  String get weeklyCalories => 'Calorias Semanais';

  @override
  String get macroBreakdown => 'Distribuição de Macros';

  @override
  String get avgCalories => 'Média de Calorias';

  @override
  String get totalScans => 'Total de Escaneamentos';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get editProfile => 'Editar';

  @override
  String get calorieGoal => 'Meta Calórica';

  @override
  String get language => 'Idioma';

  @override
  String get appearance => 'Aparência';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Escaneamentos ilimitados e recursos';

  @override
  String get waterAdd => 'Adicionar água';

  @override
  String get waterGoal => 'Meta de água';

  @override
  String waterGlasses(int count) {
    return '$count copos';
  }

  @override
  String get limitReached => 'Limite diário atingido';

  @override
  String get limitReachedSub =>
      'Você usou 5 escaneamentos gratuitos hoje.\nEscaneie ilimitadamente com o eatiq Pro.';

  @override
  String get unlimitedScans => 'Escaneamentos de IA ilimitados';

  @override
  String get unlimitedHistory => 'Histórico ilimitado';

  @override
  String get weeklyReport => 'Relatório semanal com IA';

  @override
  String get turkishDB => 'Banco de dados de comida turca';

  @override
  String get goProBtn => 'Pro — Assinar agora';

  @override
  String get yearlyDiscount => 'Economize 44% no plano anual';

  @override
  String minutesAgo(int min) {
    return 'há $min min';
  }

  @override
  String hoursAgo(int hr) {
    return 'há $hr h';
  }

  @override
  String daysAgo(int count) {
    return 'Há $count dias';
  }

  @override
  String get monday => 'Seg';

  @override
  String get tuesday => 'Ter';

  @override
  String get wednesday => 'Qua';

  @override
  String get thursday => 'Qui';

  @override
  String get friday => 'Sex';

  @override
  String get saturday => 'Sáb';

  @override
  String get sunday => 'Dom';

  @override
  String get errorGeneric => 'Ocorreu um erro';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get mealSnack => 'Lanche';

  @override
  String get settings => 'Configurações';

  @override
  String get unitSystem => 'Sistema de unidades';

  @override
  String get reminders => 'Lembretes';

  @override
  String get notifications => 'Notificações';

  @override
  String get dailyCalorieGoal => 'Meta diária de calorias';

  @override
  String get calorieRange => 'Entre 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get manual => 'Manual';

  @override
  String get analysisResult => 'Resultado da análise';

  @override
  String get detectedIngredients => 'Ingredientes detectados';

  @override
  String get addedToLog => 'Adicionado ao diário ✓';

  @override
  String get backToHome => 'OK, Voltar ao Início';

  @override
  String get mealAutoSaved => 'Refeição salva automaticamente.';

  @override
  String get historyTitle => 'Histórico';

  @override
  String get noScansYet => 'Nenhuma digitalização ainda';

  @override
  String get scanFirstMeal => 'Digitalize sua primeira refeição!';

  @override
  String scanCount(int count) {
    return '$count digitalizações';
  }

  @override
  String get bodyAnalysis => 'Análise corporal';

  @override
  String get idealWeight => 'Peso ideal';

  @override
  String get gender => 'Gênero';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get basalMetabolicRate => 'Taxa metabólica basal';

  @override
  String get dailyNeeds => 'Meta diária';

  @override
  String get bodyInfo => 'Informações corporais';

  @override
  String get mealNameLabel => 'Nome da refeição';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get portionWeightLabel => 'Peso da porção (g) — opcional';

  @override
  String get portionHint => 'Se inserido, os macros serão validados';

  @override
  String get macrosLabel => 'Macros (g) — opcional';

  @override
  String get editMeal => 'Editar refeição';

  @override
  String get addManualMeal => 'Adicionar refeição manualmente';

  @override
  String get update => 'Atualizar';

  @override
  String get bmiLabel => 'IMC';

  @override
  String get bmiUnderweight => 'Abaixo do peso';

  @override
  String get bmiNormal => 'Peso ideal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObese => 'Obesidade';

  @override
  String get bmiMorbidObese => 'Obesidade grave';

  @override
  String get bmiUnderweightDesc => 'Ligeiramente abaixo do seu peso ideal';

  @override
  String get bmiNormalDesc => 'Ótimo! Você está numa faixa de peso saudável 🎯';

  @override
  String get bmiOverweightDesc => 'Ligeiramente acima do peso saudável';

  @override
  String get bmiObeseDesc => 'Recomendamos perder peso pela sua saúde';

  @override
  String get bmiMorbidObeseDesc =>
      'Por favor, consulte um profissional de saúde';

  @override
  String get addMeal => '+ Adicionar';

  @override
  String get favorites => 'FAVORITOS';

  @override
  String get addMealShort => '+ Adicionar';

  @override
  String get mealFallback => 'Refeição';

  @override
  String get month01 => 'Jan';

  @override
  String get month02 => 'Fev';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Abr';

  @override
  String get month05 => 'Mai';

  @override
  String get month06 => 'Jun';

  @override
  String get month07 => 'Jul';

  @override
  String get month08 => 'Ago';

  @override
  String get month09 => 'Set';

  @override
  String get month10 => 'Out';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dez';

  @override
  String get validRequired => 'Campo obrigatório';

  @override
  String get validNumber => 'Insira um número válido';

  @override
  String get validPositive => 'Deve ser maior que zero';

  @override
  String get validNegative => 'Não pode ser negativo';

  @override
  String get validPortionRange => 'Deve estar entre 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro não pode ultrapassar 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro não pode ultrapassar o peso da porção (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'Total de macros (${total}g) ultrapassa o peso da porção';
  }

  @override
  String get validCalRequired => 'Calorias obrigatórias';

  @override
  String get validCalMax => 'Uma única refeição não pode ultrapassar 5000 kcal';

  @override
  String validCalInconsistent(String estimated) {
    return 'Inconsistente com macros (estimado ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'ex. Aveia, Frango...';

  @override
  String get hintCalories => 'ex. 350';

  @override
  String get hintPortion => 'ex. 200';

  @override
  String get hintProtein => 'Proteína';

  @override
  String get hintCarbs => 'Carboidratos';

  @override
  String get hintFat => 'Gordura';

  @override
  String get unitMetric => 'Métrico';

  @override
  String get unitImperial => 'Imperial';

  @override
  String get userFallback => 'Você';

  @override
  String get mealNameRequired => 'Nome da refeição obrigatório';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get appleHealth => 'Apple Saúde';

  @override
  String get appleHealthSub => 'Sincronizar refeições e água';

  @override
  String get appleHealthDenied =>
      'Permissão do Apple Saúde negada. Abra Configurações → Privacidade → Saúde → Eatiq.';

  @override
  String get goToSettings => 'Abrir Configurações';

  @override
  String get barcode => 'Código de barras';

  @override
  String get barcodeHint => 'Alinhe o código de barras no quadro';

  @override
  String get barcodeSearching => 'Procurando produto...';

  @override
  String get barcodeNotFound => 'Produto não encontrado. Tente entrada manual.';

  @override
  String get noWeightData => 'Henüz kilo geçmişi yok.';

  @override
  String get noWeightDataHint =>
      'Profil sekmesindeki düzenleme alanından kilonuzu kaydedin.';

  @override
  String streakDays(int count) {
    return '$count Dias seguidos';
  }

  @override
  String get streakMotivation => 'Registre todos os dias!';

  @override
  String get streakMilestone7 => '1 semana de série! Muito bem. 🎉';

  @override
  String get streakMilestone30 => '1 mês de série! Incrível! 🏆';

  @override
  String get activityLevel => 'Quão ativo você é?';

  @override
  String get activityLevelSub => 'Selecione seu nível de atividade diária';

  @override
  String get activitySedentary => 'Sedentário';

  @override
  String get activitySedentarySub => 'Pouco ou nenhum exercício';

  @override
  String get activityLight => 'Levemente ativo';

  @override
  String get activityLightSub => 'Exercício leve 1-3 dias/semana';

  @override
  String get activityActive => 'Ativo';

  @override
  String get activityActiveSub => 'Exercício moderado 3-5 dias/semana';

  @override
  String get activityVery => 'Muito ativo';

  @override
  String get activityVerySub => 'Exercício intenso 6-7 dias/semana';

  @override
  String get onboardingSummaryTitle => 'Tudo pronto! 🎉';

  @override
  String get onboardingSummarySub =>
      'Aqui está o seu objetivo diário personalizado.';

  @override
  String get onboardingRecommend => 'Calorias diárias recomendadas';

  @override
  String get onboardingGender => 'Qual é o seu gênero?';

  @override
  String get onboardingGenderSub => 'Usado para calcular sua taxa metabólica.';

  @override
  String get onboardingAge => 'Qual a sua idade?';

  @override
  String get onboardingAgeSub => 'Usado para calcular sua taxa metabólica.';

  @override
  String get onboardingHeightWeight => 'Altura e Peso';

  @override
  String get onboardingHeightWeightSub =>
      'Necessário para cálculos de IMC e calorias.';

  @override
  String get waterToday => 'Água hoje';

  @override
  String get reset => 'Redefinir';

  @override
  String get confirmDelete =>
      'Todos os dados serão redefinidos. Você tem certeza?';

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
