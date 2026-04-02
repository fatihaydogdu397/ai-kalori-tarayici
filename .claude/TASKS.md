# eatiq — Master Görev Listesi
> TEK kaynak bu dosyadır. SPRINT.md, GEMINI_TASKS.md, GEMINI_TASKS_2.md artık kullanılmıyor.
> Claude, Gemini ve Fatih buraya bakar. Görev alırken OWNER'ı yaz, bitince ✅ işaretle.

---

## 📌 KURALLAR
1. Görev almadan önce OWNER'ını yaz
2. Aynı dosyaya aynı anda iki AI dokunmasın
3. Her görev ayrı commit: `feat: #N - açıklama`
4. `dart analyze lib/` hata olmadan bitir
5. Yeni ARB key → önce `app_tr.arb`, sonra Gemini 9 dile çevirir

---

## 🔴 ACİL

| # | Görev | Kim | Durum |
|---|-------|-----|-------|
| I | Apple Health okuma → app_provider state + home/progress UI | **Gemini** | ❌ YAPILMADI |
| 4 | RevenueCat sandbox test (StoreKit config) | **Fatih** | 🔄 Devam |

---

## 🟡 AKTİF

| # | Görev | Kim | Durum |
|---|-------|-----|-------|
| 7 | Günlük AI bildirimi — akşam 20:00 dinamik içerik | **Claude** | ⏳ |
| 12 | Geçmişten Hızlı Ekle — `copyAsNew()` + "Bugüne Ekle" butonu | **Claude** | ⏳ |
| 10 | ARB çevirileri (yeni key'ler sürekli geliyor) | **Gemini** | 🔄 Sürekli |

---

## 🟢 SIRA BEKLEYEN

| # | Görev | Kim | Durum |
|---|-------|-----|-------|
| 6 | App Store screenshots (6.7" + 5.5") | **Gemini** | ⏳ |
| 5 | kUseMockData = false | ✅ | Yapıldı (2 Nisan) |

---

## ✅ TAMAMLANAN

| Görev | Kim | Tarih |
|-------|-----|-------|
| Multi-provider AI (GPT-4o → Gemini → Claude) | Claude | Sprint 6 |
| Porsiyon picker (gram slider + pişirme) | Claude | Sprint 6 |
| flutter_dotenv — tüm key'ler .env'den | Claude+Gemini | Sprint 6 |
| iOS Widget containerBackground fix | Claude | Sprint 5 |
| Analiz sonucu düzenleme + gram slider | Gemini | Sprint 6 |
| Kilo takibi DB + grafik | Gemini | Sprint 6 |
| Responsive mimari (flutter_screenutil) | Gemini | Sprint 6 |
| Android kamera izni, Android widget | Gemini | Sprint 6 |
| Bundle ID → com.fatihaydogdu.eatiq | Claude | 2 Nisan |
| App Group ID → group.com.fatihaydogdu.eatiq | Claude | 2 Nisan |
| RevenueCat kurulum (App Store + RC dashboard) | Fatih+Claude | 2 Nisan |
| kUseMockData = false | Claude | 2 Nisan |
| RevenueCat satın alma akışı bağlandı | Claude | 2 Nisan |
| Onboarding aktivite sayfası overflow fix | Claude | 2 Nisan |
| App Store metadata 10 dil | Claude | 2 Nisan |
| L10n: 10 dil × 187+ key | Gemini | Sprint 5 |
| Barkod tarayıcı | Claude | Sprint 5 |
| Apple Health yazma + Settings toggle | Claude | Sprint 5 |

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

**ARB key'leri:**
```json
"activeCaloriesBurned": "Bugün {cal} kcal yaktın",
"todaySteps": "{steps} adım",
"netCalories": "Net: {net} kcal"
```

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

Claude yeni key eklediğinde `app_tr.arb`'a yazar.
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
