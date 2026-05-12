import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D3-F · Side card — photo on one side, glass info card on the other.
/// Alternating left/right (zigzag) layout. 3 rows total.
/// Source mock: docs/share-card-mocks/v3-side-card.html
class D3FSideCard extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D3FSideCard({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final strings = ShareCardStrings.of(locale);
    final meals = data.meals;
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ThreeMealBackground(
            blob1: ShareTokens.lime,
            blob1Align: Alignment(1.2, -0.6),
            blob2: ShareTokens.mint,
            blob2Align: Alignment(-1.2, 0.7),
          ),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: strings.todayEyebrow,
              line1: strings.mindfulPlatesLine1,
              line2: strings.mindfulPlatesLine2,
            ),
          ),
          Positioned(
            top: 540,
            left: 60,
            right: 60,
            bottom: 180,
            child: Column(
              children: [
                for (var i = 0; i < meals.length && i < 3; i++) ...[
                  Expanded(
                    child: _MealRow(
                      meal: meals[i],
                      strings: strings,
                      reversed: i % 2 == 1,
                    ),
                  ),
                  if (i < meals.length - 1 && i < 2)
                    const SizedBox(height: 18),
                ],
              ],
            ),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final dynamic meal;
  final ShareCardStrings strings;
  final bool reversed;
  const _MealRow({
    required this.meal,
    required this.strings,
    required this.reversed,
  });

  @override
  Widget build(BuildContext context) {
    final photoChild = _PhotoBlock(meal: meal, strings: strings);
    final dataChild = _InfoBlock(meal: meal, strings: strings);
    return Row(
      children: reversed
          ? [
              Expanded(flex: 10, child: dataChild),
              const SizedBox(width: 14),
              Expanded(flex: 12, child: photoChild),
            ]
          : [
              Expanded(flex: 12, child: photoChild),
              const SizedBox(width: 14),
              Expanded(flex: 10, child: dataChild),
            ],
    );
  }
}

class _PhotoBlock extends StatelessWidget {
  final dynamic meal;
  final ShareCardStrings strings;
  const _PhotoBlock({required this.meal, required this.strings});

  @override
  Widget build(BuildContext context) {
    final t = meal.analyzedAt as DateTime;
    final timeText =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MealPhoto(imagePath: meal.imagePath),
          Positioned(
            top: 14,
            left: 14,
            child: MealCategoryTag(
              text: '${strings.mealTag(meal.mealCategory)} · $timeText',
              fontSize: 13,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              background: const Color(0x99000000),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final dynamic meal;
  final ShareCardStrings strings;
  const _InfoBlock({required this.meal, required this.strings});

  @override
  Widget build(BuildContext context) {
    final n = meal.totalNutrients;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ShareTokens.glassFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ShareTokens.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            n.calories.round().toString(),
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: ShareTokens.lime,
              letterSpacing: -2.24,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            strings.kcalLabel.toLowerCase(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ShareTokens.textMuted,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          _MacroRow(
            label: strings.proteinLabel,
            value: '${n.protein.round()}g',
            color: ShareTokens.protein,
          ),
          const SizedBox(height: 8),
          _MacroRow(
            label: strings.carbLabel,
            value: '${n.carbs.round()}g',
            color: ShareTokens.carb,
          ),
          const SizedBox(height: 8),
          _MacroRow(
            label: strings.fatLabel,
            value: '${n.fat.round()}g',
            color: ShareTokens.fat,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ShareTokens.textSecondary,
              letterSpacing: 1,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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
