# Auth Flow & Splash Screen Updates

Bu aşamada hedeflenen, kullanıcının doğrudan karşılama (splash) ekranından onboarding yerine öncelikle Kayıt/Giriş (Auth) sistemine yönlendirilmesidir. Ayrıca, Splash ekranındaki revizyonlar yapılacaktır.

## User Review Required

> [!WARNING]
> Şuan projede **Firebase Auth** veya tam teşekküllü bir Backend bağlı görünmüyor. Sunulan akış, "UI olarak tamamen fonksiyonel ve validasyonlu" formları barındıracak, state ise şimdilik yerel `SharedPreferences` (ve mock) üzerinden yürütülecektir. Eğer hazırlanan `eatiq-backend` uç noktalarına doğrudan entegre etmemi isterseniz bunu onay sonrası planlayabiliriz. Şimdilik arayüzü ve navigasyon kurallarını uygulayacağım.

## Proposed Changes

---

### UI & Flow Changes

#### [MODIFY] [splash_screen.dart](file:///Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/lib/screens/splash_screen.dart)
- "Already have an account? Sign in" yazısı kaldırılacak.
- Sağ üst köşeye bir **Dil Seçme Butonu** eklenecek (Kullanıcı diller arası geçiş yapabilecek).
- "Get Started" butonu artık `OnboardingScreen`'e değil, yeni oluşturacağımız `AuthScreen`'e yönlendirecek.
- Uygulama ilk açıldığında `isLoggedIn` ve `isOnboardingDone` kontrolleri yapılarak doğru ekrana geçiş otomatize edilecek.

#### [NEW] [auth_screen.dart](file:///Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/lib/screens/auth/auth_screen.dart)
- Kullanıcıya şu seçenekler sunulacak:
  - Continue with Apple
  - Continue with Google
  - Continue with Facebook
  - Sign Up with Email
  - Login with Email
- Tasarım konseptini Splash'teki fütürist premium görünüme sadık kalarak, şık butonlar ve şeffaf katmanlarla tasarlanacak.

#### [NEW] [register_screen.dart](file:///Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/lib/screens/auth/register_screen.dart)
- İsim, Soyisim, Email, Şifre, Şifre Doğrulama alanlarını içeren form.
- Form validasyonları (Email format kontrolü, Şifrelerin eşleşmesi durumu) yapılacak.
- Başarılı kayıt sonrası: `isLoggedIn = true` yapılır ve `OnboardingScreen`'e geçilir. 

#### [NEW] [login_screen.dart](file:///Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/lib/screens/auth/login_screen.dart)
- Email ve Şifre alanları bulunacak.
- Başarılı giriş sonrası `AppProvider`'daki `isOnboardingDone()` kontrol edilecek:
  - Eğer kullanıcı dataları (onboarding) tamsa -> `HomeScreen`
  - Eğer eksikse -> `OnboardingScreen`

---

### Business Logic

#### [MODIFY] [app_provider.dart](file:///Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/lib/services/app_provider.dart)
- `bool isLoggedIn()` ve `Future<void> setLoggedIn(bool)` mantığı eklenecek.
- Auth durumunu bellekte tutacak fonksiyonlar hazırlanacak.
- Splash başlangıcındaki kontrol akışı `isLoggedIn`'i de dahil edecek şekilde güncellenecek.

## Open Questions

- Şimdilik Mock (örnek) Auth sistemi ile mi ilerleyelim yoksa backend servisinizde hazır uç noktalar (/login, /register) var mı? (Cevap vermezseniz Mock UI ile akışı harika bir tasarımla hazırlayacağım.)
- Google/Apple login butonlarında kullanılan ikonlar için `font_awesome_flutter` eklentisini `pubspec.yaml`'a eklemem uygun mudur?

## Verification Plan

### Manual Verification
- Splash ekranında dil butonunun çalışması test edilecek.
- Get Started'a basılınca AuthScreen açıldığı doğrulanacak.
- Register sırasında boş alan, hatalı email veya eşleşmeyen şifre uyarılarının (validasyonların) çıkıp çıkmadığı kontrol edilecek.
- Kayıt sonrası -> Onboarding. Giriş sonrası -> Kayıtlar mevcutsa Home ekranına geçiş doğrulanacak.
