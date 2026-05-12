import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'share_capture_service.dart';
import 'share_card_data.dart';
import 'share_tokens.dart';
import 'templates/shared/meal_photo.dart';
import 'templates/weekly/w2_full_7days.dart';

/// Weekly share picker — horizontal carousel of 7 weekly templates with the
/// same primary CTA flow as [SharePickerScreen].
class WeeklySharePickerScreen extends StatefulWidget {
  final WeeklyShareCardData data;
  final String locale;
  const WeeklySharePickerScreen({super.key, required this.data, this.locale = 'tr'});

  @override
  State<WeeklySharePickerScreen> createState() => _WeeklySharePickerScreenState();
}

class _WeeklySharePickerScreenState extends State<WeeklySharePickerScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.82);
  int _currentIndex = 0;
  bool _isSharing = false;

  late final List<_TemplateEntry> _templates;

  @override
  void initState() {
    super.initState();
    _templates = [
      _TemplateEntry(
        id: 'w2',
        label: '7 Gün Tam',
        builder: (d, l) => W2Full7Days(data: d, locale: l),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<ImageProvider> _imagesToPreload() {
    final providers = <ImageProvider>[];
    for (final dayMeals in widget.data.days) {
      for (final meal in dayMeals) {
        final p = MealPhoto.providerFor(meal.imagePath);
        if (p != null) providers.add(p);
      }
    }
    return providers;
  }

  Future<void> _share(Rect? origin) async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      final entry = _templates[_currentIndex];
      final card = entry.builder(widget.data, widget.locale);
      final file = await ShareCaptureService.capture(card, filename: 'eatiq_${entry.id}.png', preloadImages: _imagesToPreload());
      if (!mounted) return;
      await Share.shareXFiles([XFile(file.path, mimeType: 'image/png')], sharePositionOrigin: origin);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShareTokens.cardDeep,
      appBar: AppBar(
        backgroundColor: ShareTokens.cardDeep,
        elevation: 0,
        iconTheme: const IconThemeData(color: ShareTokens.snow),
        title: const Text(
          'Haftalık Paylaş',
          style: TextStyle(color: ShareTokens.snow, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _templates.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _ScaledPreview(child: _templates[i].builder(widget.data, widget.locale)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _DotIndicator(count: _templates.length, current: _currentIndex),
            const SizedBox(height: 20),
            _ShareCta(busy: _isSharing, onTap: _share),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TemplateEntry {
  final String id;
  final String label;
  final Widget Function(WeeklyShareCardData data, String locale) builder;
  const _TemplateEntry({required this.id, required this.label, required this.builder});
}

class _ScaledPreview extends StatelessWidget {
  final Widget child;
  const _ScaledPreview({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final scale = math.min(constraints.maxWidth / ShareTokens.canvas.width, constraints.maxHeight / ShareTokens.canvas.height);
        final w = ShareTokens.canvas.width * scale;
        final h = ShareTokens.canvas.height * scale;
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [BoxShadow(blurRadius: 32, offset: Offset(0, 12), color: Color(0x66000000))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                width: w,
                height: h,
                child: FittedBox(fit: BoxFit.contain, child: ShareCaptureService.wrapForCanvas(child)),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _DotIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox(height: 8);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(color: active ? ShareTokens.lime : Colors.white24, borderRadius: BorderRadius.circular(3)),
        );
      }),
    );
  }
}

class _ShareCta extends StatelessWidget {
  final bool busy;
  final ValueChanged<Rect?> onTap;
  const _ShareCta({required this.busy, required this.onTap});

  Rect? _originFromContext(BuildContext ctx) {
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: busy ? null : () => onTap(_originFromContext(ctx)),
            style: ElevatedButton.styleFrom(
              backgroundColor: ShareTokens.lime,
              foregroundColor: ShareTokens.voidBg,
              disabledBackgroundColor: ShareTokens.lime.withValues(alpha: 0.4),
              disabledForegroundColor: ShareTokens.voidBg,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: busy
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: ShareTokens.voidBg))
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.ios_share_rounded, size: 22),
                      SizedBox(width: 10),
                      Text('Paylaş', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.17)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
