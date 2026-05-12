import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';

/// D1-A · Hero — big rounded photo on top, glassmorphism macro card below.
/// Source mock: docs/share-card-mocks/1-single-meal.html
class D1AHero extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D1AHero({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final meal = data.meals.first;
    final strings = ShareCardStrings.of(locale);
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ShareCardBackground(),
          Positioned(
            top: 230,
            left: 80,
            right: 80,
            height: 880,
            child: MealPhoto(imagePath: meal.imagePath, borderRadius: BorderRadius.circular(32)),
          ),
          Positioned(
            top: 1180,
            left: 80,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.eyebrowFor(meal.mealCategory),
                  style: const TextStyle(color: ShareTokens.lime, fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 4.4, height: 1),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.heroTitle,
                  style: const TextStyle(color: ShareTokens.snow, fontSize: 72, fontWeight: FontWeight.w800, letterSpacing: -2.88, height: 0.95),
                ),
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
            style: const TextStyle(fontSize: 120, fontWeight: FontWeight.w800, color: ShareTokens.lime, letterSpacing: -6, height: 1),
          ),
          const SizedBox(height: 8),
          Text(
            strings.kcalLabel,
            style: const TextStyle(fontSize: 22, color: ShareTokens.textMuted, fontWeight: FontWeight.w600, letterSpacing: 3.3, height: 1),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _MacroItem(value: data.totalProtein.round(), label: strings.proteinLabel, color: ShareTokens.protein),
              ),
              Expanded(
                child: _MacroItem(value: data.totalCarbs.round(), label: strings.carbLabel, color: ShareTokens.carb),
              ),
              Expanded(
                child: _MacroItem(value: data.totalFat.round(), label: strings.fatLabel, color: ShareTokens.fat),
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
  const _MacroItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value}g',
          style: TextStyle(fontSize: 56, fontWeight: FontWeight.w800, color: color, letterSpacing: -1.68, height: 1),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: ShareTokens.textMuted, fontWeight: FontWeight.w600, letterSpacing: 2.16, height: 1),
        ),
      ],
    );
  }
}
