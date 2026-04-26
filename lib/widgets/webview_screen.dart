import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

/// Generic in-app WebView screen used by Privacy Policy & Terms of Service.
/// Loads [url], shows a centered spinner while loading, and a retry view on
/// network/main-frame errors.
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _loading = true;
              _error = null;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _loading = false);
          },
          onWebResourceError: (e) {
            if (!mounted) return;
            // Sub-resource hatalarını yok say — ana frame yüklemesi başarısızsa
            // göster.
            if (e.isForMainFrame ?? true) {
              setState(() {
                _error = e.description;
                _loading = false;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _reload() {
    setState(() {
      _error = null;
      _loading = true;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading && _error == null)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          if (_error != null)
            Container(
              color: bg,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded, size: 48, color: textMuted),
                      const SizedBox(height: 12),
                      Text(
                        isTr
                            ? 'Sayfa yüklenemedi.'
                            : 'Could not load the page.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textPrimary, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _reload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor:
                              isDark ? AppColors.void_ : AppColors.snow,
                        ),
                        child: Text(isTr ? 'Tekrar dene' : 'Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
