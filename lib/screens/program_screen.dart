import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import '../services/api/diet_plan_service.dart';
import 'dietary_anamnesis_screen.dart';
import 'weekly_diet_plan_screen.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  final DietPlanService _service = DietPlanService.instance;
  DietPlan? _activePlan;
  DietPlanWeeklyLimit? _quota; // EAT-128
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivePlan();
    _loadQuota();
  }

  Future<void> _loadActivePlan() async {
    try {
      final plan = await _service.getActivePlan();
      if (!mounted) return;
      setState(() {
        _activePlan = plan;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _loadQuota() async {
    try {
      final q = await _service.weeklyLimit();
      if (!mounted) return;
      setState(() => _quota = q);
    } catch (_) {
      // Quota query başarısız olursa badge gizli kalır.
    }
  }

  void _onPrimaryPressed() {
    final plan = _activePlan;
    if (plan != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WeeklyDietPlanScreen(
            plan: plan,
            anamnesisData: const {},
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DietaryAnamnesisScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    final hasPlan = _activePlan != null;
    final title = hasPlan
        ? 'Aktif Diyet Programınız Hazır'
        : 'Kişiselleştirilmiş Diyet Programınız Sizi Bekliyor!';
    final ctaText = hasPlan ? 'Programımı Aç' : 'Başla';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).navProgram,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  if (_quota != null)
                    _QuotaBadge(
                      quota: _quota!,
                      isDark: isDark,
                      accent: accent,
                      textMuted: textMuted,
                    ),
                ],
              ),
              const Spacer(),
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
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 16.h),
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
                  onPressed: _loading ? null : _onPrimaryPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: accentFg,
                    disabledBackgroundColor: accent.withValues(alpha: 0.5),
                    disabledForegroundColor: accentFg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    elevation: 0,
                  ),
                  child: _loading
                      ? SizedBox(
                          height: 18.h,
                          width: 18.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation(accentFg),
                          ),
                        )
                      : Text(
                          ctaText,
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

/// EAT-128: 7 günlük plan üretim kotasını chip olarak gösterir.
/// remaining=0 → kırmızı "limit dolu" uyarısı, aksi halde accent tonu.
class _QuotaBadge extends StatelessWidget {
  final DietPlanWeeklyLimit quota;
  final bool isDark;
  final Color accent;
  final Color textMuted;
  const _QuotaBadge({
    required this.quota,
    required this.isDark,
    required this.accent,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final blocked = quota.isBlocked;
    final color = blocked ? const Color(0xFFFF3B30) : accent;
    final label = blocked
        ? (isTr ? 'Haftalık limit doldu' : 'Weekly limit reached')
        : (isTr
            ? '${quota.remaining}/${quota.limit} bu hafta kaldı'
            : '${quota.remaining}/${quota.limit} left this week');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            blocked ? Icons.lock_clock_rounded : Icons.event_available_rounded,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
