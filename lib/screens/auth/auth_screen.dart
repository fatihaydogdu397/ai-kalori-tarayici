import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_provider.dart';
import '../../services/auth/social_sign_in.dart';
import '../../generated/app_localizations.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../home_screen.dart';
import '../onboarding_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  Future<void> _handleSocialLogin(String providerName) async {
    setState(() => _isLoading = true);
    final provider = context.read<AppProvider>();

    try {
      // Native SDK'dan idToken al.
      String? idToken;
      switch (providerName.toUpperCase()) {
        case 'GOOGLE':
          idToken = await SocialSignIn.google();
          break;
        case 'APPLE':
          idToken = await SocialSignIn.apple();
          break;
        case 'FACEBOOK':
          if (mounted) setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facebook sign-in will be available soon.'),
              backgroundColor: AppColors.amber,
            ),
          );
          return;
        default:
          throw UnsupportedError('Unknown provider: $providerName');
      }

      if (idToken == null) {
        // Kullanıcı iptal etti — sessiz geç.
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      await provider.authSocialLogin(
        provider: providerName.toUpperCase(),
        idToken: idToken,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Giriş başarısız: $e'),
          backgroundColor: AppColors.coral,
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    final done = await provider.isOnboardingDone();
    if (!mounted) return;

    if (done) {
      provider.loadHistory();
      provider.loadTodayStats();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
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

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Elegant blurry background (resembling splash theme)
          Positioned(
            top: -100.h,
            left: -100.w,
            child: Container(
              width: 300.w, height: 300.w,
              decoration: BoxDecoration(color: AppColors.lime.withOpacity(0.15), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            bottom: -50.h,
            right: -100.w,
            child: Container(
              width: 250.w, height: 250.w,
              decoration: BoxDecoration(color: AppColors.violet.withOpacity(0.1), shape: BoxShape.circle),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  // Header
                  Icon(Icons.auto_awesome, color: isDark ? AppColors.lime : AppColors.violet, size: 32.sp),
                  SizedBox(height: 16.h),
                  Text(
                    "Join eatiq",
                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Choose how you want to continue.",
                    style: TextStyle(fontSize: 14.sp, color: textMuted),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(),
                  
                  if (_isLoading)
                    Center(child: CircularProgressIndicator(color: AppColors.lime))
                  else ...[
                    // Social Buttons
                    _SocialButton(
                      iconWidget: Icon(Icons.apple, size: 26.sp, color: textPrimary),
                      label: "Continue with Apple",
                      isDark: isDark,
                      onTap: () => _handleSocialLogin("apple"),
                    ),
                    SizedBox(height: 12.h),
                    _SocialButton(
                      iconWidget: SvgPicture.string(
                        '''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/></svg>''',
                        width: 24.sp, 
                        height: 24.sp,
                      ),
                      label: "Continue with Google",
                      isDark: isDark,
                      onTap: () => _handleSocialLogin("google"),
                    ),
                    SizedBox(height: 12.h),
                    _SocialButton(
                      iconWidget: Icon(Icons.facebook_rounded, size: 26.sp, color: textPrimary),
                      label: "Continue with Facebook",
                      isDark: isDark,
                      onTap: () => _handleSocialLogin("facebook"),
                    ),
                    
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text("OR", style: TextStyle(color: textMuted, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(child: Divider(color: isDark ? Colors.white24 : Colors.black12)),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Email Buttons
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                        foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                      ),
                      child: Text(
                        "Sign up with Email",
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                        foregroundColor: textPrimary,
                        side: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                      ),
                      child: Text(
                        l.signIn,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SocialButton({required this.iconWidget, required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 24.w),
                child: iconWidget,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp, 
                fontWeight: FontWeight.w600, 
                color: isDark ? AppColors.darkText : AppColors.lightText
              ),
            ),
          ],
        ),
      ),
    );
  }
}
