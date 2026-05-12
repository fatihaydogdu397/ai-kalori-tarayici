import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';

/// D1-C · Polaroid — tilted polaroid photo + handwritten caption center
/// stage, with the same glass macro card from D1-A pinned underneath.
/// (Old design had floating macro stickers; replaced per user feedback.)
/// Source mock: docs/share-card-mocks/d1c-polaroid.html
class D1CPolaroid extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D1CPolaroid({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final meal = data.meals.first;
    final strings = ShareCardStrings.of(locale);
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const _BackgroundWithBlobs(),
          // Polaroid (tilted)
          Positioned(
            top: 290,
            left: 0,
            right: 0,
            child: Center(
              child: Transform.rotate(
                angle: -3 * 3.1415926535 / 180,
                child: Container(
                  width: 720,
                  padding: const EdgeInsets.fromLTRB(40, 40, 40, 32),
                  decoration: BoxDecoration(
                    color: ShareTokens.snow,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 30),
                        blurRadius: 80,
                        color: Color(0x80000000),
                      ),
                      BoxShadow(
                        offset: Offset(0, 8),
                        blurRadius: 24,
                        color: Color(0x4D000000),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 640,
                        height: 640,
                        child: MealPhoto(
                          imagePath: meal.imagePath,
                          borderRadius: BorderRadius.circular(4),
                          withDarkBottomGradient: false,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        strings.polaroidCaption,
                        style: GoogleFonts.caveat(
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: ShareTokens.voidBg,
                          letterSpacing: 0.38,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Glass macro card (same as D1-A)
          Positioned(
            top: 1290,
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

class _BackgroundWithBlobs extends StatelessWidget {
  const _BackgroundWithBlobs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ShareCardBackground(),
        Positioned(
          top: -150,
          right: -150,
          child: _Blob(size: 600, color: ShareTokens.lime),
        ),
        Positioned(
          bottom: 200,
          left: -100,
          child: _Blob(size: 500, color: ShareTokens.violet),
        ),
        Positioned(
          top: 760,
          right: -100,
          child: _Blob(size: 400, color: ShareTokens.coral),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final double size;
  final Color color;
  const _Blob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                color.withValues(alpha: 0.5),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
