import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'auth/auth_screen.dart';
import 'paywall_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fadeAnimation = CurvedAnimation(parent: _enterController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _enterController.forward();
      _checkOnboarding();
    });
  }

  @override
  void dispose() {
    _enterController.dispose();
    super.dispose();
  }

  Future<void> _checkOnboarding() async {
    final provider = context.read<AppProvider>();
    final isLoggedIn = provider.isLoggedIn;
    final done = await provider.isOnboardingDone();
    if (!mounted) return;

    if (isLoggedIn) {
      if (done) {
        if (!provider.isPremium) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
        } else {
          provider.loadHistory();
          provider.loadTodayStats();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const isDark = true; // Always force dark mode on Splash Screen
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnText = isDark ? AppColors.void_ : AppColors.snow;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // 1. Fluid Ambient Background
          Positioned.fill(child: _FluidBackground(isDark: isDark)),

          // 2. Main Content
          SafeArea(
            child: Stack(
              children: [
                // Language Dropdown
                // Positioned(
                //   top: 10.h,
                //   right: 28.w,
                //   child: FadeTransition(
                //     opacity: _fadeAnimation,
                //     child: _LanguageDropdown(isDark: isDark),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const Spacer(flex: 1),
                          // Top indicator / logo
                          SvgPicture.asset(isDark ? 'assets/icons/wordmark_dark.svg' : 'assets/icons/wordmark_light.svg', height: 28.h),
                          const Spacer(flex: 2),

                          // Central Scanner Visual
                          const _CentralVisual(),

                          const Spacer(flex: 2),

                          // Title Text
                          Text(
                            l.splashTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -1, height: 1.1),
                          ),
                          SizedBox(height: 32.h),

                          // CTA Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnBg,
                                foregroundColor: btnText,
                                shadowColor: isDark ? AppColors.lime.withOpacity(0.3) : AppColors.void_.withOpacity(0.2),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.r), // pill shape looks modern
                                ),
                                padding: EdgeInsets.symmetric(vertical: 18.h),
                              ),
                              child: Text(
                                l.getStarted,
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, letterSpacing: 0.5, color: btnText),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FluidBackground extends StatefulWidget {
  final bool isDark;
  const _FluidBackground({required this.isDark});

  @override
  State<_FluidBackground> createState() => _FluidBackgroundState();
}

class _FluidBackgroundState extends State<_FluidBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
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
      builder: (context, _) {
        final t = _controller.value * 2 * math.pi;
        final isDark = widget.isDark;

        final orb1Color = isDark ? AppColors.lime.withOpacity(0.15) : AppColors.lime.withOpacity(0.35);
        final orb2Color = isDark ? AppColors.violet.withOpacity(0.15) : AppColors.violet.withOpacity(0.3);
        final orb3Color = isDark ? AppColors.amber.withOpacity(0.1) : AppColors.amber.withOpacity(0.25);

        return Stack(
          children: [
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 + 100 * math.cos(t) - 150,
              top: MediaQuery.of(context).size.height * 0.3 + 100 * math.sin(t) - 150,
              child: _buildOrb(orb1Color, 300),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.5 + 120 * math.cos(t + math.pi) - 150,
              bottom: MediaQuery.of(context).size.height * 0.3 + 120 * math.sin(t + math.pi) - 150,
              child: _buildOrb(orb2Color, 300),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.5 + 80 * math.cos(t + math.pi / 2) - 100,
              top: MediaQuery.of(context).size.height * 0.5 + 80 * math.sin(t + math.pi / 2) - 100,
              child: _buildOrb(orb3Color, 200),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _CentralVisual extends StatefulWidget {
  const _CentralVisual();

  @override
  State<_CentralVisual> createState() => _CentralVisualState();
}

class _CentralVisualState extends State<_CentralVisual> with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  Timer? _iconTimer;
  int _currentIconIndex = 0;

  final List<IconData> _icons = [
    Icons.restaurant_menu_rounded,
    Icons.lunch_dining_rounded,
    Icons.local_pizza_rounded,
    Icons.fastfood_rounded,
    Icons.local_cafe_rounded,
    Icons.set_meal_rounded,
    Icons.ramen_dining_rounded,
    Icons.bakery_dining_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _iconTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentIconIndex = (_currentIconIndex + 1) % _icons.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    _iconTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const isDark = true; // Always force dark mode on Splash Screen

    // True glassmorphism lens
    final glassColor = isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.4);
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8);

    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: 220.w,
          height: 220.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: glassColor,
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(color: isDark ? Colors.black.withOpacity(0.4) : AppColors.lime.withOpacity(0.05), blurRadius: 40, spreadRadius: -5),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: Tween<double>(begin: 0.7, end: 1.0).animate(animation), child: child),
                  );
                },
                child: Icon(
                  _icons[_currentIconIndex],
                  key: ValueKey<int>(_currentIconIndex),
                  size: 80.sp,
                  color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.08),
                ),
              ),

              // Scanning Line
              AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  final yOffset = -70.0 + (_scanController.value * 140.0);
                  return Transform.translate(
                    offset: Offset(0, yOffset),
                    child: Container(
                      width: 130.w,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: AppColors.lime, blurRadius: 10, spreadRadius: 2),
                          BoxShadow(color: AppColors.lime.withOpacity(0.6), blurRadius: 24, spreadRadius: 6),
                          BoxShadow(color: Colors.white, blurRadius: 4, spreadRadius: 0), // Core bright laser
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Corner edges to make it look like a viewfinder
              _buildCorner(Alignment.topLeft, isDark),
              _buildCorner(Alignment.topRight, isDark),
              _buildCorner(Alignment.bottomLeft, isDark),
              _buildCorner(Alignment.bottomRight, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, bool isDark) {
    final edgeColor = isDark ? AppColors.lime : AppColors.void_.withOpacity(0.7);
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(36.w), // moved slightly inwards to match the circle
        child: Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            border: Border(
              top: (alignment == Alignment.topLeft || alignment == Alignment.topRight) ? BorderSide(color: edgeColor, width: 3) : BorderSide.none,
              bottom: (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight)
                  ? BorderSide(color: edgeColor, width: 3)
                  : BorderSide.none,
              left: (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft) ? BorderSide(color: edgeColor, width: 3) : BorderSide.none,
              right: (alignment == Alignment.topRight || alignment == Alignment.bottomRight)
                  ? BorderSide(color: edgeColor, width: 3)
                  : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final bool isDark;
  const _LanguageDropdown({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final currentLocale = provider.locale ?? const Locale('en');

    final bg = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12, width: 0.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale.languageCode,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: isDark ? Colors.white70 : Colors.black87),
          dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(20.r), // Added beautiful popup radius
          onChanged: (String? newValue) {
            if (newValue != null) {
              provider.setLocale(Locale(newValue));
            }
          },
          items: [
            _buildFlagItem('en', '🇬🇧', isDark),
            _buildFlagItem('tr', '🇹🇷', isDark),
            _buildFlagItem('de', '🇩🇪', isDark),
            _buildFlagItem('fr', '🇫🇷', isDark),
            _buildFlagItem('es', '🇪🇸', isDark),
            _buildFlagItem('ar', '🇸🇦', isDark),
            _buildFlagItem('ru', '🇷🇺', isDark),
            _buildFlagItem('pt', '🇵🇹', isDark),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildFlagItem(String code, String flag, bool isDark) {
    return DropdownMenuItem(
      value: code,
      child: Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 8.w),
            Text(
              code.toUpperCase(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
