import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'diet_plan_loading_screen.dart';

// ── Multi-select pill data ────────────────────────────────────────────────────
class _PillOption {
  final String id;
  final String label;
  final String emoji;
  const _PillOption(this.id, this.label, this.emoji);
}

const _restrictions = [
  _PillOption('none', 'None', '✅'),
  _PillOption('vegetarian', 'Vegetarian', '🥦'),
  _PillOption('vegan', 'Vegan', '🌱'),
  _PillOption('gluten_free', 'Gluten Free', '🌾'),
  _PillOption('dairy_free', 'Dairy Free', '🥛'),
  _PillOption('nut_free', 'Nut Free', '🥜'),
  _PillOption('egg_free', 'Egg Free', '🥚'),
  _PillOption('halal', 'Halal', '☪️'),
];

const _cuisines = [
  _PillOption('turkish', 'Turkish', '🫙'),
  _PillOption('mediterranean', 'Mediterranean', '🫒'),
  _PillOption('asian', 'Asian', '🍜'),
  _PillOption('italian', 'Italian', '🍝'),
  _PillOption('american', 'American', '🍔'),
  _PillOption('mexican', 'Mexican', '🌮'),
  _PillOption('middle_eastern', 'Middle Eastern', '🧆'),
  _PillOption('no_pref', 'No Preference', '🌍'),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class DietaryAnamnesisScreen extends StatefulWidget {
  const DietaryAnamnesisScreen({super.key});

  @override
  State<DietaryAnamnesisScreen> createState() => _DietaryAnamnesisScreenState();
}

class _DietaryAnamnesisScreenState extends State<DietaryAnamnesisScreen> {
  int _page = 0;
  static const int _totalPages = 5;

  // Form state
  final Set<String> _selectedRestrictions = {};
  final Set<String> _selectedCuisines = {};
  int _mealsPerDay = 4;
  String _cookingTime = 'medium'; // quick / medium / relaxed
  String _budget = 'medium'; // low / medium / high
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _totalPages - 1) {
      setState(() => _page++);
      HapticFeedback.selectionClick();
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      setState(() => _page--);
      HapticFeedback.selectionClick();
    } else {
      Navigator.pop(context);
    }
  }

  void _finish() {
    final data = {
      'restrictions': _selectedRestrictions.toList(),
      'cuisines': _selectedCuisines.toList(),
      'mealsPerDay': _mealsPerDay,
      'cookingTime': _cookingTime,
      'budget': _budget,
      'notes': _notesController.text.trim(),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => DietPlanLoadingScreen(anamnesisData: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final progress = (_page + 1) / _totalPages;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            _ProgressHeader(
              progress: progress,
              page: _page,
              totalPages: _totalPages,
              isDark: isDark,
              accent: accent,
              onBack: _back,
            ),
            // Page content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: _buildPage(isDark, accent),
              ),
            ),
            // Bottom CTA
            _buildBottomCTA(isDark, accent),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(bool isDark, Color accent) {
    switch (_page) {
      case 0:
        return _PageRestrictions(
          key: const ValueKey(0),
          isDark: isDark,
          accent: accent,
          selected: _selectedRestrictions,
          onToggle: (id) {
            setState(() {
              if (id == 'none') {
                _selectedRestrictions.clear();
                _selectedRestrictions.add('none');
              } else {
                _selectedRestrictions.remove('none');
                if (_selectedRestrictions.contains(id)) {
                  _selectedRestrictions.remove(id);
                } else {
                  _selectedRestrictions.add(id);
                }
              }
            });
          },
        );
      case 1:
        return _PageCuisines(
          key: const ValueKey(1),
          isDark: isDark,
          accent: accent,
          selected: _selectedCuisines,
          onToggle: (id) {
            setState(() {
              if (id == 'no_pref') {
                _selectedCuisines.clear();
                _selectedCuisines.add('no_pref');
              } else {
                _selectedCuisines.remove('no_pref');
                if (_selectedCuisines.contains(id)) {
                  _selectedCuisines.remove(id);
                } else {
                  _selectedCuisines.add(id);
                }
              }
            });
          },
        );
      case 2:
        return _PageMealsPerDay(
          key: const ValueKey(2),
          isDark: isDark,
          accent: accent,
          value: _mealsPerDay,
          onChanged: (v) => setState(() => _mealsPerDay = v),
        );
      case 3:
        return _PageCookingTime(
          key: const ValueKey(3),
          isDark: isDark,
          accent: accent,
          selected: _cookingTime,
          onSelected: (v) => setState(() => _cookingTime = v),
          budget: _budget,
          onBudget: (v) => setState(() => _budget = v),
        );
      case 4:
        return _PageNotes(
          key: const ValueKey(4),
          isDark: isDark,
          accent: accent,
          controller: _notesController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomCTA(bool isDark, Color accent) {
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;
    final isLast = _page == _totalPages - 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _next,
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: accentFg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
            padding: EdgeInsets.symmetric(vertical: 16.h),
            elevation: 0,
          ),
          child: Text(
            isLast ? 'Generate My Plan' : 'Continue',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}

// ── Progress Header ───────────────────────────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final double progress;
  final int page, totalPages;
  final bool isDark;
  final Color accent;
  final VoidCallback onBack;

  const _ProgressHeader({
    required this.progress,
    required this.page,
    required this.totalPages,
    required this.isDark,
    required this.accent,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 24.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.sp,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                    valueColor: AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${page + 1}/$totalPages',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Page 1: Restrictions ──────────────────────────────────────────────────────
class _PageRestrictions extends StatelessWidget {
  final bool isDark;
  final Color accent;
  final Set<String> selected;
  final void Function(String) onToggle;

  const _PageRestrictions({
    super.key,
    required this.isDark,
    required this.accent,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text('Any food restrictions?', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary)),
          SizedBox(height: 8.h),
          Text('Select all that apply', style: TextStyle(fontSize: 14.sp, color: textMuted)),
          SizedBox(height: 32.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _restrictions.map((opt) {
              final isSelected = selected.contains(opt.id);
              return _MultiPill(
                label: '${opt.emoji} ${opt.label}',
                isSelected: isSelected,
                isDark: isDark,
                accent: accent,
                onTap: () => onToggle(opt.id),
              );
            }).toList(),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Page 2: Cuisines ──────────────────────────────────────────────────────────
class _PageCuisines extends StatelessWidget {
  final bool isDark;
  final Color accent;
  final Set<String> selected;
  final void Function(String) onToggle;

  const _PageCuisines({
    super.key,
    required this.isDark,
    required this.accent,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text('Cuisine preferences?', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary)),
          SizedBox(height: 8.h),
          Text('We\'ll include your favorites in the plan', style: TextStyle(fontSize: 14.sp, color: textMuted)),
          SizedBox(height: 32.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _cuisines.map((opt) {
              final isSelected = selected.contains(opt.id);
              return _MultiPill(
                label: '${opt.emoji} ${opt.label}',
                isSelected: isSelected,
                isDark: isDark,
                accent: accent,
                onTap: () => onToggle(opt.id),
              );
            }).toList(),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Page 3: Meals Per Day ─────────────────────────────────────────────────────
class _PageMealsPerDay extends StatelessWidget {
  final bool isDark;
  final Color accent;
  final int value;
  final void Function(int) onChanged;

  const _PageMealsPerDay({
    super.key,
    required this.isDark,
    required this.accent,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text('Meals per day?', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary)),
          SizedBox(height: 8.h),
          Text('Including snacks', style: TextStyle(fontSize: 14.sp, color: textMuted)),
          SizedBox(height: 48.h),
          // Big stepper
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepperBtn(
                    icon: Icons.remove_rounded,
                    onTap: value > 2 ? () => onChanged(value - 1) : null,
                    isDark: isDark,
                  ),
                  SizedBox(width: 32.w),
                  Column(
                    children: [
                      Text(
                        '$value',
                        style: TextStyle(fontSize: 56.sp, fontWeight: FontWeight.w800, color: accent),
                      ),
                      Text(
                        'meals',
                        style: TextStyle(fontSize: 14.sp, color: textMuted),
                      ),
                    ],
                  ),
                  SizedBox(width: 32.w),
                  _StepperBtn(
                    icon: Icons.add_rounded,
                    onTap: value < 7 ? () => onChanged(value + 1) : null,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
          // Descriptions
          ..._mealDescriptions(value, textMuted),
        ],
      ),
    );
  }

  List<Widget> _mealDescriptions(int n, Color textMuted) {
    final String desc;
    switch (n) {
      case 2:
        desc = '2 large meals — intermittent fasting style';
      case 3:
        desc = '3 main meals — classic breakfast, lunch & dinner';
      case 4:
        desc = '3 main meals + 1 snack — balanced day';
      case 5:
        desc = '3 main meals + 2 snacks — steady energy throughout the day';
      case 6:
        desc = '6 small meals — frequent feeding, high metabolism';
      case 7:
        desc = '7 meals — ultra-frequent, athlete level';
      default:
        desc = '';
    }
    return [
      Center(
        child: Text(
          desc,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.5),
        ),
      ),
    ];
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDark;

  const _StepperBtn({required this.icon, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.selectionClick();
              onTap!();
            }
          : null,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          icon,
          size: 24.sp,
          color: isDisabled
              ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary).withValues(alpha: 0.4)
              : (isDark ? AppColors.darkText : AppColors.lightText),
        ),
      ),
    );
  }
}

// ── Page 4: Cooking Time + Budget ─────────────────────────────────────────────
class _PageCookingTime extends StatelessWidget {
  final bool isDark;
  final Color accent;
  final String selected;
  final void Function(String) onSelected;
  final String budget;
  final void Function(String) onBudget;

  const _PageCookingTime({
    super.key,
    required this.isDark,
    required this.accent,
    required this.selected,
    required this.onSelected,
    required this.budget,
    required this.onBudget,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    const cookOptions = [
      ('quick', '⚡', 'Quick', '< 15 min'),
      ('medium', '🍳', 'Moderate', '15–30 min'),
      ('relaxed', '👨‍🍳', 'Relaxed', '30–60 min'),
    ];

    const budgetOptions = [
      ('low', '💸', 'Budget', 'Affordable meals'),
      ('medium', '💳', 'Moderate', 'Regular groceries'),
      ('high', '🌟', 'Premium', 'Quality ingredients'),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text('Cooking & budget', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary)),
          SizedBox(height: 8.h),
          Text('We\'ll keep your meals practical', style: TextStyle(fontSize: 14.sp, color: textMuted)),
          SizedBox(height: 28.h),
          Text('Cooking time per meal', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.5)),
          SizedBox(height: 12.h),
          Column(
            children: cookOptions.map((opt) {
              final isSelected = selected == opt.$1;
              return _OptionRow(
                emoji: opt.$2,
                title: opt.$3,
                subtitle: opt.$4,
                isSelected: isSelected,
                isDark: isDark,
                accent: accent,
                onTap: () => onSelected(opt.$1),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
          Text('Grocery budget', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.5)),
          SizedBox(height: 12.h),
          Column(
            children: budgetOptions.map((opt) {
              final isSelected = budget == opt.$1;
              return _OptionRow(
                emoji: opt.$2,
                title: opt.$3,
                subtitle: opt.$4,
                isSelected: isSelected,
                isDark: isDark,
                accent: accent,
                onTap: () => onBudget(opt.$1),
              );
            }).toList(),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Page 5: Notes ─────────────────────────────────────────────────────────────
class _PageNotes extends StatelessWidget {
  final bool isDark;
  final Color accent;
  final TextEditingController controller;

  const _PageNotes({
    super.key,
    required this.isDark,
    required this.accent,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text('Anything else?', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary)),
          SizedBox(height: 8.h),
          Text('Food dislikes, health notes, or special requests', style: TextStyle(fontSize: 14.sp, color: textMuted)),
          SizedBox(height: 32.h),
          TextField(
            controller: controller,
            maxLines: 5,
            style: TextStyle(fontSize: 15.sp, color: textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. I hate broccoli, I\'m lactose intolerant, I prefer high-protein breakfasts...',
              hintStyle: TextStyle(fontSize: 13.sp, color: textMuted),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.08 : 0.07),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: accent.withValues(alpha: 0.2), width: 1),
            ),
            child: Row(
              children: [
                Text('✨', style: TextStyle(fontSize: 20.sp)),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'AI will generate a personalized 7-day meal plan tailored exactly to your profile.',
                    style: TextStyle(fontSize: 13.sp, color: textPrimary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────
class _MultiPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final Color accent;
  final VoidCallback onTap;

  const _MultiPill({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? accent : Colors.transparent,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected
                ? accent
                : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
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

class _OptionRow extends StatelessWidget {
  final String emoji, title, subtitle;
  final bool isSelected, isDark;
  final Color accent;
  final VoidCallback onTap;

  const _OptionRow({
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
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: isDark ? 0.12 : 0.08) : cardBg,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24.sp)),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary)),
                  Text(subtitle, style: TextStyle(fontSize: 12.sp, color: textMuted)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: accent, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
