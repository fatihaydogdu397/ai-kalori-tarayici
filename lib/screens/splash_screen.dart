import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightSurface;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconBg = isDark ? AppColors.lime : AppColors.void_;
    final iconColor = isDark ? AppColors.void_ : AppColors.lime;
    final wordEat = isDark ? AppColors.snow : AppColors.void_;
    final wordIq = isDark ? AppColors.lime : AppColors.limeDark;
    final statMeals = isDark ? AppColors.lime : AppColors.void_;
    final statAccuracy = isDark ? AppColors.violet : AppColors.violetDark;
    final statRating = isDark ? AppColors.amber : AppColors.amberDark;
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnText = isDark ? AppColors.void_ : AppColors.lime;
    final signInColor = isDark ? AppColors.violet : AppColors.violetDark;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              // Logo
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'e',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: iconColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Wordmark
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1,
                  ),
                  children: [
                    TextSpan(text: 'eat', style: TextStyle(color: wordEat)),
                    TextSpan(text: 'iq', style: TextStyle(color: wordIq)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Snap a photo. Know what you eat.',
                style: TextStyle(fontSize: 13, color: textMuted),
              ),
              const SizedBox(height: 32),
              // Stats
              Row(
                children: [
                  _StatCard(bg: cardBg, value: '5M+', label: 'meals scanned', valueColor: statMeals),
                  const SizedBox(width: 10),
                  _StatCard(bg: cardBg, value: '98%', label: 'accuracy', valueColor: statAccuracy),
                  const SizedBox(width: 10),
                  _StatCard(bg: cardBg, value: '4.8', label: 'rating', valueColor: statRating),
                ],
              ),
              const Spacer(),
              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AppProvider>().loadHistory();
                    context.read<AppProvider>().loadTodayStats();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnBg,
                    foregroundColor: btnText,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: btnText,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 12, color: textMuted),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign in',
                      style: TextStyle(color: signInColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Color bg;
  final String value;
  final String label;
  final Color valueColor;

  const _StatCard({
    required this.bg,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textMuted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: valueColor,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
