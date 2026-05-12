import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/food_analysis.dart';
import '../../share_card_data.dart';
import '../../share_tokens.dart';
import 'meal_photo.dart';

/// Shared building blocks for the weekly share-card templates.
class WeeklyHelpers {
  WeeklyHelpers._();

  /// Iterates 7 days of [data], yielding (date, meals[]) pairs.
  static List<({DateTime date, List<FoodAnalysis> meals})> daysOf(
    WeeklyShareCardData data,
  ) {
    return List.generate(7, (i) {
      final d = data.weekStart.add(Duration(days: i));
      return (date: d, meals: data.days[i]);
    });
  }

  /// Sum kcal for a list of meals.
  static int sumKcal(List<FoodAnalysis> meals) =>
      meals.fold(0, (s, m) => s + m.totalNutrients.calories.round());

  /// Sum macros: (protein, carbs, fat).
  static ({int protein, int carbs, int fat}) sumMacros(
    List<FoodAnalysis> meals,
  ) {
    var p = 0, c = 0, f = 0;
    for (final m in meals) {
      p += m.totalNutrients.protein.round();
      c += m.totalNutrients.carbs.round();
      f += m.totalNutrients.fat.round();
    }
    return (protein: p, carbs: c, fat: f);
  }

  /// "Pzt" / "Sal" abbreviated day name.
  static String shortDay(DateTime d, String locale) =>
      DateFormat('E', locale).format(d);

  /// Title-cased month-and-day pill text ("22 – 28 Nis").
  static String weekRange(DateTime start, String locale) {
    final end = start.add(const Duration(days: 6));
    final fmt = DateFormat('d MMM', locale);
    final endFmt = DateFormat('d MMM', locale);
    if (start.month == end.month) {
      return '${start.day} – ${endFmt.format(end)}';
    }
    return '${fmt.format(start)} – ${endFmt.format(end)}';
  }

  static String formatKcal(int kcal) {
    if (kcal < 1000) return kcal.toString();
    final s = kcal.toString();
    return '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';
  }
}

/// A pill-shaped day label: "Pzt / 22"
class DayLabelPill extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final double width;
  const DayLabelPill({
    super.key,
    required this.dayName,
    required this.dayNumber,
    this.width = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: const Color(0x801C1C2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x0FFFFFFF)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ShareTokens.textMuted,
              letterSpacing: 1.1,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dayNumber.toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: ShareTokens.snow,
              letterSpacing: -0.44,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// A small per-meal thumbnail tile used inside weekly rows.
class WeeklyMealThumb extends StatelessWidget {
  final FoodAnalysis meal;
  final bool showMacros;
  final bool showKcal;
  const WeeklyMealThumb({
    super.key,
    required this.meal,
    this.showKcal = true,
    this.showMacros = false,
  });

  @override
  Widget build(BuildContext context) {
    final n = meal.totalNutrients;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MealPhoto(imagePath: meal.imagePath, withDarkBottomGradient: false),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.4, 1],
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xE6000000),
                ],
              ),
            ),
          ),
          if (showKcal)
            Positioned(
              bottom: showMacros ? 22 : 6,
              left: 6,
              right: 6,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: n.calories.round().toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -0.16,
                        height: 1,
                      ),
                    ),
                    const TextSpan(
                      text: ' kcal',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ShareTokens.textMuted,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (showMacros)
            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    n.protein.round().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ShareTokens.protein,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    n.carbs.round().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ShareTokens.carb,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    n.fat.round().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: ShareTokens.fat,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Day totals capsule used on the right of weekly day rows.
class DayTotalsCapsule extends StatelessWidget {
  final int kcal;
  final int mealCount;
  final ({int protein, int carbs, int fat}) macros;
  final double width;
  final bool detailedMacros;
  final String mealsWord;
  final String proteinLabel;
  final String carbLabel;
  final String fatLabel;

  const DayTotalsCapsule({
    super.key,
    required this.kcal,
    required this.mealCount,
    required this.macros,
    required this.mealsWord,
    required this.proteinLabel,
    required this.carbLabel,
    required this.fatLabel,
    this.width = 130,
    this.detailedMacros = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x801C1C2A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x0FFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            WeeklyHelpers.formatKcal(kcal),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: ShareTokens.lime,
              letterSpacing: -0.44,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'KCAL · $mealCount ${mealsWord.toLowerCase()}',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: ShareTokens.textMuted,
              letterSpacing: 0.9,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          if (detailedMacros) ...[
            _MacroRow(label: proteinLabel, value: '${macros.protein}g', color: ShareTokens.protein),
            _MacroRow(label: carbLabel, value: '${macros.carbs}g', color: ShareTokens.carb),
            _MacroRow(label: fatLabel, value: '${macros.fat}g', color: ShareTokens.fat),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${macros.protein}g',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ShareTokens.protein,
                    height: 1,
                  ),
                ),
                Text(
                  '${macros.carbs}g',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ShareTokens.carb,
                    height: 1,
                  ),
                ),
                Text(
                  '${macros.fat}g',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: ShareTokens.fat,
                    height: 1,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MacroRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: ShareTokens.textMuted,
              letterSpacing: 0.9,
              height: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Week totals card pinned at the bottom of every weekly template.
class WeekTotalsCard extends StatelessWidget {
  final WeeklyShareCardData data;
  final String kcalLabel;
  final String proteinLabel;
  final String carbLabel;
  final String fatLabel;
  final String totalLabel;

  const WeekTotalsCard({
    super.key,
    required this.data,
    required this.kcalLabel,
    required this.proteinLabel,
    required this.carbLabel,
    required this.fatLabel,
    required this.totalLabel,
  });

  @override
  Widget build(BuildContext context) {
    final all = data.days.expand((d) => d).toList();
    final kcal = WeeklyHelpers.sumKcal(all);
    final m = WeeklyHelpers.sumMacros(all);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      decoration: BoxDecoration(
        color: ShareTokens.glassFill,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: ShareTokens.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                totalLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ShareTokens.textMuted,
                  letterSpacing: 2.1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: WeeklyHelpers.formatKcal(kcal),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -1.92,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: ' ${kcalLabel.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: ShareTokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Macro(value: m.protein, label: proteinLabel, color: ShareTokens.protein),
              const SizedBox(width: 16),
              _Macro(value: m.carbs, label: carbLabel, color: ShareTokens.carb),
              const SizedBox(width: 16),
              _Macro(value: m.fat, label: fatLabel, color: ShareTokens.fat),
            ],
          ),
        ],
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _Macro({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${value}g',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ShareTokens.textMuted,
            letterSpacing: 1.1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

/// Stat badge row used at the top of weekly cards (5/7 gün, 12 öğün, etc.).
class WeeklyStatBadge extends StatelessWidget {
  final String text;
  final Color color;
  const WeeklyStatBadge({
    super.key,
    required this.text,
    this.color = ShareTokens.lime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1,
        ),
      ),
    );
  }
}
