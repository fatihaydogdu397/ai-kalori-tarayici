import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/api/nutrition_service.dart';
import '../models/food_analysis.dart';
import '../generated/app_localizations.dart';

/// UI transfer objesi — BE foods query yanıtından doldurulur.
class _FoodItem {
  final String id;
  final String name;
  final String emoji;
  final double cal; // per 100g
  final double protein;
  final double carbs;
  final double fat;
  final String category;

  const _FoodItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.cal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
  });

  factory _FoodItem.fromBackend(Map<String, dynamic> raw) {
    return _FoodItem(
      id: (raw['id'] ?? '') as String,
      name: (raw['name'] ?? '') as String,
      emoji: '🍽️',
      cal: (raw['calories'] as num?)?.toDouble() ?? 0,
      protein: (raw['protein'] as num?)?.toDouble() ?? 0,
      carbs: (raw['carbs'] as num?)?.toDouble() ?? 0,
      fat: (raw['fat'] as num?)?.toDouble() ?? 0,
      category: (raw['category'] ?? '') as String,
    );
  }
}

/// "All" sentinel + BE'den dinamik gelen USDA kategorileri. Kategoriler
/// `foodCategories` query ile yüklenir; chip tıklanınca `foods(category: ...)`
/// parametresiyle BE filtrelenir (EAT-120).
const _kAllCategory = 'All';

// ── Screen ────────────────────────────────────────────────────────────────────

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final _searchCtrl = TextEditingController();
  final NutritionService _nutritionService = NutritionService.instance;
  String _query = '';
  String _category = _kAllCategory;
  final Set<String> _dietTagFilter = {}; // EAT-136
  Timer? _debounce;
  bool _loading = false;
  List<_FoodItem> _items = const [];
  List<String> _categories = const [_kAllCategory];

  // EAT-136 / EAT-92: dietary tag chip'leri. BE `FoodsFilterInput`'ta henüz
  // `tags` alanı olmadığı için client-side filter; NutritionService.foods
  // dietTagFilter parametresiyle sonuçları kesiyor.
  static const List<({String key, String emoji})> _dietTagChips = [
    (key: 'vegan', emoji: '🌱'),
    (key: 'vegetarian', emoji: '🥦'),
    (key: 'gluten_free', emoji: '🌾'),
    (key: 'dairy_free', emoji: '🥛'),
    (key: 'nut_free', emoji: '🥜'),
    (key: 'pescatarian', emoji: '🐟'),
    (key: 'halal', emoji: '☪️'),
    (key: 'kosher', emoji: '✡️'),
    (key: 'low_carb', emoji: '⚖️'),
    (key: 'keto', emoji: '🥑'),
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadFoods();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    setState(() => _query = v);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _loadFoods);
  }

  void _onCategorySelected(String cat) {
    if (cat == _category) return;
    setState(() => _category = cat);
    _loadFoods();
  }

  Future<void> _loadCategories() async {
    try {
      final remote = await _nutritionService.foodCategories();
      if (!mounted || remote.isEmpty) return;
      setState(() {
        _categories = [_kAllCategory, ...remote];
      });
    } catch (_) {
      // BE'den kategori gelmezse sadece "All" gösterilmeye devam eder.
    }
  }

  Future<void> _loadFoods() async {
    setState(() => _loading = true);
    try {
      final rows = await _nutritionService.foods(
        search: _query.trim().isEmpty ? null : _query.trim(),
        category: _category == _kAllCategory ? null : _category,
        dietTagFilter: _dietTagFilter.isEmpty ? null : _dietTagFilter.toList(),
        limit: 50,
      );
      if (!mounted) return;
      setState(() {
        _items = rows.map(_FoodItem.fromBackend).toList(growable: false);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _items = const [];
        _loading = false;
      });
    }
  }

  void _toggleDietTag(String tag) {
    setState(() {
      if (_dietTagFilter.contains(tag)) {
        _dietTagFilter.remove(tag);
      } else {
        _dietTagFilter.add(tag);
      }
    });
    _loadFoods();
  }

  String _dietTagLabel(String key, String localeCode) {
    if (localeCode == 'tr') {
      switch (key) {
        case 'vegan':
          return 'Vegan';
        case 'vegetarian':
          return 'Vejetaryen';
        case 'gluten_free':
          return 'Glutensiz';
        case 'dairy_free':
          return 'Sütsüz';
        case 'nut_free':
          return 'Fındıksız';
        case 'pescatarian':
          return 'Peskateryen';
        case 'halal':
          return 'Helal';
        case 'kosher':
          return 'Koşer';
        case 'low_carb':
          return 'Az Karb.';
        case 'keto':
          return 'Keto';
      }
    }
    return key
        .split('_')
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  String _translateCategory(String cat, AppLocalizations l) {
    if (cat == _kAllCategory) return l.categoryAll;
    // BE kategorileri USDA FDC string'leridir (örn. "Poultry Products").
    // L10n eşlemesi henüz yok; etiket ham gösterilir.
    return cat;
  }

  List<_FoodItem> get _filtered {
    // BE zaten search'ü filtreliyor; kategori chip'leri EAT-120'ye kadar no-op.
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.limeDark;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);

    final results = _filtered;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10.r), border: border),
                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp, color: textMuted),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    l.foodSearch,
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // ── Search Bar ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 46.h,
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r), border: border),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(Icons.search_rounded, color: textMuted, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        style: TextStyle(fontSize: 15.sp, color: textPrimary, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: l.searchFoodsHint,
                          hintStyle: TextStyle(fontSize: 15.sp, color: textMuted, fontWeight: FontWeight.w400),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          _onSearchChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(Icons.close_rounded, color: textMuted, size: 18.sp),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // ── Dietary tag chips (EAT-136 — client-side filter) ──────────
            SizedBox(
              height: 30.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _dietTagChips.length,
                separatorBuilder: (_, __) => SizedBox(width: 6.w),
                itemBuilder: (_, i) {
                  final tag = _dietTagChips[i];
                  final selected = _dietTagFilter.contains(tag.key);
                  final localeCode = Localizations.localeOf(context).languageCode;
                  return GestureDetector(
                    onTap: () => _toggleDietTag(tag.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: selected ? accent.withOpacity(isDark ? 0.18 : 0.1) : cardBg,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: selected ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
                          width: selected ? 1.2 : 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${tag.emoji} ${_dietTagLabel(tag.key, localeCode)}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? accent : textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),

            // ── Category Chips ────────────────────────────────────────────
            SizedBox(
              height: 34.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final selected = cat == _category;
                  return GestureDetector(
                    onTap: () => _onCategorySelected(cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: selected ? accent : cardBg,
                        borderRadius: BorderRadius.circular(17.r),
                        border: selected
                            ? null
                            : (isDark ? Border.all(color: AppColors.darkSurface, width: 1) : Border.all(color: AppColors.lightBorder, width: 0.5)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _translateCategory(cat, l),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? (isDark ? AppColors.void_ : Colors.white) : textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8.h),

            // ── Results count ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
              child: Text(
                l.foodCount(results.length),
                style: TextStyle(fontSize: 12.sp, color: textMuted, fontWeight: FontWeight.w500),
              ),
            ),

            // ── Food List ─────────────────────────────────────────────────
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: accent))
                  : results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🔍', style: TextStyle(fontSize: 40.sp)),
                          SizedBox(height: 12.h),
                          Text(
                            l.noFoodsFound,
                            style: TextStyle(color: textMuted, fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 100.h),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (_, i) => _FoodCard(
                        item: results[i],
                        cardBg: cardBg,
                        border: border,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        accent: accent,
                        isDark: isDark,
                        onAdd: () => _showAddSheet(context, results[i], isDark, cardBg, textPrimary, textMuted, accent, l),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, _FoodItem food, bool isDark, Color cardBg, Color textPrimary, Color textMuted, Color accent, AppLocalizations l) {
    double grams = 100;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) {
          final factor = grams / 100;
          final cal = food.cal * factor;
          final pro = food.protein * factor;
          final car = food.carbs * factor;
          final fat = food.fat * factor;

          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, MediaQuery.of(context).padding.bottom + 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Food name + emoji
                Row(
                  children: [
                    Text(food.emoji, style: TextStyle(fontSize: 32.sp)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary),
                          ),
                          Text(
                            '${cal.toStringAsFixed(0)} kcal',
                            style: TextStyle(fontSize: 14.sp, color: accent, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Macro row
                Row(
                  children: [
                    _SheetMacro(label: l.protein, value: '${pro.toStringAsFixed(1)}g', color: AppColors.violet),
                    SizedBox(width: 12.w),
                    _SheetMacro(label: l.carbs, value: '${car.toStringAsFixed(1)}g', color: AppColors.amber),
                    SizedBox(width: 12.w),
                    _SheetMacro(label: l.fat, value: '${fat.toStringAsFixed(1)}g', color: AppColors.coral),
                  ],
                ),
                SizedBox(height: 20.h),

                // Portion slider
                Text(
                  l.portionGrams(grams.toStringAsFixed(0)),
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                Slider(
                  value: grams,
                  min: 10,
                  max: 500,
                  divisions: 49,
                  activeColor: accent,
                  inactiveColor: accent.withValues(alpha: 0.2),
                  onChanged: (v) => setS(() => grams = v),
                ),
                SizedBox(height: 8.h),

                // Log button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      _logFood(context, food, grams);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: isDark ? AppColors.void_ : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      elevation: 0,
                    ),
                    child: Text(
                      l.addToLog,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _logFood(BuildContext context, _FoodItem food, double grams) {
    final factor = grams / 100;
    final provider = context.read<AppProvider>();
    final l = AppLocalizations.of(context);
    final analysis = FoodAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: '', // Mock arama olduğu için görsel yok
      foods: [
        FoodItem(
          name: food.name,
          nameTr: food.name,
          portion: grams,
          portionUnit: 'g',
          nutrients: NutrientInfo(
            calories: food.cal * factor,
            protein: food.protein * factor,
            carbs: food.carbs * factor,
            fat: food.fat * factor,
            fiber: 0,
            sugar: 0,
          ),
          healthScore: 'Orta',
          tags: [food.category],
        ),
      ],
      totalNutrients: NutrientInfo(
        calories: food.cal * factor,
        protein: food.protein * factor,
        carbs: food.carbs * factor,
        fat: food.fat * factor,
        fiber: 0,
        sugar: 0,
      ),
      summary: '',
      advice: '',
      analyzedAt: DateTime.now(),
    );
    provider.saveManualEntry(analysis);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.foodAddedToLog(food.name)),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkCard : AppColors.lightText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ── Food Card ─────────────────────────────────────────────────────────────────

class _FoodCard extends StatelessWidget {
  final _FoodItem item;
  final Color cardBg, textPrimary, textMuted, accent;
  final Border? border;
  final bool isDark;
  final VoidCallback onAdd;

  const _FoodCard({
    required this.item,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
    this.border,
    required this.isDark,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r), border: border),
      child: Row(
        children: [
          // Emoji
          Text(item.emoji, style: TextStyle(fontSize: 28.sp)),
          SizedBox(width: 12.w),

          // Name + macros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '${item.cal.toStringAsFixed(0)} kcal',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: accent),
                    ),
                    Text(
                      '  ·  P${item.protein.toStringAsFixed(0)}g'
                      '  C${item.carbs.toStringAsFixed(0)}g'
                      '  F${item.fat.toStringAsFixed(0)}g',
                      style: TextStyle(fontSize: 11.sp, color: textMuted, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add button
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.add_rounded, color: accent, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet Macro ───────────────────────────────────────────────────────────────

class _SheetMacro extends StatelessWidget {
  final String label, value;
  final Color color;

  const _SheetMacro({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: color),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: textMuted, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
