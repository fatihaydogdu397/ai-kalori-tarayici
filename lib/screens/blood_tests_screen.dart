import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/blood_test.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import 'blood_test_upload_screen.dart';
import 'pdf_viewer_screen.dart';

String _t(BuildContext ctx, String tr, String en) =>
    Localizations.localeOf(ctx).languageCode == 'tr' ? tr : en;

/// Kullanıcının yüklediği kan tahlillerini listeleyen ekran — Settings altında.
/// Kart üzerine tıklayınca dosyayı tarayıcıda açar; uzun basınca silme sorar.
class BloodTestsScreen extends StatefulWidget {
  const BloodTestsScreen({super.key});

  @override
  State<BloodTestsScreen> createState() => _BloodTestsScreenState();
}

class _BloodTestsScreenState extends State<BloodTestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadBloodTests();
    });
  }

  void _openFile(String url) {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdfViewerScreen(url: url)),
    );
  }

  Future<void> _confirmDelete(BloodTest test) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_t(ctx, 'Kan tahlilini sil', 'Delete blood test')),
        content: Text(_t(ctx, 'Bu kayıt kalıcı olarak silinecek.', 'This record will be permanently deleted.')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(_t(ctx, 'İptal', 'Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(_t(ctx, 'Sil', 'Delete')),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      try {
        await context.read<AppProvider>().deleteBloodTest(test.id);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_t(context, 'Bir şeyler ters gitti', 'Something went wrong')),
              backgroundColor: AppColors.coral,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(_t(context, 'Kan Tahlillerim', 'My Blood Tests'),
            style: AppTypography.titleLarge.copyWith(color: textPrimary)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accent,
        foregroundColor: isDark ? AppColors.void_ : Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: Text(_t(context, 'Ekle', 'Add'),
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BloodTestUploadScreen()),
          );
        },
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          if (provider.bloodTestsLoading && provider.bloodTests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.bloodTests.isEmpty) {
            return _EmptyState(textMuted: textMuted, textPrimary: textPrimary);
          }
          return RefreshIndicator(
            onRefresh: () => provider.loadBloodTests(),
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 80.h),
              itemCount: provider.bloodTests.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, i) {
                final t = provider.bloodTests[i];
                return _BloodTestCard(
                  test: t,
                  cardBg: cardBg,
                  textPrimary: textPrimary,
                  textMuted: textMuted,
                  accent: accent,
                  onTap: () => _openFile(t.fileUrl),
                  onLongPress: () => _confirmDelete(t),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _BloodTestCard extends StatelessWidget {
  final BloodTest test;
  final Color cardBg;
  final Color textPrimary;
  final Color textMuted;
  final Color accent;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _BloodTestCard({
    required this.test,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
    required this.onTap,
    required this.onLongPress,
  });

  String _statusLabel(BuildContext context) {
    switch (test.status) {
      case BloodTestStatus.pending:
        return _t(context, 'AI analiz bekliyor', 'AI analysis pending');
      case BloodTestStatus.completed:
        return _t(context, 'Analiz tamamlandı', 'Analysis completed');
      case BloodTestStatus.failed:
        return _t(context, 'Analiz başarısız', 'Analysis failed');
    }
  }

  Color _statusColor() {
    switch (test.status) {
      case BloodTestStatus.pending:
        return AppColors.amber;
      case BloodTestStatus.completed:
        return accent;
      case BloodTestStatus.failed:
        return AppColors.coral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();
    final dateStr = test.testDate ?? test.createdAt.toIso8601String().substring(0, 10);
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.bloodtype_rounded, color: statusColor, size: 22),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateStr, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary)),
                  SizedBox(height: 2.h),
                  Text(_statusLabel(context), style: TextStyle(fontSize: 11.sp, color: statusColor, fontWeight: FontWeight.w600)),
                  if (test.errorMessage != null) ...[
                    SizedBox(height: 4.h),
                    Text(test.errorMessage!, style: TextStyle(fontSize: 11.sp, color: textMuted), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, color: textMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color textMuted;
  final Color textPrimary;
  const _EmptyState({required this.textMuted, required this.textPrimary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bloodtype_outlined, size: 60, color: textMuted),
            SizedBox(height: 12.h),
            Text(
              _t(context, 'Henüz yüklenmiş kan tahlili yok', 'No blood tests uploaded yet'),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: textPrimary),
            ),
            SizedBox(height: 6.h),
            Text(
              _t(
                context,
                'Sağ alttaki + ile PDF veya görsel olarak ekleyebilirsin.',
                'Tap the + button to add a PDF or an image.',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
