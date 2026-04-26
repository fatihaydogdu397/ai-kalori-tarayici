import 'package:flutter/material.dart';

/// App-wide tap-to-dismiss keyboard wrapper. Tap on any non-focusable area
/// unfocuses the current field; taps on TextFields / buttons keep working
/// because of [HitTestBehavior.translucent].
///
/// Mounted via [MaterialApp.builder] in `lib/main.dart` so every screen in
/// the Navigator stack inherits the behavior.
class KeyboardDismisser extends StatelessWidget {
  final Widget child;
  const KeyboardDismisser({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
