import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadWeeklyStats();
    });
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

    return Scaffold(
      backgroundColor: bg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final weekly = provider.weeklyStats;
          final avgCal = weekly.isEmpty
              ? 0.0
              : weekly.fold<double>(0, (s, d) => s + (d['calories'] as num).toDouble()) / weekly.length;
          final totalScans = provider.history.length;

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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.progress, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary)),
                    Text(l.thisWeek, style: TextStyle(fontSize: 12, color: textMuted)),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),

                        // Özet kartlar
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
                            const SizedBox(width: 10),
                            _StatCard(
                              label: l.totalScans,
                              value: totalScans.toString(),
                              unit: '📸',
                              color: isDark ? AppColors.violet : AppColors.violetDark,
                              bg: cardBg,
                              border: border,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Haftalık kalori grafiği
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.weeklyCalories, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 160,
                                child: weekly.isEmpty
                                    ? Center(child: Text(l.noMeals.split('\n').first, style: TextStyle(color: textMuted, fontSize: 12)))
                                    : BarChart(
                                        BarChartData(
                                          alignment: BarChartAlignment.spaceAround,
                                          maxY: weekly.fold<double>(0, (m, d) => (d['calories'] as num).toDouble() > m ? (d['calories'] as num).toDouble() : m) * 1.3 + 100,
                                          barTouchData: BarTouchData(enabled: false),
                                          titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: AxisTitles(
                                              sideTitles: SideTitles(
                                                showTitles: true,
                                                getTitlesWidget: (val, meta) {
                                                  final days = [l.monday, l.tuesday, l.wednesday, l.thursday, l.friday, l.saturday, l.sunday];
                                                  final idx = val.toInt();
                                                  if (idx < 0 || idx >= days.length) return const SizedBox();
                                                  return Text(days[idx], style: TextStyle(fontSize: 10, color: textMuted));
                                                },
                                              ),
                                            ),
                                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                          ),
                                          gridData: FlGridData(
                                            show: true,
                                            drawVerticalLine: false,
                                            getDrawingHorizontalLine: (_) => FlLine(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, strokeWidth: 0.5),
                                          ),
                                          borderData: FlBorderData(show: false),
                                          barGroups: List.generate(weekly.length, (i) {
                                            final cal = (weekly[i]['calories'] as num).toDouble();
                                            return BarChartGroupData(x: i, barRods: [
                                              BarChartRodData(
                                                toY: cal,
                                                color: cal > 0 ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
                                                width: 18,
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                              ),
                                            ]);
                                          }),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Makro dağılım
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l.macroBreakdown, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: textPrimary)),
                              const SizedBox(height: 14),
                              if (weekly.isEmpty)
                                Center(child: Text(l.noMeals.split('\n').first, style: TextStyle(color: textMuted, fontSize: 12)))
                              else ...[
                                _MacroBar(
                                  label: l.protein,
                                  value: weekly.fold<double>(0, (s, d) => s + (d['protein'] as num).toDouble()),
                                  color: isDark ? AppColors.violet : AppColors.violetDark,
                                  textPrimary: textPrimary,
                                  textMuted: textMuted,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 10),
                                _MacroBar(
                                  label: l.carbs,
                                  value: weekly.fold<double>(0, (s, d) => s + (d['carbs'] as num).toDouble()),
                                  color: isDark ? AppColors.amber : AppColors.amberDark,
                                  textPrimary: textPrimary,
                                  textMuted: textMuted,
                                  isDark: isDark,
                                ),
                                const SizedBox(height: 10),
                                _MacroBar(
                                  label: l.fat,
                                  value: weekly.fold<double>(0, (s, d) => s + (d['fat'] as num).toDouble()),
                                  color: isDark ? AppColors.coral : AppColors.coralDark,
                                  textPrimary: textPrimary,
                                  textMuted: textMuted,
                                  isDark: isDark,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
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
}

class _StatCard extends StatelessWidget {
  final String label, value, unit;
  final Color color, bg;
  final Border? border;
  final Color textPrimary, textMuted;
  const _StatCard({required this.label, required this.value, required this.unit, required this.color, required this.bg, this.border, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: border),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: textMuted)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color, height: 1)),
                  ),
                ),
                const SizedBox(width: 4),
                Text(unit, style: TextStyle(fontSize: 11, color: textMuted)),
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
  const _MacroBar({required this.label, required this.value, required this.color, required this.textPrimary, required this.textMuted, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: textMuted)),
            Text('${value.toStringAsFixed(0)}g', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value > 0 ? (value / 700).clamp(0.0, 1.0) : 0,
            minHeight: 6,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
