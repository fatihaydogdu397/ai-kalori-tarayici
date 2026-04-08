import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnText = isDark ? AppColors.void_ : AppColors.snow;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            children: [
              const Spacer(),
              // Phone mockup
              _PhoneMockup(isDark: isDark),
              const Spacer(),
              // Title
              Text(
                l.splashTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 32.h),
              // CTA button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnBg,
                    foregroundColor: btnText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 0,
                  ),
                  child: Text(
                    l.getStarted,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: btnText,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l.alreadyHaveAccount,
                    style: TextStyle(fontSize: 13.sp, color: textMuted),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      // Future: navigate to login screen
                    },
                    child: Text(
                      l.signIn,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneMockup extends StatelessWidget {
  final bool isDark;
  const _PhoneMockup({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final screenBg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final frameBorder = isDark ? const Color(0xFF3A3A4A) : const Color(0xFFD0CDE8);
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Container(
      width: 200.w,
      height: 340.h,
      decoration: BoxDecoration(
        color: screenBg,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: frameBorder, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: Column(
          children: [
            // Status bar + notch
            Container(
              color: screenBg,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('9:41', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: textPrimary)),
                  Container(
                    width: 40.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: frameBorder,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  Icon(Icons.battery_full_rounded, size: 12.sp, color: textMuted),
                ],
              ),
            ),
            // App header
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  Icon(Icons.water_drop_rounded, size: 14.sp, color: accent),
                  const SizedBox(width: 4),
                  Text('eatiq', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: textPrimary)),
                ],
              ),
            ),
            // Calorie ring area
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    // Mini ring
                    SizedBox(
                      width: 44.w,
                      height: 44.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 0.62,
                            strokeWidth: 5,
                            backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(accent),
                          ),
                          Text('62%', style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w800, color: textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('1877', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: textPrimary)),
                        Text('kcal left', style: TextStyle(fontSize: 7.sp, color: textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Macro pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  _MacroPill(label: 'P', value: '58g', color: AppColors.violet, isDark: isDark),
                  const SizedBox(width: 4),
                  _MacroPill(label: 'C', value: '143g', color: AppColors.amber, isDark: isDark),
                  const SizedBox(width: 4),
                  _MacroPill(label: 'F', value: '33g', color: AppColors.coral, isDark: isDark),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Recent entries label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Son Kayıtlar', style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w700, color: textMuted)),
              ),
            ),
            const SizedBox(height: 4),
            // Meal items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _MealRow(name: 'Tavuklu Pilav', cal: '300', isDark: isDark, textPrimary: textPrimary, textMuted: textMuted),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: _MealRow(name: 'Çoban Salatası', cal: '140', isDark: isDark, textPrimary: textPrimary, textMuted: textMuted),
            ),
            const Spacer(),
            // Bottom nav bar
            Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.home_rounded, size: 14.sp, color: accent),
                  Icon(Icons.bar_chart_rounded, size: 14.sp, color: textMuted),
                  Icon(Icons.restaurant_menu_rounded, size: 14.sp, color: textMuted),
                  Icon(Icons.settings_rounded, size: 14.sp, color: textMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool isDark;
  const _MacroPill({required this.label, required this.value, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 3),
            Text(value, style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final String name, cal;
  final bool isDark;
  final Color textPrimary, textMuted;
  const _MealRow({required this.name, required this.cal, required this.isDark, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w600, color: textPrimary)),
          Text('$cal kcal', style: TextStyle(fontSize: 7.sp, color: textMuted)),
        ],
      ),
    );
  }
}
