import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';

class ProgramScreen extends StatelessWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                AppLocalizations.of(context).navProgram,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              // Food plate illustration
              Center(
                child: Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text('🥗', style: TextStyle(fontSize: 64.sp)),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Kişiselleştirilmiş Diyet Programınız Sizi Bekliyor!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 16.h),
              // Feature bullets
              _FeatureBullet(
                icon: '✅',
                text: 'Kişiselleştirilmiş Program — Hedef ve tercihlerinize özel',
                textMuted: textMuted,
              ),
              SizedBox(height: 10.h),
              _FeatureBullet(
                icon: '📅',
                text: '7 Günlük Detaylı Plan — Her gün için hesaplanmış öğünler',
                textMuted: textMuted,
              ),
              SizedBox(height: 10.h),
              _FeatureBullet(
                icon: '🎯',
                text: 'Kolay Takip — Günlük öğünlerinizi kolayca takip edin',
                textMuted: textMuted,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to dietary anamnesis flow
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: accentFg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 0,
                  ),
                  child: Text(
                    'Başla',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureBullet extends StatelessWidget {
  final String icon, text;
  final Color textMuted;
  const _FeatureBullet({required this.icon, required this.text, required this.textMuted});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: TextStyle(fontSize: 16.sp)),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              color: textMuted,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
