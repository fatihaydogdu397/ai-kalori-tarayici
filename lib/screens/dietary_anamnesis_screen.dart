import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/api/nutrition_service.dart';
import 'diet_plan_loading_screen.dart';
import 'blood_test_upload_screen.dart';
import '../main.dart' show rootNavigatorKey;

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

// ── Screen ────────────────────────────────────────────────────────────────────
class DietaryAnamnesisScreen extends StatefulWidget {
  const DietaryAnamnesisScreen({super.key});

  @override
  State<DietaryAnamnesisScreen> createState() => _DietaryAnamnesisScreenState();
}

class _DietaryAnamnesisScreenState extends State<DietaryAnamnesisScreen> {
  int _page = 0;
  static const int _totalPages = 3;

  // Form state
  final Set<String> _selectedRestrictions = {};
  int _mealsPerDay = 4;
  // BE şeması alanı zorunlu tuttuğu için default 'medium' yolluyoruz.
  // Kullanıcı isterse diet_profile_edit_screen üzerinden değiştirebilir.
  static const String _cookingTime = 'medium';

  // EAT-135: disliked foods (id, display name) — generateDietPlan'a iletiliyor.
  final List<({String id, String name})> _dislikedFoods = [];

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

  Future<void> _finish() async {
    final restrictions = _selectedRestrictions.toList();
    final dislikedIds = _dislikedFoods.map((f) => f.id).toList();

    // Provider'a kaydet (persist) — cuisines/budget/notes UI'dan kaldırıldı,
    // BE şeması hâlâ alanları zorunlu tuttuğu için boş değer geçiyoruz.
    await context.read<AppProvider>().saveAnamnesisProfile(
      restrictions: restrictions,
      cuisines: const [],
      mealsPerDay: _mealsPerDay,
      cookingTime: _cookingTime,
      budget: 'medium',
      notes: '',
      dislikedFoodIds: dislikedIds,
    );

    if (!mounted) return;

    final data = {
      'restrictions': restrictions,
      'cuisines': const <String>[],
      'mealsPerDay': _mealsPerDay,
      'cookingTime': _cookingTime,
      'budget': 'medium',
      'notes': '',
      'dislikedFoodIds': dislikedIds,
    };

    // Anamnesis sonrası kan tahlili yükleme opsiyonu. Skip edilse bile diyet
    // planı üretimine devam edilir.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BloodTestUploadScreen(
          isOnboarding: true,
          onCompleted: () {
            rootNavigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (_) => DietPlanLoadingScreen(anamnesisData: data)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final progress = (_page + 1) / _totalPages;

    return PopScope(
      // First step → allow system pop (exits the flow). Later steps → intercept
      // and step back inside the multi-step flow instead of exiting.
      canPop: _page == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _back();
      },
      child: Scaffold(
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
        return _PageMealsPerDay(
          key: const ValueKey(1),
          isDark: isDark,
          accent: accent,
          value: _mealsPerDay,
          onChanged: (v) => setState(() => _mealsPerDay = v),
        );
      case 2:
        return _PageDislikedFoods(
          key: const ValueKey(2),
          isDark: isDark,
          accent: accent,
          selected: _dislikedFoods,
          onToggle: (food) {
            setState(() {
              final idx = _dislikedFoods.indexWhere((f) => f.id == food.id);
              if (idx >= 0) {
                _dislikedFoods.removeAt(idx);
              } else {
                _dislikedFoods.add(food);
              }
            });
          },
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
// ── Page 1: Meals Per Day ─────────────────────────────────────────────────────
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

// ── Page 5: Disliked Foods (EAT-135) ──────────────────────────────────────────
class _PageDislikedFoods extends StatefulWidget {
  final bool isDark;
  final Color accent;
  final List<({String id, String name})> selected;
  final void Function(({String id, String name})) onToggle;

  const _PageDislikedFoods({
    super.key,
    required this.isDark,
    required this.accent,
    required this.selected,
    required this.onToggle,
  });

  @override
  State<_PageDislikedFoods> createState() => _PageDislikedFoodsState();
}

class _PageDislikedFoodsState extends State<_PageDislikedFoods> {
  final NutritionService _nutrition = NutritionService.instance;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<({String id, String name})> _results = const [];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(q));
  }

  Future<void> _search(String q) async {
    final trimmed = q.trim();
    // EAT-163: min 3 chars guard.
    if (trimmed.length < 3) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    try {
      final rows = await _nutrition.foods(search: trimmed, limit: 20);
      if (!mounted) return;
      setState(() {
        _results = rows
            .map((r) => (
                  id: (r['id'] ?? '') as String,
                  name: (r['name'] ?? '') as String,
                ))
            .where((r) => r.id.isNotEmpty && r.name.isNotEmpty)
            .toList(growable: false);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _loading = false;
      });
    }
  }

  bool _isSelected(String id) => widget.selected.any((f) => f.id == id);

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final accent = widget.accent;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32.h),
          Text(
            isTr ? 'Sevmediğin yiyecekler?' : 'Any foods you dislike?',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            isTr
                ? 'Bunları planlarında kullanmayacağız (opsiyonel).'
                : 'We won\'t include these in your plans (optional).',
            style: TextStyle(fontSize: 14.sp, color: textMuted),
          ),
          SizedBox(height: 20.h),

          // Search field
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14.r),
              border: border,
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Icon(Icons.search_rounded, color: textMuted, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _onSearchChanged,
                    style: TextStyle(fontSize: 14.sp, color: textPrimary),
                    decoration: InputDecoration(
                      hintText: isTr
                          ? 'Ara: brokoli, yulaf, somon…'
                          : 'Search: broccoli, oatmeal, salmon…',
                      hintStyle: TextStyle(fontSize: 13.sp, color: textMuted),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                if (_loading)
                  Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        valueColor: AlwaysStoppedAnimation(accent),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Selected chips
          if (widget.selected.isNotEmpty) ...[
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: widget.selected
                  .map(
                    (f) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(isDark ? 0.15 : 0.1),
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: accent.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            f.name,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: accent,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () => widget.onToggle(f),
                            child: Icon(Icons.close_rounded, size: 14.sp, color: accent),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16.h),
          ],

          // Results
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        _searchCtrl.text.trim().isEmpty
                            ? (isTr
                                ? 'Aramak istediğin yiyeceği yaz; hiçbiri yoksa bu adımı atlayabilirsin.'
                                : 'Start typing a food name to find it. You can skip this step.')
                            : (isTr ? 'Sonuç bulunamadı.' : 'No results.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.4),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                    ),
                    itemBuilder: (context, i) {
                      final food = _results[i];
                      final selected = _isSelected(food.id);
                      return InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          widget.onToggle(food);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  food.name,
                                  style: TextStyle(fontSize: 14.sp, color: textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.add_circle_outline_rounded,
                                color: selected ? accent : textMuted,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
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

