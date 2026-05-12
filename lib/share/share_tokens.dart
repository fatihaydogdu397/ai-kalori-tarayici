import 'package:flutter/material.dart';

/// Design tokens for share cards.
/// Mirrors `docs/share-card-mocks/_shared.css`.
class ShareTokens {
  ShareTokens._();

  // Story canvas (IG / FB / Snap stories)
  static const Size canvas = Size(1080, 1920);

  // Palette
  static const Color voidBg = Color(0xFF0F0F14);
  static const Color card = Color(0xFF1C1C2A);
  static const Color cardDeep = Color(0xFF08080C);
  static const Color surface = Color(0xFF2A2A3E);
  static const Color snow = Color(0xFFF0EEF8);
  static const Color textMuted = Color(0xFF9090A8);
  static const Color textSecondary = Color(0xFFB0B0C8);
  static const Color lime = Color(0xFFC8F135);
  static const Color limeDeep = Color(0xFF5A7A0A);
  static const Color violet = Color(0xFF7B8FFF);
  static const Color amber = Color(0xFFFFB347);
  static const Color coral = Color(0xFFFF6B6B);
  static const Color mint = Color(0xFF2DDCB4);

  // Macro semantic mapping (matches html .protein-color / .carb-color / .fat-color)
  static const Color protein = violet;
  static const Color carb = amber;
  static const Color fat = coral;

  // Glass surfaces
  static const Color glassFill = Color(0x991C1C2A); // rgba(28,28,42,0.6)
  static const Color glassBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color pillFill = Color(0x14FFFFFF);
  static const Color pillBorder = Color(0x1AFFFFFF);

  static const String fontFamily = 'Inter';
}
