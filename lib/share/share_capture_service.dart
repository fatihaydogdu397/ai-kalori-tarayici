import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'share_tokens.dart';

class ShareCaptureService {
  static final _controller = ScreenshotController();

  /// Wraps [card] in the same Theme + MediaQuery used by [capture], so a
  /// scaled preview renders identically to the exported PNG.
  static Widget wrapForCanvas(Widget card) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        fontFamily: ShareTokens.fontFamily,
        textTheme: GoogleFonts.interTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(size: ShareTokens.canvas),
          child: SizedBox(
            width: ShareTokens.canvas.width,
            height: ShareTokens.canvas.height,
            child: card,
          ),
        ),
      ),
    );
  }

  /// Renders [card] off-screen at 1080×1920 and writes a PNG.
  ///
  /// [preloadImages] should include any remote/file image used inside the
  /// card so the off-screen tree paints the real bitmap, not the placeholder.
  static Future<File> capture(
    Widget card, {
    String? filename,
    List<ImageProvider> preloadImages = const [],
  }) async {
    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(),
      GoogleFonts.fraunces(),
      GoogleFonts.caveat(),
      GoogleFonts.jetBrainsMono(),
    ]);

    for (final provider in preloadImages) {
      await _resolveProvider(provider);
    }

    // pixelRatio 3.0 → 3240×5760 fiziksel piksel. IG Story 1080×1920'a
    // küçülttükten sonra bile yazılar/foto crisp. Dosya 2-4 MB civarı,
    // share_plus üzerinden sorunsuz.
    final bytes = await _controller.captureFromWidget(
      wrapForCanvas(card),
      pixelRatio: 3.0,
      targetSize: ShareTokens.canvas,
    );

    final dir = await getTemporaryDirectory();
    final name =
        filename ?? 'eatiq_share_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Decodes [provider] so a subsequent captureFromWidget paints the real
  /// bitmap. Swallows errors — a broken URL falls through to placeholder.
  static Future<void> _resolveProvider(ImageProvider provider) {
    final completer = Completer<void>();
    final stream = provider.resolve(ImageConfiguration.empty);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
      onError: (err, _) {
        if (!completer.isCompleted) completer.complete();
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
    return completer.future.timeout(
      const Duration(seconds: 6),
      onTimeout: () {
        stream.removeListener(listener);
      },
    );
  }
}
