// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'eatiq';

  @override
  String get tagline => 'Сфотографируй. Узнай, что ешь.';

  @override
  String get getStarted => 'Начать';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get signIn => 'Войти';

  @override
  String get skip => 'Пропустить';

  @override
  String get continueBtn => 'Продолжить';

  @override
  String get letsGo => 'Поехали';

  @override
  String get back => 'Назад';

  @override
  String get save => 'Сохранить';

  @override
  String get done => 'Готово';

  @override
  String get cancel => 'Отмена';

  @override
  String get onboardingHello => 'Привет! 👋';

  @override
  String get onboardingNameSub => 'Давай познакомимся. Как тебя зовут?';

  @override
  String get onboardingNameHint => 'Введи своё имя...';

  @override
  String get onboardingNameRequired => 'Пожалуйста, введи своё имя';

  @override
  String get onboardingBody => 'Узнай своё тело';

  @override
  String get onboardingBodySub => 'Рассчитаем твою цель по калориям.';

  @override
  String get onboardingGoal => 'Какова твоя цель?';

  @override
  String get onboardingGoalSub =>
      'Скорректируем цель по калориям в соответствии с ней.';

  @override
  String get onboardingTheme => 'Внешний вид';

  @override
  String get onboardingThemeSub => 'Можно изменить позже.';

  @override
  String get male => 'Мужской';

  @override
  String get female => 'Женский';

  @override
  String get age => 'Возраст';

  @override
  String get height => 'Рост';

  @override
  String get weight => 'Вес';

  @override
  String get ageUnit => 'лет';

  @override
  String get heightUnit => 'см';

  @override
  String get weightUnit => 'кг';

  @override
  String get goalLose => 'Похудеть';

  @override
  String get goalLoseSub => 'С постепенным дефицитом калорий';

  @override
  String get goalMaintain => 'Поддержать вес';

  @override
  String get goalMaintainSub => 'Сбалансированное и здоровое питание';

  @override
  String get goalGain => 'Набрать вес';

  @override
  String get goalGainSub => 'Наращивание мышечной массы';

  @override
  String get dark => 'Тёмная';

  @override
  String get light => 'Светлая';

  @override
  String greeting(String name) {
    return 'Привет, $name';
  }

  @override
  String get defaultName => 'Ты';

  @override
  String get caloriestoday => 'Калории сегодня';

  @override
  String get todaysMeals => 'Приёмы пищи сегодня';

  @override
  String get noMeals =>
      'Приёмы пищи ещё не добавлены.\nОткрой камеру и отсканируй первое блюдо!';

  @override
  String get protein => 'Белки';

  @override
  String get carbs => 'Углев';

  @override
  String get fat => 'Жиры';

  @override
  String get water => 'Вода';

  @override
  String get analyzing => 'Анализируется...';

  @override
  String get analyzingSub => 'ИИ рассчитывает питательную ценность';

  @override
  String get camera => 'Камера';

  @override
  String get gallery => 'Галерея';

  @override
  String get home => 'Главная';

  @override
  String get scan => 'Сканер';

  @override
  String get progress => 'Прогресс';

  @override
  String get profile => 'Профиль';

  @override
  String get weeklyCalories => 'Калории за неделю';

  @override
  String get macroBreakdown => 'Распределение макросов';

  @override
  String get avgCalories => 'Ср. калории';

  @override
  String get totalScans => 'Всего сканирований';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get editProfile => 'Изменить';

  @override
  String get calorieGoal => 'Цель по калориям';

  @override
  String get language => 'Язык';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get premium => 'Премиум';

  @override
  String get premiumSub => 'Безлимитное сканирование и функции';

  @override
  String get waterAdd => 'Добавить воду';

  @override
  String get waterGoal => 'Цель по воде';

  @override
  String waterGlasses(int count) {
    return '$count стаканов';
  }

  @override
  String get limitReached => 'Достигнут дневной лимит';

  @override
  String get limitReachedSub =>
      'Сегодня использовано 5 бесплатных сканирований.\nСканируй безлимитно с eatiq Pro.';

  @override
  String get unlimitedScans => 'Безлимитное AI-сканирование';

  @override
  String get unlimitedHistory => 'Безлимитная история';

  @override
  String get weeklyReport => 'Еженедельный AI-отчёт';

  @override
  String get turkishDB => 'База турецких блюд';

  @override
  String get goProBtn => 'Pro — Подписаться';

  @override
  String get yearlyDiscount => 'Экономия 44% при годовой подписке';

  @override
  String minutesAgo(int min) {
    return '$min мин назад';
  }

  @override
  String hoursAgo(int hr) {
    return '$hr ч назад';
  }

  @override
  String daysAgo(int count) {
    return '$count дней назад';
  }

  @override
  String get monday => 'Пн';

  @override
  String get tuesday => 'Вт';

  @override
  String get wednesday => 'Ср';

  @override
  String get thursday => 'Чт';

  @override
  String get friday => 'Пт';

  @override
  String get saturday => 'Сб';

  @override
  String get sunday => 'Вс';

  @override
  String get errorGeneric => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get mealBreakfast => 'Завтрак';

  @override
  String get mealLunch => 'Обед';

  @override
  String get mealDinner => 'Ужин';

  @override
  String get mealSnack => 'Перекус';

  @override
  String get settings => 'Настройки';

  @override
  String get unitSystem => 'Система единиц';

  @override
  String get reminders => 'Напоминания';

  @override
  String get notifications => 'Уведомления';

  @override
  String get dailyCalorieGoal => 'Дневная цель по калориям';

  @override
  String get calorieRange => 'От 1200 до 4000 ккал';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get manual => 'Вручную';

  @override
  String get analysisResult => 'Результат анализа';

  @override
  String get detectedIngredients => 'Обнаруженные ингредиенты';

  @override
  String get addedToLog => 'Добавлено в дневник ✓';

  @override
  String get backToHome => 'ОК, На главную';

  @override
  String get mealAutoSaved => 'Прием пищи сохранен автоматически.';

  @override
  String get historyTitle => 'История';

  @override
  String get noScansYet => 'Сканирований пока нет';

  @override
  String get scanFirstMeal => 'Сканируйте первый приём пищи!';

  @override
  String scanCount(int count) {
    return '$count сканирований';
  }

  @override
  String get bodyAnalysis => 'Анализ тела';

  @override
  String get idealWeight => 'Идеальный вес';

  @override
  String get gender => 'Пол';

  @override
  String get goalLabel => 'Цель';

  @override
  String get basalMetabolicRate => 'Базальный метаболизм';

  @override
  String get dailyNeeds => 'Дневная цель';

  @override
  String get bodyInfo => 'Параметры тела';

  @override
  String get mealNameLabel => 'Название блюда';

  @override
  String get categoryLabel => 'Категория';

  @override
  String get portionWeightLabel => 'Вес порции (г) — необязательно';

  @override
  String get portionHint => 'При вводе макросы будут проверены';

  @override
  String get macrosLabel => 'Макросы (г) — необязательно';

  @override
  String get editMeal => 'Редактировать блюдо';

  @override
  String get addManualMeal => 'Добавить блюдо вручную';

  @override
  String get update => 'Обновить';

  @override
  String get bmiLabel => 'ИМТ';

  @override
  String get bmiUnderweight => 'Недостаток веса';

  @override
  String get bmiNormal => 'Идеальный вес';

  @override
  String get bmiOverweight => 'Избыточный вес';

  @override
  String get bmiObese => 'Ожирение';

  @override
  String get bmiMorbidObese => 'Тяжёлое ожирение';

  @override
  String get bmiUnderweightDesc => 'Немного ниже идеального веса';

  @override
  String get bmiNormalDesc => 'Отлично! Вы в здоровом диапазоне веса 🎯';

  @override
  String get bmiOverweightDesc => 'Немного выше здорового веса';

  @override
  String get bmiObeseDesc => 'Рекомендуем похудеть для здоровья';

  @override
  String get bmiMorbidObeseDesc => 'Пожалуйста, проконсультируйтесь с врачом';

  @override
  String get addMeal => '+ Добавить';

  @override
  String get favorites => 'ИЗБРАННОЕ';

  @override
  String get addMealShort => '+ Добавить';

  @override
  String get mealFallback => 'Приём пищи';

  @override
  String get month01 => 'Янв';

  @override
  String get month02 => 'Фев';

  @override
  String get month03 => 'Мар';

  @override
  String get month04 => 'Апр';

  @override
  String get month05 => 'Май';

  @override
  String get month06 => 'Июн';

  @override
  String get month07 => 'Июл';

  @override
  String get month08 => 'Авг';

  @override
  String get month09 => 'Сен';

  @override
  String get month10 => 'Окт';

  @override
  String get month11 => 'Ноя';

  @override
  String get month12 => 'Дек';

  @override
  String get validRequired => 'Обязательное поле';

  @override
  String get validNumber => 'Введите корректное число';

  @override
  String get validPositive => 'Должно быть больше нуля';

  @override
  String get validNegative => 'Не может быть отрицательным';

  @override
  String get validPortionRange => 'Должно быть от 1 до 5000г';

  @override
  String validMacroMax(String macro) {
    return '$macro не может превышать 1000г';
  }

  @override
  String validMacroPortion(String macro, String portion) {
    return '$macro не может превышать вес порции ($portionг)';
  }

  @override
  String validMacroTotal(String total) {
    return 'Общие макросы ($totalг) превышают вес порции';
  }

  @override
  String get validCalRequired => 'Калории обязательны';

  @override
  String get validCalMax => 'Один приём пищи не может превышать 5000 ккал';

  @override
  String validCalInconsistent(String estimated) {
    return 'Несоответствие с макросами (оценка ~$estimated ккал)';
  }

  @override
  String get hintMealName => 'напр. Овсянка, Курица...';

  @override
  String get hintCalories => 'напр. 350';

  @override
  String get hintPortion => 'напр. 200';

  @override
  String get hintProtein => 'Белки';

  @override
  String get hintCarbs => 'Углеводы';

  @override
  String get hintFat => 'Жиры';

  @override
  String get unitMetric => 'Метрическая';

  @override
  String get unitImperial => 'Имперская';

  @override
  String get userFallback => 'Ты';

  @override
  String get mealNameRequired => 'Название блюда обязательно';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get appleHealth => 'Apple Health';

  @override
  String get appleHealthSub => 'Синхронизация еды и воды';

  @override
  String get appleHealthDenied =>
      'Доступ к Apple Health отклонён. Откройте Настройки → Конфиденциальность → Здоровье → Eatiq.';

  @override
  String get goToSettings => 'Открыть Настройки';

  @override
  String get barcode => 'Штрихкод';

  @override
  String get barcodeHint => 'Совместите штрихкод с рамкой';

  @override
  String get barcodeSearching => 'Поиск продукта...';

  @override
  String get barcodeNotFound => 'Продукт не найден. Попробуйте ручной ввод.';

  @override
  String get noWeightData => 'Нет данных о весе.';

  @override
  String get noWeightDataHint => 'Введите вес в разделе Профиль.';

  @override
  String streakDays(int count) {
    return '$count Дней подряд';
  }

  @override
  String get streakMotivation => 'Добавляйте каждый день!';

  @override
  String get streakMilestone7 => '1 неделя подряд! Так держать. 🎉';

  @override
  String get streakMilestone30 => '1 месяц подряд! Потрясающе! 🏆';

  @override
  String get activityLevel => 'Насколько вы активны?';

  @override
  String get activityLevelSub => 'Выберите ваш ежедневный уровень активности';

  @override
  String get activitySedentary => 'Скромный';

  @override
  String get activitySedentarySub => 'Мало или совсем без упражнений';

  @override
  String get activityLight => 'Слегка активный';

  @override
  String get activityLightSub => 'Легкие упражнения 1-3 дня/нед';

  @override
  String get activityActive => 'Активный';

  @override
  String get activityActiveSub => 'Умеренные упражнения 3-5 дней/нед';

  @override
  String get activityVery => 'Очень активный';

  @override
  String get activityVerySub => 'Тяжелые упражнения 6-7 дней/нед';

  @override
  String get onboardingSummaryTitle => 'Вы готовы! 🎉';

  @override
  String get onboardingSummarySub => 'Вот ваша персональная ежедневная цель.';

  @override
  String get onboardingRecommend => 'Рекомендуемые ежедневные калории';

  @override
  String get onboardingGender => 'Каков ваш пол?';

  @override
  String get onboardingGenderSub => 'Используется для расчета обмена веществ.';

  @override
  String get onboardingAge => 'Сколько вам лет?';

  @override
  String get onboardingAgeSub => 'Используется для расчета обмена веществ.';

  @override
  String get onboardingHeightWeight => 'Рост и вес';

  @override
  String get onboardingHeightWeightSub =>
      'Необходимо для ИМТ и дневных калорий.';

  @override
  String get waterToday => 'Вода сегодня';

  @override
  String get reset => 'Сброс';

  @override
  String get confirmDelete => 'Все данные будут сброшены. Вы уверены?';

  @override
  String get dailySummaryTitle => 'Итоги дня 📊';

  @override
  String dailySummaryBody(String cal, String goal, String water) {
    return 'Сегодня вы потребили $cal/$goal ккал и $waterл воды. Так держать!';
  }

  @override
  String get goalAchievement => 'Достижение цели';

  @override
  String get consistency => 'Постоянство';

  @override
  String get topDay => 'Лучший день';

  @override
  String get avgWater => 'Ср. вода';

  @override
  String get weeklyInsight => 'Анализ недели';

  @override
  String get monthlyInsight => 'Анализ месяца';

  @override
  String get mostConsumedMeal => 'Самый частый приём пищи';

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
  String get navDaily => 'Ежедневно';

  @override
  String get navProgram => 'Программа';

  @override
  String get stepsToday => 'Шаги';

  @override
  String stepsGoal(String steps, String goal) {
    return '$steps / $goal';
  }

  @override
  String get caloriesBurned => 'сожжено';

  @override
  String get thirtyDays => '30 Дней';

  @override
  String get avgPerDay => 'ср. / день';

  @override
  String get mealsLoggedLabel => 'приёмов пищи';

  @override
  String get caloriesChartTitle => 'Калории';

  @override
  String get noDataYet => 'Данных пока нет';

  @override
  String get recentLogs => 'Последние записи';

  @override
  String get currentLabel => 'текущий';

  @override
  String get targetLabel => 'цель';

  @override
  String get noGoalSet => 'Цель не задана';

  @override
  String kcalRemainingGoal(String remaining, String goal) {
    return 'Осталось $remaining ккал · цель $goal';
  }

  @override
  String weightLostLabel(String amount, String unit) {
    return '↓ $amount $unit потеряно';
  }

  @override
  String weightGainedLabel(String amount, String unit) {
    return '↑ $amount $unit набрано';
  }

  @override
  String get weightStable => 'Стабильный вес';

  @override
  String get foodSearch => 'Поиск еды';

  @override
  String get searchFoodsHint => 'Поиск продуктов...';

  @override
  String get noFoodsFound => 'Продукты не найдены';

  @override
  String get addToLog => 'В дневник';

  @override
  String foodAddedToLog(String name) {
    return '$name добавлено в дневник';
  }

  @override
  String portionGrams(String grams) {
    return 'Порция: $grams г';
  }

  @override
  String foodCount(int count) {
    return '$count продуктов';
  }

  @override
  String get categoryAll => 'Все';

  @override
  String get categoryDairy => 'Молочные продукты';

  @override
  String get categoryFruit => 'Фрукты';

  @override
  String get categoryFats => 'Жиры';

  @override
  String get categoryVegetables => 'Овощи';

  @override
  String get categoryFastFood => 'Фастфуд';

  @override
  String get categorySnacks => 'Перекусы';

  @override
  String get aiDietitian => 'ИИ-диетолог';

  @override
  String get aiPoweredBy => 'На основе eatiq AI';

  @override
  String get onlineLabel => 'Онлайн';

  @override
  String get askNutritionHint => 'Спросите о питании...';

  @override
  String get quickPromptProtein => 'Сколько белка мне нужно?';

  @override
  String get quickPromptFatLoss => 'Лучшие продукты для сжигания жира?';

  @override
  String get quickPromptCalories => 'Нужно ли считать калории?';

  @override
  String get quickPromptMealPrep => 'Советы по подготовке блюд?';

  @override
  String get aiGreeting =>
      'Привет! Я ваш ИИ-диетолог от eatiq. Спросите меня всё о питании, планировании приёмов пищи или о достижении ваших целей здоровья. 🥗';

  @override
  String get signInToEatiq => 'Войти в eatiq';

  @override
  String get signInSubtitle =>
      'Синхронизируйте прогресс на всех устройствах и получайте персонализированные советы по питанию.';

  @override
  String get continueWithApple => 'Продолжить с Apple';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get continueWithoutSignIn => 'Продолжить без входа';

  @override
  String get legalAgreementNote =>
      'Продолжая, вы соглашаетесь с нашими Условиями использования и Политикой конфиденциальности.';

  @override
  String get subscriptionLegal => 'Подписка и правовая информация';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get searchLabel => 'Поиск';

  @override
  String get dietitianLabel => 'Диетолог';

  @override
  String get targetWeight => 'Целевой вес';

  @override
  String goalHitBadge(String pct) {
    return 'Цель $pct% достигнута';
  }

  @override
  String consistencyBadge(String pct) {
    return '$pct% постоянства';
  }

  @override
  String get waterAdd250 => '+250 мл';

  @override
  String get waterAdd500 => '+500 мл';

  @override
  String get waterAdd700 => '+700 мл';

  @override
  String get aiNote => 'Заметка ИИ';

  @override
  String get additionalNotes => 'Дополнительные заметки';

  @override
  String get avgWaterLabel => 'Ср. вода';

  @override
  String get caloriesLabel => 'Калории';

  @override
  String get carbsLabel => 'Углеводы';

  @override
  String get consistencyLabel => 'Постоянство';

  @override
  String get cookingTime => 'Время приготовления';

  @override
  String get cuisinePreferences => 'Кулинарные предпочтения';

  @override
  String get dietitianNav => 'Диетолог';

  @override
  String get editPreferences => 'Изменить настройки';

  @override
  String get fatLabel => 'Жиры';

  @override
  String get foodRestrictions => 'Пищевые ограничения';

  @override
  String get foodDislikesHint =>
      'Нелюбимые продукты, аллергии или особые пожелания...';

  @override
  String get goalAchievementLabel => 'Достижение цели';

  @override
  String get groceryBudget => 'Бюджет на продукты';

  @override
  String get mealsPerDay => 'Приёмов пищи в день';

  @override
  String get monthlyLabel => 'Ежемесячно';

  @override
  String get proteinLabel => 'Белки';

  @override
  String get regeneratePlan => 'Обновить план';

  @override
  String get sharePlan => 'Поделиться планом';

  @override
  String get thisWeekLabel => 'На этой неделе';

  @override
  String get topMealLabel => 'Основной приём пищи';

  @override
  String get waterLabel => 'Вода';

  @override
  String get weightLabel => 'Вес';

  @override
  String get yearlyLabel => 'Ежегодно';

  @override
  String get solidFood => '🍽️  Твёрдая пища';

  @override
  String get askNutritionHint2 => 'Спросите о питании...';

  @override
  String get continueWithApple2 => 'Продолжить с Apple';

  @override
  String get continueWithGoogle2 => 'Продолжить с Google';

  @override
  String get searchLabel2 => 'Поиск';

  @override
  String get searchFoodsHint2 => 'Поиск продуктов...';
}
