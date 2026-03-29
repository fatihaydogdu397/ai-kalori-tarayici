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
}
