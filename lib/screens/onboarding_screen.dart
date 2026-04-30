import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/api/nutrition_service.dart';
import '../services/notification_service.dart';
import '../generated/app_localizations.dart';
import 'paywall_screen.dart';
import 'blood_test_upload_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  static const int _totalPages = 12;
  int _bloodTestsUploaded = 0;

  // User data
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
  final Set<String> _dietTypes = <String>{};

  // Allergies & restrictions (BE keys; writeTokens expanded at finish).
  final Set<String> _restrictionKeys = {};
  final Set<String> _allergenKeys = {};
  List<DietaryPreferenceOption> _dietaryOptions = const [];

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
    if (_page == 7 && _dietTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).onboardingDietTypeRequired),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
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
    final restrictionTokens = _dietaryOptions
        .where((o) => o.category == 'RESTRICTION' && _restrictionKeys.contains(o.key))
        .expand((o) => o.writeTokens)
        .toList(growable: false);
    final allergenTokens = _dietaryOptions
        .where((o) => o.category == 'ALLERGEN' && _allergenKeys.contains(o.key))
        .expand((o) => o.writeTokens)
        .toList(growable: false);
    final authName = provider.userName.trim();
    provider.saveProfile(
      name: authName.isEmpty ? AppLocalizations.of(context).userFallback : authName,
      age: _calculatedAge,
      height: _heightCm,
      weight: _weightKg,
      gender: _gender,
      goal: _goal,
      activityLevel: _activityLevel,
      targetWeight: _targetWeightKg,
      weeklyPace: _weeklyPace,
      dietTypes: _dietTypes.toList(growable: false),
      allergens: allergenTokens,
      dietRestrictions: restrictionTokens,
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

    // Notification page (now index 9 after removing Name + Summary).
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
                  // 0: Gender
                  _PageGender(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    gender: _gender,
                    onGender: (v) => setState(() => _gender = v),
                  ),
                  // 1: Birth Date
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
                  // 2: Height & Weight drum picker
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
                  // 3: Goal
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
                  // 4: Target Weight
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
                  // 5: Weekly Pace
                  _PageWeeklyPace(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    pace: _weeklyPace,
                    goal: _goal,
                    onChanged: (v) => setState(() => _weeklyPace = v),
                  ),
                  // 6: Activity Level
                  _PageActivity(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    activity: _activityLevel,
                    onActivity: (v) => setState(() => _activityLevel = v),
                  ),
                  // 7: Diet Type
                  _PageDietType(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    selected: _dietTypes,
                    onToggle: (v) => setState(() {
                      if (_dietTypes.contains(v)) {
                        _dietTypes.remove(v);
                      } else if (_dietTypes.length < 5) {
                        _dietTypes.add(v);
                      }
                    }),
                  ),
                  // 8: Allergies & Restrictions
                  _PageAllergiesRestrictions(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    restrictionKeys: _restrictionKeys,
                    allergenKeys: _allergenKeys,
                    onOptionsLoaded: (opts) => setState(() => _dietaryOptions = opts),
                    onToggle: () => setState(() {}),
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
                  // 10: Optional blood-test upload
                  _PageBloodTestOptional(
                    isDark: isDark,
                    textPrimary: textPrimary,
                    textMuted: textMuted,
                    uploadedCount: _bloodTestsUploaded,
                    onUpload: () async {
                      final res = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(builder: (_) => const BloodTestUploadScreen()),
                      );
                      if (res == true && mounted) {
                        setState(() => _bloodTestsUploaded++);
                      }
                    },
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

// ── Page 0: Cinsiyet ─────────────────────────────────────────────────────────
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
// EAT-117: Seçenekler BE `dietaryPreferenceOptions` query'sinden çekilir.
// Network hatası / offline durumda hardcoded fallback kullanılır.
class _PageDietType extends StatefulWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _PageDietType({required this.isDark, required this.textPrimary, required this.textMuted, required this.selected, required this.onToggle});

  @override
  State<_PageDietType> createState() => _PageDietTypeState();
}

class _PageDietTypeState extends State<_PageDietType> {
  // BE yanıtından DIET_TYPE kategorisindeki key'ler (writeTokens[0] kullanılır).
  List<({String key, String defaultLabel})>? _remoteOptions;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final all = await NutritionService.instance.dietaryPreferenceOptions();
      if (!mounted) return;
      final dietTypes = all
          .where((o) => o.category == 'DIET_TYPE')
          .map((o) => (
                key: (o.writeTokens.isNotEmpty ? o.writeTokens.first : o.key),
                defaultLabel: o.defaultLabel,
              ))
          .toList(growable: false);
      setState(() => _remoteOptions = dietTypes);
    } catch (_) {
      // Sessiz düş — hardcoded fallback kullanılacak.
    }
  }

  // Key → emoji map. BE yeni key ekleyince burada emoji tanımlanır; tanımsız
  // key için nötr fallback döner.
  String _emojiFor(String key) {
    switch (key) {
      case 'standard':
      case 'balanced':
        return '🍽️';
      case 'low_carb':
        return '🥬';
      case 'keto':
        return '🥑';
      case 'high_protein':
        return '🥩';
      case 'vegan':
        return '🌱';
      case 'vegetarian':
        return '🥦';
      case 'pescatarian':
        return '🐟';
      case 'mediterranean':
        return '🫒';
      case 'custom':
        return '⚙️';
      default:
        return '🍴';
    }
  }

  // Key → localized label. Mobil i18n tanımı varsa onu, yoksa BE'nin
  // defaultLabel'ını kullan.
  String _labelFor(String key, String defaultLabel, AppLocalizations l) {
    switch (key) {
      case 'standard':
      case 'balanced':
        return l.dietStandard;
      case 'low_carb':
        return l.dietLowCarb;
      case 'keto':
        return l.dietKeto;
      case 'high_protein':
        return l.dietHighProtein;
      case 'custom':
        return l.dietCustom;
      default:
        return defaultLabel.isEmpty ? key : defaultLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    // BE yanıtı geldiyse onu, gelmediyse (loading / error) statik fallback'i kullan.
    final options = _remoteOptions ?? const [
      (key: 'balanced', defaultLabel: 'Balanced'),
      (key: 'mediterranean', defaultLabel: 'Mediterranean'),
      (key: 'high_protein', defaultLabel: 'High-protein'),
      (key: 'low_carb', defaultLabel: 'Low-carb'),
      (key: 'keto', defaultLabel: 'Keto'),
      (key: 'vegetarian', defaultLabel: 'Vegetarian'),
      (key: 'vegan', defaultLabel: 'Vegan'),
      (key: 'pescatarian', defaultLabel: 'Pescatarian'),
      (key: 'custom', defaultLabel: 'Custom'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingDietType, style: AppTypography.headlineLarge.copyWith(color: widget.textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingDietTypeSub, style: AppTypography.bodyMedium.copyWith(color: widget.textMuted)),
          const SizedBox(height: 32),
          ...options.map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _PillButton(
                label: '${_emojiFor(opt.key)}  ${_labelFor(opt.key, opt.defaultLabel, l)}',
                selected: widget.selected.contains(opt.key),
                isDark: widget.isDark,
                onTap: () => widget.onToggle(opt.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page 9b: Allergies & Restrictions ────────────────────────────────────────
// BE `dietaryPreferenceOptions` query'sinden RESTRICTION + ALLERGEN kategorileri
// çekilir; seçimler `writeTokens` olarak genişletilip user.dietRestrictions[] /
// user.allergens[] alanlarına yazılır.
class _PageAllergiesRestrictions extends StatefulWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final Set<String> restrictionKeys;
  final Set<String> allergenKeys;
  final ValueChanged<List<DietaryPreferenceOption>> onOptionsLoaded;
  final VoidCallback onToggle;

  const _PageAllergiesRestrictions({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.restrictionKeys,
    required this.allergenKeys,
    required this.onOptionsLoaded,
    required this.onToggle,
  });

  @override
  State<_PageAllergiesRestrictions> createState() => _PageAllergiesRestrictionsState();
}

class _PageAllergiesRestrictionsState extends State<_PageAllergiesRestrictions> {
  List<DietaryPreferenceOption> _restrictions = const [];
  List<DietaryPreferenceOption> _allergens = const [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final all = await NutritionService.instance.dietaryPreferenceOptions();
      if (!mounted) return;
      widget.onOptionsLoaded(all);
      setState(() {
        _restrictions = all.where((o) => o.category == 'RESTRICTION').toList(growable: false);
        _allergens = all.where((o) => o.category == 'ALLERGEN').toList(growable: false);
        _loaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loaded = true);
    }
  }

  void _toggle(Set<String> bucket, String key) {
    if (bucket.contains(key)) {
      bucket.remove(key);
    } else {
      bucket.add(key);
    }
    setState(() {});
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.onboardingAllergiesTitle, style: AppTypography.headlineLarge.copyWith(color: widget.textPrimary)),
          const SizedBox(height: 8),
          Text(l.onboardingAllergiesSub, style: AppTypography.bodyMedium.copyWith(color: widget.textMuted)),
          const SizedBox(height: 32),
          if (!_loaded)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(
                  color: widget.isDark ? AppColors.lime : AppColors.void_,
                  strokeWidth: 2,
                ),
              ),
            )
          else ...[
            if (_restrictions.isNotEmpty) ...[
              Text(
                l.onboardingAllergiesReligious,
                style: AppTypography.titleMedium.copyWith(color: widget.textMuted, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _restrictions
                    .map((o) => _Chip(
                          label: o.defaultLabel,
                          selected: widget.restrictionKeys.contains(o.key),
                          isDark: widget.isDark,
                          onTap: () => _toggle(widget.restrictionKeys, o.key),
                        ))
                    .toList(growable: false),
              ),
              const SizedBox(height: 24),
            ],
            if (_allergens.isNotEmpty) ...[
              Text(
                l.onboardingAllergiesAllergens,
                style: AppTypography.titleMedium.copyWith(color: widget.textMuted, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _allergens
                    .map((o) => _Chip(
                          label: o.defaultLabel,
                          selected: widget.allergenKeys.contains(o.key),
                          isDark: widget.isDark,
                          onTap: () => _toggle(widget.allergenKeys, o.key),
                        ))
                    .toList(growable: false),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected, isDark;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final bg = selected ? accent : Colors.transparent;
    final textColor = selected
        ? (isDark ? AppColors.void_ : AppColors.snow)
        : (isDark ? AppColors.darkText : AppColors.lightText);
    final borderColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(100.r),
          border: selected ? null : Border.all(color: borderColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor),
        ),
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

// ── Page 10: Optional Blood-Test Upload ──────────────────────────────────────
// EAT-156: standalone BloodTestUploadScreen (push) ile çağrılır. Inline TR/EN —
// 10-locale l10n migration follow-up'ta yapılacak.
class _PageBloodTestOptional extends StatelessWidget {
  final bool isDark;
  final Color textPrimary, textMuted;
  final int uploadedCount;
  final Future<void> Function() onUpload;

  const _PageBloodTestOptional({
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.uploadedCount,
    required this.onUpload,
  });

  String _t(BuildContext ctx, String tr, String en) =>
      Localizations.localeOf(ctx).languageCode == 'tr' ? tr : en;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(color: isDark ? AppColors.darkCard : AppColors.void_, shape: BoxShape.circle),
            child: Icon(Icons.science_rounded, size: 36.sp, color: isDark ? AppColors.darkText : AppColors.snow),
          ),
          const SizedBox(height: 20),
          Text(
            _t(context, 'Kan tahlilini yükle', 'Upload your blood test'),
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            _t(
              context,
              'Opsiyoneldir. Yüklersen AI diyet önerilerimiz ve planın daha sana özel olur. İstersen şimdi atla, sonra profilden ekleyebilirsin.',
              'Optional. If you upload, the AI personalizes your plan and recommendations. You can skip for now and add later from your profile.',
            ),
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: textMuted),
          ),
          const SizedBox(height: 32),
          if (uploadedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: accent, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 18.sp, color: accent),
                  const SizedBox(width: 8),
                  Text(
                    _t(
                      context,
                      uploadedCount == 1 ? '1 dosya yüklendi' : '$uploadedCount dosya yüklendi',
                      uploadedCount == 1 ? '1 file uploaded' : '$uploadedCount files uploaded',
                    ),
                    style: AppTypography.bodyMedium.copyWith(color: textPrimary, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onUpload,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: Icon(Icons.upload_file_rounded, size: 20.sp),
              label: Text(
                uploadedCount > 0
                    ? _t(context, 'Bir tane daha ekle', 'Upload another')
                    : _t(context, 'Yükle', 'Upload'),
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Page 11: Tema ─────────────────────────────────────────────────────────────
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
