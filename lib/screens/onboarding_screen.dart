import 'package:flutter/material.dart';
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

  // User data
  String _name = '';
  String _gender = 'male';
  double _age = 25;
  double _height = 170;
  double _weight = 70;
  String _goal = 'maintain'; // lose / maintain / gain

  bool _nameError = false;

  void _next() {
    // Sayfa 0: isim zorunlu
    if (_page == 0 && _name.trim().isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    setState(() => _nameError = false);
    if (_page < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _finish() {
    final provider = context.read<AppProvider>();
    provider.saveProfile(
      name: _name.trim().isEmpty ? AppLocalizations.of(context).userFallback : _name.trim(),
      age: _age.round(),
      height: _height,
      weight: _weight,
      gender: _gender,
      goal: _goal,
    );
    provider.loadHistory();
    provider.loadTodayStats();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: i <= _page
                            ? (isDark ? AppColors.lime : AppColors.void_)
                            : (isDark ? AppColors.darkCard : AppColors.lightBorder),
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
                      child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: textMuted),
                    )
                  else
                    const SizedBox(width: 18),
                  Text('${_page + 1} / 4', style: TextStyle(fontSize: 12, color: textMuted)),
                  GestureDetector(
                    onTap: _finish,
                    child: Text(AppLocalizations.of(context).skip, style: TextStyle(fontSize: 12, color: textMuted)),
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
                    onChanged: (v) => setState(() { _name = v; _nameError = false; }),
                  ),
                  _PageBody(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    gender: _gender,
                    age: _age,
                    height: _height,
                    weight: _weight,
                    onGender: (v) => setState(() => _gender = v),
                    onAge: (v) => setState(() => _age = v),
                    onHeight: (v) => setState(() => _height = v),
                    onWeight: (v) => setState(() => _weight = v),
                  ),
                  _PageGoal(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    goal: _goal,
                    onGoal: (v) => setState(() => _goal = v),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _page < 3 ? AppLocalizations.of(context).continueBtn : AppLocalizations.of(context).letsGo,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
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
          Text(l.onboardingHello, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingNameSub, style: TextStyle(fontSize: 15, color: textMuted)),
          const SizedBox(height: 40),
          TextField(
            autofocus: true,
            onChanged: onChanged,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textPrimary),
            decoration: InputDecoration(
              hintText: l.onboardingNameHint,
              hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: textMuted),
              border: InputBorder.none,
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hasError ? AppColors.coral : (isDark ? AppColors.darkCard : AppColors.lightBorder), width: 2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: hasError ? AppColors.coral : (isDark ? AppColors.lime : AppColors.void_), width: 2)),
              errorText: hasError ? l.onboardingNameRequired : null,
            ),
            cursorColor: isDark ? AppColors.lime : AppColors.void_,
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Boy/Kilo/Yaş ─────────────────────────────────────────────────────
class _PageBody extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String gender;
  final double age, height, weight;
  final ValueChanged<String> onGender;
  final ValueChanged<double> onAge, onHeight, onWeight;

  const _PageBody({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.onGender,
    required this.onAge,
    required this.onHeight,
    required this.onWeight,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingBody, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingBodySub, style: TextStyle(fontSize: 15, color: textMuted)),
          const SizedBox(height: 28),

          // Gender
          Row(
            children: [
              _GenderBtn(label: l.male, icon: '♂', selected: gender == 'male', isDark: isDark, onTap: () => onGender('male')),
              const SizedBox(width: 12),
              _GenderBtn(label: l.female, icon: '♀', selected: gender == 'female', isDark: isDark, onTap: () => onGender('female')),
            ],
          ),
          const SizedBox(height: 20),

          // Yaş
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
          const SizedBox(height: 12),

          // Boy
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

          // Kilo
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

class _BmiBadge extends StatelessWidget {
  final double height, weight;
  final bool isDark;
  const _BmiBadge({required this.height, required this.weight, required this.isDark});

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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l.bmiLabel} ${bmi.toStringAsFixed(1)}', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Text(desc, style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)), textAlign: TextAlign.right),
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
  const _GenderBtn({required this.label, required this.icon, required this.selected, required this.isDark, required this.onTap});

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
            borderRadius: BorderRadius.circular(12),
            border: selected ? null : Border.all(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, width: 0.5),
          ),
          child: Column(
            children: [
              Text(icon, style: TextStyle(fontSize: 20, color: selected ? (isDark ? AppColors.void_ : AppColors.lime) : (isDark ? AppColors.darkText : AppColors.lightText))),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? (isDark ? AppColors.void_ : AppColors.lime) : (isDark ? AppColors.darkText : AppColors.lightText))),
            ],
          ),
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
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: textMuted)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary)),
                    TextSpan(text: ' $unit', style: TextStyle(fontSize: 12, color: textMuted)),
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
              inactiveTrackColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
              thumbColor: accent,
            ),
            child: Slider(value: sliderValue, min: min, max: max, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

// ── Page 3: Hedef ─────────────────────────────────────────────────────────────
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (ctx) {
            final l = AppLocalizations.of(ctx);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.onboardingGoal, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary)),
              const SizedBox(height: 8),
              Text(l.onboardingGoalSub, style: TextStyle(fontSize: 15, color: textMuted)),
              const SizedBox(height: 32),
              _GoalCard(emoji: '📉', title: l.goalLose, subtitle: l.goalLoseSub, selected: goal == 'lose', isDark: isDark, onTap: () => onGoal('lose')),
              const SizedBox(height: 12),
              _GoalCard(emoji: '⚖️', title: l.goalMaintain, subtitle: l.goalMaintainSub, selected: goal == 'maintain', isDark: isDark, onTap: () => onGoal('maintain')),
              const SizedBox(height: 12),
              _GoalCard(emoji: '💪', title: l.goalGain, subtitle: l.goalGainSub, selected: goal == 'gain', isDark: isDark, onTap: () => onGoal('gain')),
            ]);
          }),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _GoalCard({required this.emoji, required this.title, required this.subtitle, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? (isDark ? AppColors.lime : AppColors.void_)
        : (isDark ? AppColors.darkCard : AppColors.lightCard);
    final titleColor = selected ? (isDark ? AppColors.void_ : AppColors.lime) : (isDark ? AppColors.darkText : AppColors.lightText);
    final subColor = selected ? (isDark ? AppColors.void_.withOpacity(0.6) : AppColors.lime.withOpacity(0.7)) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
    final borderColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: selected ? null : Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: titleColor)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: subColor)),
              ],
            ),
            const Spacer(),
            if (selected) Icon(Icons.check_circle_rounded, color: isDark ? AppColors.void_ : AppColors.lime, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Page 4: Tema ─────────────────────────────────────────────────────────────
class _PageTheme extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;

  const _PageTheme({required this.isDark, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingTheme, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingThemeSub, style: TextStyle(fontSize: 15, color: textMuted)),
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

class _ThemeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected, isDark;
  final VoidCallback onTap;
  const _ThemeCard({required this.label, required this.icon, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (isDark ? AppColors.lime : AppColors.void_) : (isDark ? AppColors.darkCard : AppColors.lightCard);
    final fgColor = selected ? (isDark ? AppColors.void_ : AppColors.lime) : (isDark ? AppColors.darkText : AppColors.lightText);
    final borderColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: selected ? null : Border.all(color: borderColor, width: 0.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: fgColor, size: 32),
              const SizedBox(height: 10),
              Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: fgColor)),
            ],
          ),
        ),
      ),
    );
  }
}
