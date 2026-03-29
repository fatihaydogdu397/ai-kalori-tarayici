# eatiq Sprint Board
> Bu dosyayı Claude ve Gemini okur/yazar. Bir görevi almadan önce buraya bak — başkası üzerinde çalışıyorsa dokunma.

---

## 🔴 KURALLAR
1. Bir görevi almadan önce `[OWNER]` alanına kendi adını yaz
2. Aynı dosyayı aynı anda iki AI düzenlemesin
3. Tamamlanan görev `✅` olarak işaretlenir ve ne yapıldığı yazılır
4. Conflict çıkarsa Fatih karar verir

---

## ✅ Tamamlanan (Sprint 1–5)
- Sprint 1–4: Onboarding, tema, RevenueCat, su, profil, öğün, streak, favoriler, hatırlatıcılar, settings
- L10n: 10 dil × 187+ key
- Apple Health: health_service.dart, Settings toggle, HealthKit izinleri
- Barkod Tarayıcı: mobile_scanner + Open Food Facts API
- iOS Widget: SwiftUI widget, containerBackground fix
- Multi-provider AI: GPT-4o primary → Gemini 2.5 Flash → Claude fallback
- Porsiyon picker: gram slider + pişirme yöntemi → AI prompt'a eklendi
- flutter_dotenv: .env'den runtime key okuma

---

## 🚧 Sprint 6 — Aktif

### #1 Haftalık/Aylık Progress Grafikleri
**OWNER: Claude**
**STATUS: ⏳ Bekliyor**
**Öncelik: 🔴 Yüksek**
**Dosyalar:**
- `lib/screens/progress_screen.dart` → mevcut günlük → haftalık/aylık ekle
- `lib/services/database_service.dart` → haftalık/aylık sorgu metodları
- `pubspec.yaml` → fl_chart paketi
**Plan:**
- Haftalık: 7 günlük çubuk grafik (kalori, protein, karbonhidrat, yağ)
- Aylık: 30 günlük trend çizgisi
- Tab switcher: Günlük / Haftalık / Aylık

---

### #2 Analiz Sonucu Düzenleme
**OWNER: Claude**
**STATUS: ⏳ Bekliyor**
**Öncelik: 🔴 Yüksek**
**Dosyalar:**
- `lib/screens/result_screen.dart` → gram slider + kalori canlı güncelleme
- `lib/models/food_analysis.dart` → porsiyon değişince makro hesaplama
**Plan:**
- ResultScreen'de her yemek satırında gram düzenlenebilir
- Gram değişince kalori/protein/karb/yağ orantılı güncellenir
- "Kaydet" ile DB'ye yazar

---

### #3 Kilo Takibi
**OWNER: Claude**
**STATUS: ⏳ Bekliyor**
**Öncelik: 🟡 Orta**
**Dosyalar:**
- `lib/screens/profile_screen.dart` → kilo giriş butonu
- `lib/services/database_service.dart` → weight_logs tablosu
- `lib/screens/progress_screen.dart` → kilo grafik sekmesi
**Plan:**
- Günlük kilo girişi (profile veya progress ekranından)
- Zaman serisi grafik (hedef kilo çizgisi + gerçek kilo)
- Apple Health'e de yaz

---

### #4 RevenueCat App Store Connect Kurulum
**OWNER: Fatih (manuel)**
**STATUS: ⏳ Bekliyor (App Store hesabı gerekli)**
**Öncelik: 🟡 Orta**
**Yapılacaklar:**
- App Store Connect'te uygulama oluştur
- In-App Purchase ürünleri tanımla (aylık/yıllık)
- RevenueCat dashboard'da App Store bağla
- `RC_IOS_KEY` .env'e ekle

---

### #5 kUseMockData = false
**OWNER: Claude**
**STATUS: ⏳ Bekliyor (RevenueCat kurulumu sonrası)**
**Öncelik: 🟡 Orta**
**Dosyalar:**
- `lib/dev/mock_data.dart` → `kUseMockData = false`

---

### #6 App Store Screenshots + Metadata
**OWNER: Gemini**
**STATUS: ⏳ Bekliyor (uygulama kararlı olduktan sonra)**
**Öncelik: 🟡 Orta**
**Yapılacaklar:**
- 6.7" ve 5.5" screenshot'lar (iPhone 15 Pro Max + iPhone 8 Plus)
- App Store açıklaması (TR + EN)
- Anahtar kelimeler (keywords)
- Gizlilik politikası URL'i

---

### #7 Günlük AI Beslenme Özeti (Push Notification)
**OWNER: Claude**
**STATUS: ⏳ Bekliyor**
**Öncelik: 🟢 Düşük**
**Dosyalar:**
- `lib/services/notification_service.dart` → akşam scheduled notification
- `lib/services/ai_service.dart` → günlük özet prompt
**Plan:**
- Her akşam 20:00 sabit bildirim: "Bugün X kcal aldın, Y kcal kaldı"
- Haftalık özet (Pazar): AI ile trend analizi
- Kullanıcı saati settings'ten değiştirebilir

---

## 📋 İş Bölümü

| # | Görev | Kim | Durum |
|---|-------|-----|-------|
| 1 | Haftalık/Aylık Grafikler | **Claude** | ⏳ |
| 2 | Analiz Sonucu Düzenleme | **Claude** | ⏳ |
| 3 | Kilo Takibi | **Claude** | ⏳ |
| 4 | RevenueCat App Store | **Fatih** | ⏳ |
| 5 | kUseMockData = false | **Gemini** | ⏳ |
| 6 | App Store Screenshots + Metadata (TR+EN) | **Gemini** | ⏳ |
| 7 | Günlük AI Bildirimi | **Claude** | ⏳ |
| 8 | Android kamera + CAMERA izni (AndroidManifest) | **Gemini** | ⏳ |
| 9 | Android Widget (home_widget Android tarafı) | **Gemini** | ⏳ |
| 10 | ARB çevirileri — yeni key'ler eklendikçe 10 dile | **Gemini** | 🔄 Sürekli |

---

## 🤝 İş Bölümü Prensibi
| Claude | Gemini |
|--------|--------|
| Flutter/Dart karmaşık logic | Android native tarafı |
| API entegrasyonları | AndroidManifest, Android widget |
| Grafikler + state management | App Store screenshots + metadata |
| Bildirim servisi (iOS) | ARB çevirileri (10 dil) |
| Kilo takibi + DB | kUseMockData = false |
| Analiz düzenleme | Asset / icon işleri |

## 📌 Gemini İçin Kural
Claude yeni bir özellik ekleyince yeni ARB key'leri `lib/l10n/app_tr.arb`'a yazar.
Gemini bu key'leri diğer 9 dile (`app_en`, `app_de`, `app_fr`, `app_es`, `app_ar`, `app_pt`, `app_ru`, `app_it`, `app_ka`) çevirir ve commit + push atar.
