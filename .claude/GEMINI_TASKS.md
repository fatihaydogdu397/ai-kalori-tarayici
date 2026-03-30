# Gemini Görev Listesi — Sprint 6 Devamı

> Bu dosyayı oku, görevleri sırayla yap. Her görev bitince commit + push at. SPRINT.md'deki ilgili satırı ✅ yap.

---

## Görev #11 — PurchaseService dotenv'e Geçiş
**Öncelik: 🔴 KRİTİK**
**Dosya:** `lib/services/purchase_service.dart`

### Şu an ne var:
```dart
static const _iosKey = String.fromEnvironment('RC_IOS_KEY', defaultValue: '');
static const _androidKey = String.fromEnvironment('RC_ANDROID_KEY', defaultValue: '');
```
`String.fromEnvironment` sadece `--dart-define` ile çalışır. Biz artık `flutter_dotenv` kullanıyoruz.

### Ne yapılacak:
1. `purchase_service.dart` dosyasına `import 'package:flutter_dotenv/flutter_dotenv.dart';` ekle
2. `static const` satırlarını şöyle değiştir:
```dart
static String get _iosKey => dotenv.env['RC_IOS_KEY'] ?? '';
static String get _androidKey => dotenv.env['RC_ANDROID_KEY'] ?? '';
```
3. `.env` dosyasına (proje kökünde) şu satırları ekle (değerler boş kalacak, Fatih dolduracak):
```
RC_IOS_KEY=
RC_ANDROID_KEY=
```

### Dikkat:
- `.env` zaten `.gitignore`'da var, commit'e girmez ama pubspec.yaml'da assets'e ekli, build'e girer. Sorun yok.
- `static const` → `static String get` olacak çünkü dotenv runtime'da okunur, compile-time'da değil.

---

## Görev #12 — Geçmişten / Favorilerden Bugüne Ekle
**Öncelik: 🟡 ÖNEMLİ**
**Dosyalar:** `lib/screens/history_screen.dart`, `lib/screens/home_screen.dart`

### Ne yapılacak:
History ekranındaki her öğün kartına ve home ekranındaki favoriler şeridine **"Bugüne Ekle"** butonu ekle.

**Davranış:**
- Butona basınca o `FoodAnalysis` objesi `provider.saveManualEntry(analysis)` ile bugünkü tarihle yeniden kaydedilsin
- Kaydedilen yeni entry'nin `id`'si yeni bir `DateTime.now().millisecondsSinceEpoch.toString()` olsun (aynı ID'yi tekrar kaydetme, kopya oluştur)
- `analyzedAt` → `DateTime.now()` olarak set edilsin
- Kayıt sonrası kısa bir SnackBar: "Öğüne eklendi ✓" (yeşil)

**FoodAnalysis kopyalama:**
`lib/models/food_analysis.dart` dosyasında zaten `copyWithScaled` var. Bir de `copyAsNew()` metodu ekle:
```dart
FoodAnalysis copyAsNew() {
  return FoodAnalysis(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    imagePath: imagePath,
    foods: foods,
    totalNutrients: totalNutrients,
    summary: summary,
    advice: advice,
    analyzedAt: DateTime.now(),
    mealCategory: mealCategory,
    isFavorite: false,
  );
}
```

**History ekranı — her kart için:**
- Mevcut swipe-to-delete aksiyonunun yanına ikinci bir aksiyon ekle: sola kaydırınca "Bugüne Ekle" (yeşil, takvim ikonu)
- Ya da karta uzun basınca bottom sheet: "Bugüne Ekle" / "Favoriye Ekle" / "Sil"

**Home ekranı favoriler şeridi:**
- Favori kartına küçük bir `+` butonu ekle (sağ alt köşe)
- Basınca `copyAsNew()` + `saveManualEntry()`

**ARB key'leri** (app_tr.arb'a ekle, diğer 9 dile çevir):
```json
"addToToday": "Bugüne Ekle",
"addedToLog": "Öğüne eklendi ✓"
```
Not: `addedToLog` zaten var mı kontrol et, varsa kullan.

---

## Görev #7 — Günlük AI Beslenme Özeti (Dinamik Bildirim)
**Öncelik: 🟡 ÖNEMLİ**
**Dosyalar:** `lib/services/notification_service.dart`, `lib/services/app_provider.dart`

### Şu an ne var:
`notification_service.dart`'ta akşam için static bildirim var:
```dart
NotificationService.scheduleDaily(kNotifDinner, dinnerTime, 'Akşam yemeği! 🌙', 'Günü tamamlamak için akşam yemeğini kaydet.');
```

### Ne yapılacak:
Her akşam 20:00'de çalışacak **dinamik özet bildirimi** ekle.

**Adımlar:**

1. `notification_service.dart`'a yeni bir metod ekle:
```dart
static Future<void> showDailySummary({
  required int calories,
  required int calorieGoal,
  required double water,
  required double waterGoal,
}) async {
  final remaining = calorieGoal - calories;
  String title;
  String body;

  if (calories == 0) {
    title = 'Bugün ne yedin? 🍽️';
    body = 'Öğünlerini Eatiq\'e kaydetmeyi unutma!';
  } else if (remaining > 200) {
    title = 'Günlük özet 📊';
    body = 'Bugün $calories kcal aldın, hedefinize $remaining kcal kaldı.';
  } else if (remaining >= -100) {
    title = 'Harika gün! 🎯';
    body = 'Bugün $calories kcal aldın, hedefinle mükemmel uyum!';
  } else {
    title = 'Dikkat ⚠️';
    body = 'Bugün hedefinizi ${remaining.abs()} kcal aştın.';
  }

  if (water < waterGoal * 0.7) {
    body += ' Su hedefini tamamlamayı unutma! 💧';
  }

  await _plugin.show(99, title, body, _details());
}
```

2. `app_provider.dart`'a `scheduleDailySummary()` metodu ekle. Bu metod her gün 20:00'de `showDailySummary` çağırır. `loadTodayStats()` çağrıldıktan sonra tetiklenebilir.

3. `NotificationService`'te 20:00 için scheduled notification ekle — her gün tetiklensin, tetiklenince o anki günlük veriyi okusun.

**Önemli not:** `scheduleDaily` mevcut metoduna dokunma, sadece yeni bir 20:00 scheduled notification ekle `kNotifSummary = 10` ID ile.

**ARB key'leri** (app_tr.arb'a ekle, 9 dile çevir):
```json
"dailySummaryTitle": "Günlük özet 📊",
"dailySummaryBody": "Bugün {calories} kcal aldın, {remaining} kcal kaldı.",
"dailySummaryPerfect": "Harika gün! 🎯",
"dailySummaryOver": "Bugün hedefinizi {amount} kcal aştın."
```

---

## Görev #6 — App Store Screenshots + Metadata
**Öncelik: 🟢 NICE-TO-HAVE**

### Ne yapılacak:
`.claude/APP_STORE_METADATA.md` adında bir dosya oluştur ve içine yaz:

**TR açıklama** (4000 karakter max):
- Uygulamanın ne yaptığını anlat
- Özellikler listesi (AI analiz, barkod, Apple Health, widget, vs.)
- Premium özellikleri belirt

**EN açıklama** (aynısının İngilizce çevirisi)

**Keywords TR:** (100 karakter max, virgülle ayrılmış)

**Keywords EN:** (100 karakter max)

**Subtitle TR:** (30 karakter max)
**Subtitle EN:** (30 karakter max)

Screenshot için not: Gerçek screenshot'lar Fatih tarafından cihazdan alınacak. Sen sadece metadata metnini hazırla.

---

## Genel Kurallar
- Her görev için ayrı commit at: `feat: Görev #XX - açıklama`
- `app_provider.dart` ve `database_service.dart`'a dokunmadan önce mevcut kodu dikkatlice oku
- `dart analyze lib/` ile hata kontrolü yap
- Biten görevi SPRINT.md'de ✅ olarak işaretle
- Her şey bitince Claude'a rapor ver
