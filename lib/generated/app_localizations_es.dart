// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Toma una foto. Sabe lo que comes.';

  @override
  String get getStarted => 'Empezar';

  @override
  String get alreadyHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get skip => 'Saltar';

  @override
  String get continueBtn => 'Continuar';

  @override
  String get letsGo => '¡Vamos!';

  @override
  String get back => 'Atrás';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Hecho';

  @override
  String get cancel => 'Cancelar';

  @override
  String get onboardingHello => '¡Hola! 👋';

  @override
  String get onboardingNameSub => 'Vamos a conocerte. ¿Cuál es tu nombre?';

  @override
  String get onboardingNameHint => 'Escribe tu nombre...';

  @override
  String get onboardingNameRequired => 'Por favor ingresa tu nombre';

  @override
  String get onboardingBody => 'Conoce tu cuerpo';

  @override
  String get onboardingBodySub => 'Calculemos tu objetivo calórico.';

  @override
  String get onboardingGoal => '¿Cuál es tu objetivo?';

  @override
  String get onboardingGoalSub =>
      'Ajustaremos tu meta calórica en consecuencia.';

  @override
  String get onboardingTheme => 'Apariencia';

  @override
  String get onboardingThemeSub => 'Puedes cambiarlo más tarde.';

  @override
  String get male => 'Hombre';

  @override
  String get female => 'Mujer';

  @override
  String get age => 'Edad';

  @override
  String get height => 'Altura';

  @override
  String get weight => 'Peso';

  @override
  String get ageUnit => 'años';

  @override
  String get heightUnit => 'cm';

  @override
  String get weightUnit => 'kg';

  @override
  String get goalLose => 'Perder peso';

  @override
  String get goalLoseSub => 'Lento y constante con déficit calórico';

  @override
  String get goalMaintain => 'Mantener peso';

  @override
  String get goalMaintainSub => 'Alimentación equilibrada y saludable';

  @override
  String get goalGain => 'Ganar peso';

  @override
  String get goalGainSub => 'Ganar masa muscular';

  @override
  String get dark => 'Oscuro';

  @override
  String get light => 'Claro';

  @override
  String greeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get defaultName => 'tú';

  @override
  String get caloriestoday => 'Calorías hoy';

  @override
  String get todaysMeals => 'Comidas de hoy';

  @override
  String get noMeals =>
      'No hay comidas registradas.\n¡Toca la cámara para escanear tu primera comida!';

  @override
  String get protein => 'Proteína';

  @override
  String get carbs => 'Carbs';

  @override
  String get fat => 'Grasa';

  @override
  String get water => 'Agua';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get analyzingSub => 'La IA está calculando tus nutrientes';

  @override
  String get camera => 'Cámara';

  @override
  String get gallery => 'Galería';

  @override
  String get home => 'Inicio';

  @override
  String get scan => 'Escanear';

  @override
  String get progress => 'Progreso';

  @override
  String get profile => 'Perfil';

  @override
  String get weeklyCalories => 'Calorías semanales';

  @override
  String get macroBreakdown => 'Distribución de macros';

  @override
  String get avgCalories => 'Prom. Calorías';

  @override
  String get totalScans => 'Escaneos totales';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get editProfile => 'Editar';

  @override
  String get calorieGoal => 'Objetivo calórico';

  @override
  String get language => 'Idioma';

  @override
  String get appearance => 'Apariencia';

  @override
  String get premium => 'Premium';

  @override
  String get premiumSub => 'Escaneos ilimitados y funciones';

  @override
  String get waterAdd => 'Agregar agua';

  @override
  String get waterGoal => 'Meta de agua';

  @override
  String waterGlasses(int count) {
    return '$count vasos';
  }

  @override
  String get limitReached => 'Límite diario alcanzado';

  @override
  String get limitReachedSub =>
      'Usaste 5 escaneos gratuitos hoy.\nEscanea ilimitado con eatiq Pro.';

  @override
  String get unlimitedScans => 'Escaneos IA ilimitados';

  @override
  String get unlimitedHistory => 'Historial ilimitado';

  @override
  String get weeklyReport => 'Informe IA semanal';

  @override
  String get turkishDB => 'Base de datos comida turca';

  @override
  String get goProBtn => 'Ir a Pro — ₺149/mes';

  @override
  String get yearlyDiscount => 'Ahorra 44% con ₺999/año';

  @override
  String minutesAgo(int min) {
    return 'hace $min min';
  }

  @override
  String hoursAgo(int hr) {
    return 'hace $hr h';
  }

  @override
  String daysAgo(int count) {
    return 'Hace $count días';
  }

  @override
  String get monday => 'Lun';

  @override
  String get tuesday => 'Mar';

  @override
  String get wednesday => 'Mié';

  @override
  String get thursday => 'Jue';

  @override
  String get friday => 'Vie';

  @override
  String get saturday => 'Sáb';

  @override
  String get sunday => 'Dom';

  @override
  String get errorGeneric => 'Algo salió mal';

  @override
  String get retry => 'Reintentar';

  @override
  String get mealBreakfast => 'Desayuno';

  @override
  String get mealLunch => 'Almuerzo';

  @override
  String get mealDinner => 'Cena';

  @override
  String get mealSnack => 'Merienda';

  @override
  String get settings => 'Configuración';

  @override
  String get unitSystem => 'Sistema de unidades';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get dailyCalorieGoal => 'Meta diaria de calorías';

  @override
  String get calorieRange => 'Entre 1200 – 4000 kcal';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get manual => 'Manual';

  @override
  String get analysisResult => 'Resultado del análisis';

  @override
  String get detectedIngredients => 'Ingredientes detectados';

  @override
  String get addedToLog => 'Añadido al registro ✓';

  @override
  String get backToHome => 'OK, Volver al inicio';

  @override
  String get mealAutoSaved => 'Comida guardada automáticamente.';

  @override
  String get historyTitle => 'Historial';

  @override
  String get noScansYet => 'Aún no hay escaneos';

  @override
  String get scanFirstMeal => '¡Escanea tu primera comida!';

  @override
  String scanCount(int count) {
    return '$count escaneos';
  }

  @override
  String get bodyAnalysis => 'Análisis corporal';

  @override
  String get idealWeight => 'Peso ideal';

  @override
  String get gender => 'Género';

  @override
  String get goalLabel => 'Objetivo';

  @override
  String get basalMetabolicRate => 'Tasa metabólica basal';

  @override
  String get dailyNeeds => 'Objetivo diario';

  @override
  String get bodyInfo => 'Información corporal';

  @override
  String get mealNameLabel => 'Nombre de la comida';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get portionWeightLabel => 'Peso de la porción (g) — opcional';

  @override
  String get portionHint => 'Si introduces datos, se validarán los macros';

  @override
  String get macrosLabel => 'Macros (g) — opcional';

  @override
  String get editMeal => 'Editar comida';

  @override
  String get addManualMeal => 'Añadir comida manualmente';

  @override
  String get update => 'Actualizar';

  @override
  String get bmiLabel => 'IMC';

  @override
  String get bmiUnderweight => 'Bajo peso';

  @override
  String get bmiNormal => 'Peso ideal';

  @override
  String get bmiOverweight => 'Sobrepeso';

  @override
  String get bmiObese => 'Obesidad';

  @override
  String get bmiMorbidObese => 'Obesidad severa';

  @override
  String get bmiUnderweightDesc => 'Ligeramente por debajo de tu peso ideal';

  @override
  String get bmiNormalDesc => '¡Genial! Estás en un rango de peso saludable 🎯';

  @override
  String get bmiOverweightDesc => 'Ligeramente por encima del peso saludable';

  @override
  String get bmiObeseDesc => 'Recomendamos perder peso por tu salud';

  @override
  String get bmiMorbidObeseDesc => 'Consulta a un profesional de la salud';

  @override
  String get addMeal => '+ Añadir';

  @override
  String get favorites => 'FAVORITOS';

  @override
  String get addMealShort => '+ Añadir';

  @override
  String get mealFallback => 'Comida';

  @override
  String get month01 => 'Ene';

  @override
  String get month02 => 'Feb';

  @override
  String get month03 => 'Mar';

  @override
  String get month04 => 'Abr';

  @override
  String get month05 => 'May';

  @override
  String get month06 => 'Jun';

  @override
  String get month07 => 'Jul';

  @override
  String get month08 => 'Ago';

  @override
  String get month09 => 'Sep';

  @override
  String get month10 => 'Oct';

  @override
  String get month11 => 'Nov';

  @override
  String get month12 => 'Dic';

  @override
  String get validRequired => 'Campo obligatorio';

  @override
  String get validNumber => 'Introduce un número válido';

  @override
  String get validPositive => 'Debe ser mayor que cero';

  @override
  String get validNegative => 'No puede ser negativo';

  @override
  String get validPortionRange => 'Debe estar entre 1–5000g';

  @override
  String validMacroMax(String macro) {
    return '$macro no puede superar 1000g';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro no puede superar el peso de la ración (${portion}g)';
  }

  @override
  String validMacroTotal(String total) {
    return 'Los macros totales (${total}g) superan el peso de la ración';
  }

  @override
  String get validCalRequired => 'Se requieren calorías';

  @override
  String get validCalMax => 'Una sola comida no puede superar 5000 kcal';

  @override
  String validCalInconsistent(String estimated) {
    return 'Inconsistente con los macros (estimado ~$estimated kcal)';
  }

  @override
  String get hintMealName => 'ej. Avena, Pollo...';

  @override
  String get hintCalories => 'ej. 350';

  @override
  String get hintPortion => 'ej. 200';

  @override
  String get hintProtein => 'Proteína';

  @override
  String get hintCarbs => 'Carbos';

  @override
  String get hintFat => 'Grasa';

  @override
  String get unitMetric => 'Métrico';

  @override
  String get unitImperial => 'Imperial';

  @override
  String get userFallback => 'Tú';

  @override
  String get mealNameRequired => 'Se requiere el nombre de la comida';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get appleHealth => 'Apple Salud';

  @override
  String get appleHealthSub => 'Sincronizar comidas y agua';

  @override
  String get appleHealthDenied =>
      'Permiso de Apple Salud denegado. Abre Ajustes → Privacidad → Salud → Eatiq.';

  @override
  String get goToSettings => 'Abrir Ajustes';

  @override
  String get barcode => 'Código de barras';

  @override
  String get barcodeHint => 'Alinea el código de barras en el marco';

  @override
  String get barcodeSearching => 'Buscando producto...';

  @override
  String get barcodeNotFound =>
      'Producto no encontrado. Prueba la entrada manual.';

  @override
  String get noWeightData => 'Sin datos de peso aún.';

  @override
  String get noWeightDataHint => 'Ingresa tu peso desde la sección Perfil.';

  @override
  String streakDays(int count) {
    return '$count Días de racha';
  }

  @override
  String get streakMotivation => '¡Registra todos los días!';

  @override
  String get streakMilestone7 => '¡1 semana de racha! ¡Genial! 🎉';

  @override
  String get streakMilestone30 => '¡1 mes de racha! ¡Increíble! 🏆';

  @override
  String get activityLevel => '¿Qué tan activo eres?';

  @override
  String get activityLevelSub => 'Selecciona tu nivel de actividad diaria';

  @override
  String get activitySedentary => 'Sedentario';

  @override
  String get activitySedentarySub => 'Poco o ningún ejercicio';

  @override
  String get activityLight => 'Ligeramente activo';

  @override
  String get activityLightSub => 'Ejercicio ligero 1-3 días/semana';

  @override
  String get activityActive => 'Activo';

  @override
  String get activityActiveSub => 'Ejercicio moderado 3-5 días/semana';

  @override
  String get activityVery => 'Muy activo';

  @override
  String get activityVerySub => 'Ejercicio intenso 6-7 días/semana';

  @override
  String get onboardingSummaryTitle => '¡Listo! 🎉';

  @override
  String get onboardingSummarySub =>
      'Aquí está tu objetivo diario personalizado.';

  @override
  String get onboardingRecommend => 'Calorías diarias recomendadas';

  @override
  String get onboardingGender => '¿Cuál es tu género?';

  @override
  String get onboardingGenderSub => 'Usado para calcular tu metabolismo.';

  @override
  String get onboardingAge => '¿Cuántos años tienes?';

  @override
  String get onboardingAgeSub => 'Usado para calcular tu metabolismo.';

  @override
  String get onboardingHeightWeight => 'Altura y Peso';

  @override
  String get onboardingHeightWeightSub => 'Necesario para el IMC y calorías.';

  @override
  String get waterToday => 'Agua de hoy';

  @override
  String get reset => 'Restablecer';

  @override
  String get confirmDelete =>
      '¿Se restablecerán todos los datos. ¿Estás seguro?';

  @override
  String get dailySummaryTitle => 'Resumen del día 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Hoy consumiste $cal/$goal kcal y ${water}L de agua. ¡Sigue así!';
  }

  @override
  String get goalAchievement => 'Logro de objetivos';

  @override
  String get consistency => 'Consistencia';

  @override
  String get topDay => 'Mejor día';

  @override
  String get avgWater => 'Agua prom.';

  @override
  String get weeklyInsight => 'Análisis semanal';

  @override
  String get monthlyInsight => 'Análisis mensual';

  @override
  String get mostConsumedMeal => 'Comida más consumida';

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
  String get navDaily => 'Diario';

  @override
  String get navProgram => 'Programa';

  @override
  String get stepsToday => 'Pasos';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'quemadas';

  @override
  String get thirtyDays => '30 Días';

  @override
  String get avgPerDay => 'prom. / día';

  @override
  String get mealsLoggedLabel => 'comidas registradas';

  @override
  String get caloriesChartTitle => 'Calorías';

  @override
  String get noDataYet => 'Aún no hay datos';

  @override
  String get recentLogs => 'Registros recientes';

  @override
  String get currentLabel => 'actual';

  @override
  String get targetLabel => 'meta';

  @override
  String get noGoalSet => 'Sin objetivo definido';

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
    return '↑ $amount $unit ganados';
  }

  @override
  String get weightStable => 'Peso estable';

  @override
  String get foodSearch => 'Buscar alimentos';

  @override
  String get searchFoodsHint => 'Buscar alimentos...';

  @override
  String get noFoodsFound => 'No se encontraron alimentos';

  @override
  String get addToLog => 'Añadir al registro';

  @override
  String foodAddedToLog(String name) {
    return '$name añadido al registro';
  }

  @override
  String portionGrams(String grams) {
    return 'Porción: $grams g';
  }

  @override
  String foodCount(int count) {
    return '$count alimentos';
  }

  @override
  String get categoryAll => 'Todos';

  @override
  String get categoryDairy => 'Lácteos';

  @override
  String get categoryFruit => 'Fruta';

  @override
  String get categoryFats => 'Grasas';

  @override
  String get categoryVegetables => 'Verduras';

  @override
  String get categoryFastFood => 'Comida rápida';

  @override
  String get categorySnacks => 'Aperitivos';

  @override
  String get aiDietitian => 'Dietista IA';

  @override
  String get aiPoweredBy => 'Impulsado por eatiq AI';

  @override
  String get onlineLabel => 'En línea';

  @override
  String get askNutritionHint => 'Preguntar sobre nutrición...';

  @override
  String get quickPromptProtein => '¿Cuánta proteína necesito?';

  @override
  String get quickPromptFatLoss => '¿Mejores alimentos para perder grasa?';

  @override
  String get quickPromptCalories => '¿Debo contar calorías?';

  @override
  String get quickPromptMealPrep => '¿Consejos para preparar comidas?';

  @override
  String get aiGreeting =>
      '¡Hola! Soy tu Dietista IA powered by eatiq. Pregúntame cualquier cosa sobre nutrición, planificación de comidas o cómo alcanzar tus metas de salud. 🥗';

  @override
  String get signInToEatiq => 'Iniciar sesión en eatiq';

  @override
  String get signInSubtitle =>
      'Sincroniza tu progreso en todos los dispositivos y desbloquea información nutricional personalizada.';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get continueWithoutSignIn => 'Continuar sin iniciar sesión';

  @override
  String get legalAgreementNote =>
      'Al continuar, acepta nuestros Términos de servicio y Política de privacidad.';

  @override
  String get subscriptionLegal => 'Suscripción y Legal';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get searchLabel => 'Buscar';

  @override
  String get dietitianLabel => 'Dietista';

  @override
  String get targetWeight => 'Peso objetivo';

  @override
  String goalHitBadge(String pct) {
    return 'Objetivo $pct% logrado';
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
  String get additionalNotes => 'Notas adicionales';

  @override
  String get avgWaterLabel => 'Agua prom.';

  @override
  String get caloriesLabel => 'Calorías';

  @override
  String get carbsLabel => 'Carbohidratos';

  @override
  String get consistencyLabel => 'Consistencia';

  @override
  String get cookingTime => 'Tiempo de cocción';

  @override
  String get cuisinePreferences => 'Preferencias culinarias';

  @override
  String get dietitianNav => 'Dietista';

  @override
  String get editPreferences => 'Editar preferencias';

  @override
  String get fatLabel => 'Grasas';

  @override
  String get foodRestrictions => 'Restricciones alimentarias';

  @override
  String get foodDislikesHint =>
      'Alimentos no deseados, alergias o solicitudes especiales...';

  @override
  String get goalAchievementLabel => 'Logro de objetivos';

  @override
  String get groceryBudget => 'Presupuesto de compras';

  @override
  String get mealsPerDay => 'Comidas por día';

  @override
  String get monthlyLabel => 'Mensual';

  @override
  String get proteinLabel => 'Proteínas';

  @override
  String get regeneratePlan => 'Regenerar plan';

  @override
  String get sharePlan => 'Compartir plan';

  @override
  String get thisWeekLabel => 'Esta semana';

  @override
  String get topMealLabel => 'Comida principal';

  @override
  String get waterLabel => 'Agua';

  @override
  String get weightLabel => 'Peso';

  @override
  String get yearlyLabel => 'Anual';

  @override
  String get solidFood => '🍽️  Comida sólida';

  @override
  String get askNutritionHint2 => 'Preguntar sobre nutrición...';

  @override
  String get continueWithApple2 => 'Continuar con Apple';

  @override
  String get continueWithGoogle2 => 'Continuar con Google';

  @override
  String get searchLabel2 => 'Buscar';

  @override
  String get searchFoodsHint2 => 'Buscar alimentos...';
}
