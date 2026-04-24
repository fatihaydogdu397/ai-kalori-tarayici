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
  String get noWeightData => 'Ainda sem dados de peso.';

  @override
  String get noWeightDataHint => 'Insira seu peso na seção Perfil.';

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
  String get dailySummaryTitle => 'Resumo do dia 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Hoje você consumiu $cal/$goal kcal e ${water}L de água. Continue assim!';
  }

  @override
  String get goalAchievement => 'Conquista de meta';

  @override
  String get consistency => 'Consistência';

  @override
  String get topDay => 'Melhor dia';

  @override
  String get avgWater => 'Água méd.';

  @override
  String get weeklyInsight => 'Análise semanal';

  @override
  String get monthlyInsight => 'Análise mensal';

  @override
  String get mostConsumedMeal => 'Refeição mais consumida';

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
  String get navDaily => 'Diário';

  @override
  String get navProgram => 'Programa';

  @override
  String get stepsToday => 'Passos';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'queimadas';

  @override
  String get thirtyDays => '30 Dias';

  @override
  String get avgPerDay => 'méd. / dia';

  @override
  String get mealsLoggedLabel => 'refeições registradas';

  @override
  String get caloriesChartTitle => 'Calorias';

  @override
  String get noDataYet => 'Ainda sem dados';

  @override
  String get recentLogs => 'Registros recentes';

  @override
  String get currentLabel => 'atual';

  @override
  String get targetLabel => 'meta';

  @override
  String get noGoalSet => 'Sem meta definida';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return '$remaining kcal restantes · meta $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit perdidos';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit ganhos';
  }

  @override
  String get weightStable => 'Peso estável';

  @override
  String get foodSearch => 'Pesquisar alimentos';

  @override
  String get searchFoodsHint => 'Pesquisar alimentos...';

  @override
  String get noFoodsFound => 'Nenhum alimento encontrado';

  @override
  String get addToLog => 'Adicionar ao diário';

  @override
  String foodAddedToLog(String name) {
    return '$name adicionado ao diário';
  }

  @override
  String portionGrams(String grams) {
    return 'Porção: $grams g';
  }

  @override
  String foodCount(int count) {
    return '$count alimentos';
  }

  @override
  String get categoryAll => 'Todos';

  @override
  String get categoryDairy => 'Laticínios';

  @override
  String get categoryFruit => 'Frutas';

  @override
  String get categoryFats => 'Gorduras';

  @override
  String get categoryVegetables => 'Vegetais';

  @override
  String get categoryFastFood => 'Fast food';

  @override
  String get categorySnacks => 'Lanches';

  @override
  String get aiDietitian => 'Nutricionista IA';

  @override
  String get aiPoweredBy => 'Desenvolvido por eatiq AI';

  @override
  String get onlineLabel => 'Online';

  @override
  String get askNutritionHint => 'Pergunte sobre nutrição...';

  @override
  String get quickPromptProtein => 'Quanto de proteína eu preciso?';

  @override
  String get quickPromptFatLoss => 'Melhores alimentos para perda de gordura?';

  @override
  String get quickPromptCalories => 'Devo contar calorias?';

  @override
  String get quickPromptMealPrep => 'Dicas de preparação de refeições?';

  @override
  String get aiGreeting =>
      'Olá! Sou seu Nutricionista IA powered by eatiq. Pergunte-me qualquer coisa sobre nutrição, planejamento de refeições ou como atingir seus objetivos de saúde. 🥗';

  @override
  String get signInToEatiq => 'Entrar no eatiq';

  @override
  String get signInSubtitle =>
      'Sincronize seu progresso em todos os dispositivos e desbloqueie insights nutricionais personalizados.';

  @override
  String get continueWithApple => 'Continuar com Apple';

  @override
  String get continueWithGoogle => 'Continuar com Google';

  @override
  String get continueWithoutSignIn => 'Continuar sem entrar';

  @override
  String get legalAgreementNote =>
      'Ao continuar, você concorda com nossos Termos de Serviço e Política de Privacidade.';

  @override
  String get subscriptionLegal => 'Assinatura e Legal';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get searchLabel => 'Pesquisar';

  @override
  String get dietitianLabel => 'Nutricionista';

  @override
  String get targetWeight => 'Peso alvo';

  @override
  String goalHitBadge(String pct) {
    return 'Meta $pct% atingida';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% consistente';
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
  String get additionalNotes => 'Notas adicionais';

  @override
  String get avgWaterLabel => 'Água méd.';

  @override
  String get caloriesLabel => 'Calorias';

  @override
  String get carbsLabel => 'Carboidratos';

  @override
  String get consistencyLabel => 'Consistência';

  @override
  String get cookingTime => 'Tempo de cozimento';

  @override
  String get cuisinePreferences => 'Preferências culinárias';

  @override
  String get dietitianNav => 'Nutricionista';

  @override
  String get editPreferences => 'Editar preferências';

  @override
  String get fatLabel => 'Gordura';

  @override
  String get foodRestrictions => 'Restrições alimentares';

  @override
  String get foodDislikesHint =>
      'Alimentos não desejados, alergias ou pedidos especiais...';

  @override
  String get goalAchievementLabel => 'Conquista de meta';

  @override
  String get groceryBudget => 'Orçamento para compras';

  @override
  String get mealsPerDay => 'Refeições por dia';

  @override
  String get monthlyLabel => 'Mensal';

  @override
  String get proteinLabel => 'Proteína';

  @override
  String get regeneratePlan => 'Regenerar plano';

  @override
  String get sharePlan => 'Compartilhar plano';

  @override
  String get thisWeekLabel => 'Esta semana';

  @override
  String get topMealLabel => 'Refeição principal';

  @override
  String get waterLabel => 'Água';

  @override
  String get weightLabel => 'Peso';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get solidFood => '🍽️  Comida sólida';

  @override
  String get askNutritionHint2 => 'Pergunte sobre nutrição...';

  @override
  String get continueWithApple2 => 'Continuar com Apple';

  @override
  String get continueWithGoogle2 => 'Continuar com Google';

  @override
  String get searchLabel2 => 'Pesquisar';

  @override
  String get searchFoodsHint2 => 'Pesquisar alimentos...';
}
