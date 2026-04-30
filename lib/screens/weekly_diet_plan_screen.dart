import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import '../services/api/diet_plan_service.dart';
import '../services/api/nutrition_service.dart';
import '../utils/error_messages.dart';
import 'diet_profile_edit_screen.dart';

// ── Data models ───────────────────────────────────────────────────────────────
class DietMealFood {
  final String id;
  final int position;
  final String name;
  final String portionDescription;
  final double quantity;
  final String unit;
  final String? foodId;

  const DietMealFood({
    required this.id,
    required this.position,
    required this.name,
    required this.portionDescription,
    required this.quantity,
    required this.unit,
    this.foodId,
  });
}

class DietMeal {
  final String id;
  final String name;
  final String category;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String time;
  final String emoji;
  final List<DietMealFood> foods;
  final bool completed;

  const DietMeal({
    this.id = '',
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
    required this.emoji,
    this.foods = const [],
    this.completed = false,
  });

  DietMeal copyWith({bool? completed}) => DietMeal(
        id: id,
        name: name,
        category: category,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        time: time,
        emoji: emoji,
        foods: foods,
        completed: completed ?? this.completed,
      );
}

class DietDay {
  final String dayName;
  final DateTime? date;
  final List<DietMeal> meals;
  final int totalCalories;

  const DietDay({required this.dayName, this.date, required this.meals, required this.totalCalories});
}

class DietPlan {
  final int dailyCalorieGoal;
  final List<DietDay> days;
  final DateTime generatedAt;

  const DietPlan({required this.dailyCalorieGoal, required this.days, required this.generatedAt});
}

// ── Screen ────────────────────────────────────────────────────────────────────
class WeeklyDietPlanScreen extends StatefulWidget {
  final DietPlan plan;
  final Map<String, dynamic> anamnesisData;
  // EAT-188: Bottom-nav embed durumunda back arrow gizlenir.
  final bool showBackButton;

  const WeeklyDietPlanScreen({
    super.key,
    required this.plan,
    required this.anamnesisData,
    this.showBackButton = true,
  });

  @override
  State<WeeklyDietPlanScreen> createState() => _WeeklyDietPlanScreenState();
}

class _WeeklyDietPlanScreenState extends State<WeeklyDietPlanScreen> {
  int _selectedDay = 0;

  // EAT-138: swap sonrası lokal mutable state (session-only).
  late List<DietDay> _days;

  @override
  void initState() {
    super.initState();
    _days = widget.plan.days.toList();
  }

  void _applySwap(int dayIndex, int mealIndex, DietMeal newMeal) {
    setState(() {
      final day = _days[dayIndex];
      final newMeals = List<DietMeal>.from(day.meals);
      newMeals[mealIndex] = newMeal;
      final total = newMeals.fold<int>(0, (s, m) => s + m.calories);
      _days[dayIndex] = DietDay(
        dayName: day.dayName,
        date: day.date,
        meals: newMeals,
        totalCalories: total,
      );
    });
  }

  bool _isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  // EAT-172: BE auto-revert plan'da değişiklik yapmış olabilir (linked food
  // entry silindiyse meal.completed = false). Pull-to-refresh ve
  // complete/uncomplete sonrası planın tamamı yeniden çekilir.
  Future<void> _refreshPlan() async {
    try {
      final fresh = await DietPlanService.instance.getActivePlan();
      if (!mounted || fresh == null) return;
      setState(() => _days = fresh.days.toList());
    } catch (_) {
      // Sessiz düş — UI bozulmasın.
    }
  }

  Future<void> _toggleMealEaten(int dayIndex, int mealIndex) async {
    final meal = _days[dayIndex].meals[mealIndex];
    if (meal.id.isEmpty) return;
    final wasCompleted = meal.completed;

    // Optimistic update.
    setState(() {
      final day = _days[dayIndex];
      final newMeals = List<DietMeal>.from(day.meals);
      newMeals[mealIndex] = meal.copyWith(completed: !wasCompleted);
      _days[dayIndex] = DietDay(
        dayName: day.dayName,
        date: day.date,
        meals: newMeals,
        totalCalories: day.totalCalories,
      );
    });
    HapticFeedback.lightImpact();

    try {
      if (wasCompleted) {
        await DietPlanService.instance.uncompleteMeal(meal.id);
      } else {
        await DietPlanService.instance.completeMeal(meal.id);
      }
      // BE otomatik FoodAnalysis link'lerini günceller; planı yeniden çek.
      await _refreshPlan();
    } catch (e) {
      if (!mounted) return;
      // Rollback.
      setState(() {
        final day = _days[dayIndex];
        final newMeals = List<DietMeal>.from(day.meals);
        newMeals[mealIndex] = meal.copyWith(completed: wasCompleted);
        _days[dayIndex] = DietDay(
          dayName: day.dayName,
          date: day.date,
          meals: newMeals,
          totalCalories: day.totalCalories,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).errorGeneric),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    final selectedDayPlan = _days[_selectedDay];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Row(
                children: [
                  if (widget.showBackButton) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(10.r),
                          border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp, color: textPrimary),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your 7-Day Plan',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        Text(
                          '${widget.plan.dailyCalorieGoal} kcal/day target',
                          style: TextStyle(fontSize: 12.sp, color: textMuted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showPlanOptions(context, isDark, accent, accentFg),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(10.r),
                        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                      ),
                      child: Icon(Icons.more_horiz_rounded, size: 20.sp, color: textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Day selector
            SizedBox(
              height: 72.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _days.length,
                itemBuilder: (context, i) {
                  final day = _days[i];
                  final isSelected = _selectedDay == i;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDay = i);
                      HapticFeedback.selectionClick();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected ? accent : (isDark ? AppColors.darkCard : AppColors.lightCard),
                        borderRadius: BorderRadius.circular(14.r),
                        border: isSelected ? null : Border.all(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.dayName.substring(0, 3),
                            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: isSelected ? accentFg : textMuted),
                          ),
                          SizedBox(height: 2.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(fontWeight: FontWeight.w800, color: isSelected ? accentFg : textPrimary, height: 1.0),
                              children: [
                                TextSpan(
                                  text: '${day.totalCalories}',
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                TextSpan(
                                  text: ' kcal',
                                  style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600, color: (isSelected ? accentFg : textMuted)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 12.h),

            // Meals list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshPlan,
                color: accent,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: selectedDayPlan.meals.length + 1, // +1 for summary
                  itemBuilder: (context, i) {
                    if (i == selectedDayPlan.meals.length) {
                      return _DaySummaryCard(day: selectedDayPlan, isDark: isDark, accent: accent, accentFg: accentFg);
                    }
                    final meal = selectedDayPlan.meals[i];
                    return _MealCard(
                      meal: meal,
                      isToday: _isToday(selectedDayPlan.date),
                      isDark: isDark,
                      accent: accent,
                      onTap: () => _showMealDetail(
                        context,
                        meal,
                        _selectedDay,
                        i,
                        isDark,
                        accent,
                        accentFg,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetail(BuildContext context, DietMeal meal, int dayIndex, int mealIndex, bool isDark, Color accent, Color accentFg) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final isToday = _isToday(_days[dayIndex].date);
    final l = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(meal.emoji, style: TextStyle(fontSize: 28.sp)),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: textPrimary),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          _TagPill(label: meal.category, isDark: isDark),
                          SizedBox(width: 6.w),
                          _TagPill(label: '🕐 ${meal.time}', isDark: isDark),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // Calories big
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${meal.calories}',
                      style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w800, color: accent),
                    ),
                    Text(
                      'kcal',
                      style: TextStyle(fontSize: 13.sp, color: textMuted),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            // Macros row
            Row(
              children: [
                _MacroBox(label: 'Protein', value: '${meal.protein}g', color: isDark ? AppColors.violet : AppColors.violetDark, isDark: isDark),
                SizedBox(width: 8.w),
                _MacroBox(label: 'Carbs', value: '${meal.carbs}g', color: isDark ? AppColors.amber : AppColors.amberDark, isDark: isDark),
                SizedBox(width: 8.w),
                _MacroBox(label: 'Fat', value: '${meal.fat}g', color: isDark ? AppColors.coral : AppColors.coralDark, isDark: isDark),
              ],
            ),
            if (meal.foods.isNotEmpty) ...[
              SizedBox(height: 24.h),
              Text(
                Localizations.localeOf(context).languageCode == 'tr' ? 'Önerilen yemekler' : 'Suggested foods',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: 0.4),
              ),
              SizedBox(height: 10.h),
              ...meal.foods.map(
                (f) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('•  ', style: TextStyle(fontSize: 14.sp, color: accent, fontWeight: FontWeight.w800)),
                      Expanded(
                        child: Text(
                          _formatFood(f),
                          style: TextStyle(fontSize: 13.sp, color: textPrimary, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 24.h),
            Row(
              children: [
                // EAT-138: swap meal
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSwapSheet(context, meal, dayIndex, mealIndex, isDark, accent, accentFg);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: accent,
                      side: BorderSide(color: accent, width: 1.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    icon: Icon(Icons.swap_horiz_rounded, size: 18.sp),
                    label: Text(
                      Localizations.localeOf(context).languageCode == 'tr' ? 'Değiştir' : 'Swap',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: isToday
                      ? ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _toggleMealEaten(dayIndex, mealIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: meal.completed
                                ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
                                : accent,
                            foregroundColor: meal.completed ? textPrimary : accentFg,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                          ),
                          icon: Icon(
                            meal.completed ? Icons.undo_rounded : Icons.restaurant_menu_rounded,
                            size: 16.sp,
                          ),
                          label: Text(
                            meal.completed ? l.dietPlanMarkNotEaten : l.dietPlanIAteThis,
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: accentFg,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                          ),
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'tr' ? 'Tamam' : 'Got it',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFood(DietMealFood f) {
    final qty = f.quantity > 0
        ? '${f.quantity == f.quantity.roundToDouble() ? f.quantity.toInt() : f.quantity.toStringAsFixed(1)}${f.unit.isNotEmpty ? ' ${f.unit}' : ''} '
        : '';
    final desc = f.portionDescription.isNotEmpty ? ' · ${f.portionDescription}' : '';
    return '$qty${f.name}$desc';
  }

  /// EAT-138: `nutrition.recommendMeal` ile alternatif öneri al ve lokalde swap et.
  /// Persistence out-of-scope (follow-up ticket: backend `replaceMeal` mutation).
  Future<void> _showSwapSheet(
    BuildContext context,
    DietMeal currentMeal,
    int dayIndex,
    int mealIndex,
    bool isDark,
    Color accent,
    Color accentFg,
  ) async {
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    // Loading sheet.
    RecommendedMeal? rec;
    String? errorMsg;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            // Lazy trigger only once.
            if (rec == null && errorMsg == null) {
              Future<void>(() async {
                try {
                  final r = await NutritionService.instance
                      .recommendMeal(currentMeal.category);
                  if (!sheetCtx.mounted) return;
                  setS(() => rec = r);
                } catch (e) {
                  if (!sheetCtx.mounted) return;
                  setS(() => errorMsg = localizedError(sheetCtx, e));
                }
              });
            }

            final content = rec != null
                ? _buildSwapAlternativeBody(
                    context,
                    rec!,
                    currentMeal,
                    isDark,
                    accent,
                    accentFg,
                    textPrimary,
                    textMuted,
                    cardBg,
                    isTr,
                    onAccept: () {
                      _applySwap(
                        dayIndex,
                        mealIndex,
                        DietMeal(
                          name: rec!.items.isNotEmpty
                              ? rec!.items.map((i) => i.name).take(3).join(' + ')
                              : currentMeal.name,
                          category: currentMeal.category,
                          calories: rec!.actualCalories.round(),
                          protein: rec!.actualProtein.round(),
                          carbs: rec!.actualCarbs.round(),
                          fat: rec!.actualFat.round(),
                          time: currentMeal.time,
                          emoji: currentMeal.emoji,
                        ),
                      );
                      Navigator.pop(sheetCtx);
                    },
                  )
                : errorMsg != null
                    ? _buildSwapErrorBody(isTr, textPrimary, textMuted)
                    : _buildSwapLoadingBody(accent, textMuted, isTr);

            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: content,
            );
          },
        );
      },
    );
  }

  Widget _buildSwapLoadingBody(Color accent, Color textMuted, bool isTr) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),
        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(accent)),
        SizedBox(height: 16.h),
        Text(
          isTr ? 'Alternatif hazırlanıyor…' : 'Finding an alternative…',
          style: TextStyle(fontSize: 13.sp, color: textMuted),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSwapErrorBody(bool isTr, Color textPrimary, Color textMuted) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.h),
        Icon(Icons.error_outline_rounded, size: 40.sp, color: Colors.orange),
        SizedBox(height: 12.h),
        Text(
          isTr ? 'Alternatif bulunamadı' : 'No alternative found',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        SizedBox(height: 6.h),
        Text(
          isTr
              ? 'Daha sonra tekrar dene veya günün tamamını yeniden oluştur.'
              : 'Try again later or regenerate the whole day.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.4),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildSwapAlternativeBody(
    BuildContext sheetContext,
    RecommendedMeal rec,
    DietMeal current,
    bool isDark,
    Color accent,
    Color accentFg,
    Color textPrimary,
    Color textMuted,
    Color cardBg,
    bool isTr, {
    required VoidCallback onAccept,
  }) {
    final items = rec.items;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          isTr ? 'Alternatif öneri' : 'Alternative suggestion',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        SizedBox(height: 6.h),
        Text(
          '${rec.actualCalories.round()} kcal · ${rec.actualProtein.round()}g P · ${rec.actualCarbs.round()}g C · ${rec.actualFat.round()}g F',
          style: TextStyle(fontSize: 12.sp, color: textMuted),
        ),
        SizedBox(height: 16.h),
        if (items.isNotEmpty)
          ...items.take(5).map(
                (item) => Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(isDark ? 0.08 : 0.06),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textPrimary),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '${item.portionGrams.toStringAsFixed(0)}g · ${item.calories.round()} kcal',
                              style: TextStyle(fontSize: 11.sp, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                      if (item.role.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            item.role,
                            style: TextStyle(fontSize: 10.sp, color: accent, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(sheetContext),
                style: OutlinedButton.styleFrom(
                  foregroundColor: textMuted,
                  side: BorderSide(color: isDark ? AppColors.darkSurface : AppColors.lightBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  isTr ? 'Vazgeç' : 'Cancel',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: accentFg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  elevation: 0,
                ),
                child: Text(
                  isTr ? 'Bunu kullan' : 'Use this',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPlanOptions(BuildContext context, bool isDark, Color accent, Color accentFg) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            SizedBox(height: 20.h),
            _BottomSheetOption(
              icon: Icons.edit_rounded,
              label: 'Edit Preferences',
              color: isDark ? AppColors.amber : AppColors.void_,
              textColor: textPrimary,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context); // close sheet
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DietProfileEditScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Meal Card ─────────────────────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  final DietMeal meal;
  final bool isToday;
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  const _MealCard({required this.meal, required this.isToday, required this.isDark, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final showEatenBadge = isToday && meal.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: showEatenBadge
              ? Border.all(color: accent.withValues(alpha: 0.5), width: 1.2)
              : (isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(meal.emoji, style: TextStyle(fontSize: 22.sp)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          meal.name,
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showEatenBadge) ...[
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_rounded, size: 11.sp, color: accent),
                              SizedBox(width: 2.w),
                              Text(
                                AppLocalizations.of(context).dietPlanEatenLabel,
                                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: accent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Text(
                        meal.category,
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                      Text(
                        meal.time,
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories}',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: accent),
                ),
                Text(
                  'kcal',
                  style: TextStyle(fontSize: 10.sp, color: textMuted),
                ),
              ],
            ),
            SizedBox(width: 6.w),
            Icon(Icons.chevron_right_rounded, size: 18.sp, color: textMuted),
          ],
        ),
      ),
    );
  }
}

// ── Day Summary Card ──────────────────────────────────────────────────────────
class _DaySummaryCard extends StatelessWidget {
  final DietDay day;
  final bool isDark;
  final Color accent;
  final Color accentFg;

  const _DaySummaryCard({required this.day, required this.isDark, required this.accent, required this.accentFg});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    final totalProtein = day.meals.fold(0, (s, m) => s + m.protein);
    final totalCarbs = day.meals.fold(0, (s, m) => s + m.carbs);
    final totalFat = day.meals.fold(0, (s, m) => s + m.fat);

    return Container(
      margin: EdgeInsets.only(bottom: 24.h, top: 4.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day Total',
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.5),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${day.totalCalories}',
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: accent),
                  ),
                  Text(
                    'kcal total',
                    style: TextStyle(fontSize: 11.sp, color: textMuted),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  _SummaryMacro(label: 'Protein', value: '${totalProtein}g', color: isDark ? AppColors.violet : AppColors.violetDark),
                  SizedBox(height: 4.h),
                  _SummaryMacro(label: 'Carbs', value: '${totalCarbs}g', color: isDark ? AppColors.amber : AppColors.amberDark),
                  SizedBox(height: 4.h),
                  _SummaryMacro(label: 'Fat', value: '${totalFat}g', color: isDark ? AppColors.coral : AppColors.coralDark),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Macro bar
          _MacroBar(protein: totalProtein, carbs: totalCarbs, fat: totalFat, isDark: isDark),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'P ${totalProtein}g',
                style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.violet : AppColors.violetDark),
              ),
              Text(
                'C ${totalCarbs}g',
                style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.amber : AppColors.amberDark),
              ),
              Text(
                'F ${totalFat}g',
                style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.coral : AppColors.coralDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final int protein, carbs, fat;
  final bool isDark;

  const _MacroBar({required this.protein, required this.carbs, required this.fat, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final total = (protein * 4 + carbs * 4 + fat * 9).toDouble();
    if (total == 0) return const SizedBox.shrink();

    final pFrac = (protein * 4) / total;
    final cFrac = (carbs * 4) / total;
    final fFrac = (fat * 9) / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Row(
        children: [
          Flexible(
            flex: (pFrac * 100).round(),
            child: Container(height: 6, color: isDark ? AppColors.violet : AppColors.violetDark),
          ),
          Flexible(
            flex: (cFrac * 100).round(),
            child: Container(height: 6, color: isDark ? AppColors.amber : AppColors.amberDark),
          ),
          Flexible(
            flex: (fFrac * 100).round(),
            child: Container(height: 6, color: isDark ? AppColors.coral : AppColors.coralDark),
          ),
        ],
      ),
    );
  }
}

class _SummaryMacro extends StatelessWidget {
  final String label, value;
  final Color color;

  const _SummaryMacro({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label  $value',
          style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
class _TagPill extends StatelessWidget {
  final String label;
  final bool isDark;

  const _TagPill({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightSurface, borderRadius: BorderRadius.circular(6.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MacroBox extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool isDark;

  const _MacroBox({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: color),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: color.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, textColor;
  final bool isDark;
  final VoidCallback onTap;

  const _BottomSheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(color: isDark ? AppColors.darkBg : AppColors.lightBg, borderRadius: BorderRadius.circular(14.r)),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
