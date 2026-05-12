import 'dart:io';
import 'package:flutter/material.dart';

import '../../share_tokens.dart';

/// Renders the meal photo. Supports remote URLs (BE) and local file paths
/// (camera / picker). Falls back to a tone-matched gradient placeholder.
class MealPhoto extends StatelessWidget {
  final String imagePath;
  final BorderRadius borderRadius;
  final bool withDarkBottomGradient;

  const MealPhoto({
    super.key,
    required this.imagePath,
    this.borderRadius = BorderRadius.zero,
    this.withDarkBottomGradient = true,
  });

  /// Returns an ImageProvider for the path, or null if it should fall back
  /// to a placeholder. Call this from the picker to precache before capture.
  static ImageProvider? providerFor(String imagePath) {
    if (imagePath.isEmpty) return null;
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    if (File(imagePath).existsSync()) {
      return FileImage(File(imagePath));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = providerFor(imagePath);

    final Widget content = provider == null
        ? const _PlateGradientPlaceholder()
        : Image(
            image: provider,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const _PlateGradientPlaceholder(),
          );

    final stack = Stack(
      fit: StackFit.expand,
      children: [
        content,
        if (withDarkBottomGradient)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB3000000)],
              ),
            ),
          ),
      ],
    );

    return borderRadius == BorderRadius.zero
        ? stack
        : ClipRRect(borderRadius: borderRadius, child: stack);
  }
}

class _PlateGradientPlaceholder extends StatelessWidget {
  const _PlateGradientPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4A3520), Color(0xFF8B5A2B)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.4, -0.3),
              radius: 0.55,
              colors: [Color(0xFFD4622A), Color(0x00D4622A)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.4, 0.2),
              radius: 0.5,
              colors: [Color(0xFFF4A050), Color(0x00F4A050)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, 0.6),
              radius: 0.45,
              colors: [Color(0xFF2A5A2A), Color(0x002A5A2A)],
            ),
          ),
        ),
        Container(color: ShareTokens.voidBg.withValues(alpha: 0)),
      ],
    );
  }
}
