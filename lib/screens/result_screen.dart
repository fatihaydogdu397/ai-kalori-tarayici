import 'dart:io';
import 'package:flutter/material.dart';
import '../models/food_analysis.dart';
import '../theme/app_theme.dart';
import '../widgets/nutrient_card.dart';

class ResultScreen extends StatelessWidget {
  final FoodAnalysis analysis;

  const ResultScreen({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero image header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.background.withOpacity(0.8),
                          AppTheme.background,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kalori badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${analysis.totalCalories.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Özet
                  _sectionTitle('📊 Analiz Özeti'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      analysis.summary,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Makro değerleri
                  _sectionTitle('🥗 Besin Değerleri'),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                    children: [
                      NutrientCard(
                        label: 'Kalori',
                        value: analysis.totalNutrients.calories,
                        unit: 'kcal',
                        color: AppTheme.accent,
                        icon: Icons.local_fire_department_rounded,
                      ),
                      NutrientCard(
                        label: 'Protein',
                        value: analysis.totalNutrients.protein,
                        unit: 'gram',
                        color: AppTheme.primary,
                        icon: Icons.fitness_center_rounded,
                      ),
                      NutrientCard(
                        label: 'Karbonhidrat',
                        value: analysis.totalNutrients.carbs,
                        unit: 'gram',
                        color: AppTheme.warning,
                        icon: Icons.grain_rounded,
                      ),
                      NutrientCard(
                        label: 'Yağ',
                        value: analysis.totalNutrients.fat,
                        unit: 'gram',
                        color: const Color(0xFF9B8BFF),
                        icon: Icons.water_drop_rounded,
                      ),
                      NutrientCard(
                        label: 'Lif',
                        value: analysis.totalNutrients.fiber,
                        unit: 'gram',
                        color: const Color(0xFF4ECDC4),
                        icon: Icons.eco_rounded,
                      ),
                      NutrientCard(
                        label: 'Şeker',
                        value: analysis.totalNutrients.sugar,
                        unit: 'gram',
                        color: const Color(0xFFFF8E6E),
                        icon: Icons.cookie_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Yemek listesi
                  if (analysis.foods.isNotEmpty) ...[
                    _sectionTitle('🍽️ Tespit Edilen Yemekler'),
                    const SizedBox(height: 12),
                    ...analysis.foods.map((f) => _buildFoodItem(f)),
                    const SizedBox(height: 24),
                  ],

                  // Beslenme önerisi
                  _sectionTitle('💡 AI Önerisi'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.15),
                          AppTheme.primary.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🤖', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            analysis.advice,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Geri dön butonu
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Yeni Tarama Yap'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final file = File(analysis.imagePath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover);
    }
    return Container(
      color: AppTheme.card,
      child: const Center(
        child: Icon(Icons.restaurant, color: AppTheme.primary, size: 60),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    Color healthColor;
    switch (food.healthScore) {
      case 'Mükemmel':
        healthColor = AppTheme.success;
        break;
      case 'İyi':
        healthColor = AppTheme.primary;
        break;
      case 'Orta':
        healthColor = AppTheme.warning;
        break;
      default:
        healthColor = AppTheme.error;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.restaurant_menu,
                color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.nameTr,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${food.portion.toStringAsFixed(0)} ${food.portionUnit}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${food.nutrients.calories.toStringAsFixed(0)} kcal',
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: healthColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  food.healthScore,
                  style: TextStyle(
                      color: healthColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
