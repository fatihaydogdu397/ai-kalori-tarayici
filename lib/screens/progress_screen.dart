import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _tabIndex = 1; // 0: Günlük, 1: Haftalık, 2: Aylık

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
    final textMuted = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: _tabIndex,
                    children: {
                      0: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l.today,
                          style: TextStyle(
                            color: _tabIndex == 0
                                ? (isDark ? Colors.black : Colors.white)
                                : textPrimary,
                          ),
                        ),
                      ),
                      1: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l.thisWeek,
                          style: TextStyle(
                            color: _tabIndex == 1
                                ? (isDark ? Colors.black : Colors.white)
                                : textPrimary,
                          ),
                        ),
                      ),
                      2: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "30 Gün",
                          style: TextStyle(
                            color: _tabIndex == 2
                                ? (isDark ? Colors.black : Colors.white)
                                : textPrimary,
                          ),
                        ),
                      ),
                      3: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l.weight,
                          style: TextStyle(
                            color: _tabIndex == 3
                                ? (isDark ? Colors.black : Colors.white)
                                : textPrimary,
                          ),
                        ),
                      ),
                    },
                    thumbColor: accent,
                    backgroundColor: cardBg,
                    onValueChanged: (val) {
                      if (val != null) setState(() => _tabIndex = val);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 100),
                  child: _buildSelectedView(
                    context,
                    provider,
                    bg,
                    cardBg,
                    textPrimary,
                    textMuted,
                    accent,
                    border,
                    l,
                    isDark,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedView(
    BuildContext context,
    AppProvider provider,
    Color bg,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    AppLocalizations l,
    bool isDark,
  ) {
    if (_tabIndex == 0)
      return _buildDailyView(
        context,
        provider,
        cardBg,
        textPrimary,
        textMuted,
        accent,
        border,
        l,
        isDark,
      );
    if (_tabIndex == 1)
      return _buildWeeklyView(
        context,
        provider,
        cardBg,
        textPrimary,
        textMuted,
        accent,
        border,
        l,
        isDark,
      );
    if (_tabIndex == 2)
      return _buildMonthlyView(
        context,
        provider,
        cardBg,
        textPrimary,
        textMuted,
        accent,
        border,
        l,
        isDark,
      );
    return _buildWeightView(
      context,
      provider,
      cardBg,
      textPrimary,
      textMuted,
      accent,
      border,
      l,
      isDark,
    );
  }

  Widget _buildDailyView(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    AppLocalizations l,
    bool isDark,
  ) {
    final tStats = provider.todayStats;
    final cal = tStats['calories'] ?? 0.0;
    final pro = tStats['protein'] ?? 0.0;
    final car = tStats['carbs'] ?? 0.0;
    final fat = tStats['fat'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatCard(
              label: l.caloriestoday,
              value: cal.toStringAsFixed(0),
              unit: 'kcal',
              color: accent,
              bg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
            SizedBox(width: 10.w),
            _StatCard(
              label: l.water,
              value: provider.waterToday.toStringAsFixed(1),
              unit: 'L',
              color: Colors.cyan,
              bg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.macroBreakdown,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              _MacroBar(
                label: l.protein,
                value: pro,
                color: AppColors.violet,
                textPrimary: textPrimary,
                textMuted: textMuted,
                isDark: isDark,
              ),
              SizedBox(height: 10.h),
              _MacroBar(
                label: l.carbs,
                value: car,
                color: AppColors.amber,
                textPrimary: textPrimary,
                textMuted: textMuted,
                isDark: isDark,
              ),
              SizedBox(height: 10.h),
              _MacroBar(
                label: l.fat,
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
    );
  }

  Widget _buildWeeklyView(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    AppLocalizations l,
    bool isDark,
  ) {
    final weekly = provider.weeklyStats;
    final avgCal = weekly.isEmpty
        ? 0.0
        : weekly.fold<double>(
                0,
                (s, d) => s + (d['calories'] as num).toDouble(),
              ) /
              weekly.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatCard(
              label: l.avgCalories,
              value: avgCal.toStringAsFixed(0),
              unit: 'kcal',
              color: accent,
              bg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.weeklyCalories,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 160,
                child: weekly.isEmpty
                    ? Center(
                        child: Text(
                          l.noMeals.split('\n').first,
                          style: TextStyle(color: textMuted, fontSize: 12.sp),
                        ),
                      )
                    : BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY:
                              weekly.fold<double>(
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
                                  if (idx < 0 || idx >= weekly.length)
                                    return SizedBox();
                                  final dateStr = weekly[idx]['date'] as String;
                                  try {
                                    final d = DateTime.parse(dateStr);
                                    // Sadece başlangıç gün harfleri (örn. P, S, Ç, P, C, C, P)
                                    final dayName = DateFormat(
                                      'E',
                                      l.localeName,
                                    ).format(d);
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        dayName,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: textMuted,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    return SizedBox();
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
                            final cal = (weekly[i]['calories'] as num)
                                .toDouble();
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: cal,
                                  color: cal > 0
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
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.macroBreakdown,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              if (weekly.isEmpty)
                Center(
                  child: Text(
                    l.noMeals.split('\n').first,
                    style: TextStyle(color: textMuted, fontSize: 12.sp),
                  ),
                )
              else ...[
                _MacroBar(
                  label: l.protein,
                  value: weekly.fold<double>(
                    0,
                    (s, d) => s + (d['protein'] as num).toDouble(),
                  ),
                  color: AppColors.violet,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
                SizedBox(height: 10.h),
                _MacroBar(
                  label: l.carbs,
                  value: weekly.fold<double>(
                    0,
                    (s, d) => s + (d['carbs'] as num).toDouble(),
                  ),
                  color: AppColors.amber,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
                SizedBox(height: 10.h),
                _MacroBar(
                  label: l.fat,
                  value: weekly.fold<double>(
                    0,
                    (s, d) => s + (d['fat'] as num).toDouble(),
                  ),
                  color: AppColors.coral,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyView(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    AppLocalizations l,
    bool isDark,
  ) {
    final monthly = provider.monthlyStats;
    final avgCal = monthly.isEmpty
        ? 0.0
        : monthly.fold<double>(
                0,
                (s, d) => s + (d['calories'] as num).toDouble(),
              ) /
              monthly.length;

    final spots = List.generate(monthly.length, (i) {
      return FlSpot(i.toDouble(), (monthly[i]['calories'] as num).toDouble());
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatCard(
              label: l.avgCalories,
              value: avgCal.toStringAsFixed(0),
              unit: 'kcal',
              color: accent,
              bg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "30 Gün Trend",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: 160,
                child: monthly.isEmpty
                    ? Center(
                        child: Text(
                          l.noMeals.split('\n').first,
                          style: TextStyle(color: textMuted, fontSize: 12.sp),
                        ),
                      )
                    : LineChart(
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
                                  if (idx < 0 || idx >= monthly.length)
                                    return SizedBox();
                                  final dateStr =
                                      monthly[idx]['date'] as String;
                                  try {
                                    final d = DateTime.parse(dateStr);
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8),
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
                                    return SizedBox();
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
                                color: accent.withOpacity(0.15),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.macroBreakdown,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              if (monthly.isEmpty)
                Center(
                  child: Text(
                    l.noMeals.split('\n').first,
                    style: TextStyle(color: textMuted, fontSize: 12.sp),
                  ),
                )
              else ...[
                _MacroBar(
                  label: l.protein,
                  value: monthly.fold<double>(
                    0,
                    (s, d) => s + (d['protein'] as num).toDouble(),
                  ),
                  color: AppColors.violet,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
                SizedBox(height: 10.h),
                _MacroBar(
                  label: l.carbs,
                  value: monthly.fold<double>(
                    0,
                    (s, d) => s + (d['carbs'] as num).toDouble(),
                  ),
                  color: AppColors.amber,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
                SizedBox(height: 10.h),
                _MacroBar(
                  label: l.fat,
                  value: monthly.fold<double>(
                    0,
                    (s, d) => s + (d['fat'] as num).toDouble(),
                  ),
                  color: AppColors.coral,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightView(
    BuildContext context,
    AppProvider provider,
    Color cardBg,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Border? border,
    AppLocalizations l,
    bool isDark,
  ) {
    final logs = provider.weightLogs;
    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Column(
            children: [
              Icon(
                Icons.monitor_weight_rounded,
                size: 48,
                color: textMuted.withOpacity(0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                '${l.noWeightData}\n${l.noWeightDataHint}',
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

    final isImperial = provider.unitSystem == UnitSystem.imperial;
    final unit = isImperial ? 'lb' : 'kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatCard(
              label: l.weight,
              value: provider.weight.toStringAsFixed(1),
              unit: unit,
              color: AppColors.violet,
              bg: cardBg,
              border: border,
              textPrimary: textPrimary,
              textMuted: textMuted,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          height: 250.h,
          padding: EdgeInsets.fromLTRB(16, 24, 24, 16),
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
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    interval: (logs.length / 5).clamp(1.0, 10.0).toDouble(),
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= logs.length)
                        return const SizedBox.shrink();
                      final dt = DateTime.parse(logs[i]['date']);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
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
                        padding: const EdgeInsets.only(right: 8),
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
                    color: AppColors.violet.withOpacity(0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, unit;
  final Color color, bg;
  final Border? border;
  final Color textPrimary, textMuted;
  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bg,
    this.border,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: textMuted,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: color,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
            backgroundColor: isDark
                ? AppColors.darkSurface
                : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
