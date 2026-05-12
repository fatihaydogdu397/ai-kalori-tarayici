import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/purchase_service.dart';
import '../generated/app_localizations.dart';
import 'home_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  String _selectedPlan = 'yearly';
  bool _isLoading = false;

  static const _weeklyPrice = '₺49';
  static const _monthlyPrice = '₺149';
  static const _yearlyPrice = '₺999';

  static const _features = [
    ('🔍', 'Unlimited AI food scans', 'No daily cap, scan as much as you want'),
    ('📊', 'Full history & analytics', 'Track progress over weeks and months'),
    ('📅', 'Weekly AI report', 'Personalized insights every week'),
    ('🥗', 'AI diet plan generator', 'Custom 7-day plans tailored to you'),
    ('🏷️', 'Turkish food database', '10,000+ local dishes and ingredients'),
    ('💧', 'Apple Health sync', 'Seamless meals & water integration'),
  ];

  Future<void> _purchase() async {
    // DEV-BYPASS-PAYWALL: Pre-launch geçici. Kullanıcı paywall'ı görüyor ama
    // plan seçince gerçek RevenueCat satın alımı yerine local dev-premium
    // flag'i set ediliyor → tüm premium ekranlara erişebilsin. Launch öncesi
    // bu blok revert edilecek; `_selectedPlan` kullanımı ile gerçek
    // PurchaseService.purchase(planType: _selectedPlan) geri gelecek.
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final provider = context.read<AppProvider>();
    await provider.enableDevPremium();
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  /// EAT-159: 3 branch — success+entitlement / success+no-entitlement / error.
  /// `_isLoading` butonu disabled tutar; aşağıdaki snackbar mesajları
  /// kullanıcıya neyin yanlış gittiğini net söyler.
  Future<void> _restore() async {
    setState(() => _isLoading = true);
    final provider = context.read<AppProvider>();
    final result = await provider.restorePurchases();
    if (!mounted) return;
    setState(() => _isLoading = false);

    final isTr = Localizations.localeOf(context).languageCode == 'tr';

    switch (result) {
      case RestoreResult.success:
        if (provider.isPremium) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(isTr ? 'Aboneliğin geri yüklendi.' : 'Subscription restored.'), behavior: SnackBarBehavior.floating));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isTr ? 'Abonelik bulundu, eşitleniyor… Birazdan yeniden dene.' : 'Subscription found, syncing… Please retry shortly.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      case RestoreResult.noEntitlement:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTr ? 'Bu Apple/Google hesabında aktif abonelik yok.' : 'No active subscription on this Apple/Google account.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case RestoreResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isTr
                  ? 'Geri yükleme başarısız oldu. İnternet bağlantını kontrol edip tekrar dene.'
                  : 'Restore failed. Check your connection and try again.',
            ),
            backgroundColor: AppColors.coral,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final bodyBg = isDark ? AppColors.void_ : AppColors.lightBg;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bodyBg,
        body: Stack(
          children: [
            // 1) Arka plan — tema-aware
            Positioned.fill(child: _Backdrop(isDark: isDark)),

            // 2) İçerik
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHero(isDark),
                          SizedBox(height: 28.h),
                          _buildFeatureGrid(isDark),
                          SizedBox(height: 32.h),
                          _buildPlanSelector(isDark),
                          SizedBox(height: 220.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3) Bottom CTA — pinned at bottom
            Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomCTA(l, isDark)),
          ],
        ),
      ),
    );
  }

  // ── Hero ────────────────────────────────────────────────────────────────────
  Widget _buildHero(bool isDark) {
    // Tema-aware accent: dark→lime, light→void. Hero arkaplan da light mode'da
    // açık zemin (_Backdrop), o yüzden tüm metin/icon'lar tema-aware olmalı.
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;
    final titlePrimary = isDark ? Colors.white : AppColors.lightText;
    final subtitle = isDark ? Colors.white.withValues(alpha: 0.65) : AppColors.lightTextMuted;

    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 28.h, 28.w, 0),
      child: Column(
        children: [
          // Üst trial pill — accent border + accent text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: accent.withValues(alpha: 0.4), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, color: accent, size: 14.sp),
                SizedBox(width: 5.w),
                Text(
                  '3-DAY FREE TRIAL',
                  style: TextStyle(color: accent, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // Logo mark — accent fill, daha vurgulu
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark ? const [AppColors.lime, Color(0xFFB5E020)] : const [AppColors.void_, Color(0xFF2A2A3E)],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [BoxShadow(color: accent.withValues(alpha: isDark ? 0.45 : 0.25), blurRadius: 32, spreadRadius: -4)],
            ),
            child: Icon(Icons.bolt_rounded, color: accentFg, size: 36.sp),
          ),
          SizedBox(height: 20.h),
          // Title
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'eatiq',
                  style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, color: titlePrimary, letterSpacing: -1, height: 1),
                ),
                TextSpan(
                  text: ' Pro',
                  style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w900, color: accent, letterSpacing: -1, height: 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            'Unlock everything. Start your 3-Day Free Trial!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: subtitle, height: 1.4, letterSpacing: -0.1),
          ),
        ],
      ),
    );
  }

  // ── Features (2 kolon × 3 satır manuel layout) ─────────────────────────────
  Widget _buildFeatureGrid(bool isDark) {
    // Wrap responsive değildi (tek kolona düşüyordu); 3 Row × 2 Expanded
    // garantili 2×3 grid verir.
    // IntrinsicHeight = iki chip'in yüksekliğini eşleştir; stretch
    // unbounded scroll parent'ında crash atıyordu, intrinsic doğru çözüm.
    Widget rowOf(int a, int b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _FeatureChip(emoji: _features[a].$1, title: _features[a].$2, isDark: isDark),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _FeatureChip(emoji: _features[b].$1, title: _features[b].$2, isDark: isDark),
          ),
        ],
      ),
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          rowOf(0, 1),
          SizedBox(height: 10.h),
          rowOf(2, 3),
          SizedBox(height: 10.h),
          rowOf(4, 5),
        ],
      ),
    );
  }

  // ── Plans ───────────────────────────────────────────────────────────────────
  Widget _buildPlanSelector(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _PlanCard(
            isDark: isDark,
            isSelected: _selectedPlan == 'yearly',
            highlight: true,
            badgeTop: 'BEST VALUE · SAVE 44%',
            title: 'Yearly',
            price: _yearlyPrice,
            unit: '/ year',
            subtitle: '$_yearlyPrice / year after 3-day trial',
            onTap: () {
              setState(() => _selectedPlan = 'yearly');
              HapticFeedback.selectionClick();
            },
          ),
          SizedBox(height: 10.h),
          _PlanCard(
            isDark: isDark,
            isSelected: _selectedPlan == 'monthly',
            highlight: false,
            badgeTop: null,
            title: 'Monthly',
            price: _monthlyPrice,
            unit: '/ month',
            subtitle: '$_monthlyPrice / month after 3-day trial',
            onTap: () {
              setState(() => _selectedPlan = 'monthly');
              HapticFeedback.selectionClick();
            },
          ),
          SizedBox(height: 10.h),
          _PlanCard(
            isDark: isDark,
            isSelected: _selectedPlan == 'weekly',
            highlight: false,
            badgeTop: null,
            title: 'Weekly',
            price: _weeklyPrice,
            unit: '/ week',
            subtitle: '$_weeklyPrice / week after 3-day trial',
            onTap: () {
              setState(() => _selectedPlan = 'weekly');
              HapticFeedback.selectionClick();
            },
          ),
        ],
      ),
    );
  }

  // ── Bottom CTA ──────────────────────────────────────────────────────────────
  Widget _buildBottomCTA(AppLocalizations l, bool isDark) {
    final microColor = isDark ? Colors.white.withValues(alpha: 0.55) : AppColors.lightTextMuted;
    // Diğer light ekranlardaki primary action void (siyah pill); dark'ta lime.
    final btnBg = isDark ? AppColors.lime : AppColors.void_;
    final btnFg = isDark ? AppColors.void_ : AppColors.snow;
    // Backdrop tüm ekran arkasında — CTA arka plan overlay yok, backdrop
    // CTA'nın da arkasından görünür.
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Try 3 days for free. Cancel anytime.',
              style: TextStyle(fontSize: 12.sp, color: microColor, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10.h),
            // CTA — light: void fill, dark: lime fill (premium glow her ikisinde).
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: btnBg.withValues(alpha: isDark ? 0.45 : 0.25),
                          blurRadius: 24,
                          spreadRadius: -4,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: SizedBox(
                height: 58.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _purchase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnBg,
                    foregroundColor: btnFg,
                    disabledBackgroundColor: btnBg.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(btnFg)),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Start 3-Day Free Trial',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, letterSpacing: -0.2),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.arrow_forward_rounded, size: 18.sp),
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FooterLink(label: 'Restore', isDark: isDark, onTap: _isLoading ? null : _restore),
                _FooterDot(isDark: isDark),
                _FooterLink(
                  label: 'Privacy Policy',
                  isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                ),
                _FooterDot(isDark: isDark),
                _FooterLink(
                  label: 'Terms',
                  isDark: isDark,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsOfServiceScreen())),
                ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Backdrop — full-screen koyu arka plan + lime spotlight'lar
// ────────────────────────────────────────────────────────────────────────────
/// Hero kısmı her temada koyu kalır (~360h yükseklikte). Body alanı
/// tema-aware: light mode'da soft mor-beyaz, dark mode'da void. Spotlight'lar
/// Tüm ekran arka planı — gradient + spotlight'lar full-screen, hero ile body
/// arasında bölünme yok. Light & dark için aynı kompozisyon, tema-aware renk.
class _Backdrop extends StatelessWidget {
  final bool isDark;
  const _Backdrop({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient — full-screen
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xFF1A1F2C), Color(0xFF0F0F14), AppColors.void_]
                    : const [AppColors.lightBg, AppColors.lightBg, AppColors.lightBg],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Sağ üst spotlight — ekranın üstünden taşar
        Positioned(
          top: -60,
          right: -80,
          child: IgnorePointer(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.lime.withValues(alpha: isDark ? 0.22 : 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Sol alt spotlight — ekranın altından taşar
        Positioned(
          bottom: -100,
          left: -100,
          child: IgnorePointer(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.violet.withValues(alpha: isDark ? 0.14 : 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Feature chip — 2-col grid kartı
// ────────────────────────────────────────────────────────────────────────────
class _FeatureChip extends StatelessWidget {
  final String emoji;
  final String title;
  final bool isDark;
  const _FeatureChip({required this.emoji, required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? Colors.white.withValues(alpha: 0.04) : AppColors.lightCard;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightText;
    // Light: gri tinted icon bg (lime sadece dark mode + hero'da kalsın).
    final iconBg = isDark ? AppColors.lime.withValues(alpha: 0.14) : AppColors.lightSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: 16.sp)),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: textColor, height: 1.25, letterSpacing: -0.1),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Plan card — modern, premium
// ────────────────────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  final bool isDark;
  final bool isSelected;
  final bool highlight; // Yearly = true → daha kalın lime border
  final String? badgeTop;
  final String title;
  final String price;
  final String unit;
  final String subtitle;
  final VoidCallback onTap;

  const _PlanCard({
    required this.isDark,
    required this.isSelected,
    required this.highlight,
    required this.badgeTop,
    required this.title,
    required this.price,
    required this.unit,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Accent renk tema-aware: dark→lime, light→void (diğer light ekranlarla
    // tutarlı; light mode body'de "siyah/gri" hissi).
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.snow;

    final inactiveBg = isDark ? Colors.white.withValues(alpha: 0.03) : AppColors.lightCard;
    final inactiveBorder = isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.lightBorder;
    final selectedBg = isDark ? AppColors.lime.withValues(alpha: 0.08) : AppColors.lightSurface;
    final borderColor = isSelected ? accent : inactiveBorder;
    final bgColor = isSelected ? selectedBg : inactiveBg;
    final textPrimary = isDark ? Colors.white : AppColors.lightText;
    final textMuted = isDark ? Colors.white.withValues(alpha: 0.5) : AppColors.lightTextMuted;
    final radioInactive = isDark ? Colors.white.withValues(alpha: 0.35) : AppColors.lightTextMuted.withValues(alpha: 0.6);
    final priceColor = isSelected ? accent : textPrimary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: EdgeInsets.fromLTRB(16.w, highlight ? 20.h : 14.h, 16.w, 14.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: borderColor, width: isSelected ? 1.6 : 1),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? accent : Colors.transparent,
                    border: Border.all(color: isSelected ? accent : radioInactive, width: 1.8),
                  ),
                  child: isSelected ? Icon(Icons.check_rounded, size: 14.sp, color: accentFg) : null,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.3),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 11.sp, color: textMuted, height: 1.3),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, color: priceColor, letterSpacing: -0.5, height: 1),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      unit,
                      style: TextStyle(fontSize: 10.sp, color: textMuted, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Top badge — kart üstünde yüzen pill, tema-aware accent.
          if (badgeTop != null)
            Positioned(
              top: -10,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 16, spreadRadius: -2)],
                ),
                child: Text(
                  badgeTop!,
                  style: TextStyle(color: accentFg, fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Footer link / dot
// ────────────────────────────────────────────────────────────────────────────
class _FooterLink extends StatelessWidget {
  final String label;
  final bool isDark;
  final VoidCallback? onTap;
  const _FooterLink({required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white.withValues(alpha: 0.5) : AppColors.lightTextMuted;
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(fontSize: 11.sp, color: color, decoration: TextDecoration.underline, decorationColor: color.withValues(alpha: 0.6)),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  final bool isDark;
  const _FooterDot({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = isDark ? Colors.white.withValues(alpha: 0.3) : AppColors.lightTextMuted.withValues(alpha: 0.5);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
