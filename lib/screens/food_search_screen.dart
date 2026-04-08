import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../models/food_analysis.dart';

// ── Mock Food Data ────────────────────────────────────────────────────────────

class _FoodItem {
  final String name;
  final String emoji;
  final double cal; // per 100g
  final double protein;
  final double carbs;
  final double fat;
  final String category;

  const _FoodItem({
    required this.name,
    required this.emoji,
    required this.cal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
  });
}

const _mockFoods = [
  _FoodItem(name: 'Chicken Breast', emoji: '🍗', cal: 165, protein: 31, carbs: 0, fat: 3.6, category: 'Protein'),
  _FoodItem(name: 'Salmon', emoji: '🐟', cal: 208, protein: 20, carbs: 0, fat: 13, category: 'Protein'),
  _FoodItem(name: 'Egg (Large)', emoji: '🥚', cal: 155, protein: 13, carbs: 1.1, fat: 11, category: 'Protein'),
  _FoodItem(name: 'Tuna (Canned)', emoji: '🐟', cal: 116, protein: 26, carbs: 0, fat: 1, category: 'Protein'),
  _FoodItem(name: 'Beef Sirloin', emoji: '🥩', cal: 207, protein: 26, carbs: 0, fat: 11, category: 'Protein'),
  _FoodItem(name: 'Lentils', emoji: '🫘', cal: 116, protein: 9, carbs: 20, fat: 0.4, category: 'Protein'),
  _FoodItem(name: 'Greek Yogurt', emoji: '🥛', cal: 59, protein: 10, carbs: 3.6, fat: 0.4, category: 'Dairy'),
  _FoodItem(name: 'Milk (Whole)', emoji: '🥛', cal: 61, protein: 3.2, carbs: 4.8, fat: 3.3, category: 'Dairy'),
  _FoodItem(name: 'Cheddar Cheese', emoji: '🧀', cal: 403, protein: 25, carbs: 1.3, fat: 33, category: 'Dairy'),
  _FoodItem(name: 'Cottage Cheese', emoji: '🥛', cal: 98, protein: 11, carbs: 3.4, fat: 4.3, category: 'Dairy'),
  _FoodItem(name: 'Brown Rice', emoji: '🍚', cal: 216, protein: 4.5, carbs: 45, fat: 1.8, category: 'Carbs'),
  _FoodItem(name: 'White Rice', emoji: '🍚', cal: 130, protein: 2.7, carbs: 28, fat: 0.3, category: 'Carbs'),
  _FoodItem(name: 'Oatmeal', emoji: '🥣', cal: 389, protein: 17, carbs: 66, fat: 7, category: 'Carbs'),
  _FoodItem(name: 'Whole Wheat Bread', emoji: '🍞', cal: 247, protein: 13, carbs: 41, fat: 3.4, category: 'Carbs'),
  _FoodItem(name: 'Sweet Potato', emoji: '🍠', cal: 86, protein: 1.6, carbs: 20, fat: 0.1, category: 'Carbs'),
  _FoodItem(name: 'Pasta (Cooked)', emoji: '🍝', cal: 131, protein: 5, carbs: 25, fat: 1.1, category: 'Carbs'),
  _FoodItem(name: 'Banana', emoji: '🍌', cal: 89, protein: 1.1, carbs: 23, fat: 0.3, category: 'Fruit'),
  _FoodItem(name: 'Apple', emoji: '🍎', cal: 52, protein: 0.3, carbs: 14, fat: 0.2, category: 'Fruit'),
  _FoodItem(name: 'Orange', emoji: '🍊', cal: 47, protein: 0.9, carbs: 12, fat: 0.1, category: 'Fruit'),
  _FoodItem(name: 'Strawberry', emoji: '🍓', cal: 32, protein: 0.7, carbs: 7.7, fat: 0.3, category: 'Fruit'),
  _FoodItem(name: 'Blueberry', emoji: '🫐', cal: 57, protein: 0.7, carbs: 14, fat: 0.3, category: 'Fruit'),
  _FoodItem(name: 'Avocado', emoji: '🥑', cal: 160, protein: 2, carbs: 9, fat: 15, category: 'Fats'),
  _FoodItem(name: 'Almonds', emoji: '🥜', cal: 579, protein: 21, carbs: 22, fat: 50, category: 'Fats'),
  _FoodItem(name: 'Walnuts', emoji: '🥜', cal: 654, protein: 15, carbs: 14, fat: 65, category: 'Fats'),
  _FoodItem(name: 'Peanut Butter', emoji: '🥜', cal: 588, protein: 25, carbs: 20, fat: 50, category: 'Fats'),
  _FoodItem(name: 'Olive Oil', emoji: '🫒', cal: 884, protein: 0, carbs: 0, fat: 100, category: 'Fats'),
  _FoodItem(name: 'Broccoli', emoji: '🥦', cal: 34, protein: 2.8, carbs: 7, fat: 0.4, category: 'Vegetables'),
  _FoodItem(name: 'Spinach', emoji: '🥬', cal: 23, protein: 2.9, carbs: 3.6, fat: 0.4, category: 'Vegetables'),
  _FoodItem(name: 'Tomato', emoji: '🍅', cal: 18, protein: 0.9, carbs: 3.9, fat: 0.2, category: 'Vegetables'),
  _FoodItem(name: 'Carrot', emoji: '🥕', cal: 41, protein: 0.9, carbs: 10, fat: 0.2, category: 'Vegetables'),
  _FoodItem(name: 'Pizza (Margherita)', emoji: '🍕', cal: 266, protein: 11, carbs: 33, fat: 10, category: 'Fast Food'),
  _FoodItem(name: 'Burger', emoji: '🍔', cal: 295, protein: 17, carbs: 24, fat: 14, category: 'Fast Food'),
  _FoodItem(name: 'French Fries', emoji: '🍟', cal: 312, protein: 3.4, carbs: 41, fat: 15, category: 'Fast Food'),
  _FoodItem(name: 'Dark Chocolate', emoji: '🍫', cal: 598, protein: 7.8, carbs: 46, fat: 43, category: 'Snacks'),
  _FoodItem(name: 'Granola Bar', emoji: '🌾', cal: 471, protein: 9, carbs: 64, fat: 20, category: 'Snacks'),
  _FoodItem(name: 'Rice Cake', emoji: '🍘', cal: 387, protein: 8, carbs: 81, fat: 2.9, category: 'Snacks'),
];

const _categories = [
  'All', 'Protein', 'Dairy', 'Carbs', 'Fruit', 'Fats', 'Vegetables', 'Fast Food', 'Snacks',
];

// ── Screen ────────────────────────────────────────────────────────────────────

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _category = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_FoodItem> get _filtered {
    final q = _query.toLowerCase();
    return _mockFoods.where((f) {
      final matchCat = _category == 'All' || f.category == _category;
      final matchQ = q.isEmpty || f.name.toLowerCase().contains(q);
      return matchCat && matchQ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.limeDark;
    final border = isDark
        ? null
        : Border.all(color: AppColors.lightBorder, width: 0.5);

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
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: border,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: textMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Food Search',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
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
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14.r),
                  border: border,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(Icons.search_rounded, color: textMuted, size: 20.sp),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(() => _query = v),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search foods...',
                          hintStyle: TextStyle(
                            fontSize: 15.sp,
                            color: textMuted,
                            fontWeight: FontWeight.w400,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (_query.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            Icons.close_rounded,
                            color: textMuted,
                            size: 18.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),

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
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: selected ? accent : cardBg,
                        borderRadius: BorderRadius.circular(17.r),
                        border: selected
                            ? null
                            : (isDark
                                ? Border.all(
                                    color: AppColors.darkSurface, width: 1)
                                : Border.all(
                                    color: AppColors.lightBorder, width: 0.5)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? (isDark ? AppColors.void_ : Colors.white)
                              : textMuted,
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
                '${results.length} foods',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ── Food List ─────────────────────────────────────────────────
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '🔍',
                            style: TextStyle(fontSize: 40.sp),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No foods found',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
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
                        onAdd: () => _showAddSheet(context, results[i], isDark,
                            cardBg, textPrimary, textMuted, accent),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(
    BuildContext context,
    _FoodItem food,
    bool isDark,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
  ) {
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
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            padding: EdgeInsets.fromLTRB(
              24.w,
              12.h,
              24.w,
              MediaQuery.of(context).padding.bottom + 24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Food name + emoji
                Row(
                  children: [
                    Text(food.emoji,
                        style: TextStyle(fontSize: 32.sp)),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            '${cal.toStringAsFixed(0)} kcal',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: accent,
                              fontWeight: FontWeight.w700,
                            ),
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
                    _SheetMacro(label: 'Protein', value: '${pro.toStringAsFixed(1)}g', color: AppColors.violet),
                    SizedBox(width: 12.w),
                    _SheetMacro(label: 'Carbs', value: '${car.toStringAsFixed(1)}g', color: AppColors.amber),
                    SizedBox(width: 12.w),
                    _SheetMacro(label: 'Fat', value: '${fat.toStringAsFixed(1)}g', color: AppColors.coral),
                  ],
                ),
                SizedBox(height: 20.h),

                // Portion slider
                Text(
                  'Portion: ${grams.toStringAsFixed(0)} g',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
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
                      foregroundColor:
                          isDark ? AppColors.void_ : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add to Log',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
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
    final analysis = FoodAnalysis(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: food.name,
      calories: food.cal * factor,
      protein: food.protein * factor,
      carbs: food.carbs * factor,
      fat: food.fat * factor,
      fiber: 0,
      sugar: 0,
      portionDescription: '${grams.toStringAsFixed(0)}g',
      timestamp: DateTime.now(),
      mealCategory: MealCategoryX.fromTime(DateTime.now()),
      isFavorite: false,
    );
    provider.saveManualEntry(analysis);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to log'),
        backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkCard
                : AppColors.lightText,
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
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: border,
      ),
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
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '${item.cal.toStringAsFixed(0)} kcal',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                    Text(
                      '  ·  P${item.protein.toStringAsFixed(0)}g'
                      '  C${item.carbs.toStringAsFixed(0)}g'
                      '  F${item.fat.toStringAsFixed(0)}g',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: textMuted,
                        fontWeight: FontWeight.w400,
                      ),
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

  const _SheetMacro({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
