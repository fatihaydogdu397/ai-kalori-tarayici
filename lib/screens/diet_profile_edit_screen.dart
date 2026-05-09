import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/api/nutrition_service.dart';

/// DietProfileEditScreen pop dönüş değerleri. Caller bu sentinel'leri okuyup
/// "kaydedildi" / "regenerate" akışlarını inline tetikler.
const String kDietEditSaved = '__diet_edit_saved__';
const String kDietEditRegenerate = '__diet_edit_regenerate__';

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


// ── Screen ────────────────────────────────────────────────────────────────────
class DietProfileEditScreen extends StatefulWidget {
  const DietProfileEditScreen({super.key});

  @override
  State<DietProfileEditScreen> createState() => _DietProfileEditScreenState();
}

class _DietProfileEditScreenState extends State<DietProfileEditScreen> {
  late Set<String> _restrictions;
  late int _mealsPerDay;
  late String _cookingTime; // M16: UI'dan kaldırıldı, default 'medium' BE'ye gider
  bool _saving = false;

  // M16: filter restriction list
  String _restrictionQuery = '';
  final TextEditingController _restrictionFilterCtrl = TextEditingController();

  // M16: disliked foods (BE food id'leri tutulur, label lookup için ayrı map)
  late Set<String> _dislikedIds;
  final Map<String, String> _dislikedLabels = {};
  final TextEditingController _foodSearchCtrl = TextEditingController();
  Timer? _foodSearchDebounce;
  List<({String id, String name})> _foodResults = const [];
  bool _foodSearching = false;

  @override
  void initState() {
    super.initState();
    final p = context.read<AppProvider>();
    _restrictions = Set.from(p.dietRestrictions.isEmpty ? ['none'] : p.dietRestrictions);
    _mealsPerDay = p.dietMealsPerDay;
    _cookingTime = p.dietCookingTime;
    _dislikedIds = Set.from(p.dislikedFoodIds);
  }

  @override
  void dispose() {
    _restrictionFilterCtrl.dispose();
    _foodSearchCtrl.dispose();
    _foodSearchDebounce?.cancel();
    super.dispose();
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
      dislikedFoodIds: _dislikedIds.toList(),
    );
    if (!mounted) return;
    // Yeni sayfa push etmiyoruz; pop sonucu sentinel ile dönüyor. Çağıran
    // (weekly diet plan ekranı) regenerate isteğini inline overlay loader ile
    // işliyor — kullanıcı "geri" basmış gibi hisseder.
    Navigator.pop(context, regenerate ? kDietEditRegenerate : kDietEditSaved);
  }

  void _onFoodSearchChanged(String v) {
    _foodSearchDebounce?.cancel();
    final q = v.trim();
    if (q.length < 3) {
      setState(() {
        _foodResults = const [];
        _foodSearching = false;
      });
      return;
    }
    setState(() => _foodSearching = true);
    _foodSearchDebounce = Timer(const Duration(milliseconds: 350), () async {
      try {
        final rows = await NutritionService.instance.foods(search: q, limit: 15);
        if (!mounted) return;
        setState(() {
          _foodResults = rows
              .map((r) => (
                    id: (r['id'] ?? '') as String,
                    name: (r['name'] ?? '') as String,
                  ))
              .where((e) => e.id.isNotEmpty && e.name.isNotEmpty)
              .toList(growable: false);
          _foodSearching = false;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _foodResults = const [];
          _foodSearching = false;
        });
      }
    });
  }

  void _addDislike(({String id, String name}) item) {
    setState(() {
      _dislikedIds.add(item.id);
      _dislikedLabels[item.id] = item.name;
      _foodSearchCtrl.clear();
      _foodResults = const [];
    });
  }

  void _removeDislike(String id) {
    setState(() => _dislikedIds.remove(id));
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
                    SizedBox(height: 10.h),
                    _SearchField(
                      controller: _restrictionFilterCtrl,
                      hint: 'Filter restrictions...',
                      isDark: isDark,
                      onChanged: (v) => setState(() => _restrictionQuery = v.trim().toLowerCase()),
                    ),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: _restrictionOptions.where((opt) {
                        if (_restrictionQuery.isEmpty) return true;
                        return opt.$3.toLowerCase().contains(_restrictionQuery);
                      }).map((opt) {
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

                    // ── Foods to avoid (dislikes) ─────────────────────
                    _SectionTitle(title: 'Foods to Avoid', isDark: isDark),
                    SizedBox(height: 10.h),
                    _SearchField(
                      controller: _foodSearchCtrl,
                      hint: 'Search foods (e.g. mushroom)',
                      isDark: isDark,
                      onChanged: _onFoodSearchChanged,
                    ),
                    if (_foodSearching) ...[
                      SizedBox(height: 12.h),
                      const Center(child: CircularProgressIndicator()),
                    ] else if (_foodResults.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Column(
                          children: [
                            for (final r in _foodResults)
                              InkWell(
                                onTap: () => _addDislike(r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          r.name,
                                          style: TextStyle(fontSize: 13.sp, color: textPrimary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.add_rounded, size: 18.sp, color: accent),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    if (_dislikedIds.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _dislikedIds.map((id) {
                          final label = _dislikedLabels[id] ?? id;
                          return Chip(
                            label: Text(label, style: TextStyle(fontSize: 12.sp)),
                            backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                            side: BorderSide(
                              color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                              width: 0.8,
                            ),
                            deleteIcon: Icon(Icons.close_rounded, size: 14.sp, color: textMuted),
                            onDeleted: () => _removeDislike(id),
                          );
                        }).toList(),
                      ),
                    ],

                    SizedBox(height: 32.h),

                    // ── Regenerate CTA ────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
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

// ── Search field (M16) ────────────────────────────────────────────────────────
class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fg = isDark ? AppColors.darkText : AppColors.lightText;
    final muted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final fieldBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final border = isDark ? AppColors.darkSurface : AppColors.lightBorder;
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: muted, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(fontSize: 13.sp, color: fg),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 13.sp, color: muted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
