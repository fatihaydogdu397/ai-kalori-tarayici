import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'share_capture_service.dart';
import 'share_card_data.dart';
import 'share_tokens.dart';
import 'templates/daily_1/d1a_hero.dart';
import 'templates/daily_1/d1b_fullbleed.dart';
import 'templates/daily_1/d1c_polaroid.dart';
import 'templates/daily_1/d1d_magazine.dart';
import 'templates/daily_2/d2a_side_by_side.dart';
import 'templates/daily_3/d3a_bento_kcal_only.dart';
import 'templates/daily_3/d3c_bento_stat_grid.dart';
import 'templates/daily_3/d3f_side_card.dart';
import 'templates/daily_3/d3h_ticket_stub.dart';
import 'templates/daily_4/d4a_bento_2x2.dart';
import 'templates/daily_4/d4b_hero_three.dart';
import 'templates/daily_5/d5a_hero_four.dart';
import 'templates/shared/meal_photo.dart';

/// Share picker — horizontal carousel of templates filtered by meal count,
/// plus a single primary CTA that opens the OS share sheet.
class SharePickerScreen extends StatefulWidget {
  final ShareCardData data;
  final String locale;
  const SharePickerScreen({super.key, required this.data, this.locale = 'tr'});

  @override
  State<SharePickerScreen> createState() => _SharePickerScreenState();
}

class _SharePickerScreenState extends State<SharePickerScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.82);
  int _currentIndex = 0;
  bool _isSharing = false;

  late final List<_TemplateEntry> _templates;

  @override
  void initState() {
    super.initState();
    _templates = _resolveTemplates(widget.data);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<_TemplateEntry> _resolveTemplates(ShareCardData data) {
    final c = data.mealCount;
    if (c == 1) {
      return [
        _TemplateEntry(
          id: 'd1a',
          label: 'Hero',
          builder: (d, l) => D1AHero(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd1b',
          label: 'Full Bleed',
          builder: (d, l) => D1BFullBleed(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd1c',
          label: 'Polaroid',
          builder: (d, l) => D1CPolaroid(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd1d',
          label: 'Magazine',
          builder: (d, l) => D1DMagazine(data: d, locale: l),
        ),
      ];
    }
    if (c == 3) {
      return [
        _TemplateEntry(
          id: 'd3a',
          label: 'Bento Kcal',
          builder: (d, l) => D3ABentoKcalOnly(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd3c',
          label: 'Stat Grid',
          builder: (d, l) => D3CBentoStatGrid(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd3f',
          label: 'Yan Kart',
          builder: (d, l) => D3FSideCard(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd3h',
          label: 'Bilet',
          builder: (d, l) => D3HTicketStub(data: d, locale: l),
        ),
      ];
    }
    if (c == 4) {
      return [
        _TemplateEntry(
          id: 'd4a',
          label: '2×2 Grid',
          builder: (d, l) => D4ABento2x2(data: d, locale: l),
        ),
        _TemplateEntry(
          id: 'd4b',
          label: 'Hero+3',
          builder: (d, l) => D4BHeroThree(data: d, locale: l),
        ),
      ];
    }
    if (c >= 5) {
      return [
        _TemplateEntry(
          id: 'd5a',
          label: 'Hero+2×2',
          // 5'ten fazla öğün varsa ilk 5'i alıp totalleri de sadece bu 5
          // öğüne göre hesaplat. Aksi halde 6+ kayıt bulunca template ilk
          // 5'i çizer ama toplamlar 7-8 öğüne kayıyor.
          builder: (d, l) => D5AHeroFour(
            data: d.meals.length <= 5 ? d : ShareCardData(date: d.date, meals: d.meals.take(5).toList(), handle: d.handle, cta: d.cta),
            locale: l,
          ),
        ),
      ];
    }
    if (c == 2) {
      return [
        _TemplateEntry(
          id: 'd2a',
          label: 'Side by Side',
          builder: (d, l) => D2ASideBySide(data: d, locale: l),
        ),
      ];
    }
    return const [];
  }

  List<ImageProvider> _imagesToPreload() {
    final providers = <ImageProvider>[];
    for (final meal in widget.data.meals) {
      final p = MealPhoto.providerFor(meal.imagePath);
      if (p != null) providers.add(p);
    }
    return providers;
  }

  Future<void> _share(Rect? origin) async {
    if (_isSharing || _templates.isEmpty) return;
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
        title: Text(
          "Günlük Paylaş",
          style: const TextStyle(color: ShareTokens.snow, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: _templates.isEmpty
                  ? const _EmptyHint()
                  : PageView.builder(
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
  final Widget Function(ShareCardData data, String locale) builder;
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
              // border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
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

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          'Bu öğün sayısı için henüz tasarım eklenmedi.',
          textAlign: TextAlign.center,
          style: TextStyle(color: ShareTokens.textMuted, fontSize: 14),
        ),
      ),
    );
  }
}
