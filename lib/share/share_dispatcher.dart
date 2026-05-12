import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

enum ShareTarget { instagram, whatsapp, x, gallery, native }

class ShareResult {
  final bool ok;
  final String? message;
  const ShareResult.success([this.message]) : ok = true;
  const ShareResult.failed(this.message) : ok = false;
}

class ShareDispatcher {
  /// Sends [image] to the requested target. iOS / Android only.
  ///
  /// Instagram / WhatsApp / X currently fall through to the OS share sheet —
  /// the user picks the app in the sheet. We pre-filter visually in the
  /// share-card picker; deep-linking to IG Story background requires native
  /// channel work and is tracked separately.
  static Future<ShareResult> dispatch(
    ShareTarget target,
    File image, {
    String? text,
  }) async {
    try {
      switch (target) {
        case ShareTarget.gallery:
          return await _saveToGallery(image);
        case ShareTarget.instagram:
        case ShareTarget.whatsapp:
        case ShareTarget.x:
        case ShareTarget.native:
          await Share.shareXFiles([
            XFile(image.path, mimeType: 'image/png'),
          ], text: text);
          return const ShareResult.success();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('ShareDispatcher error: $e');
      return ShareResult.failed(e.toString());
    }
  }

  static Future<ShareResult> _saveToGallery(File image) async {
    try {
      final has = await Gal.hasAccess();
      if (!has) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          return const ShareResult.failed('gallery_permission_denied');
        }
      }
      await Gal.putImage(image.path, album: 'eatiq');
      return const ShareResult.success('saved_to_gallery');
    } on GalException catch (e) {
      return ShareResult.failed(e.type.message);
    }
  }
}
