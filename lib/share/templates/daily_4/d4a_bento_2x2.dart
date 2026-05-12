import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D4-A · 2×2 grid — 4 equal-size bento tiles. Each tile carries a tag chip,
/// kcal number and P/K/F macro line. Footer card sums daily total.
/// Source mock: docs/share-card-mocks/d4a-bento-2x2.html
class D4ABento2x2 extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D4ABento2x2({super.key, required this.data, this.locale = 'tr'});

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
            blob1Align: Alignment(-1.2, 0.2),
            blob2: ShareTokens.violet,
            blob2Align: Alignment(1.2, -0.8),
          ),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: strings.dailyJournalEyebrow,
              line1: strings.fourMealsControlLine1,
              line2: strings.fourMealsControlLine2,
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
            child: _TotalBar(data: data, strings: strings),
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
    final m0 = meals[0];
    final m1 = meals.length > 1 ? meals[1] : meals[0];
    final m2 = meals.length > 2 ? meals[2] : meals[0];
    final m3 = meals.length > 3 ? meals[3] : meals[0];
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Tile(meal: m0, strings: strings)),
              const SizedBox(width: 14),
              Expanded(child: _Tile(meal: m1, strings: strings)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _Tile(meal: m2, strings: strings)),
              const SizedBox(width: 14),
              Expanded(child: _Tile(meal: m3, strings: strings)),
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
  const _Tile({required this.meal, required this.strings});

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
                stops: [0, 0.25, 0.45, 1],
                colors: [
                  Color(0x4D000000),
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xEB000000),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: MealCategoryTag(
              text: strings.mealTag(meal.mealCategory),
              fontSize: 14,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              background: const Color(0x99000000),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      n.calories.round().toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -0.72,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        strings.kcalLabel.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ShareTokens.textMuted,
                          letterSpacing: 1.3,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    _Dot(label: 'P ${n.protein.round()}g', color: ShareTokens.protein),
                    _Dot(label: 'K ${n.carbs.round()}g', color: ShareTokens.carb),
                    _Dot(label: 'Y ${n.fat.round()}g', color: ShareTokens.fat),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final String label;
  final Color color;
  const _Dot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TotalBar extends StatelessWidget {
  final ShareCardData data;
  final ShareCardStrings strings;
  const _TotalBar({required this.data, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
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
                '${strings.totalLabel} · ${data.mealCount} ${strings.mealLabel.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 14,
                  color: ShareTokens.textMuted,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _formatKcal(data.totalCalories.round()),
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -2.24,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text: ' ${strings.kcalLabel.toLowerCase()}',
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
              _Macro(value: data.totalProtein.round(), label: strings.proteinLabel, color: ShareTokens.protein),
              const SizedBox(width: 18),
              _Macro(value: data.totalCarbs.round(), label: strings.carbLabel, color: ShareTokens.carb),
              const SizedBox(width: 18),
              _Macro(value: data.totalFat.round(), label: strings.fatLabel, color: ShareTokens.fat),
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
  const _Macro({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${value}g',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ShareTokens.textMuted,
            letterSpacing: 1.2,
            height: 1,
          ),
        ),
      ],
    );
  }
}

String _formatKcal(int kcal) {
  if (kcal < 1000) return kcal.toString();
  final s = kcal.toString();
  return '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';
}
