import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

/// Mock Social Login Screen (EAT-22)
/// No real auth — all buttons show a coming-soon snack or navigate back.
/// Wire to real Google/Apple SDKs when backend is ready.
class SocialLoginScreen extends StatefulWidget {
  /// If true, shown as a bottom sheet modal.
  final bool isModal;
  const SocialLoginScreen({super.key, this.isModal = false});

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  bool _loading = false;

  void _mockSignIn(String provider) async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider sign-in coming soon'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard
            : AppColors.lightText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.limeDark;
    final border = isDark
        ? null
        : Border.all(color: AppColors.lightBorder, width: 0.5);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!widget.isModal) ...[
          SizedBox(height: MediaQuery.of(context).padding.top + 16.h),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: border,
                  ),
                  child: Icon(Icons.close_rounded, size: 18.sp, color: textMuted),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.h),
        ] else
          SizedBox(height: 8.h),

        // Logo / icon
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Center(
            child: Text('🥗', style: TextStyle(fontSize: 34.sp)),
          ),
        ),
        SizedBox(height: 20.h),

        // Headline
        Text(
          'Sign in to eatiq',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w900,
            color: textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Sync your progress across devices and\nunlock personalised nutrition insights.',
          style: TextStyle(
            fontSize: 14.sp,
            color: textMuted,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),

        // Apple Sign In
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _SocialButton(
            label: 'Continue with Apple',
            icon: Icons.apple_rounded,
            bgColor: isDark ? Colors.white : Colors.black,
            fgColor: isDark ? Colors.black : Colors.white,
            onTap: _loading ? null : () => _mockSignIn('Apple'),
            loading: _loading,
          ),
        ),
        SizedBox(height: 12.h),

        // Google Sign In
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _SocialButton(
            label: 'Continue with Google',
            customIcon: _GoogleIcon(),
            bgColor: cardBg,
            fgColor: textPrimary,
            borderColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
            onTap: _loading ? null : () => _mockSignIn('Google'),
            loading: false,
          ),
        ),
        SizedBox(height: 24.h),

        // Divider
        Row(
          children: [
            SizedBox(width: 24.w),
            Expanded(
              child: Divider(
                color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                thickness: 0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                'or',
                style: TextStyle(fontSize: 12.sp, color: textMuted),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                thickness: 0.5,
              ),
            ),
            SizedBox(width: 24.w),
          ],
        ),
        SizedBox(height: 16.h),

        // Guest
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(
            'Continue without signing in',
            style: TextStyle(
              fontSize: 14.sp,
              color: textMuted,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: textMuted,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Legal note
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            'By continuing, you agree to our Terms of Service\nand Privacy Policy.',
            style: TextStyle(
              fontSize: 11.sp,
              color: textMuted.withValues(alpha: 0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        if (!widget.isModal) SizedBox(height: 40.h),
      ],
    );

    if (widget.isModal) {
      return Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(child: content),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(child: content),
    );
  }
}

// ── Social Button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final Color bgColor, fgColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool loading;

  const _SocialButton({
    required this.label,
    this.icon,
    this.customIcon,
    required this.bgColor,
    required this.fgColor,
    this.borderColor,
    required this.onTap,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
        ),
        child: loading
            ? Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fgColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (customIcon != null)
                    customIcon!
                  else if (icon != null)
                    Icon(icon, color: fgColor, size: 20.sp),
                  SizedBox(width: 10.w),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: fgColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── Google "G" Icon ───────────────────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(20.w, 20.w),
      painter: _GoogleIconPainter(),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Background circle
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = Colors.white,
    );

    // Simplified "G" using colored arcs
    const sweep = 3.14159;
    // Blue arc (top-right to bottom)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.75),
      -1.57,
      sweep,
      false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );
    // Red arc (top-left)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.75),
      -sweep - 1.57,
      sweep * 0.5,
      false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
