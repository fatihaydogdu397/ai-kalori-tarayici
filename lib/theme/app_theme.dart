import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  static TextStyle get displayLarge => TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800, height: 1.2);
  static TextStyle get headlineLarge => TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w800, height: 1.2);
  static TextStyle get titleLarge => TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800);
  static TextStyle get titleMedium => TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700);
  static TextStyle get bodyLarge => TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);
  static TextStyle get bodyMedium => TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle get bodySmall => TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500);
  static TextStyle get labelSmall => TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600);
}

class AppColors {
  // Core
  static const lime = Color(0xFFC8F135);
  static const void_ = Color(0xFF0F0F14);
  static const card = Color(0xFF1C1C2A);
  static const snow = Color(0xFFF0EEF8);

  // Macro colors
  static const violet = Color(0xFF7B8FFF); // protein
  static const amber = Color(0xFFFFB347); // carbs
  static const coral = Color(0xFFFF6B6B); // fat
  static const mint = Color(0xFF2DDCB4); // water

  // Dark mode surfaces
  static const darkBg = Color(0xFF0F0F14);
  static const darkCard = Color(0xFF1C1C2A);
  static const darkCardDeep = Color(0xFF08080C);
  static const darkSurface = Color(0xFF2A2A3E);
  static const darkText = Color(0xFFF0EEF8);
  static const darkTextMuted = Color(0xFF3A3A50);
  static const darkTextSecondary = Color(0xFF5A5A70);

  // Macro card backgrounds dark
  static const darkProteinBg = Color(0xFF1E1425);
  static const darkCarbsBg = Color(0xFF1F1A10);
  static const darkFatBg = Color(0xFF1F1116);
  static const darkWaterBg = Color(0xFF0E1A1F);

  // Light mode surfaces
  static const lightBg = Color(0xFFF7F6FF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFE8E6F5);
  static const lightSurface = Color(0xFFEEEDF8);
  static const lightText = Color(0xFF0F0F14);
  static const lightTextMuted = Color(0xffaaaaabc);
  static const lightTextSecondary = Color(0xFF9999AA);

  // Macro card backgrounds light
  static const lightProteinBg = Color(0xFFEEECFC);
  static const lightCarbsBg = Color(0xFFFFF4E6);
  static const lightFatBg = Color(0xFFFFEEEE);
  static const lightWaterBg = Color(0xFFE6FAF5);

  // Lime dark variant (for light mode text on lime)
  static const limeDark = Color(0xFF5A7A0A);
  static const limeDeep = Color(0xFF3A5A0A);

  // Violet dark (light mode)
  static const violetDark = Color(0xFF4A55CC);
  static const amberDark = Color(0xFFC07A10);
  static const coralDark = Color(0xFFCC3A3A);
  static const mintDark = Color(0xFF0A8A6A);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lime,
        secondary: AppColors.violet,
        surface: AppColors.darkCard,
        onPrimary: AppColors.void_,
        onSurface: AppColors.darkText,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.darkText,
        displayColor: AppColors.darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.void_,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.void_,
        secondary: AppColors.violetDark,
        surface: AppColors.lightCard,
        onPrimary: AppColors.lime,
        onSurface: AppColors.lightText,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.lightText,
        displayColor: AppColors.lightText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.lightBorder, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.void_,
          foregroundColor: AppColors.lime,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
