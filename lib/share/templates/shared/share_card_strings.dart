import '../../../models/food_analysis.dart';

/// Locale-aware copy bank for share cards. Faz 5'te ARB'a taşınacak;
/// şimdilik elle yönetilen tablolar.
class ShareCardStrings {
  // Daily-1 (Hero, Full Bleed, Polaroid, Magazine)
  final String heroTitle;
  final String magazineTitle;
  final String polaroidCaption;

  // Common labels
  final String kcalLabel;
  final String proteinLabel;
  final String carbLabel;
  final String fatLabel;
  final String mealsRecordedSuffix;
  final String volPrefix;
  final String issuePrefix;
  final String totalLabel;
  final String dailyTotalLabel;
  final String hourLabel;
  final String mealLabel;

  // Eyebrows
  final String dailyJournalEyebrow; // "Bugünün Günlüğü"
  final String todayEyebrow; // "Bugün"

  // Daily-2 titles
  final String twoMealsOneGoalLine1; // "2 öğün,"
  final String twoMealsOneGoalLine2; // "1 hedef."

  // Daily-3 titles (one per template)
  final String threeMealsOneGoalLine1; // "3 öğün,"
  final String threeMealsOneGoalLine2; // "1 hedef."
  final String everyMealLoggedLine1; // "Her öğün"
  final String everyMealLoggedLine2; // "kayıtta."
  final String detailContinuityLine1; // "Detayda"
  final String detailContinuityLine2; // "devamlılık."
  final String mindfulPlatesLine1; // "Bilinçli"
  final String mindfulPlatesLine2; // "tabaklar."
  final String threeMealsFullControlLine1; // "3 öğün,"
  final String threeMealsFullControlLine2; // "tam kontrol."
  final String plateToTicketLine1; // "Tabaktan"
  final String plateToTicketLine2; // "biletine."

  // Daily-4 / Daily-5 titles
  final String fourMealsControlLine1; // "4 öğün,"
  final String fourMealsControlLine2; // "kontrol."
  final String fiveMealsFullTempoLine1; // "5 öğün,"
  final String fiveMealsFullTempoLine2; // "tam tempo."
  final String mealsBalancedLine1; // "Bilinçli"
  final String mealsBalancedLine2; // "tabaklar."
  final String plateToTicketShortLine1; // "Tabaktan"
  final String plateToTicketShortLine2; // "biletine."

  // Weekly titles
  final String weeklyEyebrow; // "Geçen 7 Gün"
  final String weeklyDenseTitle; // "Hafta\nözeti." (mocks vary)
  final String weeklyFullTitle; // "7 gün,\ntam görüntü."

  // Misc
  final String checkMarkPrefix; // "✓"
  final String Function(MealCategory) eyebrowFor; // long "BUGÜNÜN KAHVALTISI"
  final String Function(MealCategory) mealTag; // short "KAHVALTI"

  const ShareCardStrings._({
    required this.heroTitle,
    required this.magazineTitle,
    required this.polaroidCaption,
    required this.kcalLabel,
    required this.proteinLabel,
    required this.carbLabel,
    required this.fatLabel,
    required this.mealsRecordedSuffix,
    required this.volPrefix,
    required this.issuePrefix,
    required this.totalLabel,
    required this.dailyTotalLabel,
    required this.hourLabel,
    required this.mealLabel,
    required this.dailyJournalEyebrow,
    required this.todayEyebrow,
    required this.twoMealsOneGoalLine1,
    required this.twoMealsOneGoalLine2,
    required this.threeMealsOneGoalLine1,
    required this.threeMealsOneGoalLine2,
    required this.everyMealLoggedLine1,
    required this.everyMealLoggedLine2,
    required this.detailContinuityLine1,
    required this.detailContinuityLine2,
    required this.mindfulPlatesLine1,
    required this.mindfulPlatesLine2,
    required this.threeMealsFullControlLine1,
    required this.threeMealsFullControlLine2,
    required this.plateToTicketLine1,
    required this.plateToTicketLine2,
    required this.fourMealsControlLine1,
    required this.fourMealsControlLine2,
    required this.fiveMealsFullTempoLine1,
    required this.fiveMealsFullTempoLine2,
    required this.mealsBalancedLine1,
    required this.mealsBalancedLine2,
    required this.plateToTicketShortLine1,
    required this.plateToTicketShortLine2,
    required this.weeklyEyebrow,
    required this.weeklyDenseTitle,
    required this.weeklyFullTitle,
    required this.checkMarkPrefix,
    required this.eyebrowFor,
    required this.mealTag,
  });

  static ShareCardStrings of(String locale) =>
      _bank[locale.toLowerCase()] ?? _bank['tr']!;

  static final Map<String, ShareCardStrings> _bank = {
    'tr': ShareCardStrings._(
      heroTitle: 'Hedefe\ntam isabet.',
      magazineTitle: 'Tabakta denge.',
      polaroidCaption: 'Bugünün öğünü ✦',
      kcalLabel: 'KALORİ',
      proteinLabel: 'PROTEİN',
      carbLabel: 'KARB',
      fatLabel: 'YAĞ',
      mealsRecordedSuffix: 'KAYITLI',
      volPrefix: 'VOL.',
      issuePrefix: 'ISSUE',
      totalLabel: 'TOPLAM',
      dailyTotalLabel: 'GÜNÜN TOPLAMI',
      hourLabel: 'SAAT',
      mealLabel: 'ÖĞÜN',
      dailyJournalEyebrow: 'BUGÜNÜN GÜNLÜĞÜ',
      todayEyebrow: 'BUGÜN',
      twoMealsOneGoalLine1: '2 öğün,',
      twoMealsOneGoalLine2: '1 hedef.',
      threeMealsOneGoalLine1: '3 öğün,',
      threeMealsOneGoalLine2: '1 hedef.',
      everyMealLoggedLine1: 'Her öğün',
      everyMealLoggedLine2: 'kayıtta.',
      detailContinuityLine1: 'Detayda',
      detailContinuityLine2: 'devamlılık.',
      mindfulPlatesLine1: 'Bilinçli',
      mindfulPlatesLine2: 'tabaklar.',
      threeMealsFullControlLine1: '3 öğün,',
      threeMealsFullControlLine2: 'tam kontrol.',
      plateToTicketLine1: 'Tabaktan',
      plateToTicketLine2: 'biletine.',
      fourMealsControlLine1: '4 öğün,',
      fourMealsControlLine2: 'kontrol.',
      fiveMealsFullTempoLine1: '5 öğün,',
      fiveMealsFullTempoLine2: 'tam tempo.',
      mealsBalancedLine1: 'Bilinçli',
      mealsBalancedLine2: 'tabaklar.',
      plateToTicketShortLine1: 'Tabaktan',
      plateToTicketShortLine2: 'biletine.',
      weeklyEyebrow: 'GEÇEN 7 GÜN',
      weeklyDenseTitle: 'Hafta\nözeti.',
      weeklyFullTitle: '7 gün,\ntam görüntü.',
      checkMarkPrefix: '✓',
      eyebrowFor: (c) {
        switch (c) {
          case MealCategory.breakfast:
            return 'BUGÜNÜN KAHVALTISI';
          case MealCategory.lunch:
            return 'BUGÜNÜN ÖĞLE YEMEĞİ';
          case MealCategory.dinner:
            return 'BUGÜNÜN AKŞAM YEMEĞİ';
          case MealCategory.snack:
            return 'BUGÜNÜN ARA ÖĞÜNÜ';
        }
      },
      mealTag: (c) {
        switch (c) {
          case MealCategory.breakfast:
            return 'KAHVALTI';
          case MealCategory.lunch:
            return 'ÖĞLE';
          case MealCategory.dinner:
            return 'AKŞAM';
          case MealCategory.snack:
            return 'ARA ÖĞÜN';
        }
      },
    ),
    'en': ShareCardStrings._(
      heroTitle: 'Right on\nthe target.',
      magazineTitle: 'Balanced plate.',
      polaroidCaption: "Today's meal ✦",
      kcalLabel: 'KCAL',
      proteinLabel: 'PROTEIN',
      carbLabel: 'CARB',
      fatLabel: 'FAT',
      mealsRecordedSuffix: 'LOGGED',
      volPrefix: 'VOL.',
      issuePrefix: 'ISSUE',
      totalLabel: 'TOTAL',
      dailyTotalLabel: "TODAY'S TOTAL",
      hourLabel: 'TIME',
      mealLabel: 'MEAL',
      dailyJournalEyebrow: "TODAY'S JOURNAL",
      todayEyebrow: 'TODAY',
      twoMealsOneGoalLine1: '2 meals,',
      twoMealsOneGoalLine2: '1 goal.',
      threeMealsOneGoalLine1: '3 meals,',
      threeMealsOneGoalLine2: '1 goal.',
      everyMealLoggedLine1: 'Every meal',
      everyMealLoggedLine2: 'logged.',
      detailContinuityLine1: 'Detailed',
      detailContinuityLine2: 'consistency.',
      mindfulPlatesLine1: 'Mindful',
      mindfulPlatesLine2: 'plates.',
      threeMealsFullControlLine1: '3 meals,',
      threeMealsFullControlLine2: 'full control.',
      plateToTicketLine1: 'From plate',
      plateToTicketLine2: 'to ticket.',
      fourMealsControlLine1: '4 meals,',
      fourMealsControlLine2: 'in control.',
      fiveMealsFullTempoLine1: '5 meals,',
      fiveMealsFullTempoLine2: 'full tempo.',
      mealsBalancedLine1: 'Mindful',
      mealsBalancedLine2: 'plates.',
      plateToTicketShortLine1: 'From plate',
      plateToTicketShortLine2: 'to ticket.',
      weeklyEyebrow: 'LAST 7 DAYS',
      weeklyDenseTitle: 'Week\nrecap.',
      weeklyFullTitle: '7 days,\nfull view.',
      checkMarkPrefix: '✓',
      eyebrowFor: (c) {
        switch (c) {
          case MealCategory.breakfast:
            return "TODAY'S BREAKFAST";
          case MealCategory.lunch:
            return "TODAY'S LUNCH";
          case MealCategory.dinner:
            return "TODAY'S DINNER";
          case MealCategory.snack:
            return "TODAY'S SNACK";
        }
      },
      mealTag: (c) {
        switch (c) {
          case MealCategory.breakfast:
            return 'BREAKFAST';
          case MealCategory.lunch:
            return 'LUNCH';
          case MealCategory.dinner:
            return 'DINNER';
          case MealCategory.snack:
            return 'SNACK';
        }
      },
    ),
  };
}
