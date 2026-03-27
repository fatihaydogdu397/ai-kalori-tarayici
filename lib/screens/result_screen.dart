import 'dart:io';
import 'package:flutter/material.dart';
import '../models/food_analysis.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final FoodAnalysis analysis;

  const ResultScreen({super.key, required this.analysis});

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

    final food = analysis.foods.isNotEmpty ? analysis.foods.first : null;
    final total = analysis.totalNutrients;

    // Ingredient tag colors
    final tagConfigs = [
      (AppColors.lime, isDark ? const Color(0xFF1A2010) : const Color(0xFFEEF5E0), isDark ? const Color(0xFF3A5A20) : const Color(0xFFAACE60)),
      (isDark ? AppColors.violet : AppColors.violetDark, isDark ? const Color(0xFF1A1A30) : const Color(0xFFEEECFC), isDark ? const Color(0xFF3A3A60) : const Color(0xFFAAAADE)),
      (isDark ? AppColors.amber : AppColors.amberDark, isDark ? const Color(0xFF1F1510) : const Color(0xFFFFF4E6), isDark ? const Color(0xFF4A3A20) : const Color(0xFFDDAA60)),
      (isDark ? AppColors.coral : AppColors.coralDark, isDark ? const Color(0xFF200E10) : const Color(0xFFFFEEEE), isDark ? const Color(0xFF4A2020) : const Color(0xFFDDAAAA)),
    ];

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
                  Text(
                    'Scan result',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: textPrimary),
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
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: File(analysis.imagePath).existsSync()
                              ? Image.file(File(analysis.imagePath), fit: BoxFit.cover)
                              : Center(
                                  child: Icon(Icons.restaurant_rounded, size: 48, color: textMuted),
                                ),
                        ),
                        // AI badge
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: aiBg, borderRadius: BorderRadius.circular(6)),
                            child: Text('AI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: aiText)),
                          ),
                        ),
                        // Confidence
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black54 : Colors.white70,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '94% confidence',
                              style: TextStyle(fontSize: 11, color: textMuted),
                            ),
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
                                      food?.nameTr ?? analysis.summary,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: textPrimary),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '1 serving · approx. ${food?.portion.toStringAsFixed(0) ?? "—"}${food?.portionUnit ?? "g"}',
                                      style: TextStyle(fontSize: 11, color: textMuted),
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
                          Divider(color: divider, height: 1),
                          const SizedBox(height: 12),
                          // Macros row
                          Row(
                            children: [
                              _MacroCell(value: '${total.protein.toStringAsFixed(0)}g', label: 'protein', color: isDark ? AppColors.violet : AppColors.violetDark),
                              VerticalDivider(color: divider, width: 1),
                              _MacroCell(value: '${total.carbs.toStringAsFixed(0)}g', label: 'carbs', color: isDark ? AppColors.amber : AppColors.amberDark),
                              VerticalDivider(color: divider, width: 1),
                              _MacroCell(value: '${total.fat.toStringAsFixed(0)}g', label: 'fat', color: isDark ? AppColors.coral : AppColors.coralDark),
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
                            Text('Detected ingredients', style: TextStyle(fontSize: 11, color: textMuted)),
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

                    // Summary / advice
                    if (analysis.advice.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(14), border: border),
                        child: Text(analysis.advice, style: TextStyle(fontSize: 12, color: textMuted, height: 1.5)),
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
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btnBg,
                        foregroundColor: btnText,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text('Add to diary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: btnText)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Edit details', style: TextStyle(fontSize: 12, color: textMuted)),
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
  final String value;
  final String label;
  final Color color;

  const _MacroCell({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final textMuted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.darkTextMuted
        : const Color(0xFFAAAAAA);
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
