import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';

class PaywallScreen extends StatefulWidget {
  /// If true, user arrived from a hard limit (scan limit reached).
  /// If false, user navigated here from settings / premium button.
  final bool fromLimit;

  const PaywallScreen({super.key, this.fromLimit = false});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isYearly = true;
  bool _isLoading = false;

  static const _monthlyPrice = '₺149';
  static const _yearlyPrice = '₺999';
  static const _monthlyTotal = '₺1,788';

  static const _features = [
    ('🔍', 'Unlimited AI food scans', 'No daily cap, scan as much as you want'),
    ('📊', 'Full history & analytics', 'Track progress over weeks and months'),
    ('📅', 'Weekly AI report', 'Personalized insights every week'),
    ('🥗', 'AI diet plan generator', 'Custom 7-day plans tailored to you'),
    ('🏷️', 'Turkish food database', '10,000+ local dishes and ingredients'),
    ('💧', 'Apple Health sync', 'Seamless meals & water integration'),
  ];

  Future<void> _purchase() async {
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    // TODO: Hook up RevenueCat purchase flow
    // final provider = context.read<AppProvider>();
    // await provider.purchaseSubscription(_isYearly ? 'yearly' : 'monthly');

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  Future<void> _restore() async {
    final provider = context.read<AppProvider>();
    await provider.restorePurchases();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(isDark, accent),
                  SizedBox(height: 24.h),
                  _buildFeatureList(isDark),
                  SizedBox(height: 24.h),
                  _buildPlanSelector(isDark, accent),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
          _buildBottomCTA(isDark, accent, accentFg, l),
        ],
      ),
    );
  }

  Widget _buildHero(bool isDark, Color accent) {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 300.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1A1F2E), const Color(0xFF0F0F14)]
                  : [const Color(0xFF1A1F2E), const Color(0xFF2D3550)],
            ),
          ),
        ),
        // Back button
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.close_rounded, color: Colors.white, size: 18.sp),
                ),
              ),
            ),
          ),
        ),
        // Hero content
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(32.w, 60.h, 32.w, 32.h),
            child: Column(
              children: [
                // Logo mark
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(
                    color: AppColors.lime.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: AppColors.lime.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Center(
                    child: Text('⚡', style: TextStyle(fontSize: 30.sp)),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'eatiq Pro',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Unlock everything.\nEat smarter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom fade
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 48.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, isDark ? AppColors.darkBg : AppColors.lightBg],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureList(bool isDark) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
        ),
        child: Column(
          children: List.generate(_features.length, (i) {
            final (emoji, title, subtitle) = _features[i];
            final isLast = i == _features.length - 1;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Center(child: Text(emoji, style: TextStyle(fontSize: 20.sp))),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textPrimary)),
                            SizedBox(height: 2.h),
                            Text(subtitle, style: TextStyle(fontSize: 11.sp, color: textMuted, height: 1.3)),
                          ],
                        ),
                      ),
                      Icon(Icons.check_circle_rounded, color: isDark ? AppColors.lime : AppColors.void_, size: 18.sp),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 16.w,
                    endIndent: 16.w,
                    color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPlanSelector(bool isDark, Color accent) {
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your plan',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textMuted),
          ),
          SizedBox(height: 12.h),
          // Yearly plan
          _PlanOption(
            isSelected: _isYearly,
            isDark: isDark,
            accent: accent,
            badge: 'Save 44%',
            title: 'Yearly',
            price: _yearlyPrice,
            subtitle: '${(_yearlyPrice.replaceAll('₺', '').replaceAll(',', ''))}  •  Billed annually',
            subNote: 'vs $_monthlyTotal if paid monthly',
            onTap: () {
              setState(() => _isYearly = true);
              HapticFeedback.selectionClick();
            },
          ),
          SizedBox(height: 10.h),
          // Monthly plan
          _PlanOption(
            isSelected: !_isYearly,
            isDark: isDark,
            accent: accent,
            badge: null,
            title: 'Monthly',
            price: _monthlyPrice,
            subtitle: '$_monthlyPrice/month  •  Billed monthly',
            subNote: null,
            onTap: () {
              setState(() => _isYearly = false);
              HapticFeedback.selectionClick();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(bool isDark, Color accent, Color accentFg, AppLocalizations l) {
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
        border: Border(top: BorderSide(color: isDark ? AppColors.darkCard : AppColors.lightBorder, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _purchase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: accentFg,
                  disabledBackgroundColor: accent.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(accentFg),
                        ),
                      )
                    : Text(
                        _isYearly
                            ? 'Start with Yearly — $_yearlyPrice'
                            : 'Start with Monthly — $_monthlyPrice',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _restore,
                  child: Text(
                    'Restore purchase',
                    style: TextStyle(fontSize: 12.sp, color: textMuted, decoration: TextDecoration.underline),
                  ),
                ),
                Text('  ·  ', style: TextStyle(fontSize: 12.sp, color: textMuted)),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 12.sp, color: textMuted, decoration: TextDecoration.underline),
                  ),
                ),
                Text('  ·  ', style: TextStyle(fontSize: 12.sp, color: textMuted)),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Terms',
                    style: TextStyle(fontSize: 12.sp, color: textMuted, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

// ── Plan Option ───────────────────────────────────────────────────────────────
class _PlanOption extends StatelessWidget {
  final bool isSelected, isDark;
  final Color accent;
  final String? badge;
  final String title, price, subtitle;
  final String? subNote;
  final VoidCallback onTap;

  const _PlanOption({
    required this.isSelected,
    required this.isDark,
    required this.accent,
    required this.badge,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.subNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? accent.withValues(alpha: isDark ? 0.1 : 0.07) : cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Radio circle
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? accent : (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 14.sp, color: isDark ? AppColors.void_ : AppColors.snow)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: textPrimary)),
                      if (badge != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.lime.withValues(alpha: 0.2) : AppColors.void_.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: accent),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: TextStyle(fontSize: 12.sp, color: textMuted)),
                  if (subNote != null) ...[
                    SizedBox(height: 2.h),
                    Text(subNote!, style: TextStyle(fontSize: 11.sp, color: accent.withValues(alpha: 0.8), fontWeight: FontWeight.w600)),
                  ],
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: isSelected ? accent : textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
