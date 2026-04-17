import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/app_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  // Live password validation checks
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _passController.addListener(_validatePassword);
    _confirmPassController.addListener(_validatePassword);
    _passFocus.addListener(_onFocusChange);
    _confirmPassFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isPasswordFocused = _passFocus.hasFocus || _confirmPassFocus.hasFocus;
    });
  }

  void _validatePassword() {
    final pass = _passController.text;
    final confirm = _confirmPassController.text;

    setState(() {
      _hasMinLength = pass.length >= 8;
      _hasUppercase = pass.contains(RegExp(r'[A-Z]'));
      _hasLowercase = pass.contains(RegExp(r'[a-z]'));
      _hasNumber = pass.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = pass.contains(RegExp(r'[!@#\$&*~,._\-]'));
      _passwordsMatch = pass.isNotEmpty && pass == confirm;
    });
  }

  @override
  void dispose() {
    _passFocus.removeListener(_onFocusChange);
    _confirmPassFocus.removeListener(_onFocusChange);
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    _passController.removeListener(_validatePassword);
    _confirmPassController.removeListener(_validatePassword);
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    if (!(_hasMinLength && _hasUppercase && _hasLowercase && _hasNumber && _hasSpecialChar && _passwordsMatch)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please meet all password criteria'), backgroundColor: AppColors.coral),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<AppProvider>().resetPassword(
            widget.email,
            widget.code,
            _passController.text,
          );
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully! Log in with your new password.'), backgroundColor: AppColors.lime),
      );
      
      // Navigate back to login screen
      Navigator.of(context).popUntil((route) => route.isFirst);
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.coral),
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
                SizedBox(height: 20.h),
                Text(
                  "Create New Password",
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, color: textPrimary),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Your new password must be unique from those previously used.",
                  style: TextStyle(fontSize: 14.sp, color: textMuted),
                ),
                SizedBox(height: 40.h),

                // Password
                _buildTextField(
                  controller: _passController,
                  focusNode: _passFocus,
                  label: "New Password",
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

                // Confirm Password
                _buildTextField(
                  controller: _confirmPassController,
                  focusNode: _confirmPassFocus,
                  label: "Confirm New Password",
                  isDark: isDark,
                  obscureText: _obscureConfirmPass,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPass ? Icons.visibility_off : Icons.visibility, color: textMuted),
                    onPressed: () => setState(() => _obscureConfirmPass = !_obscureConfirmPass),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    if (v != _passController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                
                // Live Password Checks
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: Alignment.topCenter,
                  child: _isPasswordFocused
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 20.h),
                            _buildPasswordChecks(isDark),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                
                SizedBox(height: 48.h),
                
                if (_isLoading)
                  Center(child: CircularProgressIndicator(color: AppColors.lime))
                else
                  ElevatedButton(
                    onPressed: _handleReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                      foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text("Save Password", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
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
    FocusNode? focusNode,
    String? Function(String?)? validator,
  }) {
    final fillColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03);
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
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

  Widget _buildPasswordChecks(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCheckItem("At least 8 characters", _hasMinLength, isDark),
        _buildCheckItem("At least 1 uppercase letter", _hasUppercase, isDark),
        _buildCheckItem("At least 1 lowercase letter", _hasLowercase, isDark),
        _buildCheckItem("At least 1 number", _hasNumber, isDark),
        _buildCheckItem("At least 1 special character", _hasSpecialChar, isDark),
        _buildCheckItem("Passwords match", _passwordsMatch, isDark),
      ],
    );
  }

  Widget _buildCheckItem(String label, bool isValid, bool isDark) {
    Color color;
    if (isValid) {
      color = isDark ? AppColors.lime : const Color(0xFF10B981);
    } else {
      if (_passController.text.isEmpty && _confirmPassController.text.isEmpty) {
        color = isDark ? Colors.white38 : Colors.black38;
      } else {
        color = AppColors.coral;
      }
    }

    final icon = isValid ? Icons.check_circle_rounded : (_passController.text.isEmpty ? Icons.radio_button_unchecked_rounded : Icons.cancel_rounded);

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13.sp,
              fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
