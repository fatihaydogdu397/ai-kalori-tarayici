import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_provider.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  
  Timer? _timer;
  int _secondsLeft = 180; // 3 minutes total
  int _resendCooldown = 60; // 1 minute cooldown per resend

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsLeft = 180;
      _resendCooldown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) _secondsLeft--;
        if (_resendCooldown > 0) _resendCooldown--;
        
        if (_secondsLeft == 0 && _resendCooldown == 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit code'), backgroundColor: AppColors.coral),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<AppProvider>().verifyPasswordResetOtp(widget.email, otp);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email, code: otp),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.coral),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      await context.read<AppProvider>().sendPasswordResetOtp(widget.email);
      
      if (_secondsLeft == 0) {
        // If the 3 minutes fully expired, restart the entire session
        _startTimer();
      } else {
        // Just within the 3 min window, reset only the cooldown
        setState(() => _resendCooldown = 60);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code resent!'), backgroundColor: AppColors.lime),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.coral),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Verify Email",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                "We've sent a 6-digit verification code to\n${widget.email}",
                style: TextStyle(fontSize: 14.sp, color: textMuted, height: 1.4),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              
              // Circular Timer
              Center(
                child: Container(
                  width: 130.w,
                  height: 130.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark ? AppColors.lime : AppColors.violet).withOpacity(_secondsLeft > 0 ? 0.15 : 0.0),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                       // Back shadow ring for depth
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 8,
                        color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
                      ),
                      // Animated Progress
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: _secondsLeft / 180, end: _secondsLeft / 180),
                        duration: const Duration(seconds: 1),
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            color: isDark ? AppColors.lime : AppColors.violet,
                            strokeCap: StrokeCap.round,
                          );
                        },
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer_outlined, color: textMuted.withOpacity(0.5), size: 22.sp),
                            SizedBox(height: 4.h),
                            Text(
                              _formattedTime,
                              style: TextStyle(
                                fontSize: 26.sp, 
                                fontWeight: FontWeight.w800, 
                                color: _secondsLeft == 0 ? AppColors.coral : textPrimary, 
                                letterSpacing: 1.w
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48.h),

              // OTP Input
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(color: textPrimary, fontSize: 32.sp, fontWeight: FontWeight.w800, letterSpacing: 16.w),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "••••••",
                  hintStyle: TextStyle(color: textMuted.withOpacity(0.3), letterSpacing: 16.w),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: isDark ? AppColors.lime : AppColors.violet, width: 2)),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                ),
              ),
              SizedBox(height: 32.h),

              // Resend Button
              TextButton(
                onPressed: _resendCooldown == 0 && !_isLoading ? _resendOtp : null,
                style: TextButton.styleFrom(
                  foregroundColor: _secondsLeft == 0 
                      ? AppColors.coral 
                      : (isDark ? AppColors.lime : AppColors.violet),
                  disabledForegroundColor: textMuted,
                ),
                child: Text(
                  _secondsLeft == 0 
                      ? "Restart Verification" 
                      : (_resendCooldown > 0 ? "Resend Code (${_resendCooldown}s)" : "Resend Code"),
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 32.h),

              // Action Button
              if (_isLoading)
                Center(child: CircularProgressIndicator(color: AppColors.lime))
              else
                ElevatedButton(
                  onPressed: _secondsLeft > 0 ? _verifyOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                    foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                    disabledBackgroundColor: isDark ? Colors.white12 : Colors.black12,
                    disabledForegroundColor: isDark ? Colors.white38 : Colors.black38,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                  ),
                  child: Text("Şifremi Sıfırla", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
                ),
                
              SizedBox(height: 48.h),
            ],
          ),
        ),
      ),
    );
  }
}
