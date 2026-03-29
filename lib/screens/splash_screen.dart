import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
import '../widgets/eatiq_logo.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOnboarding());
  }

  Future<void> _checkOnboarding() async {
    final provider = context.read<AppProvider>();
    final done = await provider.isOnboardingDone();
    if (!mounted) return;
    if (done) {
      provider.loadHistory();
      provider.loadTodayStats();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnText = isDark ? AppColors.void_ : AppColors.lime;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              EatiqLogo(size: 80),
              const SizedBox(height: 8),
              Text(l.tagline, style: TextStyle(fontSize: 13, color: textMuted)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnBg,
                    foregroundColor: btnText,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(l.getStarted, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: btnText)),
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
