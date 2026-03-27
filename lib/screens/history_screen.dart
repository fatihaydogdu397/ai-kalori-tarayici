import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final iconBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final calColor = isDark ? AppColors.lime : AppColors.limeDeep;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: Text('History', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 17)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded, color: textMuted, size: 26),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(Icons.history_rounded, color: textMuted, size: 36),
                  ),
                  const SizedBox(height: 16),
                  Text('No history yet', style: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text('Scan a meal to get started!', style: TextStyle(color: textMuted, fontSize: 13)),
                ],
              ),
            );
          }

          // Group by date
          final grouped = <String, List<dynamic>>{};
          for (final a in provider.history) {
            final dt = a.analyzedAt as DateTime;
            final key = '${dt.day}/${dt.month}/${dt.year}';
            grouped.putIfAbsent(key, () => []).add(a);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grouped.length,
            itemBuilder: (context, index) {
              final date = grouped.keys.elementAt(index);
              final items = grouped[date]!;
              final totalCal = items.fold<double>(0, (sum, a) => sum + (a.totalCalories as double));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(date, style: TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                        Text('${totalCal.toStringAsFixed(0)} kcal total', style: TextStyle(color: calColor, fontSize: 12)),
                      ],
                    ),
                  ),
                  ...items.map((a) => Dismissible(
                        key: Key(a.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.coral.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.delete_rounded, color: AppColors.coral, size: 24),
                        ),
                        onDismissed: (_) => provider.deleteAnalysis(a.id),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(analysis: a))),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _thumb(a.imagePath, iconBg, textMuted),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.summary.length > 50 ? '${a.summary.substring(0, 50)}...' : a.summary,
                                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${a.analyzedAt.hour.toString().padLeft(2, '0')}:${a.analyzedAt.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(color: textMuted, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      a.totalCalories.toStringAsFixed(0),
                                      style: TextStyle(color: calColor, fontWeight: FontWeight.w800, fontSize: 17),
                                    ),
                                    Text('kcal', style: TextStyle(color: textMuted, fontSize: 10)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _thumb(String path, Color bg, Color iconColor) {
    final file = File(path);
    if (file.existsSync()) {
      return Image.file(file, width: 50, height: 50, fit: BoxFit.cover);
    }
    return Container(
      width: 50,
      height: 50,
      color: bg,
      child: Icon(Icons.restaurant, color: iconColor, size: 22),
    );
  }
}
