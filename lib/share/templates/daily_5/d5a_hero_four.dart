import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D5-A · Hero + 4 — one wide hero card across the top, plus a 2×2 grid of
/// smaller tiles below. Source: docs/share-card-mocks/d5a-hero-four.html
class D5AHeroFour extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D5AHeroFour({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final strings = ShareCardStrings.of(locale);
    final ordered = _heroFirst(data.meals);
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ThreeMealBackground(
            blob1: ShareTokens.lime,
            blob1Align: Alignment(-1.2, 0.2),
            blob2: ShareTokens.mint,
            blob2Align: Alignment(1.2, -0.8),
          ),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: strings.dailyJournalEyebrow,
              line1: strings.fiveMealsFullTempoLine1,
              line2: strings.fiveMealsFullTempoLine2,
            ),
          ),
          Positioned(
            top: 540,
            left: 60,
            right: 60,
            height: 920,
            child: _Grid(meals: ordered, strings: strings),
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

  static List _heroFirst(List meals) {
    if (meals.isEmpty) return meals;
    var heroIdx = 0;
    num maxCal = meals[0].totalNutrients.calories;
    for (var i = 1; i < meals.length; i++) {
      if (meals[i].totalNutrients.calories > maxCal) {
        heroIdx = i;
        maxCal = meals[i].totalNutrients.calories;
      }
    }
    if (heroIdx == 0) return meals;
    final out = List.from(meals);
    final hero = out.removeAt(heroIdx);
    out.insert(0, hero);
    return out;
  }
}

class _Grid extends StatelessWidget {
  final List meals;
  final ShareCardStrings strings;
  const _Grid({required this.meals, required this.strings});

  @override
  Widget build(BuildContext context) {
    final hero = meals[0];
    final m1 = meals.length > 1 ? meals[1] : meals[0];
    final m2 = meals.length > 2 ? meals[2] : meals[0];
    final m3 = meals.length > 3 ? meals[3] : meals[0];
    final m4 = meals.length > 4 ? meals[4] : meals[0];
    return Column(
      children: [
        Expanded(
          flex: 14,
          child: _Tile(meal: hero, strings: strings, large: true),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              Expanded(child: _Tile(meal: m1, strings: strings)),
              const SizedBox(width: 12),
              Expanded(child: _Tile(meal: m2, strings: strings)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          flex: 10,
          child: Row(
            children: [
              Expanded(child: _Tile(meal: m3, strings: strings)),
              const SizedBox(width: 12),
              Expanded(child: _Tile(meal: m4, strings: strings)),
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
      borderRadius: BorderRadius.circular(22),
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
            top: large ? 14 : 12,
            left: large ? 14 : 12,
            child: MealCategoryTag(
              text: strings.mealTag(meal.mealCategory),
              fontSize: large ? 14 : 12,
              padding: EdgeInsets.symmetric(
                horizontal: large ? 14 : 10,
                vertical: large ? 6 : 4,
              ),
              background: const Color(0x99000000),
            ),
          ),
          Positioned(
            bottom: large ? 14 : 12,
            left: large ? 14 : 12,
            right: large ? 14 : 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      n.calories.round().toString(),
                      style: TextStyle(
                        fontSize: large ? 56 : 26,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -1.0,
                        height: 1,
                      ),
                    ),
                    SizedBox(width: large ? 6 : 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: large ? 6 : 3),
                      child: Text(
                        strings.kcalLabel.toLowerCase(),
                        style: TextStyle(
                          fontSize: large ? 16 : 11,
                          fontWeight: FontWeight.w600,
                          color: ShareTokens.textMuted,
                          letterSpacing: 1.1,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: large ? 16 : 8,
                  children: large
                      ? [
                          _Dot(
                            label: 'P ${n.protein.round()}g',
                            color: ShareTokens.protein,
                            fontSize: 17,
                          ),
                          _Dot(
                            label: 'K ${n.carbs.round()}g',
                            color: ShareTokens.carb,
                            fontSize: 17,
                          ),
                          _Dot(
                            label: 'Y ${n.fat.round()}g',
                            color: ShareTokens.fat,
                            fontSize: 17,
                          ),
                        ]
                      : [
                          Text(
                            '${n.protein.round()}g',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ShareTokens.protein,
                              height: 1,
                            ),
                          ),
                          Text(
                            '${n.carbs.round()}g',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ShareTokens.carb,
                              height: 1,
                            ),
                          ),
                          Text(
                            '${n.fat.round()}g',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: ShareTokens.fat,
                              height: 1,
                            ),
                          ),
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
  final double fontSize;
  const _Dot({
    required this.label,
    required this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: fontSize * 0.45,
          height: fontSize * 0.45,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
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
