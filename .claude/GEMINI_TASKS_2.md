# Gemini Görev Listesi — Sprint 6 Yeni Görevler

> Her görev için ayrı commit+push at. `dart analyze lib/` ile hata kontrol et. SPRINT.md'yi güncelle.

---

## Görev A — Uygulama Genelinde Text Boyutları
**Dosyalar:** `lib/theme/app_theme.dart`, tüm screen dosyaları

### Sorun:
Home screen'deki "Merhaba, [isim]" başlık satırı gibi büyük yazılar güzel görünüyor ama diğer ekranlarda (progress, profile, settings, history) yazılar küçük kalıyor. Tutarsızlık var.

### Ne yapılacak:
`lib/theme/app_theme.dart` dosyasında `AppTypography` class'ı var. Bu class'taki font size değerlerini kontrol et. Şu an `flutter_screenutil` paketi kullanılıyor (`16.sp`, `14.sp` gibi).

Tüm ekranlarda şu hiyerarşiyi uygula:
- Sayfa başlığı (SliverAppBar title): `22.sp`, `FontWeight.w800`
- Bölüm başlığı (section header): `15.sp`, `FontWeight.w700`
- Kart başlığı: `14.sp`, `FontWeight.w700`
- Gövde metni: `13.sp`, `FontWeight.w500`
- Yardımcı metin (muted): `12.sp`, `FontWeight.w400`

Kontrol et ve tutarsız olan ekranları düzelt. Özellikle:
- `profile_screen.dart` — isim ve istatistik yazıları
- `settings_screen.dart` — başlık ve açıklama yazıları
- `progress_screen.dart` — kart değerleri ve etiketler
- `history_screen.dart` — tarih grupları ve öğün adları

---

## Görev B — Ana Sayfada Öğün Kartı Kalori Kutucuğu
**Dosya:** `lib/screens/home_screen.dart`

### Sorun:
Result screen'deki kalori değeri siyah/koyu bir kutucuk içinde büyük ve belirgin görünüyor. Home screen'deki öğün listesi kartlarında ise kalori değeri düz metin olarak yazılıyor.

### Ne yapılacak:
`home_screen.dart`'ta öğün listesi kartlarını bul (günlük öğün listesi, `_MealCard` veya benzeri widget). Kalori değerini şu tasarıma uygun bir kutucuk içine al:

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  decoration: BoxDecoration(
    color: isDark ? AppColors.darkBg : AppColors.lightSurface,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
      Text(
        '${calories.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.lime : AppColors.limeDeep,
        ),
      ),
      Text('kcal', style: TextStyle(fontSize: 10, color: textMuted)),
    ],
  ),
)
```

---

## Görev C — Result Screen Alt Buton Değişikliği
**Dosya:** `lib/screens/result_screen.dart`

### Sorun:
"Günlüğe Eklendi" butonu kafa karıştırıcı çünkü analiz zaten otomatik kaydediliyor. Kullanıcı "bu butona basmazsam kaydedilmez mi?" diye düşünüyor.

### Ne yapılacak:
"Günlüğe Eklendi" butonunu **"Tamam, Ana Sayfaya Dön"** olarak değiştir.
- İkon: `Icons.check_circle_outline_rounded`
- Stil aynı kalsın (lime arka plan, koyu yazı)
- Davranış aynı: `Navigator.pop(context, false)`

Butonun hemen üstüne küçük bir bilgi notu ekle:
```dart
Text(
  'Öğün otomatik olarak kaydedildi.',
  style: TextStyle(fontSize: 11, color: textMuted),
  textAlign: TextAlign.center,
)
```

**ARB key ekle:**
```json
"backToHome": "Ana Sayfaya Dön",
"mealAutoSaved": "Öğün otomatik olarak kaydedildi."
```

---

## Görev D — Streak Sistemi Anlamlı Hale Getirme
**Dosyalar:** `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`

### Streak neden var:
Streak = ardışık gün tarama sayısı. Kullanıcıyı her gün uygulamayı kullanmaya motive eder. Retention için kritik bir gamification öğesi.

### Sorun:
Şu an sadece küçük bir 🔥 badge olarak görünüyor, kullanıcı ne anlama geldiğini anlamıyor. Daha anlamlı hale getirelim.

### Ne yapılacak:

**1. Home screen streak badge'ini geliştir:**
Şu anki basit badge'in üstüne veya yanına tıklanabilir yap. Tıklayınca küçük bir tooltip/snackbar çıksın:
```
"🔥 3 günlük seri! Her gün kayıt yaparak serisini koru."
```

**2. Profile screen'e streak kartı ekle:**
Vücut Analizi kartının yanına veya altına küçük bir "Seri" kartı ekle:
```
🔥 [streak] Günlük Seri
"En uzun serinizi kırmayın!"
```

**3. Milestone bildirimleri (isteğe bağlı, yaparsan güzel):**
- 7 gün streak: "🎉 1 haftalık seri! Harika gidiyorsun."
- 30 gün streak: "🏆 1 aylık seri! İnanılmaz bir başarı."

**ARB key ekle:**
```json
"streakDays": "{count} Günlük Seri",
"streakMotivation": "Her gün kayıt yaparak serisini koru!",
"streakMilestone7": "1 haftalık seri! Harika gidiyorsun. 🎉",
"streakMilestone30": "1 aylık seri! İnanılmaz bir başarı. 🏆"
```

---

## Görev E — Onboarding Genişletme (4 → 8 Sayfa)
**Dosya:** `lib/screens/onboarding_screen.dart`

### Mevcut durum:
4 sayfa: İsim → Vücut ölçüleri → Hedef → Tema

### Yeni yapı (8 sayfa):
```
1. Hoş Geldin + İsim  (mevcut _PageName)
2. Vücut Ölçüleri     (mevcut _PageBody — boy, kilo, yaş, cinsiyet)
3. Hedef              (mevcut _PageGoal — kilo ver/al/koru)
4. Aktivite Seviyesi  (YENİ)
5. Beslenme Tercihleri (YENİ)
6. Hatırlatıcılar     (YENİ)
7. Apple Health İzni  (YENİ)
8. Tema Seçimi        (mevcut _PageTheme)
```

### Yeni sayfalarda ne olacak:

**Sayfa 4 — Aktivite Seviyesi:**
```
Başlık: "Ne kadar aktifsiniz?"
Seçenekler (chip):
  - 🛋️ Hareketsiz (masa başı iş, az egzersiz)
  - 🚶 Az Aktif (haftada 1-3 gün egzersiz)
  - 🏃 Orta Aktif (haftada 3-5 gün egzersiz)
  - 💪 Çok Aktif (haftada 6-7 gün)
  - 🏋️ Sporcu (günde 2x)
```
State: `String _activityLevel = 'sedentary'`
Değerler: `'sedentary'`, `'light'`, `'moderate'`, `'active'`, `'veryActive'`
SharedPreferences'e kaydet: `'activityLevel'`
Bu değer TDEE hesaplamasında kullanılacak — `app_provider.dart`'taki `saveProfile`'a `activityLevel` parametresi ekle, TDEE çarpanını buna göre ayarla:
- sedentary: × 1.2
- light: × 1.375
- moderate: × 1.55
- active: × 1.725
- veryActive: × 1.9

**Sayfa 5 — Beslenme Tercihleri:**
```
Başlık: "Beslenme tercihiniz var mı?"
Alt başlık: "AI analizlerimizi kişiselleştireceğiz"
Seçenekler (çoklu seçim, chip):
  - 🥩 Standart (hiçbir kısıtlama yok)
  - 🌱 Vejetaryen
  - 🌿 Vegan
  - 🐟 Pescatarian
  - 🌾 Glutensiz
  - 🥛 Laktozsuz
  - 🕌 Helal
  - 🕍 Koşer
```
State: `List<String> _dietPreferences = []`
SharedPreferences'e kaydet: `'dietPreferences'` (JSON string olarak)
Bu değerler AI prompt'una eklenecek — `ai_service.dart`'taki `_buildPrompt`'a `dietPreferences` parametresi ekle.

**Sayfa 6 — Hatırlatıcılar:**
```
Başlık: "Öğün hatırlatıcıları"
Alt başlık: "Günlük kayıtlarını unutma"
Toggle'lar:
  - 🌅 Kahvaltı hatırlatıcısı  [08:00] [toggle]
  - ☀️ Öğle hatırlatıcısı      [12:30] [toggle]
  - 🌙 Akşam hatırlatıcısı     [19:00] [toggle]
```
Toggle açıksa saat göster (tıklanabilir, TimePicker açar).
Kaydet butonu: seçimleri SharedPreferences'e yaz, notification_service'i çağır.
Not: Bu işlevsellik zaten settings_screen'de var, aynı mantığı kullan.

**Sayfa 7 — Apple Health:**
```
Başlık: "Apple Health bağlansın mı?"
Alt başlık: "Kalori ve su verileriniz otomatik senkronize edilsin"
İkon: ❤️ (kırmızı kalp)
Açıklama: "Yemek analizleriniz ve su takibiniz Apple Health'e otomatik yazılacak. İstediğiniz zaman kapatabilirsiniz."
İki buton:
  - [Evet, Bağla] → health_service.requestPermissions() çağır
  - [Şimdi Değil] → geç
```
Bu sayfa sadece iOS'ta gösterilsin: `Platform.isIOS` kontrolü ekle.

### Kod değişiklikleri:
- `onboarding_screen.dart`'ta `_page < 3` → `_page < 7` yap
- `'${_page + 1} / 4'` → `'${_page + 1} / 8'` yap
- PageView children'a yeni sayfaları ekle
- `_next()` metodunda son sayfa kontrolünü güncelle: `if (_page < 7)`
- `saveProfile` çağrısına yeni parametreler ekle

**ARB key'leri:**
```json
"onboardingActivity": "Ne kadar aktifsiniz?",
"onboardingActivitySub": "Günlük kalori hedefinizi hesaplayalım",
"activitySedentary": "Hareketsiz",
"activityLight": "Az Aktif",
"activityModerate": "Orta Aktif",
"activityActive": "Çok Aktif",
"activityVeryActive": "Sporcu",
"onboardingDiet": "Beslenme tercihiniz var mı?",
"onboardingDietSub": "AI analizlerimizi kişiselleştireceğiz",
"onboardingReminders": "Öğün hatırlatıcıları",
"onboardingRemindersSub": "Günlük kayıtlarını unutma",
"onboardingHealth": "Apple Health bağlansın mı?",
"onboardingHealthSub": "Kalori ve su verileriniz otomatik senkronize edilsin",
"onboardingHealthConnect": "Evet, Bağla",
"onboardingHealthSkip": "Şimdi Değil"
```

---

## Görev F — Progress Ekranı İyileştirmeleri
**Dosya:** `lib/screens/progress_screen.dart`

### Sorun 1: 30 günlük grafik alt yazıları birbirine giriyor
X eksenindeki tarih etiketleri (gün/ay) üst üste biniyor.

**Çözüm:**
`getMonthlyStats` 30 veri noktası döndürüyor. Her birini yazmak yerine interval artır:
```dart
interval: 7, // Her 7 günde bir etiket göster
```
Veya sadece haftabaşlarını (Pazartesi) göster. Ya da tarihleri 45 derece eğik yaz:
```dart
getTitlesWidget: (value, meta) {
  // sadece 0, 7, 14, 21, 28. indexleri göster
  if (value.toInt() % 7 != 0) return SizedBox.shrink();
  ...
}
```

### Sorun 2: Daha bilgilendirici içerik
Her tab'a (Günlük, Haftalık, Aylık) küçük özet kartları ekle.

**Haftalık tab için:**
- "Bu hafta en çok yenilen: [en sık tekrar eden öğün adı]" (DB'den query)
- "Ortalama günlük protein: X g"
- "Hedef tutturma oranı: %X" (kaç gün kalori hedefine ulaşıldı / 7)

**Aylık tab için:**
- "Bu ay toplam: X kcal"
- "En iyi gün: [tarih] — X kcal (hedefe en yakın)"
- "30 günlük trend: ↑ artıyor / ↓ azalıyor / → stabil"

**Günlük tab için:**
- Makro breakdown'a yüzde ekle: "Protein: 45g (%18)"
- Su hedefine ulaşma yüzdesi: "Su: 1.8L / 2.5L (%72)"

**database_service.dart'a yeni sorgu ekle:**
```dart
Future<String?> getMostFrequentMealThisWeek() async {
  // Son 7 gündeki analyses tablosunda en sık geçen food name
}
Future<int> getGoalAchievementCount(int days) async {
  // Son X günde kalori hedefine ulaşılan gün sayısı
}
```

**ARB key'leri:**
```json
"weeklyMostEaten": "Bu hafta en çok: {meal}",
"goalAchievementRate": "Hedef tutturma: %{rate}",
"monthlyTotal": "Bu ay toplam {calories} kcal",
"trendIncreasing": "↑ Artış trendi",
"trendDecreasing": "↓ Azalış trendi",
"trendStable": "→ Stabil"
```

---

## Görev G — Fotoğraf Kaybolma Sorunu
**Dosyalar:** `lib/screens/home_screen.dart`, `lib/services/app_provider.dart`

### Sorun:
`image_picker` ile çekilen fotoğraf geçici bir cache dizinine kaydediliyor (`/tmp/` veya benzeri). Uygulama yeniden başlatılınca bu dosyalar silinebiliyor. Bu yüzden geçmiş öğünlerdeki fotoğraflar kayboluyor.

### Çözüm:
Fotoğraf seçildikten sonra, analiz göndermeden önce, kalıcı uygulama dizinine kopyala.

**`home_screen.dart`'taki `_pickImage` metoduna ekle:**
```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<void> _pickImage(ImageSource source) async {
  final picked = await _picker.pickImage(...);
  if (picked == null || !mounted) return;

  // Kalıcı dizine kopyala
  final appDir = await getApplicationDocumentsDirectory();
  final fileName = 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final savedPath = p.join(appDir.path, 'meals', fileName);
  await Directory(p.join(appDir.path, 'meals')).create(recursive: true);
  await File(picked.path).copy(savedPath);

  // Porsiyon sheet
  final result = await showModalBottomSheet(...);
  if (result == null || !mounted) return;

  await provider.analyzeImage(savedPath, ...); // picked.path yerine savedPath
  ...
}
```

`path_provider` paketi zaten `pubspec.yaml`'da var mı kontrol et. Yoksa ekle.

---

## Görev H — Su Ekleme Tasarım Hatası
**Dosya:** `lib/screens/home_screen.dart`

### Sorun:
Su ekleme sheet'inde (veya home screen'deki su bölümünde) bir görsel tasarım sorunu var. Muhtemelen pill/kart boyutları, renk veya layout bozukluğu.

### Ne yapılacak:
`home_screen.dart`'ta su bölümünü bul (muhtemelen `_WaterSection` veya `waterToday` etrafındaki widget). Şunları kontrol et ve düzelt:
- Su progress bar veya pill'in rengi tema ile uyumsuzsa düzelt
- "0.0L" yazısının container'ı çok büyük veya küçükse hizala
- Su ekleme butonlarının padding/margin'i tutarsızsa düzelt
- Dark/light modda renk geçişi bozuksa düzelt

Su bölümünü şu tasarıma uygun hale getir:
```
[💧 Su Takibi]
[━━━━━━━━━━░░░] 1.5L / 2.5L
[+250ml] [+500ml] [+750ml] [Özel]
```
Butonlar eşit genişlikte, hafif rounded, accent rengi (cyan/mavi).

---

## Genel Kurallar
- Her görev için ayrı commit: `feat: Görev [Harf] - açıklama`
- `dart analyze lib/` hata yok olmalı
- `app_provider.dart`'a yeni state eklerken mevcut yapıyı bozma
- Yeni ARB key'leri önce `app_tr.arb`'a ekle, sonra diğer 9 dile çevir
- Bitince Claude'a rapor ver, özellikle `app_provider.dart` değişikliklerini detaylı anlat

---

## Görev I — Apple Health Okuma Entegrasyonu
**Öncelik: 🟡 ÖNEMLİ**
**Dosyalar:** `lib/services/app_provider.dart`, `lib/screens/home_screen.dart`, `lib/screens/progress_screen.dart`

### Arka Plan:
`health_service.dart`'a 3 yeni READ metodu eklendi (Claude tarafından):
- `getTodayActiveCalories()` → bugün yakılan aktif kalori (kcal)
- `getTodaySteps()` → bugün atılan adım sayısı
- `getLatestBodyWeight()` → en son kaydedilen vücut ağırlığı (kg)

### Ne Yapılacak:

**1. app_provider.dart'a state ekle:**
```dart
double _activeCalories = 0;
int _todaySteps = 0;

double get activeCalories => _activeCalories;
int get todaySteps => _todaySteps;
double get netCalories => todayCalories - _activeCalories; // yenilen - yakılan
```

**2. loadTodayStats() içine health okuma ekle:**
```dart
Future<void> loadTodayStats() async {
  _todayStats = await _dbService.getTodayStats();
  // Health verilerini arka planda yükle
  if (_healthEnabled) {
    _activeCalories = await _healthService.getTodayActiveCalories();
    _todaySteps = await _healthService.getTodaySteps();
    // Eğer Health'ten kilo geldiyse ve kullanıcı bugün kilo girmemişse güncelle
    final latestWeight = await _healthService.getLatestBodyWeight();
    if (latestWeight != null && latestWeight > 0) {
      // Sadece son 24 saatte kilo log yoksa güncelle
      final logs = await _dbService.getWeightLogs();
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}';
      final hasTodayLog = logs.any((l) => l['date'] == todayStr);
      if (!hasTodayLog) {
        await _dbService.saveWeight(latestWeight, today);
      }
    }
  }
  notifyListeners();
  unawaited(_syncWidget());
}
```

**3. Home screen'de göster:**
Health aktifse ve `activeCalories > 0` ise ana sayfada kalori ring'inin altına küçük bir satır ekle:
```
🔥 Bugün 320 kcal yaktın  · 👟 4.250 adım
```
Stil: küçük, muted renk, kalori ring'inin hemen altında.

**4. Progress screen'de net kalori göster:**
Günlük tab'da kalori kartının yanına:
```
Net: [yenilen - yakılan] kcal
```
Yeşil = pozitif (hedef altında), kırmızı = negatif (hedef üstü).

**ARB key'leri ekle (app_tr.arb + 9 dil):**
```json
"activeCalories": "Bugün {cal} kcal yaktın",
"todaySteps": "{steps} adım",
"netCalories": "Net: {net} kcal"
```

### Dikkat:
- Health devre dışıysa (`_healthEnabled == false`) bu alanlar görünmez
- Tüm Health çağrıları try/catch ile sarılı, hata fırlatmaz
- `health_service.dart`'a dokunma, sadece mevcut metodları çağır
