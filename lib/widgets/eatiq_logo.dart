import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EatiqLogo extends StatelessWidget {
  final double size;
  const EatiqLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final asset = isDark
        ? 'assets/icons/wordmark_dark.svg'
        : 'assets/icons/wordmark_light.svg';

    return SvgPicture.asset(
      asset,
      height: size,
    );
  }
}
