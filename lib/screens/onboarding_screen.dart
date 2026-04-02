import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../generated/app_localizations.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  final int _totalPages = 8; // Artık 8 sayfa

  // User data
  String _name = '';
  String _gender = 'male';
  double _age = 25;
  double _height = 170;
  double _weight = 70;
  String _activityLevel = 'active'; // sedentary, light, active, very_active
  String _goal = 'maintain'; // lose / maintain / gain

  bool _nameError = false;

  void _next() {
    if (_page == 0 && _name.trim().isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    setState(() => _nameError = false);
    if (_page < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    final provider = context.read<AppProvider>();
    provider.saveProfile(
      name: _name.trim().isEmpty
          ? AppLocalizations.of(context).userFallback
          : _name.trim(),
      age: _age.round(),
      height: _height,
      weight: _weight,
      gender: _gender,
      goal: _goal,
      activityLevel: _activityLevel,
    );
    provider.loadHistory();
    provider.loadTodayStats();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: List.generate(_totalPages, (i) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(
                        right: i < _totalPages - 1 ? 6 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: i <= _page
                            ? (isDark ? AppColors.lime : AppColors.void_)
                            : (isDark
                                  ? AppColors.darkCard
                                  : AppColors.lightBorder),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_page > 0)
                    GestureDetector(
                      onTap: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 18,
                        color: textMuted,
                      ),
                    )
                  else
                    const SizedBox(width: 18),
                  Text(
                    '${_page + 1} / $_totalPages',
                    style: TextStyle(fontSize: 12.sp, color: textMuted),
                  ),
                  GestureDetector(
                    onTap: _finish,
                    child: Text(
                      AppLocalizations.of(context).skip,
                      style: TextStyle(fontSize: 12.sp, color: textMuted),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  _PageName(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    value: _name,
                    hasError: _nameError,
                    onChanged: (v) => setState(() {
                      _name = v;
                      _nameError = false;
                    }),
                  ),
                  _PageGender(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    gender: _gender,
                    onGender: (v) => setState(() => _gender = v),
                  ),
                  _PageAge(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    age: _age,
                    onAge: (v) => setState(() => _age = v),
                  ),
                  _PageHeightWeight(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    height: _height,
                    weight: _weight,
                    onHeight: (v) => setState(() => _height = v),
                    onWeight: (v) => setState(() => _weight = v),
                  ),
                  _PageActivity(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    activity: _activityLevel,
                    onActivity: (v) => setState(() => _activityLevel = v),
                  ),
                  _PageGoal(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    goal: _goal,
                    onGoal: (v) => setState(() => _goal = v),
                  ),
                  _PageSummary(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    weight: _weight,
                    height: _height,
                    age: _age,
                    gender: _gender,
                    activity: _activityLevel,
                    goal: _goal,
                  ),
                  _PageTheme(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                    foregroundColor: isDark ? AppColors.void_ : AppColors.lime,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _page < _totalPages - 1
                        ? AppLocalizations.of(context).continueBtn
                        : AppLocalizations.of(context).letsGo,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page 1: İsim ──────────────────────────────────────────────────────────────
class _PageName extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String value;
  final bool hasError;
  final ValueChanged<String> onChanged;

  const _PageName({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.value,
    required this.hasError,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingHello,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingNameSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          TextField(
            autofocus: true,
            onChanged: onChanged,
            style: AppTypography.titleLarge.copyWith(color: textPrimary),
            decoration: InputDecoration(
              hintText: l.onboardingNameHint,
              hintStyle: AppTypography.titleLarge.copyWith(color: textMuted),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.coral
                      : (isDark ? AppColors.darkCard : AppColors.lightBorder),
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.coral
                      : (isDark ? AppColors.lime : AppColors.void_),
                  width: 2,
                ),
              ),
              errorText: hasError ? l.onboardingNameRequired : null,
            ),
            cursorColor: isDark ? AppColors.lime : AppColors.void_,
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Cinsiyet ─────────────────────────────────────────────────────────
class _PageGender extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String gender;
  final ValueChanged<String> onGender;

  const _PageGender({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.gender,
    required this.onGender,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingGender,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingGenderSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              _GenderBtn(
                label: l.male,
                icon: '♂',
                selected: gender == 'male',
                isDark: isDark,
                onTap: () => onGender('male'),
              ),
              const SizedBox(width: 12),
              _GenderBtn(
                label: l.female,
                icon: '♀',
                selected: gender == 'female',
                isDark: isDark,
                onTap: () => onGender('female'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Page 3: Yaş ───────────────────────────────────────────────────────────────
class _PageAge extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final double age;
  final ValueChanged<double> onAge;

  const _PageAge({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.age,
    required this.onAge,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingAge,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingAgeSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          _SliderRow(
            label: l.age,
            value: '${age.round()}',
            unit: l.ageUnit,
            sliderValue: age,
            min: 15,
            max: 80,
            isDark: isDark,
            accent: accent,
            cardBg: cardBg,
            textPrimary: textPrimary,
            textMuted: textMuted,
            onChanged: onAge,
          ),
        ],
      ),
    );
  }
}

// ── Page 4: Boy Kilo ─────────────────────────────────────────────────────────
class _PageHeightWeight extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final double height, weight;
  final ValueChanged<double> onHeight, onWeight;

  const _PageHeightWeight({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.height,
    required this.weight,
    required this.onHeight,
    required this.onWeight,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingHeightWeight,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingHeightWeightSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          _SliderRow(
            label: l.height,
            value: '${height.round()}',
            unit: l.heightUnit,
            sliderValue: height,
            min: 140,
            max: 220,
            isDark: isDark,
            accent: accent,
            cardBg: cardBg,
            textPrimary: textPrimary,
            textMuted: textMuted,
            onChanged: onHeight,
          ),
          const SizedBox(height: 12),
          _SliderRow(
            label: l.weight,
            value: '${weight.round()}',
            unit: l.weightUnit,
            sliderValue: weight,
            min: 40,
            max: 180,
            isDark: isDark,
            accent: accent,
            cardBg: cardBg,
            textPrimary: textPrimary,
            textMuted: textMuted,
            onChanged: onWeight,
          ),
          const SizedBox(height: 16),
          _BmiBadge(height: height, weight: weight, isDark: isDark),
        ],
      ),
    );
  }
}

// ── Page 5: Aktivite ─────────────────────────────────────────────────────────
class _PageActivity extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String activity;
  final ValueChanged<String> onActivity;

  const _PageActivity({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.activity,
    required this.onActivity,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.activityLevel,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.activityLevelSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 32),
          _GoalCard(
            emoji: '🛋️',
            title: l.activitySedentary,
            subtitle: l.activitySedentarySub,
            selected: activity == 'sedentary',
            isDark: isDark,
            onTap: () => onActivity('sedentary'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            emoji: '🚶',
            title: l.activityLight,
            subtitle: l.activityLightSub,
            selected: activity == 'light',
            isDark: isDark,
            onTap: () => onActivity('light'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            emoji: '🏃',
            title: l.activityActive,
            subtitle: l.activityActiveSub,
            selected: activity == 'active',
            isDark: isDark,
            onTap: () => onActivity('active'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            emoji: '🏋️',
            title: l.activityVery,
            subtitle: l.activityVerySub,
            selected: activity == 'very_active',
            isDark: isDark,
            onTap: () => onActivity('very_active'),
          ),
        ],
      ),
    );
  }
}

// ── Page 6: Hedef (Eskiyle ayni) ─────────────────────────────────────────────
class _PageGoal extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String goal;
  final ValueChanged<String> onGoal;

  const _PageGoal({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.goal,
    required this.onGoal,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingGoal,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingGoalSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 32),
          _GoalCard(
            emoji: '📉',
            title: l.goalLose,
            subtitle: l.goalLoseSub,
            selected: goal == 'lose',
            isDark: isDark,
            onTap: () => onGoal('lose'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            emoji: '⚖️',
            title: l.goalMaintain,
            subtitle: l.goalMaintainSub,
            selected: goal == 'maintain',
            isDark: isDark,
            onTap: () => onGoal('maintain'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            emoji: '💪',
            title: l.goalGain,
            subtitle: l.goalGainSub,
            selected: goal == 'gain',
            isDark: isDark,
            onTap: () => onGoal('gain'),
          ),
        ],
      ),
    );
  }
}

// ── Page 7: Ozet ─────────────────────────────────────────────────────────────
class _PageSummary extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final double weight, height, age;
  final String gender, activity, goal;

  const _PageSummary({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.activity,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    // Calculate TDEE manually here for visual purpose
    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    double multiplier = 1.55;
    if (activity == 'sedentary')
      multiplier = 1.2;
    else if (activity == 'light')
      multiplier = 1.375;
    else if (activity == 'very_active')
      multiplier = 1.725;

    double tdee = bmr * multiplier;
    if (goal == 'lose') tdee -= 400;
    if (goal == 'gain') tdee += 300;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingSummaryTitle,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingSummarySub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Text(
                  l.onboardingRecommend,
                  style: AppTypography.titleMedium.copyWith(color: textMuted),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      tdee.toStringAsFixed(0),
                      style: AppTypography.displayLarge.copyWith(
                        color: isDark ? AppColors.lime : AppColors.limeDeep,
                        fontSize: 48.sp,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'kcal',
                      style: AppTypography.titleMedium.copyWith(
                        color: textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 8: Tema ─────────────────────────────────────────────────────────────
class _PageTheme extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;

  const _PageTheme({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.onboardingTheme,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l.onboardingThemeSub,
            style: AppTypography.titleMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _ThemeCard(
                label: l.themeDark,
                icon: Icons.nightlight_round,
                selected: isDark,
                isDark: isDark,
                onTap: () {
                  if (!isDark) context.read<AppProvider>().toggleTheme();
                },
              ),
              const SizedBox(width: 12),
              _ThemeCard(
                label: l.themeLight,
                icon: Icons.wb_sunny_rounded,
                selected: !isDark,
                isDark: isDark,
                onTap: () {
                  if (isDark) context.read<AppProvider>().toggleTheme();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Yardımcı Widget'lar ───────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _ThemeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isDark ? AppColors.lime : AppColors.void_)
        : (isDark ? AppColors.darkCard : AppColors.lightCard);
    final fgColor = selected
        ? (isDark ? AppColors.void_ : AppColors.lime)
        : (isDark ? AppColors.darkText : AppColors.lightText);
    final borderColor = isDark ? null : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14.r),
            border: selected
                ? null
                : Border.all(
                    color: borderColor ?? Colors.transparent,
                    width: 0.5,
                  ),
          ),
          child: Column(
            children: [
              Icon(icon, color: fgColor, size: 32.sp),
              const SizedBox(height: 10),
              Text(
                label,
                style: AppTypography.titleMedium.copyWith(color: fgColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _GoalCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isDark ? AppColors.lime : AppColors.void_)
        : (isDark ? AppColors.darkCard : AppColors.lightCard);
    final titleColor = selected
        ? (isDark ? AppColors.void_ : AppColors.lime)
        : (isDark ? AppColors.darkText : AppColors.lightText);
    final subColor = selected
        ? (isDark
              ? AppColors.void_.withOpacity(0.6)
              : AppColors.lime.withOpacity(0.7))
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final borderColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: selected ? null : Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 28.sp)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: titleColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(color: subColor),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? AppColors.void_ : AppColors.lime,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label, value, unit;
  final double sliderValue, min, max;
  final bool isDark;
  final Color accent, cardBg, textPrimary, textMuted;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.unit,
    required this.sliderValue,
    required this.min,
    required this.max,
    required this.isDark,
    required this.accent,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(color: textMuted),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: AppTypography.titleLarge.copyWith(
                        color: textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ' $unit',
                      style: AppTypography.bodySmall.copyWith(color: textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: accent,
              inactiveTrackColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.lightBorder,
              thumbColor: accent,
            ),
            child: Slider(
              value: sliderValue,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderBtn extends StatelessWidget {
  final String label, icon;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _GenderBtn({
    required this.label,
    required this.icon,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.lime : AppColors.void_)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(12.r),
            border: selected
                ? null
                : Border.all(
                    color: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightBorder,
                    width: 0.5,
                  ),
          ),
          child: Column(
            children: [
              Text(
                icon,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: selected
                      ? (isDark ? AppColors.void_ : AppColors.lime)
                      : (isDark ? AppColors.darkText : AppColors.lightText),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: selected
                      ? (isDark ? AppColors.void_ : AppColors.lime)
                      : (isDark ? AppColors.darkText : AppColors.lightText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BmiBadge extends StatelessWidget {
  final double height, weight;
  final bool isDark;
  const _BmiBadge({
    required this.height,
    required this.weight,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bmi = weight / ((height / 100) * (height / 100));
    final String label;
    final String desc;
    final Color color;

    if (bmi < 18.5) {
      label = l.bmiUnderweight;
      desc = l.bmiUnderweightDesc;
      color = isDark ? AppColors.violet : AppColors.violetDark;
    } else if (bmi < 25) {
      label = l.bmiNormal;
      desc = l.bmiNormalDesc;
      color = isDark ? AppColors.lime : AppColors.limeDark;
    } else if (bmi < 30) {
      label = l.bmiOverweight;
      desc = l.bmiOverweightDesc;
      color = isDark ? AppColors.amber : AppColors.amberDark;
    } else if (bmi < 35) {
      label = l.bmiObese;
      desc = l.bmiObeseDesc;
      color = isDark ? AppColors.coral : AppColors.coralDark;
    } else {
      label = l.bmiMorbidObese;
      desc = l.bmiMorbidObeseDesc;
      color = isDark ? AppColors.coral : AppColors.coralDark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l.bmiLabel} ${bmi.toStringAsFixed(1)}',
                style: AppTypography.labelSmall.copyWith(color: color),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.titleMedium.copyWith(color: color),
              ),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Text(
              desc,
              style: AppTypography.bodySmall.copyWith(
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
