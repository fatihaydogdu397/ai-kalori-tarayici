import 'package:flutter/material.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';

/// D1-B · Full Bleed (revised) — square radius photo center-stage with a
/// lime "Today's meal" pill above and a mega kcal numeral + glass macro card
/// below. The original full-canvas photo was swapped for a centered square
/// on user feedback (photo wall felt overwhelming).
class D1BFullBleed extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D1BFullBleed({super.key, required this.data, this.locale = 'tr'});

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
          // Lime tag pill (top-left)
          Positioned(
            top: 220,
            left: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: ShareTokens.lime,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                strings.eyebrowFor(meal.mealCategory),
                style: const TextStyle(
                  color: ShareTokens.voidBg,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.76,
                  height: 1,
                ),
              ),
            ),
          ),
          // Centered square photo (880×880)
          Positioned(
            top: 320,
            left: 100,
            right: 100,
            height: 880,
            child: MealPhoto(
              imagePath: meal.imagePath,
              borderRadius: BorderRadius.circular(40),
              withDarkBottomGradient: false,
            ),
          ),
          // Mega kcal + label
          Positioned(
            top: 1230,
            left: 60,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.totalCalories.round().toString(),
                  style: const TextStyle(
                    fontSize: 240,
                    fontWeight: FontWeight.w900,
                    color: ShareTokens.lime,
                    letterSpacing: -14.4,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.kcalLabel,
                  style: const TextStyle(
                    fontSize: 26,
                    color: ShareTokens.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 5.2,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          // Glass macro card (P/K/F only, vertical dividers)
          Positioned(
            bottom: 240,
            left: 60,
            right: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0x801C1C2A),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _GlassDataItem(
                        value: data.totalProtein.round(),
                        label: strings.proteinLabel,
                        color: ShareTokens.protein,
                      ),
                    ),
                    const _GlassDataDivider(),
                    Expanded(
                      child: _GlassDataItem(
                        value: data.totalCarbs.round(),
                        label: strings.carbLabel,
                        color: ShareTokens.carb,
                      ),
                    ),
                    const _GlassDataDivider(),
                    Expanded(
                      child: _GlassDataItem(
                        value: data.totalFat.round(),
                        label: strings.fatLabel,
                        color: ShareTokens.fat,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }
}

class _GlassDataItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _GlassDataItem({
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
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -1.68,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
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

class _GlassDataDivider extends StatelessWidget {
  const _GlassDataDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 1,
      child: ColoredBox(color: Color(0x14FFFFFF)),
    );
  }
}
