import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import 'weekly_diet_plan_screen.dart';

class DietPlanLoadingScreen extends StatefulWidget {
  final Map<String, dynamic> anamnesisData;

  const DietPlanLoadingScreen({super.key, required this.anamnesisData});

  @override
  State<DietPlanLoadingScreen> createState() => _DietPlanLoadingScreenState();
}

class _DietPlanLoadingScreenState extends State<DietPlanLoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  int _stepIndex = 0;
  Timer? _stepTimer;

  static const _steps = [
    ('🧬', 'Analyzing your profile...'),
    ('🎯', 'Calculating calorie targets...'),
    ('🥗', 'Building meal combinations...'),
    ('⚖️', 'Balancing macros...'),
    ('📅', 'Finalizing 7-day schedule...'),
    ('✨', 'Adding the finishing touches...'),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startSequence();
  }

  void _startSequence() {
    // Step through loading messages
    const stepDuration = Duration(milliseconds: 700);
    _stepTimer = Timer.periodic(stepDuration, (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _stepIndex = (_stepIndex + 1).clamp(0, _steps.length - 1);
      });
    });

    // Total loading time: ~4.2s (6 steps * 700ms), then navigate
    Future.delayed(const Duration(milliseconds: 4500), () {
      _stepTimer?.cancel();
      if (!mounted) return;
      _navigateToPlan();
    });
  }

  void _navigateToPlan() {
    final provider = context.read<AppProvider>();
    // Generate a mock plan based on profile + anamnesis data
    final plan = _generateMockPlan(provider, widget.anamnesisData);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => WeeklyDietPlanScreen(plan: plan, anamnesisData: widget.anamnesisData),
      ),
    );
  }

  DietPlan _generateMockPlan(AppProvider provider, Map<String, dynamic> data) {
    final dailyGoal = provider.dailyCalorieGoal.round();
    final mealsPerDay = (data['mealsPerDay'] as int?) ?? 4;
    final cuisines = (data['cuisines'] as List?)?.cast<String>() ?? ['no_pref'];

    // Turkish cuisine defaults
    final breakfastPool = cuisines.contains('turkish') || cuisines.contains('no_pref')
        ? ['Menemen + Whole Grain Toast', 'Yogurt Parfait + Granola', 'Omelette + Vegetables', 'Oatmeal + Banana', 'Scrambled Eggs + Avocado']
        : ['Oatmeal + Banana', 'Greek Yogurt + Berries', 'Scrambled Eggs + Toast', 'Smoothie Bowl', 'Avocado Toast'];

    final lunchPool = cuisines.contains('turkish') || cuisines.contains('no_pref')
        ? ['Grilled Chicken + Bulgur Pilaf', 'Lentil Soup + Bread', 'Stuffed Pepper (Biber Dolma)', 'Grilled Fish + Salad', 'Chickpea Stew + Rice']
        : ['Chicken Salad', 'Quinoa Bowl', 'Tuna Wrap', 'Veggie Stir-fry + Rice', 'Lentil Soup'];

    final dinnerPool = cuisines.contains('turkish') || cuisines.contains('no_pref')
        ? ['Baked Salmon + Roasted Vegetables', 'Ground Beef Casserole (Musakka)', 'Grilled Chicken Kebab + Tzatziki', 'Shrimp + Cauliflower Rice', 'Turkey Meatballs + Pasta']
        : ['Baked Salmon + Sweet Potato', 'Chicken Stir-fry', 'Ground Turkey Bowl', 'Shrimp Tacos', 'Beef & Broccoli'];

    final snackPool = [
      'Apple + Almond Butter', 'Greek Yogurt', 'Mixed Nuts (30g)', 'Rice Cake + Hummus',
      'Protein Bar', 'Banana + Peanut Butter', 'Cottage Cheese + Cucumber', 'Hard Boiled Egg',
    ];

    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    final dayPlans = List.generate(7, (i) {
      final meals = <DietMeal>[];

      // Breakfast (~25% of daily)
      meals.add(DietMeal(
        name: breakfastPool[i % breakfastPool.length],
        category: 'Breakfast',
        calories: (dailyGoal * 0.25).round(),
        protein: ((dailyGoal * 0.25) * 0.25 / 4).round(),
        carbs: ((dailyGoal * 0.25) * 0.45 / 4).round(),
        fat: ((dailyGoal * 0.25) * 0.30 / 9).round(),
        time: '08:00',
        emoji: '🌅',
      ));

      // Lunch (~35% of daily)
      meals.add(DietMeal(
        name: lunchPool[i % lunchPool.length],
        category: 'Lunch',
        calories: (dailyGoal * 0.35).round(),
        protein: ((dailyGoal * 0.35) * 0.30 / 4).round(),
        carbs: ((dailyGoal * 0.35) * 0.40 / 4).round(),
        fat: ((dailyGoal * 0.35) * 0.30 / 9).round(),
        time: '12:30',
        emoji: '☀️',
      ));

      // Dinner (~30% of daily)
      meals.add(DietMeal(
        name: dinnerPool[i % dinnerPool.length],
        category: 'Dinner',
        calories: (dailyGoal * 0.30).round(),
        protein: ((dailyGoal * 0.30) * 0.35 / 4).round(),
        carbs: ((dailyGoal * 0.30) * 0.35 / 4).round(),
        fat: ((dailyGoal * 0.30) * 0.30 / 9).round(),
        time: '19:00',
        emoji: '🌙',
      ));

      // Snacks if needed
      if (mealsPerDay >= 4) {
        meals.add(DietMeal(
          name: snackPool[(i * 2) % snackPool.length],
          category: 'Snack',
          calories: (dailyGoal * 0.07).round(),
          protein: ((dailyGoal * 0.07) * 0.20 / 4).round(),
          carbs: ((dailyGoal * 0.07) * 0.50 / 4).round(),
          fat: ((dailyGoal * 0.07) * 0.30 / 9).round(),
          time: '15:30',
          emoji: '🍎',
        ));
      }
      if (mealsPerDay >= 5) {
        meals.add(DietMeal(
          name: snackPool[(i * 2 + 1) % snackPool.length],
          category: 'Snack',
          calories: (dailyGoal * 0.03).round(),
          protein: 5,
          carbs: 8,
          fat: 3,
          time: '21:00',
          emoji: '🥛',
        ));
      }

      return DietDay(
        dayName: days[i],
        meals: meals,
        totalCalories: meals.fold(0, (s, m) => s + m.calories),
      );
    });

    return DietPlan(
      dailyCalorieGoal: dailyGoal,
      days: dayPlans,
      generatedAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _stepTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final progressVal = (_stepIndex + 1) / _steps.length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Pulsing circle with emoji
              ScaleTransition(
                scale: _pulse,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: isDark ? 0.15 : 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: accent.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _steps[_stepIndex].$1,
                        key: ValueKey(_stepIndex),
                        style: TextStyle(fontSize: 48.sp),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              Text(
                'Creating Your Plan',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: textPrimary),
              ),
              SizedBox(height: 12.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _steps[_stepIndex].$2,
                  key: ValueKey(_stepIndex),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: textMuted, height: 1.5),
                ),
              ),

              SizedBox(height: 40.h),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressVal,
                  minHeight: 4,
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                ),
              ),

              SizedBox(height: 16.h),
              Text(
                '${(_stepIndex + 1)} of ${_steps.length} steps',
                style: TextStyle(fontSize: 12.sp, color: textMuted),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
