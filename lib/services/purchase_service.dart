import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Result of a Restore Purchases attempt — distinguishes "no active sub on
/// this account" from a network/SDK error so the UI can show the right
/// message (EAT-159).
enum RestoreResult { success, noEntitlement, error }

/// RevenueCat entegrasyonu.
/// EAT-123: API key'leri artık `.env`'den değil compile-time'da inject edilir:
///   flutter build ... --dart-define=RC_IOS_KEY=appl_xxx \
///                     --dart-define=RC_ANDROID_KEY=goog_xxx
class PurchaseService {
  static const String _iosKey = String.fromEnvironment('RC_IOS_KEY');
  static const String _androidKey = String.fromEnvironment('RC_ANDROID_KEY');

  static const weeklyId = 'com.fatihaydogdu.eatiq.premium.weekly';
  static const monthlyId = 'com.fatihaydogdu.eatiq.premium.monthly';
  static const yearlyId = 'com.fatihaydogdu.eatiq.premium.yearly';

  /// `true` once `Purchases.configure(...)` has run with a real key.
  /// When false, every method below short-circuits to safe defaults so the
  /// native RevenueCat SDK never gets called — calling it unconfigured is a
  /// Swift `fatalError` that Dart try/catch cannot intercept.
  static bool _configured = false;

  static Future<void> init() async {
    if (_iosKey.isEmpty && _androidKey.isEmpty) {
      debugPrint('[PurchaseService] RC key bulunamadı — mock mod aktif');
      return;
    }

    await Purchases.setLogLevel(LogLevel.error);
    final config = PurchasesConfiguration(Platform.isIOS ? _iosKey : _androidKey);
    await Purchases.configure(config);
    _configured = true;
  }

  /// Kullanıcının aktif aboneliği var mı?
  static Future<bool> checkPremium() async {
    if (!_configured) return false;
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('eatiq Premium');
    } catch (_) {
      return false;
    }
  }

  /// Hangi planda olduğunu döndürür (weekly, monthly, yearly veya null)
  static Future<String?> getActivePlan() async {
    if (!_configured) return null;
    try {
      final info = await Purchases.getCustomerInfo();
      final ent = info.entitlements.active['eatiq Premium'];
      if (ent == null) return null;
      if (ent.productIdentifier.contains('weekly')) return 'weekly';
      if (ent.productIdentifier.contains('monthly')) return 'monthly';
      if (ent.productIdentifier.contains('yearly')) return 'yearly';
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Belirtilen paketi (weekly, monthly, yearly) satın al
  static Future<bool> purchase({required String planType}) async {
    if (!_configured) {
      debugPrint('[PurchaseService] purchase() mock modda yoksayıldı');
      return false;
    }
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        debugPrint('[PurchaseService] Offerings boş — App Store Connect bağlantısı kontrol edilmeli');
        return false;
      }

      Package? pkg;
      if (planType == 'weekly') {
        pkg = offerings.current!.weekly;
      } else if (planType == 'monthly') {
        pkg = offerings.current!.monthly;
      } else if (planType == 'yearly') {
        pkg = offerings.current!.annual;
      }

      if (pkg == null) return false;
      await Purchases.purchasePackage(pkg);
      return true;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      debugPrint('[PurchaseService] Satın alma hatası: $e');
      return false;
    } catch (e) {
      debugPrint('[PurchaseService] Beklenmedik hata: $e');
      return false;
    }
  }

  /// Satın alımları geri yükle. Üç ayrı sonucu net döndürür ki UI
  /// "abonelik yok" ile "ağ hatası" farkını kullanıcıya gösterebilsin.
  static Future<RestoreResult> restore() async {
    if (!_configured) return RestoreResult.error;
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('eatiq Premium')
          ? RestoreResult.success
          : RestoreResult.noEntitlement;
    } catch (e) {
      debugPrint('[PurchaseService] restore error: $e');
      return RestoreResult.error;
    }
  }
}
