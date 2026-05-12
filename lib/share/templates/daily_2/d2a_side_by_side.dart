import 'package:flutter/material.dart';

import '../../../models/food_analysis.dart';
import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D2-A · Side by Side — two equal-size meal tiles side by side on top,
/// glass macro card with daily totals at the bottom.
class D2ASideBySide extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D2ASideBySide({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final strings = ShareCardStrings.of(locale);
    final meals = data.meals;
    final left = meals[0];
    final right = meals.length > 1 ? meals[1] : meals[0];
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
              line1: strings.twoMealsOneGoalLine1,
              line2: strings.twoMealsOneGoalLine2,
            ),
          ),
          Positioned(
            top: 540,
            left: 60,
            right: 60,
            height: 760,
            child: Row(
              children: [
                Expanded(child: _Tile(meal: left, strings: strings)),
                const SizedBox(width: 16),
                Expanded(child: _Tile(meal: right, strings: strings)),
              ],
            ),
          ),
          Positioned(
            top: 1390,
            left: 80,
            right: 80,
            child: _MacroCard(data: data, strings: strings),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final FoodAnalysis meal;
  final ShareCardStrings strings;
  const _Tile({required this.meal, required this.strings});

  @override
  Widget build(BuildContext context) {
    final n = meal.totalNutrients;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
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
            top: 16,
            left: 16,
            child: MealCategoryTag(
              text: strings.mealTag(meal.mealCategory),
              fontSize: 14,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              background: const Color(0x99000000),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 18,
            right: 18,
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
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: ShareTokens.lime,
                        letterSpacing: -0.96,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        strings.kcalLabel.toLowerCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ShareTokens.textMuted,
                          letterSpacing: 1.4,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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

class _MacroCard extends StatelessWidget {
  final ShareCardData data;
  final ShareCardStrings strings;
  const _MacroCard({required this.data, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: ShareTokens.glassFill,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: ShareTokens.glassBorder),
      ),
      child: Column(
        children: [
          Text(
            data.totalCalories.round().toString(),
            style: const TextStyle(
              fontSize: 120,
              fontWeight: FontWeight.w800,
              color: ShareTokens.lime,
              letterSpacing: -6,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.kcalLabel,
            style: const TextStyle(
              fontSize: 22,
              color: ShareTokens.textMuted,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.3,
              height: 1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MacroItem(
                  value: data.totalProtein.round(),
                  label: strings.proteinLabel,
                  color: ShareTokens.protein,
                ),
              ),
              Expanded(
                child: _MacroItem(
                  value: data.totalCarbs.round(),
                  label: strings.carbLabel,
                  color: ShareTokens.carb,
                ),
              ),
              Expanded(
                child: _MacroItem(
                  value: data.totalFat.round(),
                  label: strings.fatLabel,
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

class _MacroItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _MacroItem({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value}g',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -1.68,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: ShareTokens.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.16,
            height: 1,
          ),
        ),
      ],
    );
  }
}
