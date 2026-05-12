import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';
import '../shared/share_title_block.dart';

/// D3-H · Ticket stub — each meal is rendered as a perforated ticket
/// (photo stub on the left, monospace info section on the right).
/// Source mock: docs/share-card-mocks/v5-ticket-stub.html
class D3HTicketStub extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D3HTicketStub({super.key, required this.data, this.locale = 'tr'});

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
            blob1Align: Alignment(-1.2, -0.3),
            blob2: ShareTokens.coral,
            blob2Align: Alignment(1.2, 0.6),
          ),
          Positioned(
            top: 200,
            left: 60,
            right: 60,
            child: ShareTitleBlock(
              eyebrow: strings.todayEyebrow,
              line1: strings.plateToTicketLine1,
              line2: strings.plateToTicketLine2,
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
                    child: _Ticket(
                      meal: meals[i],
                      ticketNo: '#${(i + 1).toString().padLeft(3, '0')}',
                      strings: strings,
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

class _Ticket extends StatelessWidget {
  final dynamic meal;
  final String ticketNo;
  final ShareCardStrings strings;
  const _Ticket({
    required this.meal,
    required this.ticketNo,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final n = meal.totalNutrients;
    final t = meal.analyzedAt as DateTime;
    final timeText =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    final monoStyle = GoogleFonts.jetBrainsMono(
      fontWeight: FontWeight.w500,
      height: 1,
    );
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: ShareTokens.glassFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ShareTokens.glassBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MealPhoto(
                  imagePath: meal.imagePath,
                  withDarkBottomGradient: false,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.3, 0.6, 1],
                      colors: [
                        Color(0x4D000000),
                        Colors.transparent,
                        Colors.transparent,
                        Color(0xB3000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ShareTokens.lime,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ticketNo,
                      style: monoStyle.copyWith(
                        color: ShareTokens.voidBg,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Perforation
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: SizedBox(
              width: 2,
              child: CustomPaint(painter: _PerforationPainter()),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Row(
                        label: strings.mealLabel,
                        value: _capitalize(
                          strings.mealTag(meal.mealCategory).toLowerCase(),
                        ),
                        monoStyle: monoStyle,
                      ),
                      const SizedBox(height: 6),
                      _Row(
                        label: strings.hourLabel,
                        value: timeText,
                        monoStyle: monoStyle,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 1,
                        color: const Color(0x14FFFFFF),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              strings.kcalLabel.toLowerCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: ShareTokens.textMuted,
                                letterSpacing: 1.95,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _MacroBox(
                              value: '${n.protein.round()}g',
                              label: strings.proteinLabel,
                              color: ShareTokens.protein,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MacroBox(
                              value: '${n.carbs.round()}g',
                              label: strings.carbLabel,
                              color: ShareTokens.carb,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _MacroBox(
                              value: '${n.fat.round()}g',
                              label: strings.fatLabel,
                              color: ShareTokens.fat,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle monoStyle;
  const _Row({
    required this.label,
    required this.value,
    required this.monoStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: monoStyle.copyWith(
            fontSize: 12,
            color: ShareTokens.textMuted,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: monoStyle.copyWith(
            fontSize: 14,
            color: ShareTokens.snow,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MacroBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MacroBox({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
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

class _PerforationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0x26FFFFFF);
    const dashHeight = 6.0;
    const gap = 6.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawRect(Rect.fromLTWH(0, y, 2, dashHeight), paint);
      y += dashHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
