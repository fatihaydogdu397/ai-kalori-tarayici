# App Store Connect + RevenueCat Kurulum Kılavuzu
> Fatih için adım adım rehber. Sırayla yap.
> Bundle ID: `com.fatihaydogdu.eatiq` | Version: `1.0` | Build: `1`

---

## BÖLÜM 1 — App Store Connect'te Uygulama Oluşturma

### 1.1 Yeni Uygulama Ekle
1. [appstoreconnect.apple.com](https://appstoreconnect.apple.com) → giriş yap
2. **My Apps** → `+` → **New App**
3. Doldur:
   - **Platform:** iOS
   - **Name:** eatiq - AI Kalori Tarayıcı
   - **Primary Language:** Turkish
   - **Bundle ID:** `com.fatihaydogdu.eatiq` (dropdown'dan seç — Xcode'dan zaten tanımlı gelir)
   - **SKU:** `eatiq001` (herhangi bir unique string)
4. **Create** tıkla

---

## BÖLÜM 2 — In-App Purchase Ürünleri Tanımlama

### 2.1 Subscription Group Oluştur
1. App sayfasında sol menü → **Monetization** → **Subscriptions**
2. **Create** → Subscription Group Name: `eatiq Premium`
3. **Create** tıkla

### 2.2 Aylık Plan
1. **+** (Add Subscription) tıkla
2. Doldur:
   - **Reference Name:** eatiq Premium Monthly
   - **Product ID:** `com.fatihaydogdu.eatiq.premium.monthly`
3. **Create** → Sonraki sayfada:
   - **Subscription Duration:** 1 Month
   - **Price:** Schedule → seç (örn. 79,99 TRY / $2,99 USD Tier 3)
   - **Localizations → Turkish:**
     - Display Name: `eatiq Premium - Aylık`
     - Description: `AI destekli sınırsız yemek analizi, gelişmiş beslenme takibi`
   - **Localizations → English:**
     - Display Name: `eatiq Premium - Monthly`
     - Description: `Unlimited AI food analysis, advanced nutrition tracking`
4. **Save**

### 2.3 Yıllık Plan
1. Aynı subscription group'a `+` tıkla
2. Doldur:
   - **Reference Name:** eatiq Premium Yearly
   - **Product ID:** `com.fatihaydogdu.eatiq.premium.yearly`
3. **Create** → Sonraki sayfada:
   - **Subscription Duration:** 1 Year
   - **Price:** ~4-5x aylık fiyat (örn. 599,99 TRY / $19,99 USD Tier 18)
   - Localizations aynı şekilde doldur
4. **Save**

> ⚠️ Product ID'leri not al — RevenueCat'e bunları gireceksin.

---

## BÖLÜM 3 — RevenueCat Kurulumu

### 3.1 RevenueCat Hesabı
1. [app.revenuecat.com](https://app.revenuecat.com) → giriş yap / hesap aç

### 3.2 Yeni Proje Oluştur
1. **+ New Project** → Name: `eatiq`

### 3.3 iOS App Ekle
1. Project içinde **+ Add App** → **App Store**
2. Doldur:
   - **App Name:** eatiq
   - **Bundle ID:** `com.fatihaydogdu.eatiq`
3. **Save** → RevenueCat sana **iOS API Key** verecek (Public Key, `appl_...` ile başlar)
4. Bu key'i kopyala → `.env` dosyasına `RC_IOS_KEY=appl_...` olarak ekle

### 3.4 App Store Connect API Bağlantısı
RevenueCat'in server-side doğrulama yapabilmesi için App Store Connect API key lazım:
1. App Store Connect → **Users and Access** → **Integrations** → **App Store Connect API**
2. **+** → Name: `RevenueCat`, Role: `Finance` → **Generate**
3. `.p8` dosyasını indir (sadece 1 kez indirilebilir!)
4. Key ID ve Issuer ID'yi not al
5. RevenueCat → Project Settings → **App Store Connect API** → bu bilgileri gir

### 3.5 Entitlements (Yetkilendirme)
1. RevenueCat → sol menü **Entitlements** → `+`
2. **Identifier:** `premium` (kodda bunu kullanıyoruz)
3. **Save**

### 3.6 Products (Ürünler)
1. RevenueCat → **Products** → `+`
   - Product ID: `com.fatihaydogdu.eatiq.premium.monthly` → App Store'da tanımladığın ile aynı
   - Kaydet
2. Tekrar `+`:
   - Product ID: `com.fatihaydogdu.eatiq.premium.yearly`
   - Kaydet

### 3.7 Offerings (Teklifler)
1. RevenueCat → **Offerings** → `+`
2. **Identifier:** `default`
3. **Add Package** × 2:
   - Package 1: Identifier `$monthly`, Product: `com.fatihaydogdu.eatiq.premium.monthly`
   - Package 2: Identifier `$annual`, Product: `com.fatihaydogdu.eatiq.premium.yearly`
4. **Save**

---

## BÖLÜM 4 — Kod Güncellemesi (Claude yapacak)

Fatih `.env`'e `RC_IOS_KEY` ekledikten sonra Claude şunları yapacak:
- `purchase_service.dart`'ta `kUseMockData = false` yap
- Test satın alma akışını kontrol et

---

## BÖLÜM 5 — Sandbox Test

1. Xcode → **Product → Destination → iPhone** (gerçek cihaz)
2. App Store Connect → **Users and Access** → **Sandbox Testers** → test Apple ID oluştur
3. iPhone'da **Settings → App Store** → Sandbox hesabına giriş yap
4. Uygulamada premium satın almayı dene — gerçek ücret kesilmez

---

## Özet Sıra

```
App Store Connect'te uygulama oluştur
    ↓
Subscription Group + aylık + yıllık plan ekle
    ↓
RevenueCat'te proje + iOS app oluştur → API key al
    ↓
RC_IOS_KEY .env'e ekle → Claude'a haber ver
    ↓
Entitlements + Products + Offerings tanımla
    ↓
Claude kUseMockData = false yapar
    ↓
Sandbox test
```
