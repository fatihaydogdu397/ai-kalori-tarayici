import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_provider.dart';
import '../home_screen.dart';
import 'forgot_password_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final provider = context.read<AppProvider>();
    
    try {
      await provider.authLogin(
        _emailController.text.trim(),
        _passController.text,
      );
      
      if (!mounted) return;

      provider.loadHistory();
      provider.loadTodayStats();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e'), backgroundColor: AppColors.coral),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                // Icon
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.lime.withOpacity(0.1) : AppColors.void_.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.lock_person_rounded, size: 32.sp, color: isDark ? AppColors.lime : AppColors.void_),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.5),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Enter your email and password to log in.",
                  style: TextStyle(fontSize: 14.sp, color: textMuted),
                ),
                SizedBox(height: 40.h),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  isDark: isDark,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    return null;
                  },
                ),
                SizedBox(height: 20.h),

                // Password
                _buildTextField(
                  controller: _passController,
                  label: "Password",
                  isDark: isDark,
                  obscureText: _obscurePass,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: textMuted),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      final emailTxt = _emailController.text.trim();
                      if (emailTxt.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter your email to reset password'), backgroundColor: AppColors.coral),
                        );
                        return;
                      }
                      
                      if (!emailTxt.contains('@') || !emailTxt.contains('.')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid email address'), backgroundColor: AppColors.coral),
                        );
                        return;
                      }
                      
                      setState(() => _isLoading = true);
                      try {
                        await context.read<AppProvider>().sendPasswordResetOtp(emailTxt);
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgotPasswordOtpScreen(email: emailTxt),
                          ),
                        );
                      } catch (e) {
                         if (!mounted) return;
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text('Failed to send OTP: $e'), backgroundColor: AppColors.coral),
                         );
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    },
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: isDark ? AppColors.lime : AppColors.violet, fontWeight: FontWeight.w600, fontSize: 13.sp),
                    ),
                  ),
                ),

                SizedBox(height: 48.h),
                
                if (_isLoading)
                  Center(child: CircularProgressIndicator(color: AppColors.lime))
                else
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                      foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text("Sign In", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
                  ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isDark,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final fillColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03);
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 14.sp),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: isDark ? AppColors.lime : AppColors.void_, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColors.coral)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColors.coral, width: 2)),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}
