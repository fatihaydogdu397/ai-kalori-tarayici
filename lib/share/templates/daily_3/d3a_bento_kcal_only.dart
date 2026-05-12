import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D3-A · Bento (kcal only) — 1 large hero photo + 2 small photos in a 2×2
/// bento grid. Each tile shows only kcal. Bottom card holds the daily total
/// + macro row. Source mock: docs/share-card-mocks/2-three-meals.html
class D3ABentoKcalOnly extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D3ABentoKcalOnly({
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
            height: 760,
            child: _BentoGrid(meals: meals, strings: strings),
          ),
          Positioned(
            bottom: 220,
            left: 60,
            right: 60,
            child: _TotalCard(data: data, strings: strings),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _BentoGrid extends StatelessWidget {
  final List meals;
  final ShareCardStrings strings;
  const _BentoGrid({required this.meals, required this.strings});

  @override
  Widget build(BuildContext context) {
    final hero = meals[0];
    final small1 = meals.length > 1 ? meals[1] : meals[0];
    final small2 = meals.length > 2 ? meals[2] : meals[0];
    return Row(
      children: [
        Expanded(
          flex: 16,
          child: _BentoTile(
            imagePath: hero.imagePath,
            tag: strings.mealTag(hero.mealCategory),
            kcal: hero.totalNutrients.calories.round(),
            kcalUnit: strings.kcalLabel.toLowerCase(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 10,
          child: Column(
            children: [
              Expanded(
                child: _BentoTile(
                  imagePath: small1.imagePath,
                  tag: strings.mealTag(small1.mealCategory),
                  kcal: small1.totalNutrients.calories.round(),
                  kcalUnit: strings.kcalLabel.toLowerCase(),
                  compact: true,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _BentoTile(
                  imagePath: small2.imagePath,
                  tag: strings.mealTag(small2.mealCategory),
                  kcal: small2.totalNutrients.calories.round(),
                  kcalUnit: strings.kcalLabel.toLowerCase(),
                  compact: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final String imagePath;
  final String tag;
  final int kcal;
  final String kcalUnit;
  final bool compact;
  const _BentoTile({
    required this.imagePath,
    required this.tag,
    required this.kcal,
    required this.kcalUnit,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          MealPhoto(imagePath: imagePath, withDarkBottomGradient: true),
          Positioned(
            top: compact ? 14 : 16,
            left: compact ? 14 : 16,
            child: MealCategoryTag(
              text: tag,
              fontSize: compact ? 13 : 14,
              foreground: ShareTokens.lime,
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 12 : 14,
                vertical: compact ? 5 : 6,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$kcal $kcalUnit',
                  style: TextStyle(
                    color: ShareTokens.lime,
                    fontSize: compact ? 18 : 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
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

class _TotalCard extends StatelessWidget {
  final ShareCardData data;
  final ShareCardStrings strings;
  const _TotalCard({required this.data, required this.strings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: ShareTokens.glassFill,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: ShareTokens.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatKcal(data.totalCalories.round()),
                    style: const TextStyle(
                      fontSize: 110,
                      fontWeight: FontWeight.w800,
                      color: ShareTokens.lime,
                      letterSpacing: -4.4,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.dailyTotalLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      color: ShareTokens.textMuted,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.7,
                      height: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: ShareTokens.lime.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: ShareTokens.lime.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '${strings.checkMarkPrefix} ${data.mealCount} ${strings.mealLabel.toLowerCase()}',
                  style: const TextStyle(
                    color: ShareTokens.lime,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _MacroCell(
                  value: data.totalProtein.round(),
                  label: strings.proteinLabel,
                  color: ShareTokens.protein,
                ),
              ),
              Expanded(
                child: _MacroCell(
                  value: data.totalCarbs.round(),
                  label: strings.carbLabel,
                  color: ShareTokens.carb,
                ),
              ),
              Expanded(
                child: _MacroCell(
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

class _MacroCell extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _MacroCell({
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
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -1.44,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ShareTokens.textMuted,
            letterSpacing: 1.92,
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
