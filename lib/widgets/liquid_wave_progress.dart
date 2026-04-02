import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidWaveProgress extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color color;
  final double size;

  const LiquidWaveProgress({
    super.key,
    required this.progress,
    required this.color,
    this.size = 180,
  });

  @override
  State<LiquidWaveProgress> createState() => _LiquidWaveProgressState();
}

class _LiquidWaveProgressState extends State<LiquidWaveProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(0.1),
            border: Border.all(color: widget.color.withOpacity(0.2), width: 2),
          ),
          child: ClipPath(
            clipper: _WaveClipper(_controller.value, widget.progress),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double progress;

  _WaveClipper(this.animationValue, this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final yOffset = size.height * (1 - progress);
    
    path.moveTo(0, yOffset);
    
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        yOffset + math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * 6,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
