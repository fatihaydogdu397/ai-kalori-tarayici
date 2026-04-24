import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import '../services/app_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _tabIndex = 1; // 0: Today, 1: This Week, 2: 30 Days, 3: Weight

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadWeeklyStats();
      context.read<AppProvider>().loadMonthlyStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
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

    return Scaffold(
      backgroundColor: bg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              // ── App Bar ───────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                backgroundColor: bg,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 56,
                title: Text(
                  l.progress,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
              ),

              // ── Hero + Tabs + Content ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero summary card (above tabs)
                      _buildHeroSection(
                        context,
                        provider,
                        cardBg,
                        textPrimary,
                        textMuted,
                        accent,
                        border,
                        isDark,
                      ),
                      SizedBox(height: 12.h),

                      // Pill tab bar (full-width)
                      _PillTabBar(
                        selectedIndex: _tabIndex,
                        labels: [
                          l.today,
                          l.thisWeek,
                          l.thirtyDays,
                          l.weight,
                        ],
                        accent: accent,
                        cardBg: cardBg,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        isDark: isDark,
                        onTap: (i) => setState(() => _tabIndex = i),
                      ),
                      SizedBox(height: 16.h),

                      // Tab content (charts, breakdowns, insights)
                      _buildTabContent(
                        context,
                        provider,
                        cardBg,
                        textPrimary,
                        textMuted,
                        accent,
                        border,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── HERO SECTION ──────────────────────────────────────────────────────────
  // Shows a summary card above the tab bar; content changes per selected tab.

  Widget _buildHeroSection(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    switch (_tabIndex) {
      case 0:
        return _buildTodayHero(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      case 1:
        return _buildWeekHero(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      case 2:
        return _buildMonthHero(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      default:
        return _buildWeightHero(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
    }
  }

  Widget _buildTodayHero(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final tStats = provider.todayStats;
    final cal = (tStats['calories'] as num? ?? 0).toDouble();
    final pro = (tStats['protein'] as num? ?? 0).toDouble();
    final car = (tStats['carbs'] as num? ?? 0).toDouble();
    final fat = (tStats['fat'] as num? ?? 0).toDouble();
    final goal = provider.dailyCalorieGoal;
    final l = AppLocalizations.of(context);
    final calProgress = goal > 0 ? (cal / goal).clamp(0.0, 1.0) : 0.0;
    final remaining = (goal - cal).clamp(0.0, double.infinity);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row with streak chip
          Row(
            children: [
              Text(
                l.today,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (provider.streak > 0)
                _StreakChip(streak: provider.streak, accent: accent, isDark: isDark),
            ],
          ),
          SizedBox(height: 12.h),

          // Big number + ring
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          cal.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 52.sp,
                            fontWeight: FontWeight.w900,
                            color: accent,
                            height: 1,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'kcal',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: textMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      goal > 0
                          ? l.kcalRemainingGoal(remaining.toStringAsFixed(0), goal.toStringAsFixed(0))
                          : l.noGoalSet,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              SizedBox(
                width: 68.w,
                height: 68.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 7,
                      color: accent.withValues(alpha: 0.15),
                    ),
                    CircularProgressIndicator(
                      value: calProgress,
                      strokeWidth: 7,
                      color: accent,
                      strokeCap: StrokeCap.round,
                    ),
                    Text(
                      '${(calProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // 4 macro pills
          Row(
            children: [
              _MacroPill(
                label: 'Protein',
                value: '${pro.toStringAsFixed(0)}g',
                color: AppColors.violet,
                bg: isDark
                    ? AppColors.darkProteinBg
                    : AppColors.lightProteinBg,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              SizedBox(width: 8.w),
              _MacroPill(
                label: 'Carbs',
                value: '${car.toStringAsFixed(0)}g',
                color: AppColors.amber,
                bg: isDark
                    ? AppColors.darkCarbsBg
                    : AppColors.lightCarbsBg,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              SizedBox(width: 8.w),
              _MacroPill(
                label: 'Fat',
                value: '${fat.toStringAsFixed(0)}g',
                color: AppColors.coral,
                bg: isDark
                    ? AppColors.darkFatBg
                    : AppColors.lightFatBg,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
              SizedBox(width: 8.w),
              _MacroPill(
                label: 'Water',
                value: '${provider.waterToday.toStringAsFixed(1)}L',
                color: AppColors.mint,
                bg: isDark
                    ? AppColors.darkWaterBg
                    : AppColors.lightWaterBg,
                textPrimary: textPrimary,
                textMuted: textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHero(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final weekly = provider.weeklyStats;
    final avgCal = weekly.isEmpty
        ? 0.0
        : weekly.fold<double>(
                0, (s, d) => s + (d['calories'] as num).toDouble()) /
            weekly.length;
    final totalMeals = weekly.fold<int>(
      0,
      (s, d) => s + ((d['mealCount'] as num?)?.toInt() ?? 0),
    );
    final insights = provider.weeklyInsights;
    final achievement = insights.isNotEmpty
        ? (insights['goalAchievement'] as double)
        : 0.0;
    final l = AppLocalizations.of(context);

    return _HeroStatRow(
      label: l.thisWeekLabel,
      leftValue: avgCal.toStringAsFixed(0),
      leftUnit: 'kcal',
      leftSub: l.avgPerDay,
      leftColor: accent,
      rightValue: totalMeals.toString(),
      rightUnit: '',
      rightSub: l.mealsLoggedLabel,
      rightColor: AppColors.violet,
      badgeLabel: achievement > 0
          ? l.goalHitBadge(achievement.toStringAsFixed(0))
          : null,
      badgeColor: accent,
      cardBg: cardBg,
      border: border,
      textPrimary: textPrimary,
      textMuted: textMuted,
      isDark: isDark,
    );
  }

  Widget _buildMonthHero(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final monthly = provider.monthlyStats;
    final avgCal = monthly.isEmpty
        ? 0.0
        : monthly.fold<double>(
                0, (s, d) => s + (d['calories'] as num).toDouble()) /
            monthly.length;
    final totalMeals = monthly.fold<int>(
      0,
      (s, d) => s + ((d['mealCount'] as num?)?.toInt() ?? 0),
    );
    final insights = provider.monthlyInsights;
    final consistency = insights.isNotEmpty
        ? (insights['consistencyScore'] as double)
        : 0.0;
    final l = AppLocalizations.of(context);

    return _HeroStatRow(
      label: l.thirtyDays,
      leftValue: avgCal.toStringAsFixed(0),
      leftUnit: 'kcal',
      leftSub: l.avgPerDay,
      leftColor: accent,
      rightValue: totalMeals.toString(),
      rightUnit: '',
      rightSub: l.mealsLoggedLabel,
      rightColor: AppColors.violet,
      badgeLabel: consistency > 0
          ? l.consistencyBadge(consistency.toStringAsFixed(0))
          : null,
      badgeColor: AppColors.amber,
      cardBg: cardBg,
      border: border,
      textPrimary: textPrimary,
      textMuted: textMuted,
      isDark: isDark,
    );
  }

  Widget _buildWeightHero(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final logs = provider.weightLogs;
    final isImperial = provider.unitSystem == UnitSystem.imperial;
    final unit = isImperial ? 'lb' : 'kg';
    final lastWeight = logs.isNotEmpty
        ? (logs.last['weight'] as num).toDouble()
        : provider.weight;
    final targetWeight = provider.targetWeight;
    final startWeight = logs.isNotEmpty
        ? (logs.first['weight'] as num).toDouble()
        : lastWeight;
    final delta = lastWeight - startWeight;
    final hasDelta = logs.length > 1;
    final l = AppLocalizations.of(context);

    String deltaBadge = '';
    Color deltaColor = textMuted;
    if (hasDelta) {
      if (delta < 0) {
        deltaBadge = l.weightLostLabel(delta.abs().toStringAsFixed(1), unit);
        deltaColor = AppColors.mint;
      } else if (delta > 0) {
        deltaBadge = l.weightGainedLabel(delta.abs().toStringAsFixed(1), unit);
        deltaColor = AppColors.coral;
      } else {
        deltaBadge = l.weightStable;
        deltaColor = textMuted;
      }
    }

    return _HeroStatRow(
      label: l.weight,
      leftValue: lastWeight.toStringAsFixed(1),
      leftUnit: unit,
      leftSub: l.currentLabel,
      leftColor: AppColors.violet,
      rightValue: targetWeight > 0 ? targetWeight.toStringAsFixed(1) : '—',
      rightUnit: targetWeight > 0 ? unit : '',
      rightSub: l.targetLabel,
      rightColor: accent,
      badgeLabel: hasDelta ? deltaBadge : null,
      badgeColor: deltaColor,
      cardBg: cardBg,
      border: border,
      textPrimary: textPrimary,
      textMuted: textMuted,
      isDark: isDark,
    );
  }

  // ── TAB CONTENT ───────────────────────────────────────────────────────────
  // Charts, macro breakdowns, insights — no stat cards here (they're in hero).

  Widget _buildTabContent(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    switch (_tabIndex) {
      case 0:
        return _buildTodayContent(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      case 1:
        return _buildWeeklyContent(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      case 2:
        return _buildMonthlyContent(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
      default:
        return _buildWeightContent(
            context, provider, cardBg, textPrimary, textMuted, accent, border, isDark);
    }
  }

  // ── TODAY CONTENT ─────────────────────────────────────────────────────────

  Widget _buildTodayContent(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final tStats = provider.todayStats;
    final pro = (tStats['protein'] as num? ?? 0).toDouble();
    final car = (tStats['carbs'] as num? ?? 0).toDouble();
    final fat = (tStats['fat'] as num? ?? 0).toDouble();

    return _MacroBreakdownCard(
      pro: pro,
      car: car,
      fat: fat,
      cardBg: cardBg,
      border: border,
      textPrimary: textPrimary,
      textMuted: textMuted,
      isDark: isDark,
    );
  }

  // ── WEEKLY CONTENT ────────────────────────────────────────────────────────

  Widget _buildWeeklyContent(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final weekly = provider.weeklyStats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar chart
        _ChartCard(
          title: 'Calories',
          cardBg: cardBg,
          border: border,
          textPrimary: textPrimary,
          child: weekly.isEmpty
              ? _EmptyChart(textMuted: textMuted)
              : SizedBox(
                  height: 160.h,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: weekly.fold<double>(
                                  0,
                                  (m, d) =>
                                      (d['calories'] as num).toDouble() > m
                                          ? (d['calories'] as num).toDouble()
                                          : m,
                                ) *
                              1.3 +
                          100,
                      barTouchData: BarTouchData(enabled: false),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) {
                              final idx = val.toInt();
                              if (idx < 0 || idx >= weekly.length) {
                                return const SizedBox.shrink();
                              }
                              final dateStr = weekly[idx]['date'] as String;
                              try {
                                final d = DateTime.parse(dateStr);
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    DateFormat('E').format(d),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              } catch (_) {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightBorder,
                          strokeWidth: 0.5,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(weekly.length, (i) {
                        final calVal =
                            (weekly[i]['calories'] as num).toDouble();
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: calVal,
                              color: calVal > 0
                                  ? accent
                                  : (isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightBorder),
                              width: 14,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4.r),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
        ),
        SizedBox(height: 12.h),

        _MacroBreakdownFromList(
          stats: weekly,
          cardBg: cardBg,
          border: border,
          textPrimary: textPrimary,
          textMuted: textMuted,
          isDark: isDark,
        ),
        SizedBox(height: 12.h),

        _AnalysisGrid(
          insights: provider.weeklyInsights,
          isWeekly: true,
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textMuted: textMuted,
          accent: accent,
          border: border,
        ),
      ],
    );
  }

  // ── MONTHLY CONTENT ───────────────────────────────────────────────────────

  Widget _buildMonthlyContent(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final monthly = provider.monthlyStats;
    final spots = List.generate(
      monthly.length,
      (i) => FlSpot(i.toDouble(), (monthly[i]['calories'] as num).toDouble()),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line chart
        _ChartCard(
          title: 'Calories',
          cardBg: cardBg,
          border: border,
          textPrimary: textPrimary,
          child: monthly.isEmpty
              ? _EmptyChart(textMuted: textMuted)
              : SizedBox(
                  height: 160.h,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: isDark
                              ? AppColors.darkSurface
                              : AppColors.lightBorder,
                          strokeWidth: 0.5,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 7,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < 0 || idx >= monthly.length) {
                                return const SizedBox.shrink();
                              }
                              final dateStr = monthly[idx]['date'] as String;
                              try {
                                final d = DateTime.parse(dateStr);
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    '${d.day}/${d.month}',
                                    style: TextStyle(
                                      color: textMuted,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              } catch (_) {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: accent,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: accent.withValues(alpha: 0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        SizedBox(height: 12.h),

        _MacroBreakdownFromList(
          stats: monthly,
          cardBg: cardBg,
          border: border,
          textPrimary: textPrimary,
          textMuted: textMuted,
          isDark: isDark,
        ),
        SizedBox(height: 12.h),

        _AnalysisGrid(
          insights: provider.monthlyInsights,
          isWeekly: false,
          isDark: isDark,
          cardBg: cardBg,
          textPrimary: textPrimary,
          textMuted: textMuted,
          accent: accent,
          border: border,
        ),
      ],
    );
  }

  // ── WEIGHT CONTENT ────────────────────────────────────────────────────────

  Widget _buildWeightContent(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    bool isDark,
  ) {
    final logs = provider.weightLogs;
    final isImperial = provider.unitSystem == UnitSystem.imperial;
    final unit = isImperial ? 'lb' : 'kg';

    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Column(
            children: [
              Icon(
                Icons.monitor_weight_rounded,
                size: 48.sp,
                color: textMuted.withValues(alpha: 0.4),
              ),
              SizedBox(height: 16.h),
              Text(
                'No weight data yet.\nLog your weight to see your progress here.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textMuted, fontSize: 13.sp),
              ),
            ],
          ),
        ),
      );
    }

    final spots = <FlSpot>[];
    double minW = double.infinity;
    double maxW = 0.0;

    for (int i = 0; i < logs.length; i++) {
      final w = (logs[i]['weight'] as num).toDouble();
      if (w < minW) minW = w;
      if (w > maxW) maxW = w;
      spots.add(FlSpot(i.toDouble(), w));
    }
    if (minW == double.infinity) minW = 50;
    minW = (minW - 5).clamp(20.0, 300.0);
    maxW = maxW + 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line chart
        Container(
          height: 250.h,
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 24.w, 16.h),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: border,
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: (logs.length / 5).clamp(1.0, 10.0),
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= logs.length) {
                        return const SizedBox.shrink();
                      }
                      final dt = DateTime.parse(logs[i]['date'] as String);
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          '${dt.day}/${dt.month}',
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (logs.length - 1).toDouble() > 0
                  ? (logs.length - 1).toDouble()
                  : 1,
              minY: minW,
              maxY: maxW,
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.violet,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.violet,
                        strokeWidth: 2,
                        strokeColor: cardBg,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.violet.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Last 5 logs
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Logs',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              ...logs.reversed.take(5).map((log) {
                final dt = DateTime.parse(log['date'] as String);
                final w = (log['weight'] as num).toDouble();
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('d MMM y').format(dt),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '${w.toStringAsFixed(1)} $unit',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// ── PILL TAB BAR ─────────────────────────────────────────────────────────────
// Full-width segmented control, no horizontal scroll.

class _PillTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final Color accent, cardBg, textPrimary, textMuted;
  final bool isDark;
  final void Function(int) onTap;

  const _PillTabBar({
    required this.selectedIndex,
    required this.labels,
    required this.accent,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selected ? accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? (isDark ? AppColors.void_ : Colors.white)
                        : textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── HERO STAT ROW ─────────────────────────────────────────────────────────────
// Used for Week / Month / Weight hero sections.

class _HeroStatRow extends StatelessWidget {
  final String label;
  final String leftValue, leftUnit, leftSub;
  final Color leftColor;
  final String rightValue, rightUnit, rightSub;
  final Color rightColor;
  final String? badgeLabel;
  final Color? badgeColor;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;
  final bool isDark;

  const _HeroStatRow({
    required this.label,
    required this.leftValue,
    required this.leftUnit,
    required this.leftSub,
    required this.leftColor,
    required this.rightValue,
    required this.rightUnit,
    required this.rightSub,
    required this.rightColor,
    this.badgeLabel,
    this.badgeColor,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.border,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row with optional badge
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              if (badgeLabel != null) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? textMuted)
                        .withValues(alpha: isDark ? 0.15 : 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    badgeLabel!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: badgeColor ?? textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),

          // Two stat columns
          Row(
            children: [
              Expanded(child: _HeroStat(
                value: leftValue,
                unit: leftUnit,
                sub: leftSub,
                color: leftColor,
                textPrimary: textPrimary,
                textMuted: textMuted,
              )),
              Container(
                width: 1,
                height: 40.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                color: textMuted.withValues(alpha: 0.15),
              ),
              Expanded(child: _HeroStat(
                value: rightValue,
                unit: rightUnit,
                sub: rightSub,
                color: rightColor,
                textPrimary: textPrimary,
                textMuted: textMuted,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value, unit, sub;
  final Color color, textPrimary, textMuted;

  const _HeroStat({
    required this.value,
    required this.unit,
    required this.sub,
    required this.color,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: color,
                height: 1,
              ),
            ),
            if (unit.isNotEmpty) ...[
              SizedBox(width: 4.w),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          sub,
          style: TextStyle(
            fontSize: 11.sp,
            color: textMuted,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── STREAK CHIP ──────────────────────────────────────────────────────────────

class _StreakChip extends StatelessWidget {
  final int streak;
  final Color accent;
  final bool isDark;

  const _StreakChip({
    required this.streak,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: 13.sp)),
          SizedBox(width: 4.w),
          Text(
            '$streak day streak',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

// ── MACRO PILL ───────────────────────────────────────────────────────────────

class _MacroPill extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  final Color textPrimary, textMuted;

  const _MacroPill({
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── CHART CARD ────────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final Color cardBg, textPrimary;
  final Border? border;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.cardBg,
    required this.textPrimary,
    this.border,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

// ── EMPTY CHART ───────────────────────────────────────────────────────────────

class _EmptyChart extends StatelessWidget {
  final Color textMuted;
  const _EmptyChart({required this.textMuted});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Center(
        child: Text(
          'No data yet',
          style: TextStyle(color: textMuted, fontSize: 12.sp),
        ),
      ),
    );
  }
}

// ── MACRO BREAKDOWN CARD (from raw values) ────────────────────────────────────

class _MacroBreakdownCard extends StatelessWidget {
  final double pro, car, fat;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;
  final bool isDark;

  const _MacroBreakdownCard({
    required this.pro,
    required this.car,
    required this.fat,
    required this.cardBg,
    this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final total = pro + car + fat;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macro Breakdown',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              SizedBox(
                width: 100.w,
                height: 100.w,
                child: total > 0
                    ? PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 30.w,
                          sections: [
                            PieChartSectionData(
                              color: AppColors.violet,
                              value: pro,
                              title: '',
                              radius: 12.w,
                            ),
                            PieChartSectionData(
                              color: AppColors.amber,
                              value: car,
                              title: '',
                              radius: 12.w,
                            ),
                            PieChartSectionData(
                              color: AppColors.coral,
                              value: fat,
                              title: '',
                              radius: 12.w,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  children: [
                    _MacroBar(
                      label: 'Protein',
                      value: pro,
                      color: AppColors.violet,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      isDark: isDark,
                    ),
                    SizedBox(height: 10.h),
                    _MacroBar(
                      label: 'Carbs',
                      value: car,
                      color: AppColors.amber,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      isDark: isDark,
                    ),
                    SizedBox(height: 10.h),
                    _MacroBar(
                      label: 'Fat',
                      value: fat,
                      color: AppColors.coral,
                      textPrimary: textPrimary,
                      textMuted: textMuted,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── MACRO BREAKDOWN FROM LIST ─────────────────────────────────────────────────

class _MacroBreakdownFromList extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;
  final bool isDark;

  const _MacroBreakdownFromList({
    required this.stats,
    required this.cardBg,
    this.border,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();
    final pro = stats.fold<double>(
        0, (s, d) => s + (d['protein'] as num).toDouble());
    final car =
        stats.fold<double>(0, (s, d) => s + (d['carbs'] as num).toDouble());
    final fat =
        stats.fold<double>(0, (s, d) => s + (d['fat'] as num).toDouble());

    return _MacroBreakdownCard(
      pro: pro,
      car: car,
      fat: fat,
      cardBg: cardBg,
      border: border,
      textPrimary: textPrimary,
      textMuted: textMuted,
      isDark: isDark,
    );
  }
}

// ── MACRO BAR ─────────────────────────────────────────────────────────────────

class _MacroBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final Color textPrimary, textMuted;
  final bool isDark;

  const _MacroBar({
    required this.label,
    required this.value,
    required this.color,
    required this.textPrimary,
    required this.textMuted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: textMuted,
              ),
            ),
            Text(
              '${value.toStringAsFixed(0)}g',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: value > 0 ? (value / 700).clamp(0.0, 1.0) : 0,
            minHeight: 6,
            backgroundColor:
                isDark ? AppColors.darkSurface : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

// ── ANALYSIS GRID ─────────────────────────────────────────────────────────────

class _AnalysisGrid extends StatelessWidget {
  final Map<String, dynamic> insights;
  final bool isWeekly, isDark;
  final Color cardBg, textPrimary, textMuted, accent;
  final Border? border;

  const _AnalysisGrid({
    required this.insights,
    required this.isWeekly,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    final achievement = insights['goalAchievement'] as double;
    final consistency = insights['consistencyScore'] as double;
    final avgWater = insights['avgWater'] as double;
    final topMeal = insights['topMeal'] as String?;

    String mealStr = '-';
    if (topMeal != null) {
      const map = {
        'breakfast': 'Breakfast',
        'lunch': 'Lunch',
        'dinner': 'Dinner',
        'snack': 'Snack',
      };
      mealStr = map[topMeal] ?? topMeal;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            isWeekly ? 'Weekly Insights' : 'Monthly Insights',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
          children: [
            _InsightItem(
              label: 'Goal Achievement',
              value: '%${achievement.toStringAsFixed(0)}',
              icon: Icons.track_changes_rounded,
              iconColor: accent,
              cardBg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
            _InsightItem(
              label: 'Consistency',
              value: '%${consistency.toStringAsFixed(0)}',
              icon: Icons.auto_awesome_rounded,
              iconColor: AppColors.amber,
              cardBg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
            _InsightItem(
              label: 'Avg Water',
              value: '${avgWater.toStringAsFixed(1)}L',
              icon: Icons.water_drop_rounded,
              iconColor: Colors.blueAccent,
              cardBg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
            _InsightItem(
              label: 'Top Meal',
              value: mealStr,
              icon: Icons.restaurant_rounded,
              iconColor: AppColors.coral,
              cardBg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
          ],
        ),
      ],
    );
  }
}

// ── INSIGHT ITEM ──────────────────────────────────────────────────────────────

class _InsightItem extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color iconColor, cardBg, textPrimary, textMuted;
  final Border? border;

  const _InsightItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.cardBg,
    this.border,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
