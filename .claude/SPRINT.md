# eatiq Sprint Board
> Bu dosyayı Claude ve Gemini okur/yazar. Bir görevi almadan önce buraya bak — başkası üzerinde çalışıyorsa dokunma.

---

## 🔴 KURALLAR
1. Bir görevi almadan önce `[OWNER]` alanına kendi adını yaz
2. Aynı dosyayı aynı anda iki AI düzenlemesin
3. Tamamlanan görev `✅` olarak işaretlenir ve ne yapıldığı yazılır
4. Conflict çıkarsa Fatih karar verir

---

## ✅ Tamamlanan (Sprint 1–4 + L10n + Apple Health)
- Sprint 1–4: Onboarding, tema, RevenueCat, su, profil, öğün, streak, favoriler, hatırlatıcılar, settings
- L10n: 10 dil × 187+ key
- Apple Health: health_service.dart, Settings toggle, HealthKit izinleri

---

## 🚧 Sprint 5 — Aktif

### #4 Barkod Tarayıcı
**OWNER: Claude**
**STATUS: 🔄 In Progress**
**Dosyalar:**
- `pubspec.yaml` → mobile_scanner paketi
- `lib/services/food_api_service.dart` → Open Food Facts API (YENİ)
- `lib/screens/barcode_scanner_screen.dart` → kamera + tarama UI (YENİ)
- `lib/screens/home_screen.dart` → scan sheet'e Barkod butonu
- `lib/l10n/app_*.arb` → barkod key'leri (10 dil)
- `ios/Runner/Info.plist` → kamera izni zaten var ✓

**Plan:**
1. `mobile_scanner` paketi ekle
2. Open Food Facts API servisi yaz
3. BarcodeScanner ekranı yaz (kamera viewfinder, tarama animasyonu)
4. Tarama sonucu → FoodAnalysis'e çevir → ResultScreen'e git
5. Scan sheet'e barkod butonu ekle
6. ARB key'leri ekle

---

### #5 iOS Widget
**OWNER: Gemini**
**STATUS: ⏳ Bekliyor (#4 bittikten sonra)**
**Dosyalar:**
- `pubspec.yaml` → home_widget paketi
- `ios/EatiqWidget/` → Swift Widget Extension (YENİ)
- `lib/services/widget_service.dart` → veri güncelleme (YENİ)
- `app_provider.dart` → widget güncelleme çağrıları
- Xcode: Widget Extension target eklenmesi gerekiyor (manuel)

**Notlar:**
- iOS 14+ gerekli (Podfile'da zaten 14.0 ✓)
- App Group: `group.com.ai.eatiq` kullanılacak
- Widget gösterecekler: bugünkü kalori, su, streak
- Fatih Xcode'da Widget Extension target eklemeli

---

## ⏳ Backlog
- RevenueCat App Store Connect setup
- `kUseMockData = false` yap (test bittikten sonra)
- Android barkod izni (CAMERA) AndroidManifest.xml

---

## 📋 Dosya Sahipliği (Conflict önleme)
| Dosya | Şu an kim kullanıyor |
|-------|---------------------|
| `lib/services/food_api_service.dart` | Claude |
| `lib/screens/barcode_scanner_screen.dart` | Claude |
| `lib/screens/home_screen.dart` | Claude |
| `pubspec.yaml` | Claude (barkod bitince serbest) |
| `ios/EatiqWidget/` | Gemini |
| `lib/services/widget_service.dart` | Gemini |

---

## 🤝 İş Bölümü Prensibi
| Claude | Gemini |
|--------|--------|
| Kompleks Flutter/Dart logic | Swift/native kod |
| API entegrasyonları | Android tarafı |
| State management (Provider) | ARB çevirileri |
| Servis mimarisi | Icon/asset işleri |
| iOS HealthKit, Scanner | iOS Widget Swift kodu |
