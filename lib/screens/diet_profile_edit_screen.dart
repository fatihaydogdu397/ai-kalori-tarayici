import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import 'diet_plan_loading_screen.dart';

// ── Pill & option data (mirrors dietary_anamnesis_screen.dart) ────────────────
const _restrictionOptions = [
  ('none', '✅', 'None'),
  ('vegetarian', '🥦', 'Vegetarian'),
  ('vegan', '🌱', 'Vegan'),
  ('gluten_free', '🌾', 'Gluten Free'),
  ('dairy_free', '🥛', 'Dairy Free'),
  ('nut_free', '🥜', 'Nut Free'),
  ('egg_free', '🥚', 'Egg Free'),
  ('halal', '☪️', 'Halal'),
];

const _cookOptions = [
  ('quick', '⚡', 'Quick', '< 15 min'),
  ('medium', '🍳', 'Moderate', '15–30 min'),
  ('relaxed', '👨‍🍳', 'Relaxed', '30–60 min'),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class DietProfileEditScreen extends StatefulWidget {
  const DietProfileEditScreen({super.key});

  @override
  State<DietProfileEditScreen> createState() => _DietProfileEditScreenState();
}

class _DietProfileEditScreenState extends State<DietProfileEditScreen> {
  late Set<String> _restrictions;
  late int _mealsPerDay;
  late String _cookingTime;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _restrictions = Set.from(p.dietRestrictions.isEmpty ? ['none'] : p.dietRestrictions);
    _mealsPerDay = p.dietMealsPerDay;
    _cookingTime = p.dietCookingTime;
  }

  Future<void> _save({bool regenerate = false}) async {
    setState(() => _saving = true);
    // cuisines/budget/notes UI'dan kaldırıldı; BE şeması hâlâ alanları
    // zorunlu tuttuğu için boş değer geçiyoruz.
    await context.read<AppProvider>().saveAnamnesisProfile(
      restrictions: _restrictions.toList(),
      cuisines: const [],
      mealsPerDay: _mealsPerDay,
      cookingTime: _cookingTime,
      budget: 'medium',
      notes: '',
    );
    if (!mounted) return;

    if (regenerate) {
      final data = {
        'restrictions': _restrictions.toList(),
        'cuisines': const <String>[],
        'mealsPerDay': _mealsPerDay,
        'cookingTime': _cookingTime,
        'budget': 'medium',
        'notes': '',
      };
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DietPlanLoadingScreen(anamnesisData: data)),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _toggleRestriction(String id) {
    setState(() {
      if (id == 'none') {
        _restrictions = {'none'};
      } else {
        _restrictions.remove('none');
        if (_restrictions.contains(id)) {
          _restrictions.remove(id);
          if (_restrictions.isEmpty) _restrictions.add('none');
        } else {
          _restrictions.add(id);
        }
      }
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 20.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18.sp, color: textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Diet Profile',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary),
                    ),
                  ),
                  TextButton(
                    onPressed: _saving ? null : () => _save(),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: _saving ? textMuted : accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // ── Restrictions ──────────────────────────────────
                    _SectionTitle(title: 'Food Restrictions', isDark: isDark),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _restrictionOptions.map((opt) {
                        final isSelected = _restrictions.contains(opt.$1);
                        return _EditPill(
                          label: '${opt.$2} ${opt.$3}',
                          isSelected: isSelected,
                          isDark: isDark,
                          accent: accent,
                          onTap: () => _toggleRestriction(opt.$1),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 28.h),

                    // ── Meals per day ─────────────────────────────────
                    _SectionTitle(title: 'Meals Per Day', isDark: isDark),
                    SizedBox(height: 12.h),
                    _MealsStepper(
                      value: _mealsPerDay,
                      isDark: isDark,
                      accent: accent,
                      onChanged: (v) => setState(() => _mealsPerDay = v),
                    ),

                    SizedBox(height: 28.h),

                    // ── Cooking time ──────────────────────────────────
                    _SectionTitle(title: 'Cooking Time', isDark: isDark),
                    SizedBox(height: 12.h),
                    ..._cookOptions.map((opt) => _OptionRow(
                      id: opt.$1,
                      emoji: opt.$2,
                      title: opt.$3,
                      subtitle: opt.$4,
                      isSelected: _cookingTime == opt.$1,
                      isDark: isDark,
                      accent: accent,
                      onTap: () {
                        setState(() => _cookingTime = opt.$1);
                        HapticFeedback.selectionClick();
                      },
                    )),

                    SizedBox(height: 32.h),

                    // ── Regenerate CTA ────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saving ? null : () => _save(regenerate: true),
                        icon: _saving
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(accentFg),
                                ),
                              )
                            : Icon(Icons.refresh_rounded, size: 18.sp),
                        label: Text(
                          'Save & Regenerate Plan',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: accentFg,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          elevation: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Edit pill (compact) ───────────────────────────────────────────────────────
class _EditPill extends StatelessWidget {
  final String label;
  final bool isSelected, isDark;
  final Color accent;
  final VoidCallback onTap;

  const _EditPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? (isDark ? AppColors.void_ : AppColors.snow)
                : (isDark ? AppColors.darkText : AppColors.lightText),
          ),
        ),
      ),
    );
  }
}

// ── Meals stepper ─────────────────────────────────────────────────────────────
class _MealsStepper extends StatelessWidget {
  final int value;
  final bool isDark;
  final Color accent;
  final void Function(int) onChanged;

  const _MealsStepper({
    required this.value,
    required this.isDark,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14.r),
        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Text('Meals per day', style: TextStyle(fontSize: 14.sp, color: textPrimary, fontWeight: FontWeight.w600)),
          const Spacer(),
          GestureDetector(
            onTap: value > 2
                ? () {
                    HapticFeedback.selectionClick();
                    onChanged(value - 1);
                  }
                : null,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.remove_rounded,
                size: 18.sp,
                color: value > 2 ? textPrimary : textMuted.withValues(alpha: 0.4),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            '$value',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: accent),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: value < 7
                ? () {
                    HapticFeedback.selectionClick();
                    onChanged(value + 1);
                  }
                : null,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 18.sp,
                color: value < 7 ? textPrimary : textMuted.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Option row ────────────────────────────────────────────────────────────────
class _OptionRow extends StatelessWidget {
  final String id, emoji, title, subtitle;
  final bool isSelected, isDark;
  final Color accent;
  final VoidCallback onTap;

  const _OptionRow({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: isDark ? 0.12 : 0.08) : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 20.sp)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 11.sp, color: textMuted)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accent, size: 18.sp),
          ],
        ),
      ),
    );
  }
}
