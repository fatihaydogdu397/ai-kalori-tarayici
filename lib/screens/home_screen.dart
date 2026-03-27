import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../models/food_analysis.dart';
import 'result_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _picker = ImagePicker();
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadHistory();
      context.read<AppProvider>().loadTodayStats();
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (picked == null || !mounted) return;

    final provider = context.read<AppProvider>();
    await provider.analyzeImage(picked.path);

    if (!mounted) return;
    if (provider.state == AnalysisState.success && provider.currentAnalysis != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(analysis: provider.currentAnalysis!)),
      ).then((_) => provider.resetState());
    } else if (provider.state == AnalysisState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: ${provider.errorMessage}'),
          backgroundColor: AppColors.coral,
        ),
      );
    }
  }

  void _showSourceSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _SheetButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  isDark: isDark,
                  onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
                ),
                const SizedBox(width: 12),
                _SheetButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  isDark: isDark,
                  onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.state == AnalysisState.loading) {
            return _buildLoading(isDark);
          }
          return _buildDashboard(provider, isDark);
        },
      ),
      bottomNavigationBar: _buildNavBar(isDark),
    );
  }

  Widget _buildLoading(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.lime.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.lime, strokeWidth: 2.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Analyzing...',
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'AI is calculating your nutrients',
            style: TextStyle(
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(AppProvider provider, bool isDark) {
    final now = DateTime.now();
    final days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final calories = provider.todayStats['calories'] ?? 0;
    final goal = provider.dailyCalorieGoal;
    final progress = (calories / goal).clamp(0.0, 1.0);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateStr, style: TextStyle(fontSize: 11, color: textMuted)),
                          const SizedBox(height: 2),
                          Text(
                            'Good morning, Fatih',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(color: AppColors.violet, shape: BoxShape.circle),
                          child: const Center(
                            child: Text('F', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.void_)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Calorie card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 62,
                          height: 62,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: 1,
                                strokeWidth: 5,
                                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                              ),
                              CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 5,
                                color: isDark ? AppColors.lime : AppColors.limeDark,
                                strokeCap: StrokeCap.round,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    calories.toStringAsFixed(0),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textPrimary),
                                  ),
                                  Text('kcal', style: TextStyle(fontSize: 9, color: textMuted)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Calories today', style: TextStyle(fontSize: 11, color: textMuted)),
                              const SizedBox(height: 3),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    calories.toStringAsFixed(0),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.lime : AppColors.limeDeep,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('/ ${goal.toStringAsFixed(0)}', style: TextStyle(fontSize: 11, color: textMuted)),
                                ],
                              ),
                              const SizedBox(height: 7),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 5,
                                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                                  valueColor: AlwaysStoppedAnimation(isDark ? AppColors.lime : AppColors.limeDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Macro pills
                  Row(
                    children: [
                      _MacroPill(
                        value: '${(provider.todayStats['protein'] ?? 0).toStringAsFixed(0)}g',
                        label: 'protein',
                        valueColor: isDark ? AppColors.violet : AppColors.violetDark,
                        bg: isDark ? AppColors.darkProteinBg : AppColors.lightProteinBg,
                      ),
                      const SizedBox(width: 6),
                      _MacroPill(
                        value: '${(provider.todayStats['carbs'] ?? 0).toStringAsFixed(0)}g',
                        label: 'carbs',
                        valueColor: isDark ? AppColors.amber : AppColors.amberDark,
                        bg: isDark ? AppColors.darkCarbsBg : AppColors.lightCarbsBg,
                      ),
                      const SizedBox(width: 6),
                      _MacroPill(
                        value: '${(provider.todayStats['fat'] ?? 0).toStringAsFixed(0)}g',
                        label: 'fat',
                        valueColor: isDark ? AppColors.coral : AppColors.coralDark,
                        bg: isDark ? AppColors.darkFatBg : AppColors.lightFatBg,
                      ),
                      const SizedBox(width: 6),
                      _MacroPill(
                        value: '1.8L',
                        label: 'water',
                        valueColor: isDark ? AppColors.mint : AppColors.mintDark,
                        bg: isDark ? AppColors.darkWaterBg : AppColors.lightWaterBg,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text("Today's meals", style: TextStyle(fontSize: 11, color: textMuted)),
                  const SizedBox(height: 8),

                  if (provider.history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No meals logged yet.\nTap the camera to scan your first meal!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textMuted, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...provider.history.take(5).map((a) => _MealRow(
                          analysis: a,
                          isDark: isDark,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ResultScreen(analysis: a)),
                          ),
                        )),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavBar(bool isDark) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final border = isDark ? AppColors.darkCard : AppColors.lightBorder;
    final iconActive = isDark ? AppColors.darkText : AppColors.lightText;
    final iconInactive = isDark ? AppColors.darkTextMuted : const Color(0xFFCCCCDD);
    final camBg = isDark ? AppColors.lime : AppColors.void_;
    final camIcon = isDark ? AppColors.void_ : AppColors.lime;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() => _tab = 0),
                child: Icon(Icons.home_rounded, color: _tab == 0 ? iconActive : iconInactive, size: 22),
              ),
              GestureDetector(
                onTap: _showSourceSheet,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: camBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.camera_alt_rounded, color: camIcon, size: 20),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _tab = 2),
                child: Icon(Icons.bar_chart_rounded, color: _tab == 2 ? iconActive : iconInactive, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final Color bg;

  const _MacroPill({required this.value, required this.label, required this.valueColor, required this.bg});

  @override
  Widget build(BuildContext context) {
    final textMuted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextMuted
        : AppColors.lightTextSecondary;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: valueColor, height: 1.1)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: textMuted)),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  final FoodAnalysis analysis;
  final bool isDark;
  final VoidCallback onTap;

  const _MealRow({required this.analysis, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);
    final iconBg = isDark ? AppColors.darkCarbsBg : AppColors.lightCarbsBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10), border: border),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text('🍽️', style: TextStyle(fontSize: 15))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.foods.isNotEmpty ? analysis.foods.first.nameTr : 'Meal',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary),
                  ),
                  Text(_timeAgo(analysis.analyzedAt), style: TextStyle(fontSize: 10, color: textMuted)),
                ],
              ),
            ),
            Text(
              analysis.totalCalories.toStringAsFixed(0),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: calColor),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _SheetButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SheetButton({required this.icon, required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              Icon(icon, color: AppColors.lime, size: 30),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
