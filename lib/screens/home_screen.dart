import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/food_analysis.dart';
import '../generated/app_localizations.dart';
import '../widgets/portion_picker_sheet.dart';
import '../widgets/liquid_wave_progress.dart';
import 'result_screen.dart';
import 'progress_screen.dart';
import 'program_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';
import 'barcode_scanner_screen.dart';
import 'paywall_screen.dart';
import 'food_search_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      context.read<AppProvider>().syncBackendProfileAndSettings();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024, imageQuality: 85);
    if (picked == null || !mounted) return;

    final provider = context.read<AppProvider>();

    // PorsiyonPickerSheet aç
    final result = await showModalBottomSheet<({int amount, bool isLiquid, CookingMethod? cooking})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PortionPickerSheet(),
    );
    if (result == null || !mounted) return;

    // AI Analizine gönder (AppProvider kendi içinde kalıcı kopyalama yapıyor)
    await provider.analyzeImage(picked.path, portionAmount: result.amount, isLiquid: result.isLiquid, cooking: result.cooking);

    if (!mounted) return;
    if (provider.state == AnalysisState.success && provider.currentAnalysis != null) {
      final retry = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(analysis: provider.currentAnalysis!, allowRetry: true)),
      );
      provider.resetState();
      if (retry == true && mounted) {
        _pickImage(source);
      }
    } else if (provider.state == AnalysisState.error) {
      final l = AppLocalizations.of(context);
      if (provider.errorMessage == 'limit_reached') {
        _showPaywall();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l.errorGeneric}: ${provider.errorMessage}'), backgroundColor: AppColors.coral));
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
                  icon: Icons.search_rounded,
                  label: 'Search',
                  isDark: isDark,
                  iconColor: isDark ? AppColors.lime : AppColors.limeDark,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodSearchScreen()));
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
    if (AppProvider.kBypassPaywall) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  void _showAddWater(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.mint : AppColors.mintDark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) {
        final provider = context.watch<AppProvider>();
        final water = provider.waterToday;
        final goal = provider.waterGoal;
        final progress = (water / goal).clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(sheetCtx).padding.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: Text('💧', style: TextStyle(fontSize: 24.sp)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.waterToday,
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: textPrimary),
                        ),
                        Text(
                          '${water.toStringAsFixed(1)}L / ${goal.toStringAsFixed(1)}L',
                          style: TextStyle(fontSize: 13.sp, color: textMuted, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(sheetCtx);
                      _showWaterGoalEditor(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightSurface, shape: BoxShape.circle),
                      child: Icon(Icons.settings_outlined, size: 18, color: textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              LiquidWaveProgress(progress: progress, color: accent, size: 140.w),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final btnWidth = (constraints.maxWidth - 24) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _WaterActionButton(
                        label: '+250ml',
                        width: btnWidth,
                        accent: accent,
                        isDark: isDark,
                        onTap: () async {
                          final provider = context.read<AppProvider>();
                          await provider.addWater(0.25);
                          if (context.mounted) provider.syncNotification(AppLocalizations.of(context));
                        },
                      ),
                      _WaterActionButton(
                        label: '+500ml',
                        width: btnWidth,
                        accent: accent,
                        isDark: isDark,
                        onTap: () async {
                          final provider = context.read<AppProvider>();
                          await provider.addWater(0.5);
                          if (context.mounted) provider.syncNotification(AppLocalizations.of(context));
                        },
                      ),
                      _WaterActionButton(
                        label: '+700ml',
                        width: btnWidth,
                        accent: accent,
                        isDark: isDark,
                        onTap: () async {
                          final provider = context.read<AppProvider>();
                          await provider.addWater(0.7);
                          if (context.mounted) provider.syncNotification(AppLocalizations.of(context));
                        },
                      ),
                      _WaterActionButton(
                        label: AppLocalizations.of(context).manual,
                        width: btnWidth,
                        accent: accent,
                        isDark: isDark,
                        isSecondary: true,
                        onTap: () => _showCustomWaterEditor(context),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l.reset),
                      content: Text(l.confirmDelete),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
                        TextButton(
                          onPressed: () async {
                            final provider = context.read<AppProvider>();
                            await provider.resetWater();
                            if (context.mounted) {
                              provider.syncNotification(AppLocalizations.of(context));
                              Navigator.pop(ctx);
                            }
                          },
                          child: Text(l.reset, style: const TextStyle(color: AppColors.coral)),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  l.reset.toUpperCase(),
                  style: TextStyle(fontSize: 12.sp, color: AppColors.coral.withValues(alpha: 0.8), fontWeight: FontWeight.w700, letterSpacing: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCustomWaterEditor(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.mint : AppColors.mintDark;
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l.manual, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ml (örn: 330)',
            filled: true,
            fillColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          ElevatedButton(
            onPressed: () {
              final ml = double.tryParse(controller.text);
              if (ml != null && ml > 0) {
                final provider = context.read<AppProvider>();
                provider.addWater(ml / 1000).then((_) {
                  if (context.mounted) provider.syncNotification(AppLocalizations.of(context));
                });
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l.save),
          ),
        ],
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
                inactiveColor: accent.withValues(alpha: 0.2),
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
    final pages = [_buildDashboardPage(isDark), const ProgressScreen(), const ProgramScreen(), const ProfileScreen()];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      floatingActionButton: _buildFAB(isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.state == AnalysisState.loading && _tab == 0) {
            return _buildLoading(isDark);
          }
          final body = pages[_tab];
          if (_tab == 0 && provider.isTodaySelected) {
            return RefreshIndicator(
              color: isDark ? AppColors.lime : AppColors.limeDark,
              onRefresh: () async {
                await provider.fetchHistoryByDate(DateTime.now());
              },
              child: body,
            );
          }
          return body;
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
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
    // Only selected date's meals, grouped by category in display order
    final targetDate = context.read<AppProvider>().selectedDate;
    final isToday = context.read<AppProvider>().isTodaySelected;

    final selectedMeals = history
        .where((a) => a.analyzedAt.year == targetDate.year && a.analyzedAt.month == targetDate.month && a.analyzedAt.day == targetDate.day)
        .toList();

    if (selectedMeals.isEmpty) {
      // Show recent meals without grouping
      return Column(
        children: history
            .take(5)
            .map(
              (a) => _MealRow(
                analysis: a,
                isDark: isDark,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(analysis: a))),
                onDelete: isToday ? () => context.read<AppProvider>().deleteAnalysis(a.id) : null,
                onFavorite: isToday ? () => context.read<AppProvider>().toggleFavorite(a) : null,
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
      final meals = selectedMeals.where((a) => a.mealCategory == cat).toList();
      if (meals.isEmpty) continue;
      final (icon, label) = labels[cat]!;
      final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 6.w),
              Text(
                label.toUpperCase(),
                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1),
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
            onDelete: isToday ? () => context.read<AppProvider>().deleteAnalysis(a.id) : null,
            onFavorite: isToday ? () => context.read<AppProvider>().toggleFavorite(a) : null,
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
        final months = [
          l.month01,
          l.month02,
          l.month03,
          l.month04,
          l.month05,
          l.month06,
          l.month07,
          l.month08,
          l.month09,
          l.month10,
          l.month11,
          l.month12,
        ];
        final dateStr = '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';

        final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
        final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
        final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
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
                      Text(dateStr, style: TextStyle(fontSize: 13, color: textMuted)),
                      const SizedBox(height: 2),
                      Text(
                        l.greeting(name),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (provider.streak > 0)
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l.streakDays(provider.streak),
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.void_),
                                      ),
                                      Text(
                                        provider.streak == 7
                                            ? l.streakMilestone7
                                            : provider.streak == 30
                                            ? l.streakMilestone30
                                            : l.streakMotivation,
                                        style: TextStyle(fontSize: 12.sp, color: AppColors.void_.withValues(alpha: 0.8)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.lime,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: isDark ? 0.2 : 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
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
            // Weekly calendar strip
            SliverToBoxAdapter(child: _WeeklyCalendar(isDark: isDark)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Kalori kartı
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14.r),
                        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80.w,
                            height: 80.w,
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
                                      style: AppTypography.titleMedium.copyWith(color: textPrimary, fontWeight: FontWeight.w800),
                                    ),
                                    Text(
                                      'kcal',
                                      textAlign: TextAlign.center,
                                      style: AppTypography.labelSmall.copyWith(color: textMuted),
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
                                Text(l.caloriestoday, style: AppTypography.bodySmall.copyWith(color: textMuted)),
                                SizedBox(height: 3.h),
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
                                          style: AppTypography.displayLarge.copyWith(color: isDark ? AppColors.lime : AppColors.limeDeep),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '/ ${goal.toStringAsFixed(0)}',
                                      style: AppTypography.bodySmall.copyWith(color: textMuted),
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
                        // Su makro pill (compact)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showAddWater(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkWaterBg : AppColors.lightWaterBg,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: AppColors.mint.withValues(alpha: 0.4), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('💧', style: TextStyle(fontSize: 14.sp)),
                                      SizedBox(width: 4.w),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${water.toStringAsFixed(1)}L',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? AppColors.mint : AppColors.mintDark,
                                              height: 1.1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: waterProgress,
                                      minHeight: 5,
                                      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                                      valueColor: AlwaysStoppedAnimation(isDark ? AppColors.mint : AppColors.mintDark),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    l.waterToday,
                                    style: AppTypography.bodySmall.copyWith(color: textMuted, fontSize: 9.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Health widgets row: Steps + Water
                    Row(
                      children: [
                        // Step counter (iOS only via Apple Health)
                        if (provider.healthEnabled)
                          Expanded(
                            child: _StepCounterCard(
                              steps: provider.todaySteps,
                              burnedCal: provider.todayActiveCalories,
                              isDark: isDark,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              cardBg: cardBg,
                            ),
                          ),
                        if (provider.healthEnabled) const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Favoriler
                    if (provider.isTodaySelected && provider.favorites.isNotEmpty) ...[
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
                          separatorBuilder: (context2, s) => const SizedBox(width: 8),
                          itemBuilder: (_, i) {
                            final fav = provider.favorites[i];
                            return GestureDetector(
                              onTap: () async {
                                await context.read<AppProvider>().duplicateAnalysisToToday(fav);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✓ ${l.addedToLog}'),
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppColors.limeDark,
                                    ),
                                  );
                                }
                              },
                              onLongPress: () => context.read<AppProvider>().toggleFavorite(fav),
                              child: Container(
                                width: 110,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isDark
                                      ? Border.all(color: AppColors.coral.withValues(alpha: 0.25), width: 1)
                                      : Border.all(color: AppColors.lightBorder, width: 0.5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      fav.displayName.isNotEmpty ? fav.displayName : l.mealFallback,
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

                    Text(l.todaysMeals, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
                    SizedBox(height: 12.h),

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

  Widget _buildFAB(bool isDark) {
    final fabBg = isDark ? AppColors.lime : AppColors.void_;
    final fabFg = isDark ? AppColors.void_ : AppColors.snow;
    return FloatingActionButton(
      onPressed: _showScanSheet,
      backgroundColor: fabBg,
      foregroundColor: fabFg,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Icon(Icons.add_rounded, size: 28.sp),
    );
  }

  Widget _buildNavBar(bool isDark) {
    final l = AppLocalizations.of(context);
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final iconActive = isDark ? AppColors.darkText : AppColors.lightText;
    final iconInactive = isDark ? AppColors.darkTextMuted : const Color(0xFFCCCCDD);
    final labelActive = isDark ? AppColors.lime : AppColors.void_;

    final items = [
      (Icons.home_rounded, l.navDaily),
      (Icons.bar_chart_rounded, l.progress),
      (Icons.restaurant_menu_rounded, l.navProgram),
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
              return GestureDetector(
                onTap: () => setState(() => _tab = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i].$1, color: isActive ? iconActive : iconInactive, size: 22),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$2,
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        color: isActive ? labelActive : iconInactive,
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
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: valueColor.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: AppTypography.titleMedium.copyWith(color: valueColor, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(color: textMuted),
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
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);

    final card = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10), border: border),
        child: Row(
          children: [
            _mealThumb(imagePath: analysis.imagePath, category: analysis.mealCategory, isDark: isDark),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.displayName.isNotEmpty ? analysis.displayName : 'Öğün',
                    maxLines: 2,
                    style: AppTypography.bodyLarge.copyWith(color: textPrimary, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(height: 2.h),
                  Text(_timeAgo(analysis.analyzedAt), style: AppTypography.bodySmall.copyWith(color: textMuted)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(color: isDark ? AppColors.darkBg : AppColors.lightSurface, borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    analysis.totalCalories.toStringAsFixed(0),
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: calColor),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(fontSize: 10.sp, color: textMuted),
                  ),
                ],
              ),
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
        decoration: BoxDecoration(color: AppColors.coral.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.delete_rounded, color: AppColors.coral, size: 20),
      ),
      child: card,
    );
  }

  Widget _mealThumb({required String imagePath, required MealCategory category, required bool isDark}) {
    const size = 44.0;
    const radius = 10.0;

    // Fotoğraf varsa göster
    if (imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.file(file, width: size, height: size, fit: BoxFit.cover),
        );
      }
    }

    // Fotoğraf yoksa kategori placeholder
    final cfg = _categoryConfig(category, isDark);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: cfg.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Icon(cfg.icon, color: Colors.white.withValues(alpha: 0.92), size: 22),
    );
  }

  ({List<Color> gradient, IconData icon}) _categoryConfig(MealCategory cat, bool isDark) {
    switch (cat) {
      case MealCategory.breakfast:
        return (gradient: [const Color(0xFFF97316), const Color(0xFFFBBF24)], icon: Icons.coffee_rounded);
      case MealCategory.lunch:
        return (gradient: [const Color(0xFF0EA5E9), const Color(0xFF38BDF8)], icon: Icons.lunch_dining_rounded);
      case MealCategory.dinner:
        return (gradient: [const Color(0xFF7C3AED), const Color(0xFFA78BFA)], icon: Icons.dinner_dining_rounded);
      case MealCategory.snack:
        return (gradient: [const Color(0xFF10B981), const Color(0xFF34D399)], icon: Icons.cookie_rounded);
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

// ── Weekly Calendar Strip ─────────────────────────────────────────────────────
class _WeeklyCalendar extends StatelessWidget {
  final bool isDark;
  const _WeeklyCalendar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final provider = context.watch<AppProvider>();
    final now = DateTime.now();
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    // Show 7 days: Today - 6 days -> Today
    final startOfWeek = now.subtract(const Duration(days: 6));
    final dayLabels = [l.monday, l.tuesday, l.wednesday, l.thursday, l.friday, l.saturday, l.sunday];

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final day = startOfWeek.add(Duration(days: i));
          final isSelected = day.day == provider.selectedDate.day && day.month == provider.selectedDate.month;
          return GestureDetector(
            onTap: () {
              provider.setSelectedDate(day);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayLabels[day.weekday - 1].substring(0, 3).toUpperCase(),
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: isSelected ? accent : textMuted),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(color: isSelected ? accent : Colors.transparent, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: isSelected ? accentFg : textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Step Counter Card ─────────────────────────────────────────────────────────
class _StepCounterCard extends StatelessWidget {
  final int steps;
  final double burnedCal;
  final bool isDark;
  final Color textPrimary, textMuted, cardBg;
  static const int stepGoal = 10000;

  const _StepCounterCard({
    required this.steps,
    required this.burnedCal,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (steps / stepGoal).clamp(0.0, 1.0);
    final accentColor = isDark ? AppColors.violet : AppColors.violetDark;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_walk_rounded, size: 16.sp, color: accentColor),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).stepsToday,
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: textMuted),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            steps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.'),
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: textPrimary),
          ),
          Text(
            '/ $stepGoal',
            style: TextStyle(fontSize: 10.sp, color: textMuted),
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          if (burnedCal > 0) ...[
            SizedBox(height: 6.h),
            Text(
              '🔥 ${burnedCal.toStringAsFixed(0)} ${AppLocalizations.of(context).caloriesBurned}',
              style: TextStyle(fontSize: 10.sp, color: textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _WaterActionButton extends StatelessWidget {
  final String label;
  final double width;
  final Color accent;
  final bool isDark;
  final VoidCallback onTap;
  final bool isSecondary;

  const _WaterActionButton({
    required this.label,
    required this.width,
    required this.accent,
    required this.isDark,
    required this.onTap,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSecondary ? (isDark ? AppColors.darkSurface : AppColors.lightSurface) : accent.withValues(alpha: isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSecondary ? (isDark ? AppColors.darkSurface : AppColors.lightBorder) : accent.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isDark ? [] : [BoxShadow(color: accent.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: isSecondary ? (isDark ? AppColors.darkText : AppColors.lightText) : (isDark ? accent : AppColors.mintDark),
            ),
          ),
        ),
      ),
    );
  }
}
