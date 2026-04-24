import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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

  static Future<void> init() async {
    if (_iosKey.isEmpty && _androidKey.isEmpty) {
      debugPrint('[PurchaseService] RC key bulunamadı — mock mod aktif');
      return;
    }

    await Purchases.setLogLevel(LogLevel.error);
    final config = PurchasesConfiguration(Platform.isIOS ? _iosKey : _androidKey);
    await Purchases.configure(config);
  }

  /// Kullanıcının aktif aboneliği var mı?
  static Future<bool> checkPremium() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey('eatiq Premium');
    } catch (_) {
      return false;
    }
  }

  /// Hangi planda olduğunu döndürür (weekly, monthly, yearly veya null)
  static Future<String?> getActivePlan() async {
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

  /// Satın alımları geri yükle
  static Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('eatiq Premium');
    } catch (_) {
      return false;
    }
  }
}
