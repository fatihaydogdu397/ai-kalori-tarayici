import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/food_analysis.dart';
import '../services/app_provider.dart';
import 'share_card_data.dart';
import 'share_picker_screen.dart';
import 'share_tokens.dart';
import 'weekly_share_picker_screen.dart';

/// Bottom sheet shown from the progress screen so the user can pick between
/// sharing the day vs. the week.
class ShareModePicker {
  ShareModePicker._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: ShareTokens.cardDeep,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => const _Sheet(),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              MaterialLocalizations.of(context).alertDialogLabel,
              style: const TextStyle(fontSize: 0, height: 0),
            ),
            const Text(
              'Ne paylaşmak istiyorsun?',
              style: TextStyle(
                color: ShareTokens.snow,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Bugünün öğünleri ya da son 7 gün',
              style: TextStyle(
                color: ShareTokens.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            _ModeTile(
              icon: Icons.today_rounded,
              title: 'Bugünü Paylaş',
              subtitle: 'Bu güne kayıtlı tüm öğünler',
              accent: ShareTokens.lime,
              onTap: () => _openDaily(context),
            ),
            const SizedBox(height: 12),
            _ModeTile(
              icon: Icons.calendar_view_week_rounded,
              title: 'Haftayı Paylaş',
              subtitle: 'Son 7 günün özeti',
              accent: ShareTokens.violet,
              onTap: () => _openWeekly(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _openDaily(BuildContext context) {
    final provider = context.read<AppProvider>();
    final now = DateTime.now();
    final todayMeals = provider.history
        .where((m) =>
            m.analyzedAt.year == now.year &&
            m.analyzedAt.month == now.month &&
            m.analyzedAt.day == now.day)
        .toList()
      ..sort((a, b) => a.analyzedAt.compareTo(b.analyzedAt));
    Navigator.pop(context);
    if (todayMeals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bugün için kayıt yok'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SharePickerScreen(
          data: ShareCardData(date: now, meals: todayMeals),
          locale: Localizations.localeOf(context).languageCode,
        ),
      ),
    );
  }

  void _openWeekly(BuildContext context) {
    final provider = context.read<AppProvider>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(const Duration(days: 6));
    final days = List<List<FoodAnalysis>>.generate(7, (i) {
      final d = weekStart.add(Duration(days: i));
      return provider.history
          .where((m) =>
              m.analyzedAt.year == d.year &&
              m.analyzedAt.month == d.month &&
              m.analyzedAt.day == d.day)
          .toList()
        ..sort((a, b) => a.analyzedAt.compareTo(b.analyzedAt));
    });
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WeeklySharePickerScreen(
          data: WeeklyShareCardData(weekStart: weekStart, days: days),
          locale: Localizations.localeOf(context).languageCode,
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;
  const _ModeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: ShareTokens.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x14FFFFFF)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ShareTokens.snow,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: ShareTokens.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: ShareTokens.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
