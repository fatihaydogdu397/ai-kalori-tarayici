import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_theme.dart';

class CalorieRing extends StatelessWidget {
  final double consumed;
  final double goal;
  final double size;

  const CalorieRing({
    super.key,
    required this.consumed,
    required this.goal,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (consumed / goal).clamp(0.0, 1.0);
    final remaining = (goal - consumed).clamp(0, goal);
    final isOver = consumed > goal;

    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: 14,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            consumed.toStringAsFixed(0),
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'kcal',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isOver ? 'Aşıldı!' : '${remaining.toStringAsFixed(0)} kaldı',
            style: TextStyle(
              color: isOver ? AppTheme.error : AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      progressColor: isOver ? AppTheme.error : AppTheme.primary,
      backgroundColor: AppTheme.surface,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1000,
    );
  }
}
