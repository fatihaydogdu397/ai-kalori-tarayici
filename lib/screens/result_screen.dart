import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_analysis.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import '../services/app_provider.dart';
import 'manual_entry_screen.dart';

class ResultScreen extends StatefulWidget {
  final FoodAnalysis analysis;
  final bool allowRetry;

  const ResultScreen({super.key, required this.analysis, this.allowRetry = false});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late FoodAnalysis _currentAnalysis;
  late double _originalPortion;
  late double _currentPortion;
  bool _portionChanged = false;

  @override
  void initState() {
    super.initState();
    _currentAnalysis = widget.analysis;
    if (_currentAnalysis.foods.isNotEmpty) {
      _originalPortion = _currentAnalysis.foods.first.portion;
      if (_originalPortion <= 0) _originalPortion = 100;
    } else {
      _originalPortion = 100;
    }
    _currentPortion = _originalPortion;
  }

  void _onPortionChanged(double newPortion) {
    setState(() {
      _currentPortion = newPortion;
      _portionChanged = true;
      final scale = _currentPortion / _originalPortion;
      _currentAnalysis = widget.analysis.copyWithScaled(scale);
    });
  }

  Future<void> _saveChanges() async {
    final provider = context.read<AppProvider>();
    if (_portionChanged) {
      await provider.saveManualEntry(_currentAnalysis);
    }
    await provider.syncNotification(AppLocalizations.of(context));
    if (mounted) Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final divider = isDark ? AppColors.darkSurface : AppColors.lightBorder;
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnText = isDark ? AppColors.void_ : AppColors.lime;
    final aiBg = isDark ? AppColors.lime : AppColors.void_;
    final aiText = isDark ? AppColors.void_ : AppColors.lime;
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);

    final food = _currentAnalysis.foods.isNotEmpty ? _currentAnalysis.foods.first : null;
    final total = _currentAnalysis.totalNutrients;

    final tagConfigs = [
      (AppColors.lime, isDark ? const Color(0xFF1A2010) : const Color(0xFFEEF5E0), isDark ? const Color(0xFF3A5A20) : const Color(0xFFAACE60)),
      (isDark ? AppColors.violet : AppColors.violetDark, isDark ? const Color(0xFF1A1A30) : const Color(0xFFEEECFC), isDark ? const Color(0xFF3A3A60) : const Color(0xFFAAAADE)),
      (isDark ? AppColors.amber : AppColors.amberDark, isDark ? const Color(0xFF1F1510) : const Color(0xFFFFF4E6), isDark ? const Color(0xFF4A3A20) : const Color(0xFFDDAA60)),
      (isDark ? AppColors.coral : AppColors.coralDark, isDark ? const Color(0xFF200E10) : const Color(0xFFFFEEEE), isDark ? const Color(0xFF4A2020) : const Color(0xFFDDAAAA)),
    ];

    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.chevron_left_rounded, color: textMuted, size: 26),
                  ),
                  const SizedBox(width: 8),
                  Text(l.analysisResult, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ManualEntryScreen(existing: _currentAnalysis),
                        ),
                      );
                      if (updated == true && context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? AppColors.darkSurface : AppColors.lightBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded, size: 13, color: textMuted),
                          const SizedBox(width: 4),
                          Text(l.editProfile, style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food image
                    Stack(
                      children: [
                        Hero(
                          tag: 'food_image_${_currentAnalysis.id}',
                          child: Container(
                            width: double.infinity,
                            height: 160,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: File(_currentAnalysis.imagePath).existsSync()
                                ? Image.file(File(_currentAnalysis.imagePath), fit: BoxFit.cover)
                                : Center(child: Icon(Icons.restaurant_rounded, size: 48, color: textMuted)),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: aiBg, borderRadius: BorderRadius.circular(6)),
                            child: Text('AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: aiText)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Main nutrition card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food?.nameTr ?? _currentAnalysis.summary,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '~${_currentPortion.toStringAsFixed(0)}${food?.portionUnit ?? "g"}',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkBg : AppColors.lightBg,
                                  borderRadius: BorderRadius.circular(10),
                                  border: border,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      total.calories.toStringAsFixed(0),
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: calColor, height: 1),
                                    ),
                                    Text('kcal', style: TextStyle(fontSize: 10, color: textMuted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // PORTION SLIDER
                          if (food != null) ...[
                            Row(
                              children: [
                                Text('${_currentPortion.toStringAsFixed(0)}${food.portionUnit}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: btnBg)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 4,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                      overlayShape: SliderComponentShape.noOverlay,
                                      activeTrackColor: btnBg,
                                      inactiveTrackColor: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                                      thumbColor: btnBg,
                                    ),
                                    child: Slider(
                                      value: _currentPortion,
                                      min: 10,
                                      max: _originalPortion > 500 ? _originalPortion * 2 : 1000,
                                      divisions: 100,
                                      onChanged: _onPortionChanged,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          Divider(color: divider, height: 1),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _MacroCell(value: '${total.protein.toStringAsFixed(0)}g', label: l.protein, color: isDark ? AppColors.violet : AppColors.violetDark),
                              VerticalDivider(color: divider, width: 1),
                              _MacroCell(value: '${total.carbs.toStringAsFixed(0)}g', label: l.carbs, color: isDark ? AppColors.amber : AppColors.amberDark),
                              VerticalDivider(color: divider, width: 1),
                              _MacroCell(value: '${total.fat.toStringAsFixed(0)}g', label: l.fat, color: isDark ? AppColors.coral : AppColors.coralDark),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Detected ingredients
                    if (food != null && food.tags.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.detectedIngredients, style: TextStyle(fontSize: 11, color: textMuted)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: food.tags.asMap().entries.map((e) {
                                final cfg = tagConfigs[e.key % tagConfigs.length];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: cfg.$2,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: cfg.$3, width: 0.5),
                                  ),
                                  child: Text(e.value, style: TextStyle(fontSize: 11, color: cfg.$1)),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Advice
                    if (_currentAnalysis.advice.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                        child: Text(_currentAnalysis.advice, style: TextStyle(fontSize: 12, color: textMuted, height: 1.5)),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.mealAutoSaved,
                    style: TextStyle(fontSize: 11, color: textMuted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBg,
                        foregroundColor: btnText,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_portionChanged ? Icons.save_rounded : Icons.check_circle_outline_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(_portionChanged ? l.save : l.backToHome, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: btnText)),
                        ],
                      ),
                    ),
                  ),
                  if (widget.allowRetry) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_rounded, size: 16, color: textMuted),
                            const SizedBox(width: 6),
                            Text('Tekrar Analiz Et', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroCell extends StatelessWidget {
  final String value, label;
  final Color color;
  const _MacroCell({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textMuted = Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: textMuted)),
        ],
      ),
    );
  }
}
