import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../services/api/api_exception.dart';
import '../services/api/diet_plan_service.dart';
import '../services/app_provider.dart';
import 'weekly_diet_plan_screen.dart';
import 'paywall_screen.dart';

class DietPlanLoadingScreen extends StatefulWidget {
  final Map<String, dynamic> anamnesisData;

  const DietPlanLoadingScreen({super.key, required this.anamnesisData});

  @override
  State<DietPlanLoadingScreen> createState() => _DietPlanLoadingScreenState();
}

class _DietPlanLoadingScreenState extends State<DietPlanLoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  int _stepIndex = 0;
  Timer? _stepTimer;
  final DietPlanService _dietPlanService = DietPlanService.instance;

  static const _steps = [
    ('🧬', 'Analyzing your profile...'),
    ('🎯', 'Calculating calorie targets...'),
    ('🥗', 'Building meal combinations...'),
    ('⚖️', 'Balancing macros...'),
    ('📅', 'Finalizing 7-day schedule...'),
    ('✨', 'Adding the finishing touches...'),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  void _startSequence() {
    // Adım göstergesi: kullanıcıya BE hazırlanırken ilerleme feedback'i ver.
    const stepDuration = Duration(milliseconds: 900);
    _stepTimer = Timer.periodic(stepDuration, (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _stepIndex = (_stepIndex + 1).clamp(0, _steps.length - 1);
      });
    });

    _generatePlan();
  }

  Future<void> _generatePlan() async {
    try {
      final plan = await _dietPlanService.generatePlan();
      _stepTimer?.cancel();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WeeklyDietPlanScreen(
            plan: plan,
            anamnesisData: widget.anamnesisData,
          ),
        ),
      );
    } on ApiException catch (e) {
      _stepTimer?.cancel();
      if (!mounted) return;
      if (e.code == 'PREMIUM_REQUIRED') {
        if (AppProvider.kBypassPaywall) {
          _showError(e.message);
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PaywallScreen()),
        );
        return;
      }
      _showError(e.message);
    } catch (e) {
      _stepTimer?.cancel();
      if (!mounted) return;
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.coral,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final progressVal = (_stepIndex + 1) / _steps.length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Pulsing circle with emoji
              ScaleTransition(
                scale: _pulse,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _steps[_stepIndex].$1,
                        key: ValueKey(_stepIndex),
                        style: TextStyle(fontSize: 48.sp),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Creating Your Plan',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              SizedBox(height: 12.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _steps[_stepIndex].$2,
                  key: ValueKey(_stepIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: textMuted, height: 1.5),
                ),
              ),

              SizedBox(height: 40.h),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressVal,
                  minHeight: 4,
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),

              SizedBox(height: 16.h),
              Text(
                '${(_stepIndex + 1)} of ${_steps.length} steps',
                style: TextStyle(fontSize: 12.sp, color: textMuted),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
