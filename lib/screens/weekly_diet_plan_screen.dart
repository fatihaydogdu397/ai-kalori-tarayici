import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'diet_profile_edit_screen.dart';

// ── Data models ───────────────────────────────────────────────────────────────
class DietMeal {
  final String name;
  final String category;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String time;
  final String emoji;

  const DietMeal({
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
    required this.emoji,
  });
}

class DietDay {
  final String dayName;
  final List<DietMeal> meals;
  final int totalCalories;

  const DietDay({
    required this.dayName,
    required this.meals,
    required this.totalCalories,
  });
}

class DietPlan {
  final int dailyCalorieGoal;
  final List<DietDay> days;
  final DateTime generatedAt;

  const DietPlan({
    required this.dailyCalorieGoal,
    required this.days,
    required this.generatedAt,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────────
class WeeklyDietPlanScreen extends StatefulWidget {
  final DietPlan plan;
  final Map<String, dynamic> anamnesisData;

  const WeeklyDietPlanScreen({
    super.key,
    required this.plan,
    required this.anamnesisData,
  });

  @override
  State<WeeklyDietPlanScreen> createState() => _WeeklyDietPlanScreenState();
}

class _WeeklyDietPlanScreenState extends State<WeeklyDietPlanScreen> {
  int _selectedDay = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    final selectedDayPlan = widget.plan.days[_selectedDay];

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your 7-Day Plan', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary)),
                        Text('${widget.plan.dailyCalorieGoal} kcal/day target', style: TextStyle(fontSize: 12.sp, color: textMuted)),
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
                itemCount: widget.plan.days.length,
                itemBuilder: (context, i) {
                  final day = widget.plan.days[i];
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
                        border: isSelected
                            ? null
                            : Border.all(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.dayName.substring(0, 3),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? accentFg : textMuted,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${day.totalCalories}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? accentFg : textPrimary,
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
                    isDark: isDark,
                    accent: accent,
                    onTap: () => _showMealDetail(context, meal, isDark, accent, accentFg),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetail(BuildContext context, DietMeal meal, bool isDark, Color accent, Color accentFg) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

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
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
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
                  child: Center(child: Text(meal.emoji, style: TextStyle(fontSize: 28.sp))),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meal.name, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: textPrimary)),
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
                    Text('kcal', style: TextStyle(fontSize: 13.sp, color: textMuted)),
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
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: accentFg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                ),
                child: Text('Got it', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
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
              icon: Icons.refresh_rounded,
              label: 'Regenerate Plan',
              color: isDark ? AppColors.lime : AppColors.void_,
              textColor: textPrimary,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context); // back to program screen
              },
            ),
            _BottomSheetOption(
              icon: Icons.share_rounded,
              label: 'Share Plan',
              color: isDark ? AppColors.violet : AppColors.violetDark,
              textColor: textPrimary,
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            _BottomSheetOption(
              icon: Icons.edit_rounded,
              label: 'Edit Preferences',
              color: isDark ? AppColors.amber : AppColors.amberDark,
              textColor: textPrimary,
              isDark: isDark,
              onTap: () {
                Navigator.pop(context); // close sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DietProfileEditScreen()),
                );
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
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  const _MealCard({required this.meal, required this.isDark, required this.accent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
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
              child: Center(child: Text(meal.emoji, style: TextStyle(fontSize: 22.sp))),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Text(
                        meal.category,
                        style: TextStyle(fontSize: 10.sp, color: textMuted),
                      ),
                      Text(' · ', style: TextStyle(fontSize: 10.sp, color: textMuted)),
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
                Text('kcal', style: TextStyle(fontSize: 10.sp, color: textMuted)),
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
                  Text('kcal total', style: TextStyle(fontSize: 11.sp, color: textMuted)),
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
              Text('P ${totalProtein}g', style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.violet : AppColors.violetDark)),
              Text('C ${totalCarbs}g', style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.amber : AppColors.amberDark)),
              Text('F ${totalFat}g', style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.coral : AppColors.coralDark)),
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
          Flexible(flex: (pFrac * 100).round(), child: Container(height: 6, color: isDark ? AppColors.violet : AppColors.violetDark)),
          Flexible(flex: (cFrac * 100).round(), child: Container(height: 6, color: isDark ? AppColors.amber : AppColors.amberDark)),
          Flexible(flex: (fFrac * 100).round(), child: Container(height: 6, color: isDark ? AppColors.coral : AppColors.coralDark)),
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
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('$label  $value', style: TextStyle(fontSize: 11.sp, color: color, fontWeight: FontWeight.w600)),
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
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(6.r),
      ),
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
            Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: color)),
            SizedBox(height: 2.h),
            Text(label, style: TextStyle(fontSize: 10.sp, color: color.withValues(alpha: 0.7))),
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
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor)),
          ],
        ),
      ),
    );
  }
}
