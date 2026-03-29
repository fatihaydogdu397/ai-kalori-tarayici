import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
import 'settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);

    return Scaffold(
      backgroundColor: bg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final name = provider.userName.isEmpty ? l.defaultName : provider.userName;
          final initial = name[0].toUpperCase();
          final goal = provider.dailyCalorieGoal;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                automaticallyImplyLeading: false,
                backgroundColor: bg,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 56.h,
                title: Text(l.profileTitle, style: AppTypography.titleLarge.copyWith(color: textPrimary)),
                actions: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(Icons.settings_rounded, color: textMuted, size: 22),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14.r), border: border),
                          child: Row(
                            children: [
                              Container(
                                width: 52.w,
                                height: 52.w,
                                decoration: const BoxDecoration(color: AppColors.violet, shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    initial,
                                    style: AppTypography.titleLarge.copyWith(color: AppColors.void_),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: AppTypography.bodyLarge.copyWith(color: textPrimary, fontWeight: FontWeight.w700)),
                                    Text(
                                      '${goal.toStringAsFixed(0)} kcal ${l.calorieGoal.toLowerCase()}',
                                      style: AppTypography.bodySmall.copyWith(color: textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              if (!provider.isPremium)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(color: isDark ? AppColors.lime : AppColors.void_, borderRadius: BorderRadius.circular(8)),
                                  child: Text('Pro', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: isDark ? AppColors.void_ : AppColors.lime)),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Premium banner
                        if (!provider.isPremium) ...[
                          GestureDetector(
                            onTap: () => _showPaywall(context, l, isDark),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDark
                                      ? [const Color(0xFF1A2A0A), const Color(0xFF0F1A08)]
                                      : [const Color(0xFFD4F06A), const Color(0xFFC8F135)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Text('⚡', style: TextStyle(fontSize: 24)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l.premium, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? AppColors.lime : AppColors.void_)),
                                        Text(l.premiumSub, style: TextStyle(fontSize: 11, color: isDark ? AppColors.lime.withOpacity(0.7) : AppColors.void_.withOpacity(0.6))),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? AppColors.lime : AppColors.void_),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // 3. Vücut Analizi
                        if (provider.weight > 0)
                          _BodyStatsCard(provider: provider, isDark: isDark, cardBg: cardBg, border: border, textPrimary: textPrimary, textMuted: textMuted),
                        SizedBox(height: 16.h),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCalorieEditor(BuildContext context, AppProvider provider, bool isDark, double current) {
    double value = current.clamp(1200, 4000);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Text(
                l.dailyCalorieGoal,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              const SizedBox(height: 20),
              Text(
                '${value.round()} kcal',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: accent, height: 1),
              ),
              const SizedBox(height: 4),
              Text(l.calorieRange, style: TextStyle(fontSize: 12, color: textMuted)),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  overlayShape: SliderComponentShape.noOverlay,
                  activeTrackColor: accent,
                  inactiveTrackColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  thumbColor: accent,
                ),
                child: Slider(value: value, min: 1200, max: 4000, divisions: 280, onChanged: (v) => setModalState(() => value = v)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.setCalorieGoalAndSave(value.roundToDouble());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: accentFg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l.save, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaywall(BuildContext context, AppLocalizations l, bool isDark) {
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Text('⚡', style: TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 16),
            Text(
              l.limitReached,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isDark ? AppColors.darkText : AppColors.lightText),
            ),
            const SizedBox(height: 8),
            Text(
              l.limitReachedSub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            ...[l.unlimitedScans, l.unlimitedHistory, l.weeklyReport, l.turkishDB].map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: accent, size: 18),
                    const SizedBox(width: 10),
                    Text(f, style: TextStyle(fontSize: 14, color: isDark ? AppColors.darkText : AppColors.lightText)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); /* TODO: RevenueCat */
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: accentFg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(l.goProBtn, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 10),
            Text(l.yearlyDiscount, style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String label;
  final Color textMuted;
  const _SectionTitle({required this.label, required this.textMuted});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 0.8),
  );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;
  final Color divider, textPrimary, textMuted;
  final bool showDivider;
  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
    required this.divider,
    required this.textPrimary,
    required this.textMuted,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: TextStyle(fontSize: 14, color: textPrimary)),
              ),
              trailing,
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, indent: 44, color: divider),
      ],
    );
  }
}

class _LangPicker extends StatelessWidget {
  final AppProvider provider;
  final bool isDark;
  final Color cardBg;
  final Border? border;

  const _LangPicker({required this.provider, required this.isDark, required this.cardBg, required this.border});

  static const langs = [
    ('tr', '🇹🇷', 'Türkçe'),
    ('en', '🇬🇧', 'English'),
    ('fr', '🇫🇷', 'Français'),
    ('es', '🇪🇸', 'Español'),
    ('de', '🇩🇪', 'Deutsch'),
    ('ar', '🇸🇦', 'العربية'),
    ('pt', '🇧🇷', 'Português'),
    ('it', '🇮🇹', 'Italiano'),
    ('ru', '🇷🇺', 'Русский'),
  ];

  void _openSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final divColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;
    final currentCode = (provider.locale?.languageCode ?? Localizations.localeOf(context).languageCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(color: divColor, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l.selectLanguage,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                ),
              ),
              const SizedBox(height: 8),
              ...langs.asMap().entries.map((e) {
                final lang = e.value;
                final selected = currentCode == lang.$1;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        provider.setLocale(Locale(lang.$1));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        child: Row(
                          children: [
                            Text(lang.$2, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                lang.$3,
                                style: TextStyle(fontSize: 15, color: textPrimary, fontWeight: selected ? FontWeight.w700 : FontWeight.w400),
                              ),
                            ),
                            if (selected)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                                child: Icon(Icons.check_rounded, size: 13, color: accentFg),
                              )
                            else
                              Text(
                                lang.$1.toUpperCase(),
                                style: TextStyle(fontSize: 11, color: textMuted, fontWeight: FontWeight.w600),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (e.key < langs.length - 1) Divider(height: 1, indent: 56, color: divColor),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final currentCode = (provider.locale?.languageCode ?? Localizations.localeOf(context).languageCode);
    final current = langs.firstWhere((l) => l.$1 == currentCode, orElse: () => langs.first);

    return GestureDetector(
      onTap: () => _openSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
        child: Row(
          children: [
            Text(current.$2, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(
              current.$3,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: textMuted),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body Stats Card
// ---------------------------------------------------------------------------

class _BodyStatsCard extends StatelessWidget {
  final AppProvider provider;
  final bool isDark;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;

  const _BodyStatsCard({
    required this.provider,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.border,
  });

  String _bmiLabel(double bmi, AppLocalizations l) {
    if (bmi < 18.5) return l.bmiUnderweight;
    if (bmi < 25)   return l.bmiNormal;
    if (bmi < 30)   return l.bmiOverweight;
    return l.bmiObese;
  }

  String _bmiEmoji(double bmi) {
    if (bmi < 18.5) return '🪶';
    if (bmi < 25)   return '💪';
    if (bmi < 30)   return '⚠️';
    return '🔴';
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return AppColors.violet;
    if (bmi < 25)   return AppColors.lime;
    if (bmi < 30)   return AppColors.amber;
    return AppColors.coral;
  }

  String _goalLabel(String goal, AppLocalizations l) {
    switch (goal) {
      case 'lose': return l.goalLose;
      case 'gain': return l.goalGain;
      default:     return l.goalMaintain;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isImperial = provider.unitSystem == UnitSystem.imperial;
    final bmi = provider.bmi;
    final bmr = provider.bmr;
    final tdee = provider.tdee;
    final bmiColor = isDark ? _bmiColor(bmi) : _bmiColor(bmi).withOpacity(0.85);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentMuted = accent.withOpacity(0.1);
    final divColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    final weightStr = isImperial
        ? '${(provider.weight * 2.20462).toStringAsFixed(1)} lb'
        : '${provider.weight.toStringAsFixed(1)} kg';
    final heightStr = isImperial
        ? () {
            final totalIn = provider.height / 2.54;
            final ft = totalIn ~/ 12;
            final inch = (totalIn % 12).round();
            return "$ft'$inch\"";
          }()
        : '${provider.height.toStringAsFixed(0)} cm';

    // İdeal kilo aralığı (BMI 18.5–24.9)
    String idealStr = '';
    if (provider.height > 0) {
      final h = provider.height / 100;
      final minIdeal = 18.5 * h * h;
      final maxIdeal = 24.9 * h * h;
      if (isImperial) {
        idealStr = '${(minIdeal * 2.20462).toStringAsFixed(0)}–${(maxIdeal * 2.20462).toStringAsFixed(0)} lb';
      } else {
        idealStr = '${minIdeal.toStringAsFixed(0)}–${maxIdeal.toStringAsFixed(0)} kg';
      }
    }

    final genderEmoji = provider.gender == 'male' ? '👨' : '👩';
    final genderLabel = provider.gender == 'male' ? l.male : l.female;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.bodyAnalysis, style: AppTypography.bodyMedium.copyWith(color: textPrimary, fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(color: accentMuted, borderRadius: BorderRadius.circular(8.r)),
                child: Text(_goalLabel(provider.goal, l), style: AppTypography.bodySmall.copyWith(color: accent, fontWeight: FontWeight.w700)),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () => _showEditSheet(context, provider, isDark),
                child: Icon(Icons.edit_rounded, size: 16, color: textMuted),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // BMI kartı
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: bmiColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: bmiColor.withOpacity(0.25), width: 1),
            ),
            child: Row(
              children: [
                Text(_bmiEmoji(bmi), style: TextStyle(fontSize: 32.sp)),
                SizedBox(width: 14.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _bmiLabel(bmi, l),
                      style: AppTypography.bodyLarge.copyWith(color: bmiColor, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      'BMI: ${bmi.toStringAsFixed(1)}',
                      style: AppTypography.bodySmall.copyWith(color: bmiColor.withOpacity(0.75)),
                    ),
                  ],
                ),
                const Spacer(),
                if (idealStr.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(l.idealWeight, style: TextStyle(fontSize: 10, color: textMuted)),
                      Text(idealStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary)),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4 temel stat
          Row(
            children: [
              ('⚖️', l.weight,   weightStr),
              ('📏', l.height,   heightStr),
              ('🎂', l.age,      '${provider.age} ${l.ageUnit}'),
              (genderEmoji, l.gender, genderLabel),
            ].map((s) {
              final (emoji, label, value) = s;
              return Expanded(
                child: Column(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textPrimary)),
                    const SizedBox(height: 2),
                    Text(label, style: TextStyle(fontSize: 10, color: textMuted)),
                  ],
                ),
              );
            }).toList(),
          ),

          if (bmr > 0) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: divColor),
            const SizedBox(height: 12),

            // BMR + TDEE
            Row(
              children: [
                Expanded(child: _MetabolicStat(label: l.basalMetabolicRate, sublabel: 'BMR', value: '${bmr.round()} kcal', isDark: isDark, textPrimary: textPrimary, textMuted: textMuted)),
                Container(width: 1, height: 44, color: divColor),
                Expanded(child: _MetabolicStat(label: l.dailyNeeds, sublabel: 'TDEE', value: '${tdee.round()} kcal', isDark: isDark, textPrimary: textPrimary, textMuted: textMuted)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

void _showEditSheet(BuildContext context, AppProvider provider, bool isDark) {
  double weight = provider.weight > 0 ? provider.weight : 70;
  double height = provider.height > 0 ? provider.height : 170;
  int age = provider.age > 0 ? provider.age : 25;
  String gender = provider.gender.isNotEmpty ? provider.gender : 'male';
  String goal = provider.goal.isNotEmpty ? provider.goal : 'maintain';

  final accent = isDark ? AppColors.lime : AppColors.void_;
  final accentFg = isDark ? AppColors.void_ : AppColors.lime;
  final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
  final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
  final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: cardBg,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => StatefulBuilder(
      builder: (ctx, setState) {
        final l = AppLocalizations.of(ctx);
        // BMI önizleme
        final h = height / 100;
        final bmi = weight / (h * h);
        Color bmiColor;
        String bmiLabel;
        if (bmi < 18.5) { bmiColor = AppColors.violet; bmiLabel = l.bmiUnderweight; }
        else if (bmi < 25) { bmiColor = AppColors.lime; bmiLabel = l.bmiNormal; }
        else if (bmi < 30) { bmiColor = AppColors.amber; bmiLabel = l.bmiOverweight; }
        else { bmiColor = AppColors.coral; bmiLabel = l.bmiObese; }

        // Minimum kalori (bazal metabolizma)
        double bmr;
        if (gender == 'male') {
          bmr = 10 * weight + 6.25 * height - 5 * age + 5;
        } else {
          bmr = 10 * weight + 6.25 * height - 5 * age - 161;
        }
        final tdee = bmr * 1.375;
        double targetKcal = tdee;
        if (goal == 'lose') targetKcal -= 400;
        if (goal == 'gain') targetKcal += 300;

        return Padding(
          padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 36, height: 4,
                    decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(l.bodyInfo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary)),
                    const Spacer(),
                    // BMI önizleme
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: bmiColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: bmiColor.withOpacity(0.3)),
                      ),
                      child: Text('BMI ${bmi.toStringAsFixed(1)} · $bmiLabel',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: bmiColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Kilo
                _SheetLabel(label: l.weight, value: '${weight.toStringAsFixed(1)} kg', textPrimary: textPrimary, textMuted: textMuted),
                SliderTheme(
                  data: _sliderTheme(context, accent, surfaceColor),
                  child: Slider(value: weight, min: 30, max: 200, divisions: 340,
                    onChanged: (v) => setState(() => weight = v)),
                ),

                // Boy
                _SheetLabel(label: l.height, value: '${height.toStringAsFixed(0)} cm', textPrimary: textPrimary, textMuted: textMuted),
                SliderTheme(
                  data: _sliderTheme(context, accent, surfaceColor),
                  child: Slider(value: height, min: 100, max: 220, divisions: 120,
                    onChanged: (v) => setState(() => height = v)),
                ),

                // Yaş
                _SheetLabel(label: l.age, value: '$age ${l.ageUnit}', textPrimary: textPrimary, textMuted: textMuted),
                SliderTheme(
                  data: _sliderTheme(context, accent, surfaceColor),
                  child: Slider(value: age.toDouble(), min: 10, max: 100, divisions: 90,
                    onChanged: (v) => setState(() => age = v.round())),
                ),

                const SizedBox(height: 4),

                // Cinsiyet
                Text(l.gender, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ToggleChip(label: '👨 ${l.male}', selected: gender == 'male', accent: accent, textPrimary: textPrimary, textMuted: textMuted, onTap: () => setState(() => gender = 'male')),
                    const SizedBox(width: 10),
                    _ToggleChip(label: '👩 ${l.female}', selected: gender == 'female', accent: accent, textPrimary: textPrimary, textMuted: textMuted, onTap: () => setState(() => gender = 'female')),
                  ],
                ),
                const SizedBox(height: 16),

                // Hedef
                Text(l.goalLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textMuted)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _ToggleChip(label: '📉 ${l.goalLose}', selected: goal == 'lose', accent: accent, textPrimary: textPrimary, textMuted: textMuted, onTap: () => setState(() => goal = 'lose')),
                    const SizedBox(width: 8),
                    _ToggleChip(label: '⚖️ ${l.goalMaintain}', selected: goal == 'maintain', accent: accent, textPrimary: textPrimary, textMuted: textMuted, onTap: () => setState(() => goal = 'maintain')),
                    const SizedBox(width: 8),
                    _ToggleChip(label: '📈 ${l.goalGain}', selected: goal == 'gain', accent: accent, textPrimary: textPrimary, textMuted: textMuted, onTap: () => setState(() => goal = 'gain')),
                  ],
                ),
                const SizedBox(height: 20),

                // Hesaplanan değerler
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: accent.withOpacity(0.07), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _CalcStat(label: l.basalMetabolicRate, value: '${bmr.round()} kcal', textPrimary: textPrimary, textMuted: textMuted),
                      Container(width: 1, height: 36, color: surfaceColor),
                      _CalcStat(label: l.dailyNeeds, value: '${targetKcal.round()} kcal', textPrimary: textPrimary, textMuted: textMuted),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await provider.saveProfile(
                        name: provider.userName.isNotEmpty ? provider.userName : 'Kullanıcı',
                        age: age,
                        height: height,
                        weight: weight,
                        gender: gender,
                        goal: goal,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: accentFg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(l.save, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

SliderThemeData _sliderTheme(BuildContext context, Color accent, Color surface) =>
    SliderTheme.of(context).copyWith(
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: SliderComponentShape.noOverlay,
      activeTrackColor: accent,
      inactiveTrackColor: surface,
      thumbColor: accent,
    );

class _SheetLabel extends StatelessWidget {
  final String label, value;
  final Color textPrimary, textMuted;
  const _SheetLabel({required this.label, required this.value, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textMuted)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textPrimary)),
    ],
  );
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent, textPrimary, textMuted;
  final VoidCallback onTap;
  const _ToggleChip({required this.label, required this.selected, required this.accent, required this.textPrimary, required this.textMuted, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? accent.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: selected ? accent.withOpacity(0.5) : textMuted.withOpacity(0.2), width: 1.5),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? accent : textMuted)),
    ),
  );
}

class _CalcStat extends StatelessWidget {
  final String label, value;
  final Color textPrimary, textMuted;
  const _CalcStat({required this.label, required this.value, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textPrimary)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(fontSize: 10, color: textMuted)),
    ],
  );
}

class _MetabolicStat extends StatelessWidget {
  final String label, sublabel, value;
  final bool isDark;
  final Color textPrimary, textMuted;

  const _MetabolicStat({
    required this.label,
    required this.sublabel,
    required this.value,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: textMuted)),
        Text(sublabel, style: TextStyle(fontSize: 9, color: textMuted.withOpacity(0.6), fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Unit Picker
// ---------------------------------------------------------------------------

class _UnitPicker extends StatelessWidget {
  final AppProvider provider;
  final bool isDark;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;

  const _UnitPicker({
    required this.provider,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      (UnitSystem.metric,   '🌍', AppLocalizations.of(context).unitMetric,   'kg · cm'),
      (UnitSystem.imperial, '🇺🇸', AppLocalizations.of(context).unitImperial, 'lb · inch'),
    ];
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
      child: Row(
        children: options.map((opt) {
          final (system, flag, label, units) = opt;
          final isSelected = provider.unitSystem == system;
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.setUnitSystem(system),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? accent.withOpacity(isDark ? 0.15 : 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? accent.withOpacity(0.5) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? accent : textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      units,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? accent.withOpacity(0.7) : textMuted.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
