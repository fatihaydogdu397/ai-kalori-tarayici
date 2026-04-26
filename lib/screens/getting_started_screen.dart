import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'auth/auth_screen.dart';
import 'paywall_screen.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({super.key});

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _enterController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic));

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
    if (!mounted) return;

    // Logged-out → CTA bekle (Get Started ile AuthScreen).
    if (!provider.isLoggedIn) return;

    // BE-source-of-truth: profile dolu ise local flag yapışkan kıl.
    final hasCompleteProfile = provider.height > 0 && provider.weight > 0;
    final localDone = await provider.isOnboardingDone();
    if (hasCompleteProfile && !localDone) {
      await provider.setOnboardingDone(true);
    }
    final done = localDone || hasCompleteProfile;

    if (!mounted) return;

    if (!done) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      return;
    }

    if (provider.isPremium) {
      provider.loadHistory();
      provider.loadTodayStats();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const btnBg = AppColors.lime;
    const btnText = AppColors.void_;
    const textPrimary = AppColors.darkText;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          const Positioned.fill(child: _FluidBackground(isDark: true)),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      SvgPicture.asset('assets/icons/wordmark_dark.svg', height: 28.h),
                      const Spacer(flex: 2),
                      const _CentralVisual(),
                      const Spacer(flex: 2),
                      Text(
                        l.splashTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -1, height: 1.1),
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnBg,
                            foregroundColor: btnText,
                            shadowColor: AppColors.lime.withOpacity(0.3),
                            elevation: 8,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
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
    final glassColor = Colors.black.withOpacity(0.2);
    final borderColor = Colors.white.withOpacity(0.1);

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
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 40, spreadRadius: -5),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
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
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
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
                          const BoxShadow(color: AppColors.lime, blurRadius: 10, spreadRadius: 2),
                          BoxShadow(color: AppColors.lime.withOpacity(0.6), blurRadius: 24, spreadRadius: 6),
                          const BoxShadow(color: Colors.white, blurRadius: 4, spreadRadius: 0),
                        ],
                      ),
                    ),
                  );
                },
              ),
              _buildCorner(Alignment.topLeft),
              _buildCorner(Alignment.topRight),
              _buildCorner(Alignment.bottomLeft),
              _buildCorner(Alignment.bottomRight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(36.w),
        child: Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            border: Border(
              top: (alignment == Alignment.topLeft || alignment == Alignment.topRight) ? const BorderSide(color: AppColors.lime, width: 3) : BorderSide.none,
              bottom: (alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight) ? const BorderSide(color: AppColors.lime, width: 3) : BorderSide.none,
              left: (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft) ? const BorderSide(color: AppColors.lime, width: 3) : BorderSide.none,
              right: (alignment == Alignment.topRight || alignment == Alignment.bottomRight) ? const BorderSide(color: AppColors.lime, width: 3) : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
