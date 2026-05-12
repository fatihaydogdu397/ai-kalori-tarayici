import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../share_tokens.dart';

/// Full-bleed background — void color + two soft radial blobs (lime / violet).
class ShareCardBackground extends StatelessWidget {
  const ShareCardBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: ShareTokens.voidBg),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.6, -0.8),
              radius: 0.9,
              colors: [Color(0x1FC8F135), Color(0x00C8F135)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.8, 0.8),
              radius: 0.85,
              colors: [Color(0x1A7B8FFF), Color(0x007B8FFF)],
            ),
          ),
        ),
      ],
    );
  }
}

/// Top brand + date pill row. Positioned at top:90 / sides:60.
class ShareCardHeader extends StatelessWidget {
  final DateTime date;
  final String locale;
  const ShareCardHeader({super.key, required this.date, this.locale = 'tr'});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM · EEE', locale).format(date);
    return Positioned(
      top: 90,
      left: 60,
      right: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ShareTokens.lime,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'e',
                  style: TextStyle(
                    color: ShareTokens.voidBg,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'eatiq',
                style: TextStyle(
                  color: ShareTokens.snow,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  letterSpacing: -0.56,
                  height: 1,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: ShareTokens.pillFill,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: ShareTokens.pillBorder),
            ),
            child: Text(
              dateStr,
              style: const TextStyle(
                color: ShareTokens.textSecondary,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom handle + lime CTA row. Positioned at bottom:80 / sides:60.
class ShareCardFooter extends StatelessWidget {
  final String handle;
  final String cta;
  const ShareCardFooter({super.key, required this.handle, required this.cta});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80,
      left: 60,
      right: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            handle,
            style: const TextStyle(
              color: ShareTokens.snow,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.36,
              height: 1,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 24),
            decoration: BoxDecoration(
              color: ShareTokens.lime,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              cta,
              style: const TextStyle(
                color: ShareTokens.voidBg,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.32,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
