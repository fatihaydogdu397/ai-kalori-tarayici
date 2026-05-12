import 'package:flutter/material.dart';

import '../../share_tokens.dart';

/// Reusable "eyebrow + 2-line title" block for daily-3/4/5 templates.
class ShareTitleBlock extends StatelessWidget {
  final String eyebrow;
  final String line1;
  final String line2;
  final double titleSize;
  final Color titleColor;

  const ShareTitleBlock({
    super.key,
    required this.eyebrow,
    required this.line1,
    required this.line2,
    this.titleSize = 100,
    this.titleColor = ShareTokens.snow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: ShareTokens.lime,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 4.4,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '$line1\n$line2',
          style: TextStyle(
            color: titleColor,
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            letterSpacing: -titleSize * 0.04,
            height: 0.95,
          ),
        ),
      ],
    );
  }
}

/// Two-blob background variant used by daily-3 templates (lime + coral).
class ThreeMealBackground extends StatelessWidget {
  final Color blob1;
  final Alignment blob1Align;
  final double blob1Size;
  final Color blob2;
  final Alignment blob2Align;
  final double blob2Size;

  const ThreeMealBackground({
    super.key,
    this.blob1 = ShareTokens.lime,
    this.blob1Align = const Alignment(-1, 0.2),
    this.blob1Size = 550,
    this.blob2 = ShareTokens.coral,
    this.blob2Align = const Alignment(1, -0.8),
    this.blob2Size = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: ShareTokens.voidBg),
        Align(
          alignment: blob1Align,
          child: _Blob(size: blob1Size, color: blob1),
        ),
        Align(
          alignment: blob2Align,
          child: _Blob(size: blob2Size, color: blob2),
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
                color.withValues(alpha: 0.18),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small uppercase tag chip (e.g. "KAHVALTI") used as meal category badge.
class MealCategoryTag extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double fontSize;
  final Color background;
  final Color foreground;
  final BorderRadius? borderRadius;
  final bool blurredBg;

  const MealCategoryTag({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.fontSize = 14,
    this.background = const Color(0x80000000),
    this.foreground = ShareTokens.lime,
    this.borderRadius,
    this.blurredBg = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius ?? BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          letterSpacing: fontSize * 0.1,
          height: 1,
        ),
      ),
    );
  }
}
