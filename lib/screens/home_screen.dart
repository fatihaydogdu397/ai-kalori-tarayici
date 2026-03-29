import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/food_analysis.dart';
import '../generated/app_localizations.dart';
import '../widgets/portion_picker_sheet.dart';
import 'result_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'manual_entry_screen.dart';
import 'barcode_scanner_screen.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _picker = ImagePicker();
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadHistory();
      context.read<AppProvider>().loadTodayStats();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85, maxWidth: 1920, maxHeight: 1920);
    if (picked == null || !mounted) return;

    // Porsiyon & pişirme seç
    final result = await showModalBottomSheet<({int grams, CookingMethod cooking})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PortionPickerSheet(),
    );
    if (result == null || !mounted) return;

    final provider = context.read<AppProvider>();
    await provider.analyzeImage(
      picked.path,
      portionGrams: result.grams,
      cooking: result.cooking,
    );

    if (!mounted) return;
    if (provider.state == AnalysisState.success && provider.currentAnalysis != null) {
      final retry = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            analysis: provider.currentAnalysis!,
            allowRetry: true,
          ),
        ),
      );
      provider.resetState();
      if (retry == true && mounted) {
        _pickImage(source);
      }
    } else if (provider.state == AnalysisState.error) {
      if (provider.errorMessage == 'limit_reached') {
        _showPaywall();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.of(context).errorGeneric}: ${provider.errorMessage}'),
          backgroundColor: AppColors.coral,
        ));
      }
    }
  }

  void _showScanSheet() {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _SheetButton(
                  icon: Icons.camera_alt_rounded,
                  label: l.camera,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 12),
                _SheetButton(
                  icon: Icons.photo_library_rounded,
                  label: l.gallery,
                  isDark: isDark,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const SizedBox(width: 12),
                _SheetButton(
                  icon: Icons.edit_rounded,
                  label: l.manual,
                  isDark: isDark,
                  iconColor: isDark ? AppColors.violet : AppColors.violetDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualEntryScreen()));
                  },
                ),
                const SizedBox(width: 12),
                _SheetButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: l.barcode,
                  isDark: isDark,
                  iconColor: isDark ? AppColors.amber : AppColors.amberDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaywall() {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Text('⚡', style: TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 16),
            Text(
              l.limitReached,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkText : AppColors.lightText),
            ),
            const SizedBox(height: 8),
            Text(
              l.limitReachedSub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            ...[l.unlimitedScans, l.unlimitedHistory, l.weeklyReport, l.turkishDB].map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: accent, size: 18),
                    const SizedBox(width: 10),
                    Text(f, style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkText : AppColors.lightText)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: accentFg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(l.goProBtn, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 10),
            Text(l.yearlyDiscount, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
      ),
    );
  }

  void _showAddWater(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.mint : AppColors.mintDark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.waterAdd,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _showWaterGoalEditor(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      l.waterGoal,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [0.1, 0.2, 0.25, 0.33, 0.5].map((amount) {
                return GestureDetector(
                  onTap: () {
                    context.read<AppProvider>().addWater(amount);
                    Navigator.pop(sheetCtx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(color: accent.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          '${(amount * 1000).toStringAsFixed(0)}ml',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: accent),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showWaterGoalEditor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final provider = context.read<AppProvider>();
    double tempGoal = provider.waterGoal;
    final accent = isDark ? AppColors.mint : AppColors.mintDark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Text(
                l.waterGoal,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkText : AppColors.lightText),
              ),
              const SizedBox(height: 24),
              Text(
                '${tempGoal.toStringAsFixed(1)} L',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: accent),
              ),
              const SizedBox(height: 8),
              Slider(
                value: tempGoal,
                min: 1.0,
                max: 5.0,
                divisions: 16,
                activeColor: accent,
                inactiveColor: accent.withOpacity(0.2),
                onChanged: (v) => setS(() => tempGoal = v),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1.0L', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary)),
                  Text('5.0L', style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.setWaterGoal(tempGoal);
                    Navigator.pop(sheetCtx);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: isDark ? AppColors.void_ : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l.save, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = [
      _buildDashboardPage(isDark),
      const SizedBox.shrink(), // Tara — FAB ile açılıyor
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (_tab == 1) {
            // Tara tab'ına basıldığında direkt sheet aç, 0'a dön
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_tab == 1) {
                setState(() => _tab = 0);
                _showScanSheet();
              }
            });
            return pages[0];
          }
          if (provider.state == AnalysisState.loading && _tab == 0) {
            return _buildLoading(isDark);
          }
          return pages[_tab];
        },
      ),
      bottomNavigationBar: _buildNavBar(isDark),
    );
  }

  Widget _buildLoading(bool isDark) {
    final l = AppLocalizations.of(context);
    final baseColor = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final highlightColor = isDark ? AppColors.darkSurface : Colors.white;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l.analyzing,
            style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(l.analyzingSub, style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildGroupedMeals(List<FoodAnalysis> history, bool isDark, AppLocalizations l) {
    // Only today's meals, grouped by category in display order
    final today = DateTime.now();
    final todayMeals = history
        .where((a) => a.analyzedAt.year == today.year && a.analyzedAt.month == today.month && a.analyzedAt.day == today.day)
        .toList();

    if (todayMeals.isEmpty) {
      // Show recent meals without grouping
      return Column(
        children: history
            .take(5)
            .map(
              (a) => _MealRow(
                analysis: a,
                isDark: isDark,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(analysis: a))),
                onDelete: () => context.read<AppProvider>().deleteAnalysis(a.id),
                onFavorite: () => context.read<AppProvider>().toggleFavorite(a),
                l: l,
              ),
            )
            .toList(),
      );
    }

    final order = [MealCategory.breakfast, MealCategory.lunch, MealCategory.dinner, MealCategory.snack];
    final labels = {
      MealCategory.breakfast: ('🌅', l.mealBreakfast),
      MealCategory.lunch: ('☀️', l.mealLunch),
      MealCategory.dinner: ('🌙', l.mealDinner),
      MealCategory.snack: ('🍎', l.mealSnack),
    };

    final widgets = <Widget>[];
    for (final cat in order) {
      final meals = todayMeals.where((a) => a.mealCategory == cat).toList();
      if (meals.isEmpty) continue;
      final (icon, label) = labels[cat]!;
      final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Text(
                label.toUpperCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      );
      widgets.addAll(
        meals.map(
          (a) => _MealRow(
            analysis: a,
            isDark: isDark,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(analysis: a))),
            onDelete: () => context.read<AppProvider>().deleteAnalysis(a.id),
            onFavorite: () => context.read<AppProvider>().toggleFavorite(a),
            l: l,
          ),
        ),
      );
    }
    return Column(children: widgets);
  }

  Widget _buildDashboardPage(bool isDark) {
    final l = AppLocalizations.of(context);
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final now = DateTime.now();
        final days = [l.monday, l.tuesday, l.wednesday, l.thursday, l.friday, l.saturday, l.sunday];
        final months = [l.month01, l.month02, l.month03, l.month04, l.month05, l.month06, l.month07, l.month08, l.month09, l.month10, l.month11, l.month12];
        final dateStr = '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';

        final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
        final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
        final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
        final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
        final calories = provider.todayStats['calories'] ?? 0;
        final goal = provider.dailyCalorieGoal;
        final progress = (calories / goal).clamp(0.0, 1.0);
        final water = provider.waterToday;
        final waterGoal = provider.waterGoal;
        final waterProgress = (water / waterGoal).clamp(0.0, 1.0);
        final name = provider.userName.isEmpty ? l.defaultName : provider.userName;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              automaticallyImplyLeading: false,
              backgroundColor: bg,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 60,
              titleSpacing: 20,
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateStr, style: TextStyle(fontSize: 11, color: textMuted)),
                      const SizedBox(height: 2),
                      Text(
                        l.greeting(name),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (provider.streak > 0)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.amber.withOpacity(isDark ? 0.2 : 0.15), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 13)),
                          const SizedBox(width: 3),
                          Text(
                            '${provider.streak}',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: isDark ? AppColors.amber : AppColors.amberDark),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                      ),
                      child: Icon(Icons.history_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Kalori kartı
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 1,
                                  strokeWidth: 7,
                                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                  constraints: BoxConstraints.expand(),
                                ),
                                CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 7,
                                  color: isDark ? AppColors.lime : AppColors.limeDark,
                                  strokeCap: StrokeCap.round,
                                  constraints: BoxConstraints.expand(),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      calories.toStringAsFixed(0),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary, height: 1.1),
                                    ),
                                    Text(
                                      'kcal',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10, color: textMuted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l.caloriestoday, style: TextStyle(fontSize: 11, color: textMuted)),
                                const SizedBox(height: 3),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          calories.toStringAsFixed(0),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? AppColors.lime : AppColors.limeDeep,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '/ ${goal.toStringAsFixed(0)}',
                                      style: TextStyle(fontSize: 11, color: textMuted),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 5,
                                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                    valueColor: AlwaysStoppedAnimation(isDark ? AppColors.lime : AppColors.limeDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Makro pills
                    Row(
                      children: [
                        _MacroPill(
                          value: '${(provider.todayStats['protein'] ?? 0).toStringAsFixed(0)}g',
                          label: l.protein,
                          valueColor: isDark ? AppColors.violet : AppColors.violetDark,
                          bg: isDark ? AppColors.darkProteinBg : AppColors.lightProteinBg,
                        ),
                        const SizedBox(width: 6),
                        _MacroPill(
                          value: '${(provider.todayStats['carbs'] ?? 0).toStringAsFixed(0)}g',
                          label: l.carbs,
                          valueColor: isDark ? AppColors.amber : AppColors.amberDark,
                          bg: isDark ? AppColors.darkCarbsBg : AppColors.lightCarbsBg,
                        ),
                        const SizedBox(width: 6),
                        _MacroPill(
                          value: '${(provider.todayStats['fat'] ?? 0).toStringAsFixed(0)}g',
                          label: l.fat,
                          valueColor: isDark ? AppColors.coral : AppColors.coralDark,
                          bg: isDark ? AppColors.darkFatBg : AppColors.lightFatBg,
                        ),
                        const SizedBox(width: 6),
                        // Su — tıklanınca su ekleme sheet'i açar
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showAddWater(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkWaterBg : AppColors.lightWaterBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.mint.withOpacity(0.25), width: 1),
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${water.toStringAsFixed(1)}L',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.mint : AppColors.mintDark,
                                        height: 1.1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('/ ${waterGoal.toStringAsFixed(1)}L', style: TextStyle(fontSize: 9, color: textMuted)),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: waterProgress,
                                        minHeight: 2,
                                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                                        valueColor: AlwaysStoppedAnimation(isDark ? AppColors.mint : AppColors.mintDark),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Favoriler
                    if (provider.favorites.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.favorite_rounded, size: 12, color: AppColors.coral),
                          const SizedBox(width: 5),
                          Text(
                            l.favorites,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: provider.favorites.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final fav = provider.favorites[i];
                            return GestureDetector(
                              onTap: () async {
                                final newAnalysis = FoodAnalysis(
                                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                                  imagePath: fav.imagePath,
                                  foods: fav.foods,
                                  totalNutrients: fav.totalNutrients,
                                  summary: fav.summary,
                                  advice: fav.advice,
                                  analyzedAt: DateTime.now(),
                                  mealCategory: MealCategoryX.fromTime(DateTime.now()),
                                );
                                await context.read<AppProvider>().saveManualEntry(newAnalysis);
                              },
                              onLongPress: () => context.read<AppProvider>().toggleFavorite(fav),
                              child: Container(
                                width: 110,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isDark
                                      ? Border.all(color: AppColors.coral.withOpacity(0.25), width: 1)
                                      : Border.all(color: AppColors.lightBorder, width: 0.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fav.summary.isNotEmpty ? fav.summary : l.mealFallback,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? AppColors.darkText : AppColors.lightText,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${fav.totalCalories.toStringAsFixed(0)} kcal',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark ? AppColors.lime : AppColors.limeDeep,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(l.addMealShort, style: TextStyle(fontSize: 9, color: textMuted)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(l.todaysMeals, style: TextStyle(fontSize: 11, color: textMuted)),
                    const SizedBox(height: 8),

                    if (provider.history.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(14),
                          border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('🍽️', style: TextStyle(fontSize: 36)),
                              const SizedBox(height: 12),
                              Text(
                                l.noMeals,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.scanFirstMeal,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      _buildGroupedMeals(provider.history, isDark, l),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNavBar(bool isDark) {
    final l = AppLocalizations.of(context);
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final iconActive = isDark ? AppColors.darkText : AppColors.lightText;
    final iconInactive = isDark ? AppColors.darkTextMuted : const Color(0xFFCCCCDD);
    final camBg = isDark ? AppColors.lime : AppColors.void_;
    final camIcon = isDark ? AppColors.void_ : AppColors.lime;
    final labelActive = isDark ? AppColors.lime : AppColors.void_;

    final items = [
      (Icons.home_rounded, l.home),
      (Icons.camera_alt_rounded, l.scan),
      (Icons.bar_chart_rounded, l.progress),
      (Icons.person_rounded, l.profile),
    ];

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = _tab == i;
              final isCam = i == 1;
              return GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isCam
                        ? Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: camBg, borderRadius: BorderRadius.circular(12)),
                            child: Icon(items[i].$1, color: camIcon, size: 20),
                          )
                        : Icon(items[i].$1, color: isActive ? iconActive : iconInactive, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$2,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        color: isCam ? (isDark ? AppColors.darkTextMuted : const Color(0xFFBBBBCC)) : (isActive ? labelActive : iconInactive),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String value, label;
  final Color valueColor, bg;
  const _MacroPill({required this.value, required this.label, required this.valueColor, required this.bg});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: valueColor.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: valueColor, height: 1.1),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final FoodAnalysis analysis;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final AppLocalizations l;
  const _MealRow({required this.analysis, required this.isDark, required this.onTap, required this.l, this.onDelete, this.onFavorite});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);
    final iconBg = isDark ? AppColors.darkCarbsBg : AppColors.lightCarbsBg;

    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10), border: border),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(_categoryEmoji(analysis.mealCategory), style: const TextStyle(fontSize: 15))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.foods.isNotEmpty
                        ? analysis.foods.first.nameTr
                        : analysis.summary.isNotEmpty
                        ? analysis.summary
                        : 'Öğün',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  Text(_timeAgo(analysis.analyzedAt), style: TextStyle(fontSize: 10, color: textMuted)),
                ],
              ),
            ),
            Text(
              analysis.totalCalories.toStringAsFixed(0),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: calColor),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFavorite,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                analysis.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 16,
                color: analysis.isFavorite ? AppColors.coral : textMuted,
              ),
            ),
          ],
        ),
      ),
    );

    if (onDelete == null) return card;

    return Dismissible(
      key: Key(analysis.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete!(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 6),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        decoration: BoxDecoration(color: AppColors.coral.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.delete_rounded, color: AppColors.coral, size: 20),
      ),
      child: card,
    );
  }

  String _categoryEmoji(MealCategory cat) {
    switch (cat) {
      case MealCategory.breakfast:
        return '🌅';
      case MealCategory.lunch:
        return '☀️';
      case MealCategory.dinner:
        return '🌙';
      case MealCategory.snack:
        return '🍎';
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return l.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l.hoursAgo(diff.inHours);
    return l.daysAgo(diff.inDays);
  }
}

class _SheetButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;
  final Color? iconColor;
  const _SheetButton({required this.icon, required this.label, required this.isDark, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              Icon(icon, color: iconColor ?? AppColors.lime, size: 30),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
