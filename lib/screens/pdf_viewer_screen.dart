import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../theme/app_theme.dart';

/// In-app file viewer for uploaded blood-test reports (PDF or image).
/// Mounted via [Navigator.push]. Decides PDF vs. image based on the URL's
/// file extension; PDFs use [PdfViewer.uri], images use [Image.network] inside
/// an [InteractiveViewer] for pinch-zoom.
class PdfViewerScreen extends StatelessWidget {
  final String url;
  final String? title;

  const PdfViewerScreen({super.key, required this.url, this.title});

  bool get _isPdf {
    final lower = url.split('?').first.toLowerCase();
    return lower.endsWith('.pdf');
  }

  String _displayTitle(BuildContext context) {
    if (title != null && title!.isNotEmpty) return title!;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    return _isPdf
        ? (isTr ? 'PDF' : 'PDF')
        : (isTr ? 'Görsel' : 'Image');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          _displayTitle(context),
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: _isPdf ? _PdfBody(url: url) : _ImageBody(url: url),
    );
  }
}

class _PdfBody extends StatelessWidget {
  final String url;
  const _PdfBody({required this.url});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    if (uri == null) return const _ErrorState();
    return PdfViewer.uri(uri);
  }
}

class _ImageBody extends StatelessWidget {
  final String url;
  const _ImageBody({required this.url});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 1,
      maxScale: 5,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (ctx, child, progress) {
            if (progress == null) return child;
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            final accent = isDark ? AppColors.lime : AppColors.void_;
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            );
          },
          errorBuilder: (_, __, ___) => const _ErrorState(),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_rounded, size: 48, color: textMuted),
            const SizedBox(height: 12),
            Text(
              isTr ? 'Dosya açılamadı.' : 'Could not open file.',
              textAlign: TextAlign.center,
              style: TextStyle(color: textPrimary, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
