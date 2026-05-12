import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';
import '../shared/weekly_helpers.dart';

/// W2 · Full 7 days — every day, every meal, with thumbnails showing both
/// kcal and macros, and detailed per-day totals on the right.
/// Source mock: docs/share-card-mocks/3i-weekly-full-7days.html
class W2Full7Days extends StatelessWidget {
  final WeeklyShareCardData data;
  final String locale;
  const W2Full7Days({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final strings = ShareCardStrings.of(locale);
    final days = WeeklyHelpers.daysOf(data);
    final activeDays = days.where((d) => d.meals.isNotEmpty).length;
    final allMeals = data.days.expand((d) => d).length;
    final avg = activeDays == 0
        ? 0
        : (WeeklyHelpers.sumKcal(data.days.expand((d) => d).toList()) /
                activeDays)
            .round();

    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ThreeMealBackground(
            blob1: ShareTokens.lime,
            blob1Align: Alignment(1.2, -0.6),
            blob2: ShareTokens.mint,
            blob2Align: Alignment(-1.2, 0.6),
          ),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: locale == 'tr'
                  ? 'BU HAFTA · $activeDays/7 GÜN'
                  : 'THIS WEEK · $activeDays/7 DAYS',
              line1: locale == 'tr' ? 'Tam' : 'Full',
              line2: locale == 'tr' ? 'kadro.' : 'roster.',
              titleSize: 88,
            ),
          ),
          Positioned(
            top: 400,
            left: 60,
            right: 60,
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                WeeklyStatBadge(
                  text: '🔥 $activeDays/7 ${locale == "tr" ? "gün" : "days"}',
                  color: ShareTokens.mint,
                ),
                WeeklyStatBadge(
                  text: '🥗 $allMeals ${strings.mealLabel.toLowerCase()}',
                ),
                WeeklyStatBadge(
                  text: '⚡ Ø ${WeeklyHelpers.formatKcal(avg)} ${strings.kcalLabel.toLowerCase()}',
                  color: ShareTokens.amber,
                ),
              ],
            ),
          ),
          Positioned(
            top: 490,
            left: 60,
            right: 60,
            bottom: 380,
            child: _ExpandedDays(
              days: days.where((d) => d.meals.isNotEmpty).toList(),
              strings: strings,
              locale: locale,
            ),
          ),
          Positioned(
            bottom: 220,
            left: 60,
            right: 60,
            child: WeekTotalsCard(
              data: data,
              kcalLabel: strings.kcalLabel,
              proteinLabel: strings.proteinLabel,
              carbLabel: strings.carbLabel,
              fatLabel: strings.fatLabel,
              totalLabel: locale == 'tr' ? 'HAFTA TOPLAMI' : 'WEEK TOTAL',
            ),
          ),
          ShareCardHeader(date: data.weekStart, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _ExpandedDays extends StatelessWidget {
  final List<({DateTime date, List meals})> days;
  final ShareCardStrings strings;
  final String locale;
  const _ExpandedDays({
    required this.days,
    required this.strings,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) {
      return Center(
        child: Text(
          locale == 'tr' ? 'Bu hafta kayıt yok' : 'No logs this week',
          style: const TextStyle(
            fontSize: 18,
            color: ShareTokens.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    // Each row gets a capped height so thumb tiles keep a roughly square
    // aspect (≈ 148 × 145). Rows are vertically centered in the band so
    // 1–3 logged days don't collapse to the top.
    final h = _rowHeight(days.length);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < days.length; i++) ...[
          SizedBox(
            height: h,
            child: _DetailedRow(
              date: days[i].date,
              meals: days[i].meals,
              strings: strings,
              locale: locale,
            ),
          ),
          if (i < days.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  static double _rowHeight(int n) {
    // Body band is ~1050 px tall (top:490, bottom:380). Cap at 180 so single-
    // day shares don't blow the row into a portrait monster, floor at 120 so
    // a packed 7-day week still fits.
    const band = 1050.0;
    const gap = 12.0;
    final raw = (band - (n - 1) * gap) / n;
    return raw.clamp(120.0, 180.0);
  }
}

class _DetailedRow extends StatelessWidget {
  final DateTime date;
  final List meals;
  final ShareCardStrings strings;
  final String locale;
  const _DetailedRow({
    required this.date,
    required this.meals,
    required this.strings,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Row(
        children: [
          DayLabelPill(
            dayName: WeeklyHelpers.shortDay(date, locale),
            dayNumber: date.day,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x05FFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0x14FFFFFF),
                  style: BorderStyle.solid,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                locale == 'tr' ? 'kayıt yok' : 'no log',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ShareTokens.textMuted,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 130,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x05FFFFFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x14FFFFFF)),
              ),
              alignment: Alignment.center,
              child: const Text(
                '—',
                style: TextStyle(
                  fontSize: 16,
                  color: ShareTokens.textMuted,
                ),
              ),
            ),
          ),
        ],
      );
    }
    final kcal = WeeklyHelpers.sumKcal(meals.cast());
    final macros = WeeklyHelpers.sumMacros(meals.cast());
    return Row(
      children: [
        DayLabelPill(
          dayName: WeeklyHelpers.shortDay(date, locale),
          dayNumber: date.day,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              for (var i = 0; i < meals.length && i < 5; i++) ...[
                Expanded(
                  child: WeeklyMealThumb(
                    meal: meals[i],
                    showMacros: true,
                  ),
                ),
                if (i < meals.length - 1 && i < 4) const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        DayTotalsCapsule(
          kcal: kcal,
          mealCount: meals.length,
          macros: macros,
          mealsWord: strings.mealLabel,
          proteinLabel: strings.proteinLabel,
          carbLabel: strings.carbLabel,
          fatLabel: strings.fatLabel,
          detailedMacros: true,
        ),
      ],
    );
  }
}
