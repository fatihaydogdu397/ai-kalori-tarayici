import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/food_analysis.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              _buildHeader(context, isDark, l, provider),
              if (provider.history.isEmpty)
                SliverFillRemaining(child: _buildEmpty(isDark, l))
              else
                _buildList(context, isDark, l, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    AppLocalizations l,
    AppProvider provider,
  ) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final totalScans = provider.history.length;

    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCard
                            : AppColors.lightCard,
                        borderRadius: BorderRadius.circular(10),
                        border: isDark
                            ? null
                            : Border.all(
                                color: AppColors.lightBorder,
                                width: 0.5,
                              ),
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: textMuted,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l.historyTitle,
                    style: AppTypography.titleLarge.copyWith(color: textPrimary),
                  ),
                  const Spacer(),
                  if (totalScans > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark ? AppColors.lime : AppColors.void_)
                            .withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l.scanCount(totalScans),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.lime : AppColors.void_,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(bool isDark, AppLocalizations l) {
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final iconBg = isDark ? AppColors.darkCard : AppColors.lightCard;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(
              child: Text('🍽️', style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.noScansYet,
            style: AppTypography.titleMedium.copyWith(color: textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            l.scanFirstMeal,
            style: TextStyle(color: textMuted, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    bool isDark,
    AppLocalizations l,
    AppProvider provider,
  ) {
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;

    // Group by date (yyyy-MM-dd)
    final grouped = <String, List<FoodAnalysis>>{};
    for (final a in provider.history) {
      final key =
          '${a.analyzedAt.year}-${a.analyzedAt.month.toString().padLeft(2, '0')}-${a.analyzedAt.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(a);
    }

    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dateKey = dates[index];
          final items = grouped[dateKey]!;
          final totalCal = items.fold<double>(0, (s, a) => s + a.totalCalories);
          final totalProt = items.fold<double>(
            0,
            (s, a) => s + a.totalNutrients.protein,
          );
          final totalCarbs = items.fold<double>(
            0,
            (s, a) => s + a.totalNutrients.carbs,
          );
          final totalFat = items.fold<double>(
            0,
            (s, a) => s + a.totalNutrients.fat,
          );

          final parts = dateKey.split('-');
          final dt = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          final now = DateTime.now();
          final diff = DateTime(
            now.year,
            now.month,
            now.day,
          ).difference(DateTime(dt.year, dt.month, dt.day)).inDays;
          final dateLabel = diff == 0
              ? l.today
              : diff == 1
              ? l.yesterday
              : l.daysAgo(diff);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date header
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      dateLabel,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${dt.day}/${dt.month}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: textMuted,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        children: [
                          _MacroChip(
                            label: '${totalCal.toStringAsFixed(0)}kcal',
                            color: calColor,
                            isDark: isDark,
                          ),
                          _MacroChip(
                            label: 'P${totalProt.toStringAsFixed(0)}',
                            color: isDark
                                ? AppColors.violet
                                : AppColors.violetDark,
                            isDark: isDark,
                          ),
                          _MacroChip(
                            label: 'K${totalCarbs.toStringAsFixed(0)}',
                            color: isDark
                                ? AppColors.amber
                                : AppColors.amberDark,
                            isDark: isDark,
                          ),
                          _MacroChip(
                            label: 'Y${totalFat.toStringAsFixed(0)}',
                            color: isDark
                                ? AppColors.coral
                                : AppColors.coralDark,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Meal cards
              ...items.map(
                (a) => _HistoryCard(
                  key: Key(a.id),
                  analysis: a,
                  isDark: isDark,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(analysis: a),
                    ),
                  ),
                  onDelete: diff == 0 ? () => provider.deleteAnalysis(a.id) : null,
                  onFavorite: () => provider.toggleFavorite(a),
                  onAddToToday: () async {
                    await provider.duplicateAnalysisToToday(a);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✓ ${l.addedToLog}'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          backgroundColor: AppColors.limeDark,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        }, childCount: dates.length),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _MacroChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isDark;
  const _MacroChip({
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final FoodAnalysis analysis;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final VoidCallback? onAddToToday;

  const _HistoryCard({
    super.key,
    required this.analysis,
    required this.isDark,
    required this.onTap,
    this.onDelete,
    this.onFavorite,
    this.onAddToToday,
  });

  String _categoryEmoji(MealCategory cat) {
    switch (cat) {
      case MealCategory.breakfast:
        return '🌅';
      case MealCategory.lunch:
        return '☀️';
      case MealCategory.dinner:
        return '🌙';
      case MealCategory.snack:
        return '🍎';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark
        ? AppColors.darkTextMuted
        : AppColors.lightTextMuted;
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;
    final iconBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final time =
        '${analysis.analyzedAt.hour.toString().padLeft(2, '0')}:${analysis.analyzedAt.minute.toString().padLeft(2, '0')}';

    final card = GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: isDark
                ? null
                : Border.all(color: AppColors.lightBorder, width: 0.5),
          ),
          child: Row(
            children: [
              // Thumbnail
              Stack(
                children: [
                  Hero(
                    tag: 'food_image_${analysis.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _Thumb(
                        path: analysis.imagePath,
                        bg: iconBg,
                        iconColor: textMuted,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _categoryEmoji(analysis.mealCategory),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analysis.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyLarge.copyWith(color: textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _MiniMacro(
                          value:
                              '${analysis.totalNutrients.protein.toStringAsFixed(0)}g',
                          label: 'P',
                          color: isDark
                              ? AppColors.violet
                              : AppColors.violetDark,
                        ),
                        const SizedBox(width: 4),
                        _MiniMacro(
                          value:
                              '${analysis.totalNutrients.carbs.toStringAsFixed(0)}g',
                          label: 'K',
                          color: isDark ? AppColors.amber : AppColors.amberDark,
                        ),
                        const SizedBox(width: 4),
                        _MiniMacro(
                          value:
                              '${analysis.totalNutrients.fat.toStringAsFixed(0)}g',
                          label: 'Y',
                          color: isDark ? AppColors.coral : AppColors.coralDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Calories + favori
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onAddToToday != null)
                        GestureDetector(
                          onTap: onAddToToday,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4, right: 10),
                            child: Icon(Icons.add_circle_outline_rounded, size: 18, color: calColor),
                          ),
                        ),
                      // EAT-162: hide "Add to favorites" entirely for already-favorited
                      // items; remove-from-favorites lives on the Favorites screen.
                      if (!analysis.isFavorite)
                        GestureDetector(
                          onTap: onFavorite,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 16,
                              color: textMuted,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    analysis.totalCalories.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: calColor,
                      height: 1,
                    ),
                  ),
                  Text(
                    'kcal',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

    if (onDelete == null) return card;

    return Dismissible(
      key: Key(analysis.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.coral.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: AppColors.coral,
          size: 22,
        ),
      ),
      onDismissed: (_) => onDelete!(),
      child: card,
    );
  }
}

class _MiniMacro extends StatelessWidget {
  final String value, label;
  final Color color;
  const _MiniMacro({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(width: 1),
        Text(
          value,
          style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  final String path;
  final Color bg, iconColor;
  const _Thumb({required this.path, required this.bg, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, width: 52, height: 52, fit: BoxFit.cover);
    }
    return Container(
      width: 52,
      height: 52,
      color: bg,
      child: Icon(Icons.restaurant_rounded, color: iconColor, size: 22),
    );
  }
}
