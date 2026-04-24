import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/notification_service.dart';
import '../generated/app_localizations.dart';
import 'paywall_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  static const int _totalPages = 12;

  // User data
  String _name = '';
  String _gender = 'male';
  int _birthDay = 15;
  int _birthMonth = 1;
  int _birthYear = 1994;
  bool _isMetric = true;
  double _heightCm = 170;
  double _weightKg = 70;
  String _goal = 'lose';
  double _targetWeightKg = 65;
  double _weeklyPace = 0.5;
  String _activityLevel = 'active';
  String _dietType = 'standard';

  bool _nameError = false;

  int get _calculatedAge {
    final now = DateTime.now();
    final birth = DateTime(_birthYear, _birthMonth, _birthDay);
    int age = now.year - birth.year;
    if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age.clamp(15, 100);
  }

  void _next() {
    if (_page == 0 && _name.trim().isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    setState(() => _nameError = false);
    if (_page < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_page > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _finish() {
    final provider = context.read<AppProvider>();
    provider.saveProfile(
      name: _name.trim().isEmpty ? AppLocalizations.of(context).userFallback : _name.trim(),
      age: _calculatedAge,
      height: _heightCm,
      weight: _weightKg,
      gender: _gender,
      goal: _goal,
      activityLevel: _activityLevel,
      targetWeight: _targetWeightKg,
      weeklyPace: _weeklyPace,
      dietType: _dietType,
    );
    provider.loadHistory();
    provider.loadTodayStats();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PaywallScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    // Notification page (index 9) has its own buttons
    final bool isNotifPage = _page == 9;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: back arrow + progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  if (_page > 0)
                    GestureDetector(
                      onTap: _prev,
                      child: Icon(Icons.arrow_back_ios_rounded, size: 18, color: textMuted),
                    )
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: (_page + 1) / _totalPages,
                        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                        minHeight: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  // 0: Name
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
                  // 1: Gender
                  _PageGender(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    gender: _gender,
                    onGender: (v) => setState(() => _gender = v),
                  ),
                  // 2: Birth Date
                  _PageBirthDate(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    day: _birthDay,
                    month: _birthMonth,
                    year: _birthYear,
                    onChanged: (d, m, y) => setState(() {
                      _birthDay = d;
                      _birthMonth = m;
                      _birthYear = y;
                    }),
                  ),
                  // 3: Height & Weight drum picker
                  _PageHeightWeightDrum(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    isMetric: _isMetric,
                    heightCm: _heightCm,
                    weightKg: _weightKg,
                    onMetricToggle: (v) => setState(() => _isMetric = v),
                    onHeight: (v) => setState(() => _heightCm = v),
                    onWeight: (v) => setState(() => _weightKg = v),
                  ),
                  // 4: Goal
                  _PageGoal(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    goal: _goal,
                    onGoal: (v) => setState(() {
                      _goal = v;
                      if (v == 'lose') {
                        _targetWeightKg = (_weightKg - 5).clamp(40, _weightKg - 0.1);
                      } else if (v == 'gain') {
                        _targetWeightKg = _weightKg + 5;
                      } else {
                        _targetWeightKg = _weightKg;
                      }
                    }),
                  ),
                  // 5: Target Weight
                  _PageTargetWeight(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    currentWeight: _weightKg,
                    targetWeight: _targetWeightKg,
                    isMetric: _isMetric,
                    goal: _goal,
                    onChanged: (v) => setState(() => _targetWeightKg = v),
                  ),
                  // 6: Weekly Pace
                  _PageWeeklyPace(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    pace: _weeklyPace,
                    goal: _goal,
                    onChanged: (v) => setState(() => _weeklyPace = v),
                  ),
                  // 7: Activity Level
                  _PageActivity(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    activity: _activityLevel,
                    onActivity: (v) => setState(() => _activityLevel = v),
                  ),
                  // 8: Diet Type
                  _PageDietType(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    dietType: _dietType,
                    onDietType: (v) => setState(() => _dietType = v),
                  ),
                  // 9: Notification Permission
                  _PageNotification(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    onEnable: () async {
                      await NotificationService.requestPermission();
                      _next();
                    },
                    onSkip: _next,
                  ),
                  // 10: Summary
                  _PageSummary(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    weight: _weightKg,
                    height: _heightCm,
                    age: _calculatedAge.toDouble(),
                    gender: _gender,
                    activity: _activityLevel,
                    goal: _goal,
                    weeklyPace: _weeklyPace,
                  ),
                  // 11: Theme
                  _PageTheme(isDark: isDark, textPrimary: textPrimary, textMuted: textMuted),
                ],
              ),
            ),
            // Continue button (hidden on notification page)
            if (!isNotifPage)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      _page < _totalPages - 1 ? AppLocalizations.of(context).continueBtn : AppLocalizations.of(context).letsGo,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
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
          Text(l.onboardingHello, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingNameSub, style: AppTypography.titleMedium.copyWith(color: textMuted)),
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
                borderSide: BorderSide(color: hasError ? AppColors.coral : (isDark ? AppColors.darkCard : AppColors.lightBorder), width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: hasError ? AppColors.coral : (isDark ? AppColors.lime : AppColors.void_), width: 2),
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

  const _PageGender({required this.isDark, required this.textPrimary, required this.textMuted, required this.gender, required this.onGender});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingGender, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingGenderSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const SizedBox(height: 48),
          _PillButton(label: l.male, selected: gender == 'male', isDark: isDark, onTap: () => onGender('male')),
          const SizedBox(height: 12),
          _PillButton(label: l.female, selected: gender == 'female', isDark: isDark, onTap: () => onGender('female')),
        ],
      ),
    );
  }
}

// ── Page 3: Doğum Tarihi (Drum Picker) ───────────────────────────────────────
class _PageBirthDate extends StatefulWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final int day, month, year;
  final void Function(int day, int month, int year) onChanged;

  const _PageBirthDate({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.day,
    required this.month,
    required this.year,
    required this.onChanged,
  });

  @override
  State<_PageBirthDate> createState() => _PageBirthDateState();
}

class _PageBirthDateState extends State<_PageBirthDate> {
  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  static const int _itemExtent = 44;
  static final List<int> _years = List.generate(DateTime.now().year - 1920 + 1, (i) => 1920 + i);

  @override
  void initState() {
    super.initState();
    _dayCtrl = FixedExtentScrollController(initialItem: widget.day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: widget.month - 1);
    _yearCtrl = FixedExtentScrollController(initialItem: _years.indexOf(widget.year).clamp(0, _years.length - 1));
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  int get _daysInMonth {
    return DateTime(widget.year, widget.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final monthNames = [
      l.month01,
      l.month02,
      l.month03,
      l.month04,
      l.month05,
      l.month06,
      l.month07,
      l.month08,
      l.month09,
      l.month10,
      l.month11,
      l.month12,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingBirthDate, style: AppTypography.headlineLarge.copyWith(color: widget.textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingBirthDateSub, style: AppTypography.bodyMedium.copyWith(color: widget.textMuted)),
          const SizedBox(height: 40),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Selection highlight
                Center(
                  child: Container(
                    height: _itemExtent.toDouble(),
                    decoration: BoxDecoration(
                      color: widget.isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                Row(
                  children: [
                    // Day
                    Expanded(
                      child: _DrumColumn(
                        controller: _dayCtrl,
                        itemCount: _daysInMonth,
                        itemExtent: _itemExtent,
                        isDark: widget.isDark,
                        textPrimary: widget.textPrimary,
                        textMuted: widget.textMuted,
                        labelBuilder: (i) => '${i + 1}',
                        onSelected: (i) {
                          final day = (i + 1).clamp(1, _daysInMonth);
                          widget.onChanged(day, widget.month, widget.year);
                        },
                      ),
                    ),
                    // Month
                    Expanded(
                      flex: 2,
                      child: _DrumColumn(
                        controller: _monthCtrl,
                        itemCount: 12,
                        itemExtent: _itemExtent,
                        isDark: widget.isDark,
                        textPrimary: widget.textPrimary,
                        textMuted: widget.textMuted,
                        labelBuilder: (i) => monthNames[i],
                        onSelected: (i) {
                          final month = i + 1;
                          final maxDay = DateTime(widget.year, month + 1, 0).day;
                          final day = widget.day.clamp(1, maxDay);
                          widget.onChanged(day, month, widget.year);
                        },
                      ),
                    ),
                    // Year
                    Expanded(
                      flex: 2,
                      child: _DrumColumn(
                        controller: _yearCtrl,
                        itemCount: _years.length,
                        itemExtent: _itemExtent,
                        isDark: widget.isDark,
                        textPrimary: widget.textPrimary,
                        textMuted: widget.textMuted,
                        labelBuilder: (i) => '${_years[i]}',
                        onSelected: (i) {
                          widget.onChanged(widget.day, widget.month, _years[i]);
                        },
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

// ── Drum Column Widget ────────────────────────────────────────────────────────
class _DrumColumn extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int itemCount, itemExtent;
  final bool isDark;
  final Color textPrimary, textMuted;
  final String Function(int) labelBuilder;
  final ValueChanged<int> onSelected;

  const _DrumColumn({
    required this.controller,
    required this.itemCount,
    required this.itemExtent,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent.toDouble(),
      diameterRatio: 1.6,
      squeeze: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (i) {
        HapticFeedback.selectionClick();
        onSelected(i);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, i) {
          final isSelected = controller.hasClients && controller.selectedItem == i;
          return Center(
            child: Text(
              labelBuilder(i),
              style: TextStyle(
                fontSize: isSelected ? 16.sp : 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? textPrimary : textMuted,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Page 4: Boy & Kilo Drum Picker ───────────────────────────────────────────
class _PageHeightWeightDrum extends StatefulWidget {
  final bool isDark, isMetric;
  final Color textPrimary, textMuted;
  final double heightCm, weightKg;
  final ValueChanged<bool> onMetricToggle;
  final ValueChanged<double> onHeight, onWeight;

  const _PageHeightWeightDrum({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.isMetric,
    required this.heightCm,
    required this.weightKg,
    required this.onMetricToggle,
    required this.onHeight,
    required this.onWeight,
  });

  @override
  State<_PageHeightWeightDrum> createState() => _PageHeightWeightDrumState();
}

class _PageHeightWeightDrumState extends State<_PageHeightWeightDrum> {
  late FixedExtentScrollController _heightCtrl;
  late FixedExtentScrollController _weightCtrl;

  static const int _itemExtent = 44;

  // Metric ranges
  static final List<int> _heightsCm = List.generate(81, (i) => 140 + i); // 140-220
  static final List<int> _weightsCm = List.generate(141, (i) => 40 + i); // 40-180

  // Imperial ranges — heights in total inches (4'7" = 55 to 7'3" = 87)
  static final List<int> _heightsIn = List.generate(33, (i) => 55 + i);
  static final List<int> _weightsLb = List.generate(221, (i) => 88 + i); // 88-308 lb

  List<int> get _heights => widget.isMetric ? _heightsCm : _heightsIn;
  List<int> get _weights => widget.isMetric ? _weightsCm : _weightsLb;

  int get _currentHeightIndex {
    if (widget.isMetric) {
      return (_heightsCm.indexOf(widget.heightCm.round())).clamp(0, _heightsCm.length - 1);
    } else {
      final inches = (widget.heightCm / 2.54).round();
      return (_heightsIn.indexOf(inches)).clamp(0, _heightsIn.length - 1);
    }
  }

  int get _currentWeightIndex {
    if (widget.isMetric) {
      return (_weightsCm.indexOf(widget.weightKg.round())).clamp(0, _weightsCm.length - 1);
    } else {
      final lbs = (widget.weightKg * 2.20462).round();
      return (_weightsLb.indexOf(lbs)).clamp(0, _weightsLb.length - 1);
    }
  }

  @override
  void initState() {
    super.initState();
    _heightCtrl = FixedExtentScrollController(initialItem: _currentHeightIndex);
    _weightCtrl = FixedExtentScrollController(initialItem: _currentWeightIndex);
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  String _heightLabel(int val) {
    if (widget.isMetric) return '$val cm';
    final ft = val ~/ 12;
    final inch = val % 12;
    return "$ft'$inch\"";
  }

  String _weightLabel(int val) {
    return widget.isMetric ? '$val kg' : '$val lb';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = widget.isDark ? AppColors.darkCard : AppColors.lightCard;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingHeightWeight, style: AppTypography.headlineLarge.copyWith(color: widget.textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingHeightWeightSub, style: AppTypography.bodyMedium.copyWith(color: widget.textMuted)),
          const SizedBox(height: 24),
          // Metric / Imperial toggle
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12.r)),
            child: Row(
              children: [
                _ToggleTab(
                  label: l.unitImperial,
                  selected: !widget.isMetric,
                  isDark: widget.isDark,
                  onTap: () {
                    widget.onMetricToggle(false);
                    // Jump scroll controllers to matching imperial values
                    Future.microtask(() {
                      _heightCtrl.jumpToItem(_currentHeightIndex);
                      _weightCtrl.jumpToItem(_currentWeightIndex);
                    });
                  },
                ),
                _ToggleTab(
                  label: l.unitMetric,
                  selected: widget.isMetric,
                  isDark: widget.isDark,
                  onTap: () {
                    widget.onMetricToggle(true);
                    Future.microtask(() {
                      _heightCtrl.jumpToItem(_currentHeightIndex);
                      _weightCtrl.jumpToItem(_currentWeightIndex);
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Drum pickers
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Height
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l.height,
                      style: AppTypography.bodyMedium.copyWith(color: widget.textMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: _itemExtent.toDouble(),
                              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10.r)),
                            ),
                          ),
                          _DrumColumn(
                            controller: _heightCtrl,
                            itemCount: _heights.length,
                            itemExtent: _itemExtent,
                            isDark: widget.isDark,
                            textPrimary: widget.textPrimary,
                            textMuted: widget.textMuted,
                            labelBuilder: (i) => _heightLabel(_heights[i]),
                            onSelected: (i) {
                              final val = _heights[i];
                              if (widget.isMetric) {
                                widget.onHeight(val.toDouble());
                              } else {
                                widget.onHeight(val * 2.54);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Weight
              Expanded(
                child: Column(
                  children: [
                    Text(
                      l.weight,
                      style: AppTypography.bodyMedium.copyWith(color: widget.textMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: _itemExtent.toDouble(),
                              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10.r)),
                            ),
                          ),
                          _DrumColumn(
                            controller: _weightCtrl,
                            itemCount: _weights.length,
                            itemExtent: _itemExtent,
                            isDark: widget.isDark,
                            textPrimary: widget.textPrimary,
                            textMuted: widget.textMuted,
                            labelBuilder: (i) => _weightLabel(_weights[i]),
                            onSelected: (i) {
                              final val = _weights[i];
                              if (widget.isMetric) {
                                widget.onWeight(val.toDouble());
                              } else {
                                widget.onWeight(val / 2.20462);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Page 5: Hedef ─────────────────────────────────────────────────────────────
class _PageGoal extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String goal;
  final ValueChanged<String> onGoal;

  const _PageGoal({required this.isDark, required this.textPrimary, required this.textMuted, required this.goal, required this.onGoal});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingGoal, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingGoalSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const SizedBox(height: 48),
          _PillButton(label: '↓  ${l.goalLose}', selected: goal == 'lose', isDark: isDark, onTap: () => onGoal('lose')),
          const SizedBox(height: 12),
          _PillButton(label: '⇔  ${l.goalMaintain}', selected: goal == 'maintain', isDark: isDark, onTap: () => onGoal('maintain')),
          const SizedBox(height: 12),
          _PillButton(label: '↑  ${l.goalGain}', selected: goal == 'gain', isDark: isDark, onTap: () => onGoal('gain')),
        ],
      ),
    );
  }
}

// ── Page 6: Hedef Kilo (Ruler Slider) ─────────────────────────────────────────
class _PageTargetWeight extends StatelessWidget {
  final bool isDark, isMetric;
  final Color textPrimary, textMuted;
  final double currentWeight, targetWeight;
  final String goal;
  final ValueChanged<double> onChanged;

  const _PageTargetWeight({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.currentWeight,
    required this.targetWeight,
    required this.isMetric,
    required this.goal,
    required this.onChanged,
  });

  double get _min => isMetric ? 40.0 : 88.0;
  double get _max => isMetric ? 200.0 : 440.0;

  double get _displayValue => isMetric ? targetWeight : targetWeight * 2.20462;
  String get _unit => isMetric ? 'kg' : 'lb';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingTargetWeight, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingTargetWeightSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const Spacer(),
          // Big value display
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _displayValue.toStringAsFixed(1),
                    style: TextStyle(fontSize: 52.sp, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  TextSpan(
                    text: ' $_unit',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: textMuted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Ruler slider
          _RulerSlider(
            value: _displayValue,
            min: _min,
            max: _max,
            step: 0.1,
            isDark: isDark,
            onChanged: (v) {
              final kg = isMetric ? v : v / 2.20462;
              onChanged(kg);
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ── Ruler Slider Widget ───────────────────────────────────────────────────────
class _RulerSlider extends StatefulWidget {
  final double value, min, max, step;
  final bool isDark;
  final ValueChanged<double> onChanged;

  const _RulerSlider({required this.value, required this.min, required this.max, required this.step, required this.isDark, required this.onChanged});

  @override
  State<_RulerSlider> createState() => _RulerSliderState();
}

class _RulerSliderState extends State<_RulerSlider> {
  double _dragStartX = 0;
  double _dragStartValue = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (d) {
        _dragStartX = d.localPosition.dx;
        _dragStartValue = widget.value;
      },
      onHorizontalDragUpdate: (d) {
        final dx = d.localPosition.dx - _dragStartX;
        // 6 pixels per 0.1 unit
        final delta = -dx * widget.step / 6;
        final raw = _dragStartValue + delta;
        final snapped = (raw / widget.step).round() * widget.step;
        final clamped = snapped.clamp(widget.min, widget.max);
        if ((clamped - widget.value).abs() >= widget.step * 0.5) {
          HapticFeedback.selectionClick();
          widget.onChanged(double.parse(clamped.toStringAsFixed(1)));
        }
      },
      child: SizedBox(
        height: 80,
        child: CustomPaint(
          painter: _RulerPainter(value: widget.value, min: widget.min, max: widget.max, step: widget.step, isDark: widget.isDark),
          size: Size(double.infinity, 80),
        ),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double value, min, max, step;
  final bool isDark;

  _RulerPainter({required this.value, required this.min, required this.max, required this.step, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final tickColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final pointerColor = isDark ? AppColors.lime : AppColors.void_;
    final textColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    final paint = Paint()
      ..color = tickColor
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final pointerPaint = Paint()
      ..color = pointerColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    // Pixels per unit
    final pixPerUnit = 60.0 / (step * 10);

    // Draw ticks: show ~20 units around the current value
    final visibleRange = size.width / pixPerUnit;
    final startVal = value - visibleRange / 2;
    final endVal = value + visibleRange / 2;

    // Round to nearest step
    double v = (startVal / step).floor() * step;
    while (v <= endVal) {
      final x = cx + (v - value) * pixPerUnit;
      if (x >= 0 && x <= size.width) {
        final isMajor = ((v / (step * 10)).round() * step * 10 - v).abs() < step * 0.1;
        final tickHeight = isMajor ? 28.0 : 16.0;
        paint.color = tickColor.withValues(alpha: isMajor ? 0.6 : 0.3);
        canvas.drawLine(Offset(x, size.height / 2 - tickHeight / 2), Offset(x, size.height / 2 + tickHeight / 2), paint);

        // Label at major ticks
        if (isMajor) {
          final label = v.toStringAsFixed(0);
          final tp = TextPainter(
            text: TextSpan(
              text: label,
              style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w500),
            ),
            textDirection: TextDirection.ltr,
          )..layout();
          tp.paint(canvas, Offset(x - tp.width / 2, size.height / 2 + 18));
        }
      }
      v = double.parse((v + step).toStringAsFixed(1));
    }

    // Center pointer
    canvas.drawLine(Offset(cx, size.height / 2 - 26), Offset(cx, size.height / 2 + 26), pointerPaint);
    // Pointer top triangle
    final path = Path()
      ..moveTo(cx - 6, size.height / 2 - 32)
      ..lineTo(cx + 6, size.height / 2 - 32)
      ..lineTo(cx, size.height / 2 - 24)
      ..close();
    canvas.drawPath(path, Paint()..color = pointerColor);
  }

  @override
  bool shouldRepaint(_RulerPainter old) => old.value != value || old.isDark != isDark;
}

// ── Page 7: Haftalık Hız ─────────────────────────────────────────────────────
class _PageWeeklyPace extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final double pace;
  final String goal;
  final ValueChanged<double> onChanged;

  const _PageWeeklyPace({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.pace,
    required this.goal,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final maxPace = goal == 'maintain' ? 0.5 : 1.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingWeeklyPace, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingWeeklyPaceSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const Spacer(),
          // Big value
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: pace.toStringAsFixed(1),
                    style: TextStyle(fontSize: 52.sp, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                  TextSpan(
                    text: ' kg',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: textMuted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Emoji markers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('🐌', style: TextStyle(fontSize: 22.sp)),
                Text('🐰', style: TextStyle(fontSize: 22.sp)),
                Text('🐎', style: TextStyle(fontSize: 22.sp)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: accent,
              inactiveTrackColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
              thumbColor: accent,
            ),
            child: Slider(
              value: pace.clamp(0.1, maxPace),
              min: 0.1,
              max: maxPace,
              divisions: ((maxPace - 0.1) / 0.1).round(),
              onChanged: (v) {
                HapticFeedback.selectionClick();
                onChanged(double.parse(v.toStringAsFixed(1)));
              },
            ),
          ),
          // Min / Max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('0.1 kg', style: AppTypography.labelSmall.copyWith(color: textMuted)),
                Text('${(maxPace / 2).toStringAsFixed(1)} kg', style: AppTypography.labelSmall.copyWith(color: textMuted)),
                Text('$maxPace kg', style: AppTypography.labelSmall.copyWith(color: textMuted)),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ── Page 8: Aktivite ─────────────────────────────────────────────────────────
class _PageActivity extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String activity;
  final ValueChanged<String> onActivity;

  const _PageActivity({required this.isDark, required this.textPrimary, required this.textMuted, required this.activity, required this.onActivity});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.activityLevel, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.activityLevelSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
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

// ── Page 9: Beslenme Türü ────────────────────────────────────────────────────
class _PageDietType extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final String dietType;
  final ValueChanged<String> onDietType;

  const _PageDietType({required this.isDark, required this.textPrimary, required this.textMuted, required this.dietType, required this.onDietType});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final options = [
      ('standard', '🍽️', l.dietStandard),
      ('low_carb', '🥬', l.dietLowCarb),
      ('keto', '🥑', l.dietKeto),
      ('high_protein', '🥩', l.dietHighProtein),
      ('custom', '⚙️', l.dietCustom),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingDietType, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingDietTypeSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const SizedBox(height: 32),
          ...options.map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PillButton(label: '${opt.$2}  ${opt.$3}', selected: dietType == opt.$1, isDark: isDark, onTap: () => onDietType(opt.$1)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 10: Bildirim İzni ───────────────────────────────────────────────────
class _PageNotification extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final VoidCallback onEnable, onSkip;

  const _PageNotification({required this.isDark, required this.textPrimary, required this.textMuted, required this.onEnable, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    final items = [
      (Icons.restaurant_menu_rounded, l.notifMealReminder),
      (Icons.water_drop_rounded, l.notifWaterReminder),
      (Icons.flag_rounded, l.notifGoalReminder),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Big bell icon
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : AppColors.void_, shape: BoxShape.circle),
            child: Icon(Icons.notifications_rounded, size: 36.sp, color: isDark ? AppColors.darkText : AppColors.snow),
          ),
          const SizedBox(height: 20),
          Text(
            l.onboardingNotifTitle,
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            l.onboardingNotifSub,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 40),
          // Notification type list
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    Icon(item.$1, size: 18.sp, color: textMuted),
                    const SizedBox(width: 12),
                    Text(item.$2, style: AppTypography.bodyMedium.copyWith(color: textPrimary)),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          // Enable button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onEnable,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: isDark ? AppColors.void_ : AppColors.snow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                l.enableNotifications,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Skip link
          GestureDetector(
            onTap: onSkip,
            child: Text(
              l.skipForNow,
              style: AppTypography.bodyMedium.copyWith(color: textMuted, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Page 11: Özet ─────────────────────────────────────────────────────────────
class _PageSummary extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final double weight, height, age;
  final String gender, activity, goal;
  final double weeklyPace;

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
    required this.weeklyPace,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    double bmr;
    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    double multiplier = 1.55;
    if (activity == 'sedentary') {
      multiplier = 1.2;
    } else if (activity == 'light') {
      multiplier = 1.375;
    } else if (activity == 'very_active') {
      multiplier = 1.725;
    }

    double tdee = bmr * multiplier;
    if (goal == 'lose') tdee -= 400;
    if (goal == 'gain') tdee += 300;
    tdee = tdee.roundToDouble();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingSummaryTitle, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingSummarySub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20.r)),
            child: Column(
              children: [
                Text(l.onboardingRecommend, style: AppTypography.titleMedium.copyWith(color: textMuted)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      tdee.toStringAsFixed(0),
                      style: AppTypography.displayLarge.copyWith(color: isDark ? AppColors.lime : AppColors.limeDeep, fontSize: 48.sp),
                    ),
                    const SizedBox(width: 8),
                    Text('kcal', style: AppTypography.titleMedium.copyWith(color: textMuted)),
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

// ── Page 12: Tema ─────────────────────────────────────────────────────────────
class _PageTheme extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;

  const _PageTheme({required this.isDark, required this.textPrimary, required this.textMuted});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingTheme, style: AppTypography.headlineLarge.copyWith(color: textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingThemeSub, style: AppTypography.bodyMedium.copyWith(color: textMuted)),
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

// ── Shared Widgets ────────────────────────────────────────────────────────────

/// Full-width pill button (Zinde AI style)
class _PillButton extends StatelessWidget {
  final String label;
  final bool selected, isDark;
  final VoidCallback onTap;

  const _PillButton({required this.label, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (isDark ? AppColors.lime : AppColors.void_) : Colors.transparent;
    final textColor = selected ? (isDark ? AppColors.void_ : AppColors.snow) : (isDark ? AppColors.darkText : AppColors.lightText);
    final borderColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14.r),
          border: selected ? null : Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: textColor),
        ),
      ),
    );
  }
}

/// Metric / Imperial toggle tab
class _ToggleTab extends StatelessWidget {
  final String label;
  final bool selected, isDark;
  final VoidCallback onTap;

  const _ToggleTab({required this.label, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? (isDark ? AppColors.lime : AppColors.void_) : Colors.transparent;
    final textColor = selected ? (isDark ? AppColors.void_ : AppColors.snow) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: textColor),
          ),
        ),
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
    final fgColor = selected ? (isDark ? AppColors.void_ : AppColors.snow) : (isDark ? AppColors.darkText : AppColors.lightText);
    final borderColor = isDark ? null : AppColors.lightBorder;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14.r),
            border: selected ? null : Border.all(color: borderColor ?? Colors.transparent, width: 0.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: fgColor, size: 32.sp),
              const SizedBox(height: 10),
              Text(label, style: AppTypography.titleMedium.copyWith(color: fgColor)),
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
    final bg = selected ? (isDark ? AppColors.lime : AppColors.void_) : (isDark ? AppColors.darkCard : AppColors.lightCard);
    final titleColor = selected ? (isDark ? AppColors.void_ : AppColors.snow) : (isDark ? AppColors.darkText : AppColors.lightText);
    final subColor = selected
        ? (isDark ? AppColors.void_.withValues(alpha: 0.6) : AppColors.snow.withValues(alpha: 0.7))
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
                  Text(title, style: AppTypography.titleMedium.copyWith(color: titleColor)),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(color: subColor)),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: isDark ? AppColors.void_ : AppColors.lime, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
