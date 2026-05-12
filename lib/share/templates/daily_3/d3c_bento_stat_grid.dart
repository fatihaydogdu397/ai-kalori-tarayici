import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D3-C · Bento with stat-grid — bento layout, each tile shows a top-left
/// lime tag + top-right kcal pill + bottom 3-cell stat grid (P/K/Y).
/// Source mock: docs/share-card-mocks/2b-bento-stat-grid.html
class D3CBentoStatGrid extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D3CBentoStatGrid({
    super.key,
    required this.data,
    this.locale = 'tr',
  });

  @override
  Widget build(BuildContext context) {
    final strings = ShareCardStrings.of(locale);
    final meals = data.meals;
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ThreeMealBackground(),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: strings.dailyJournalEyebrow,
              line1: strings.threeMealsOneGoalLine1,
              line2: strings.threeMealsOneGoalLine2,
            ),
          ),
          Positioned(
            top: 540,
            left: 60,
            right: 60,
            height: 920,
            child: _Grid(meals: meals, strings: strings),
          ),
          Positioned(
            bottom: 220,
            left: 60,
            right: 60,
            child: _BottomTotal(data: data, strings: strings),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List meals;
  final ShareCardStrings strings;
  const _Grid({required this.meals, required this.strings});

  @override
  Widget build(BuildContext context) {
    final hero = meals[0];
    final small1 = meals.length > 1 ? meals[1] : meals[0];
    final small2 = meals.length > 2 ? meals[2] : meals[0];
    return Row(
      children: [
        Expanded(
          flex: 13,
          child: _Tile(meal: hero, strings: strings, large: true),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Expanded(child: _Tile(meal: small1, strings: strings)),
              const SizedBox(height: 16),
              Expanded(child: _Tile(meal: small2, strings: strings)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final dynamic meal;
  final ShareCardStrings strings;
  final bool large;
  const _Tile({
    required this.meal,
    required this.strings,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final n = meal.totalNutrients;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MealPhoto(imagePath: meal.imagePath, withDarkBottomGradient: false),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.25, 0.5, 1],
                colors: [
                  Color(0x66000000),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xF2000000),
                ],
              ),
            ),
          ),
          // Top-left: lime square tag
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              decoration: BoxDecoration(
                color: ShareTokens.lime,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                strings.mealTag(meal.mealCategory),
                style: TextStyle(
                  color: ShareTokens.voidBg,
                  fontSize: large ? 13 : 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  height: 1,
                ),
              ),
            ),
          ),
          // Top-right: kcal pill
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: large ? 16 : 14,
                vertical: large ? 8 : 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xA6000000),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: ShareTokens.lime.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                '${n.calories.round()} ${strings.kcalLabel.toLowerCase()}',
                style: TextStyle(
                  color: ShareTokens.lime,
                  fontSize: large ? 22 : 18,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
          // Bottom: stat grid
          Positioned(
            bottom: 14,
            left: 14,
            right: 14,
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(
                    value: '${n.protein.round()}g',
                    label: large ? strings.proteinLabel : 'P',
                    color: ShareTokens.protein,
                    large: large,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _StatCell(
                    value: '${n.carbs.round()}g',
                    label: large ? strings.carbLabel : 'K',
                    color: ShareTokens.carb,
                    large: large,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _StatCell(
                    value: '${n.fat.round()}g',
                    label: large ? strings.fatLabel : 'Y',
                    color: ShareTokens.fat,
                    large: large,
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

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool large;
  const _StatCell({
    required this.value,
    required this.label,
    required this.color,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 8 : 4,
        vertical: large ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(large ? 14 : 10),
        border: Border.all(color: const Color(0x14FFFFFF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: large ? 22 : 15,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: large ? 11 : 9,
              fontWeight: FontWeight.w600,
              color: ShareTokens.textMuted,
              letterSpacing: 1,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomTotal extends StatelessWidget {
  final ShareCardData data;
  final ShareCardStrings strings;
  const _BottomTotal({required this.data, required this.strings});

  @override
  Widget build(BuildContext context) {
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
          Text(
            strings.dailyTotalLabel,
            style: const TextStyle(
              fontSize: 14,
              color: ShareTokens.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.1,
              height: 1,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _formatKcal(data.totalCalories.round()),
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -1.26,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: ' ${strings.kcalLabel.toLowerCase()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ShareTokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Text(
                '${data.totalProtein.round()}g',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ShareTokens.protein,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${data.totalCarbs.round()}g',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ShareTokens.carb,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${data.totalFat.round()}g',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: ShareTokens.fat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatKcal(int kcal) {
  if (kcal < 1000) return kcal.toString();
  final s = kcal.toString();
  return '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';
}
