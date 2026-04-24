# eatiq — Master Görev Listesi

> TEK kaynak bu dosyadır. SPRINT.md, GEMINI_TASKS.md, GEMINI_TASKS_2.md artık kullanılmıyor.
> Claude, Gemini ve Fatih buraya bakar. Görev alırken OWNER'ı yaz, bitince ✅ işaretle.

---

## 📌 KURALLAR

### 🚀 JIRA OTOMASYONU (İLK YAPILACAK İŞ)

**DİKKAT AI (Claude & Gemini)**: Yeni bir oturuma/chate başladığında **SORMADAN** ve kod yazmadan önce yapacağın İLK iş Jira'ya bağlanmaktır.

1. Kök dizindeki `.env` dosyasını oku (içinde `JIRA_BASE_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN` ve `JIRA_PROJECT_KEY` var).
2. Python `requests` (veya `curl`) kullanarakarka planda Jira REST API'sine (Basic Auth) bağlan.
3. Benden yeni task açılması talep edildiğinde DAİMA şu formatı uygula:
   - **Tüm tasklar kesinlikle İNGİLİZCE açılacaktır.**
   - Birbirine bağlı Frontend ve Backend taskları varsa bunları tek bir **Epic** altında topla (örn: `[Epic] Food Search Module`).
   - Taskların "Description" kısımlarını Atlassian Document Format (ADF) veya yapılandırılmış Jira formatında yaz. İçeriğinde mutlaka `Assigned To`, `Summary`, `Implementation Details` (bullet point listesi) ve `Affected Files` (kod formatında) başlıkları bulunsun.
   - Taskları sisteme at ve koda başlamadan önce bana task linklerini veya keylerini raporla.

### Altın Kural

Fatih olmadan hiçbir şey merge edilmez, yayına alınmaz, silinmez.

### AI İş Bölümü Kuralları

1. Görev almadan önce OWNER'ını bu dosyaya yaz
2. Aynı dosyaya aynı anda iki AI dokunmasın
3. Her görev ayrı commit: `feat: #N - açıklama`
4. `dart analyze lib/` hata olmadan bitir
5. Yeni ARB key → önce `app_tr.arb`'a yaz, sonra Gemini 9 dile çevirir
6. API key'ler asla koda yazılmaz → `.env` dosyasından `flutter_dotenv` ile okunur
7. Conflict çıkarsa Fatih karar verir

### Kim Ne Yapar?

| Claude                       | Gemini                           |
| ---------------------------- | -------------------------------- |
| Flutter/Dart karmaşık logic  | Android native tarafı            |
| API entegrasyonları          | AndroidManifest, Android widget  |
| Grafikler + state management | App Store screenshots + metadata |
| Bildirim servisi (iOS)       | ARB çevirileri (10 dil)          |
| DB katmanı                   | Asset / icon işleri              |

---

## 🔴 ACİL

| #   | Görev                                                      | Kim        | Durum        |
| --- | ---------------------------------------------------------- | ---------- | ------------ |
| I   | Apple Health okuma → app_provider state + home/progress UI | **Gemini** | ❌ YAPILMADI |
| 4   | RevenueCat sandbox test (StoreKit config)                  | **Fatih**  | 🔄 Devam     |
| 15  | [EAT-106] Purchase Flow Backend & Webhooks (Epic)          | **Claude** | 🔄 Devam     |
| 16  | [EAT-107] Configure RevenueCat Webhooks & CFraud Prevent   | **Fatih**  | ❌ YAPILMADI |

---

## 🟡 AKTİF

| #   | Görev                                                       | Kim        | Durum          |
| --- | ----------------------------------------------------------- | ---------- | -------------- |
| 13  | Voice logging — sesli öğün kaydı (Türkçe/EN)                | **Claude** | ⏳ BUGÜN/YARIN |
| 7   | Günlük AI bildirimi — akşam 20:00 dinamik içerik            | **Claude** | ⏳             |
| 12  | Geçmişten Hızlı Ekle — `copyAsNew()` + "Bugüne Ekle" butonu | **Claude** | ⏳             |
| 10  | ARB çevirileri (yeni key'ler sürekli geliyor)               | **Gemini** | 🔄 Sürekli     |

---

## 🟢 SIRA BEKLEYEN

| #   | Görev                                              | Kim        | Durum      |
| --- | -------------------------------------------------- | ---------- | ---------- |
| 6   | App Store screenshots (6.7" + 5.5")                | **Gemini** | ⏳         |
| 14  | ARKit/LiDAR porsiyon hacmi ölçümü (iPhone 12 Pro+) | **Claude** | 🔵 Backlog |

---

## ✅ TAMAMLANAN — Tam Proje Geçmişi

### Bu Oturum (5 Nisan 2026)

| Görev                                                                     | Kim    |
| ------------------------------------------------------------------------- | ------ |
| Fotoğraf kalıcı kayıt — HEIC→JPEG dönüşümü                                | Claude |
| iOS UUID path sorunu fix — DB'ye sadece filename kaydet, yüklerken çöz    | Claude |
| Fullscreen Hero zoom görüntüleyici (result screen)                        | Claude |
| AI prompt — kısa isim kuralı (max 3 kelime, cümle yasak)                  | Claude |
| FoodItem.\_shortName() — kod seviyesinde max 4 kelime kırpma              | Claude |
| Portion picker yeniden tasarım — Katı/Sıvı toggle, ml desteği             | Claude |
| Result screen — AI Notu expandable bölümü (summary ayrıldı)               | Claude |
| Result screen — Öneri başlığı + textSecondary renk                        | Claude |
| Home screen — meal card thumbnail (foto varsa resim, yoksa gradient icon) | Claude |
| `darkTextMuted` fix: #3A3A50 → #9090A8 (uygulama geneli)                  | Claude |
| Hardcoded `0xFFAAAAAA` → `AppColors.lightTextMuted` (8 yer)               | Claude |
| AppBar tarih: 11px→13px, isim: 16px→18px                                  | Claude |

---

### Sprint 1 — Temel Altyapı

| Görev                                    | Kim    |
| ---------------------------------------- | ------ |
| Proje kurulumu (Flutter 3.41, Dart 3.11) | Claude |
| Provider state management kurulumu       | Claude |
| SQLite (sqflite) entegrasyonu            | Claude |
| Google Fonts (Inter)                     | Claude |
| Temel tema + dark/light mode             | Claude |

### Sprint 2 — Onboarding & Profil

| Görev                                           | Kim    |
| ----------------------------------------------- | ------ |
| Onboarding ekranı (isim, yaş, boy, kilo, hedef) | Claude |
| Aktivite seviyesi seçimi                        | Claude |
| Kalori hedefi hesaplama (Harris-Benedict)       | Claude |
| Profil ekranı                                   | Claude |
| Su takibi                                       | Claude |

### Sprint 3 — AI Analiz Çekirdeği

| Görev                                         | Kim    |
| --------------------------------------------- | ------ |
| Claude API entegrasyonu (görüntü analizi)     | Claude |
| Kamera + galeri fotoğraf seçimi               | Claude |
| AI yemek analizi (kalori, protein, karb, yağ) | Claude |
| Analiz sonuç ekranı                           | Claude |
| Öğün kaydetme (DB)                            | Claude |

### Sprint 4 — UX & Ekstra Özellikler

| Görev                               | Kim    |
| ----------------------------------- | ------ |
| Streak sistemi                      | Claude |
| Favoriler (sık kullanılan yemekler) | Claude |
| Hatırlatıcılar (local notification) | Claude |
| Settings ekranı                     | Claude |
| RevenueCat ilk kurulum (temel)      | Claude |

### Sprint 5 — Büyük Özellikler

| Görev                                                       | Kim           |
| ----------------------------------------------------------- | ------------- |
| L10n: 10 dil × 187+ key                                     | Gemini        |
| Apple Health yazma + Settings toggle                        | Claude        |
| Barkod tarayıcı (mobile_scanner + Open Food Facts API)      | Claude        |
| iOS Widget (SwiftUI, containerBackground fix)               | Claude        |
| Multi-provider AI: GPT-4o → Gemini 2.5 Flash → Claude Haiku | Claude        |
| Porsiyon picker (gram slider + pişirme yöntemi)             | Claude        |
| flutter_dotenv: .env'den runtime key okuma                  | Claude+Gemini |

### Sprint 6 — Stabilizasyon & App Store Hazırlık

| Görev                                                           | Kim          | Tarih        |
| --------------------------------------------------------------- | ------------ | ------------ |
| Analiz sonucu düzenleme + gram slider                           | Gemini       | Sprint 6     |
| Kilo takibi DB + grafik                                         | Gemini       | Sprint 6     |
| Responsive mimari (flutter_screenutil)                          | Gemini       | Sprint 6     |
| Android kamera izni (AndroidManifest)                           | Gemini       | Sprint 6     |
| Android widget                                                  | Gemini       | Sprint 6     |
| Haftalık/Aylık progress grafikleri (fl_chart)                   | Claude       | Sprint 6     |
| AI prompt öğün adı iyileştirmesi                                | Claude       | Sprint 6     |
| Hardcoded string → l10n fix                                     | Claude       | Sprint 6     |
| Bundle ID: com.ai.eatiq → com.fatihaydogdu.eatiq                | Claude       | 2 Nisan 2026 |
| App Group ID: group.com.ai.eatiq → group.com.fatihaydogdu.eatiq | Claude       | 2 Nisan 2026 |
| RevenueCat kurulum (App Store + RC dashboard)                   | Fatih+Claude | 2 Nisan 2026 |
| RevenueCat satın alma akışı bağlandı (gerçek kod)               | Claude       | 2 Nisan 2026 |
| kUseMockData = false                                            | Claude       | 2 Nisan 2026 |
| Onboarding aktivite sayfası overflow fix                        | Claude       | 2 Nisan 2026 |
| App Store metadata 10 dil (.claude/APPSTORE_METADATA.md)        | Claude       | 2 Nisan 2026 |
| Xcode Thin Binary cycle hatası fix (Podfile post_install)       | Claude       | 2 Nisan 2026 |
| EatiqWidgetExtension imza takımı düzeltme                       | Claude       | 2 Nisan 2026 |

---

## 📋 GÖREV DETAYLARI

---

### Görev I — Apple Health Okuma → UI Entegrasyonu

**OWNER: Gemini** | **Öncelik: 🔴 ACİL**
**Dosyalar:** `lib/services/app_provider.dart`, `lib/screens/home_screen.dart`, `lib/screens/progress_screen.dart`

`health_service.dart`'ta şu metodlar HAZIR (dokunma):

- `getTodayActiveCalories()` → bugün yakılan kcal
- `getTodaySteps()` → adım sayısı
- `getLatestBodyWeight()` → son kilo (kg)

**app_provider.dart'a ekle:**

```dart
double _activeCalories = 0;
int _todaySteps = 0;
double get activeCalories => _activeCalories;
int get todaySteps => _todaySteps;

// loadTodayStats() içine ekle:
if (_healthEnabled) {
  _activeCalories = await _healthService.getTodayActiveCalories();
  _todaySteps = await _healthService.getTodaySteps();
  final latestWeight = await _healthService.getLatestBodyWeight();
  if (latestWeight != null && latestWeight > 0) {
    final logs = await _dbService.getWeightLogs();
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final hasTodayLog = logs.any((l) => l['date'] == todayStr);
    if (!hasTodayLog) await _dbService.saveWeight(latestWeight, DateTime.now());
  }
}
```

**home_screen.dart'a ekle** (kalori ring'inin altına):

```dart
if (provider.healthEnabled && provider.activeCalories > 0)
  Text('🔥 ${provider.activeCalories.toStringAsFixed(0)} kcal yaktın  ·  👟 ${provider.todaySteps} adım')
```

**progress_screen.dart'a ekle** (günlük tab kalori kartına):

```
Net: [yenilen - yakılan] kcal
```

**ARB key'leri (app_tr.arb'a yaz, sonra 9 dile çevir):**

```json
"activeCaloriesBurned": "Bugün {cal} kcal yaktın",
"todaySteps": "{steps} adım",
"netCalories": "Net: {net} kcal"
```

---

### Görev 13 — Voice Logging

**OWNER: Claude** | **Öncelik: 🟡 BUGÜN/YARIN**
**Dosyalar:** `lib/services/voice_logging_service.dart` (yeni), `lib/screens/home_screen.dart`

**Akış:**

1. Home screen'de mikrofon butonu (scan butonunun yanında)
2. Kullanıcı konuşur → `speech_to_text` paketi metne çevirir
3. Metin AI'a gönderilir: "Öğle yemeğinde ızgara tavuk ve pilav yedim, 1 bardak ayran içtim"
4. AI JSON döner (her yiyecek için kalori/makro)
5. Normal analiz sonuç ekranına yönlendirilir

**Kullanılacak paket:** `speech_to_text` (pubspec'e eklenecek)
**Dil desteği:** Türkçe (`tr_TR`) + İngilizce (`en_US`) — cihaz diline göre otomatik

**Backlog — Görev 14 — ARKit/LiDAR Porsiyon Ölçümü**

- iPhone 12 Pro+ cihazlarda LiDAR ile yemek hacmi tahmini
- Flutter tarafı: native Swift köprüsü gerekiyor (`arkit_flutter_plugin` bakımsız)
- Hacim → gram: yoğunluk tahmini için ayrıca AI prompt gerekiyor
- Önce "el/tabak referansı" yaklaşımı denenecek (LiDAR gerekmez, tüm cihazlar)

---

### Görev 7 — Günlük AI Bildirimi

**OWNER: Claude** | **Öncelik: 🟡**
**Dosyalar:** `lib/services/notification_service.dart`, `lib/services/ai_service.dart`

- Her akşam 20:00: "Bugün X kcal aldın, Y kcal kaldı"
- Pazar 20:00: Haftalık trend özeti (AI üretir)
- Kullanıcı saati settings'ten değiştirebilir

---

### Görev 12 — Geçmişten Hızlı Ekle

**OWNER: Claude** | **Öncelik: 🟡**
**Dosyalar:** `lib/screens/history_screen.dart`, `lib/services/app_provider.dart`

- History ekranında her öğün kartına "Bugüne Ekle" butonu
- `copyAsNew()` metodu: aynı öğünü bugünün tarihiyle DB'ye kaydet
- Toast: "Öğün bugüne eklendi"

---

### Görev 6 — App Store Screenshots

**OWNER: Gemini** | **Öncelik: 🟢**

- 6.7" (iPhone 15 Pro Max) ve 5.5" (iPhone 8 Plus) ekran görüntüleri
- Her ekran için TR + EN başlık metni
- Metadata hazır: `.claude/APPSTORE_METADATA.md`

---

### Görev 10 — ARB Çevirileri (Sürekli)

**OWNER: Gemini** | **Sürekli görev**

Claude yeni key eklediğinde `lib/l10n/app_tr.arb`'a yazar.
Gemini diğer 9 dile çevirir: `app_en`, `app_de`, `app_fr`, `app_es`, `app_ar`, `app_pt`, `app_ru`, `app_it`, `app_ka`

---

## 🏗️ TEKNİK REFERANS

**Bundle ID:** `com.fatihaydogdu.eatiq`
**App Group:** `group.com.fatihaydogdu.eatiq`
**RevenueCat Entitlement:** `eatiq Premium`
**Products:** `com.fatihaydogdu.eatiq.premium.monthly` / `.yearly`
**RC iOS Key:** `.env` → `RC_IOS_KEY`

**AI Zinciri:** GPT-4o → Gemini 2.5 Flash → Claude Haiku (fallback)
**Tüm key'ler:** `.env` dosyasından `flutter_dotenv` ile okunur

**Tech Stack:**

- Flutter 3.41 · Dart 3.11
- SQLite (sqflite) — lokal DB
- Provider — state management
- RevenueCat (purchases_flutter) — abonelik
- flutter_dotenv — runtime key yönetimi
- flutter_screenutil — responsive layout
- fl_chart — grafikler
- mobile_scanner — barkod
- health — Apple Health
- flutter_local_notifications — bildirimler

**Fiyatlandırma:**

- Aylık: 79,99 TRY / $3,99 USD
- Yıllık: 499,99 TRY / $19,99 USD

- uida düzeltilecek yerler
- login register ekranları apple facebook google
- mock data eklenecek
- geri tuşu sıkıntısı
- dark light renkleri gözden geçirilecek
- bir akış diagramı oluşturacağız figma ya da excalidraw
- satın alma akışı nerede??
- logout akışı
- aia kendimiz istek atmayacağız bu kısımları komple sileceğiz
- splash ekranı istekleri localization backende taşınacak
- anasayfadaki tarih geçmişe gidilecek en sağda olacak güncel tarih
- navbardaki en sağdaki buton profil olacak profilin altında settings olacak şekilde ayarlanacak diğer tasarımda yaptığımız gibi
- ilk yüklemede temayı cihaz temasından alacak onboardingde istediğini seçebilecek

- privacy policy sayfası
- terms of conditions
- restore purchase diyince nolacak
- satın alma ekranına tekrar bakılacak
- uygulamayı kaldırdım yeniden debug başlattım neden onboardingden başladı getstarteddan başlaması lazımdı
- debug sessionda aktif hangi ekrandaysak ekran adını debug console a yazdır
- login veya register olurken zaten kullanıcının adını alıyoruz onboardingten kaldıralım
- onboardingde calorie goal neden var onu sorgulayalım kalori goali en son vermemiz lazım değil mi
- yemeğin resmini çektikten veya galeriden çektikten sonra sadece ortalama porsiyon büyüklüğünü kullanıcıya soralım bir scroll bar ile,

-diyet listesi oluşturma onboarding
food restriction
cusine preference silinecek
cooking budget sayfası silinecek
arayıp arattığını tag gibi seçecek - foodstan çekecek yani searchten çekecek bir iki kelimelik tagler şeklinde istemediği şeyleri kullanıcı seçecek
