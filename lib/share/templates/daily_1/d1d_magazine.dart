import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../share_card_data.dart';
import '../../share_tokens.dart';
import '../../widgets/share_card_chrome.dart';
import '../shared/meal_photo.dart';
import '../shared/share_card_strings.dart';

/// D1-D · Magazine — editorial layout with Fraunces serif title, eyebrow
/// flanked by lime rules, inline stat row, divider, and issue/log footer line.
/// Source mock: docs/share-card-mocks/d1d-magazine.html
class D1DMagazine extends StatelessWidget {
  final ShareCardData data;
  final String locale;
  const D1DMagazine({super.key, required this.data, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final meal = data.meals.first;
    final strings = ShareCardStrings.of(locale);
    final issue = _issueNumber(meal.analyzedAt);
    final dayName = DateFormat('EEEE', locale).format(meal.analyzedAt);
    return SizedBox(
      width: ShareTokens.canvas.width,
      height: ShareTokens.canvas.height,
      child: Stack(
        children: [
          const ShareCardBackground(),
          // Full-width photo block
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            height: 1100,
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
                      stops: [0.3, 0.7, 1],
                      colors: [
                        Colors.transparent,
                        Color(0x4D0F0F14),
                        Color(0xF20F0F14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Eyebrow: lime rule · text · lime rule
          Positioned(
            top: 200,
            left: 60,
            child: Row(
              children: [
                Container(width: 40, height: 1.5, color: ShareTokens.lime),
                const SizedBox(width: 16),
                Text(
                  '${strings.eyebrowFor(meal.mealCategory)} · ${strings.volPrefix} 01',
                  style: const TextStyle(
                    color: ShareTokens.lime,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.5,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 16),
                Container(width: 40, height: 1.5, color: ShareTokens.lime),
              ],
            ),
          ),
          // Magazine title (Fraunces, serif)
          Positioned(
            bottom: 600,
            left: 60,
            right: 60,
            child: Text.rich(
              TextSpan(
                style: GoogleFonts.fraunces(
                  fontSize: 140,
                  fontWeight: FontWeight.w900,
                  color: ShareTokens.snow,
                  letterSpacing: -5.6,
                  height: 0.9,
                ),
                children: [
                  TextSpan(text: '${_titleFirstLine(strings)}\n'),
                  TextSpan(
                    text: _titleSecondLine(strings),
                    style: GoogleFonts.fraunces(
                      fontSize: 140,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: ShareTokens.lime,
                      letterSpacing: -5.6,
                      height: 0.9,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
          // Inline stats row
          Positioned(
            bottom: 400,
            left: 60,
            right: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _MagStatItem(
                  value: data.totalCalories.round(),
                  label: strings.kcalLabel,
                  color: ShareTokens.lime,
                  valueSize: 96,
                  suffix: '',
                ),
                const SizedBox(width: 60),
                _MagStatItem(
                  value: data.totalProtein.round(),
                  label: strings.proteinLabel,
                  color: ShareTokens.protein,
                  suffix: 'g',
                ),
                const SizedBox(width: 60),
                _MagStatItem(
                  value: data.totalCarbs.round(),
                  label: strings.carbLabel,
                  color: ShareTokens.carb,
                  suffix: 'g',
                ),
                const SizedBox(width: 60),
                _MagStatItem(
                  value: data.totalFat.round(),
                  label: strings.fatLabel,
                  color: ShareTokens.fat,
                  suffix: 'g',
                ),
              ],
            ),
          ),
          // Divider
          Positioned(
            bottom: 360,
            left: 60,
            right: 60,
            child: Container(height: 1.5, color: const Color(0x26FFFFFF)),
          ),
          // Bottom meta row
          Positioned(
            bottom: 240,
            left: 60,
            right: 60,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ShareTokens.textMuted,
                letterSpacing: 2.88,
                height: 1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${strings.issuePrefix} $issue'.toUpperCase(),
                          style: const TextStyle(
                            color: ShareTokens.snow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(text: ' · ${dayName.toUpperCase()}'),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${data.mealCount} ${_mealsWord(data.mealCount, locale)} · ',
                        ),
                        TextSpan(
                          text: strings.mealsRecordedSuffix,
                          style: const TextStyle(
                            color: ShareTokens.snow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShareCardHeader(date: data.date, locale: locale),
          ShareCardFooter(handle: data.handle, cta: data.cta),
        ],
      ),
    );
  }

  /// Day-of-year, zero-padded to 3 digits (matches "ISSUE 042" pattern).
  static String _issueNumber(DateTime dt) {
    final start = DateTime(dt.year, 1, 1);
    final day = dt.difference(start).inDays + 1;
    return day.toString().padLeft(3, '0');
  }

  // Title is split across two lines; first part normal, second italic+lime
  // plus a closing period. For now we infer split by stripping the trailing
  // period and second word — locale strings already shape this in copy bank.
  static String _titleFirstLine(ShareCardStrings strings) {
    final t = strings.magazineTitle;
    final stripped = t.endsWith('.') ? t.substring(0, t.length - 1) : t;
    final parts = stripped.split(' ');
    if (parts.length < 2) return stripped;
    return parts.sublist(0, parts.length - 1).join(' ');
  }

  static String _titleSecondLine(ShareCardStrings strings) {
    final t = strings.magazineTitle;
    final stripped = t.endsWith('.') ? t.substring(0, t.length - 1) : t;
    final parts = stripped.split(' ');
    if (parts.length < 2) return '';
    return parts.last;
  }

  static String _mealsWord(int count, String locale) {
    if (locale.startsWith('tr')) return 'ÖĞÜN';
    return count == 1 ? 'MEAL' : 'MEALS';
  }
}

class _MagStatItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final double valueSize;
  final String suffix;

  const _MagStatItem({
    required this.value,
    required this.label,
    required this.color,
    this.valueSize = 72,
    this.suffix = 'g',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: GoogleFonts.fraunces(
              fontSize: valueSize,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -valueSize * 0.03,
              height: 1,
            ),
            children: [
              TextSpan(text: value.toString()),
              if (suffix.isNotEmpty)
                TextSpan(
                  text: suffix,
                  style: GoogleFonts.fraunces(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: color.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ShareTokens.textMuted,
            letterSpacing: 2.8,
            height: 1,
          ),
        ),
      ],
    );
  }
}
