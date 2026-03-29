import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat entegrasyonu
/// API key'leri --dart-define ile geçirin:
/// --dart-define=RC_IOS_KEY=appl_xxx --dart-define=RC_ANDROID_KEY=goog_xxx
class PurchaseService {
  static const _iosKey = String.fromEnvironment('RC_IOS_KEY', defaultValue: '');
  static const _androidKey = String.fromEnvironment('RC_ANDROID_KEY', defaultValue: '');

  static const monthlyId = 'eatiq_pro_monthly';   // ₺149/ay
  static const yearlyId = 'eatiq_pro_yearly';     // ₺999/yıl

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
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }

  /// Aylık veya yıllık paketi satın al
  static Future<bool> purchase({required bool yearly}) async {
    try {
      final offerings = await Purchases.getOfferings();
      final pkg = yearly
          ? offerings.current?.annual
          : offerings.current?.monthly;
      if (pkg == null) return false;
      await Purchases.purchasePackage(pkg);
      return true;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) return false;
      rethrow;
    }
  }

  /// Satın alımları geri yükle
  static Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey('pro');
    } catch (_) {
      return false;
    }
  }
}
