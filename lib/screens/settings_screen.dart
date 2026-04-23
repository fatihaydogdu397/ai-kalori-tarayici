import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/app_provider.dart';
import '../services/notification_service.dart';
import '../services/api/api_exception.dart';
import '../generated/app_localizations.dart';
import 'blood_tests_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  NotificationSettings _notifSettings = const NotificationSettings();

  @override
  void initState() {
    super.initState();
    _loadNotifSettings();
  }

  Future<void> _loadNotifSettings() async {
    final s = await NotificationSettings.load();
    if (mounted) setState(() => _notifSettings = s);
  }

  Future<void> _saveAndApply(NotificationSettings s, AppProvider provider) async {
    setState(() => _notifSettings = s);
    await s.save();
    if (s.enabled) {
      final granted = await NotificationService.requestPermission();
      if (!granted) return;
    }
    await s.apply();
    if (s.enabled && s.summaryEnabled && mounted) {
      await provider.syncNotification(AppLocalizations.of(context));
    }
  }

  Future<void> _pickTime(
    TimeOfDay current,
    ValueChanged<TimeOfDay> onPicked,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final border = isDark
        ? null
        : Border.all(color: AppColors.lightBorder, width: 0.5);
    final divColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;

    return Scaffold(
      backgroundColor: bg,
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final goal = provider.dailyCalorieGoal;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                backgroundColor: bg,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 56,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: textPrimary,
                  ),
                ),
                title: Text(
                  l.settings,
                  style: AppTypography.titleLarge.copyWith(color: textPrimary),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Görünüm
                      _SectionLabel(label: l.appearance, textMuted: textMuted),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: _SettingRow(
                          icon: isDark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny_rounded,
                          iconColor: isDark
                              ? AppColors.violet
                              : AppColors.amberDark,
                          label: isDark ? l.dark : l.light,
                          trailing: Switch(
                            value: isDark,
                            onChanged: (_) => provider.toggleTheme(),
                            activeColor: AppColors.lime,
                            activeTrackColor: AppColors.lime.withOpacity(0.3),
                          ),
                          divColor: divColor,
                          textPrimary: textPrimary,
                          showDivider: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dil
                      _SectionLabel(label: l.language, textMuted: textMuted),
                      const SizedBox(height: 8),
                      _LangTile(
                        provider: provider,
                        isDark: isDark,
                        cardBg: cardBg,
                        border: border,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 16),

                      // Ölçü Birimi
                      _SectionLabel(label: l.unitSystem, textMuted: textMuted),
                      const SizedBox(height: 8),
                      _UnitTile(
                        provider: provider,
                        isDark: isDark,
                        cardBg: cardBg,
                        border: border,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 16),

                      // Kalori Hedefi
                      _SectionLabel(label: l.calorieGoal, textMuted: textMuted),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showCalorieEditor(
                          context,
                          provider,
                          isDark,
                          goal,
                          accent,
                          accentFg,
                          textPrimary,
                          textMuted,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: border,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_rounded,
                                color: isDark
                                    ? AppColors.coral
                                    : AppColors.coralDark,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${goal.toStringAsFixed(0)} kcal',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.edit_rounded,
                                size: 16,
                                color: isDark
                                    ? AppColors.lime
                                    : AppColors.limeDark,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Apple Health
                      _SectionLabel(label: l.appleHealth, textMuted: textMuted),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: _SettingRow(
                          icon: Icons.favorite_rounded,
                          iconColor: const Color(0xFFFF3B30),
                          label: l.appleHealthSub,
                          trailing: Switch(
                            value: provider.healthEnabled,
                            onChanged: (v) async {
                              final ok = await provider.setHealthEnabled(v);
                              if (!ok && context.mounted) {
                                _showHealthPermissionDialog(
                                  context,
                                  l,
                                  isDark,
                                  accent,
                                  accentFg,
                                  textPrimary,
                                  textMuted,
                                );
                              }
                            },
                            activeColor: AppColors.lime,
                            activeTrackColor: AppColors.lime.withOpacity(0.3),
                          ),
                          divColor: divColor,
                          textPrimary: textPrimary,
                          showDivider: false,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Hatırlatıcılar
                      _SectionLabel(label: l.reminders, textMuted: textMuted),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: Column(
                          children: [
                            // Ana toggle
                            _SettingRow(
                              icon: Icons.notifications_rounded,
                              iconColor: isDark
                                  ? AppColors.amber
                                  : AppColors.amberDark,
                              label: l.notifications,
                              trailing: Switch(
                                value: _notifSettings.enabled,
                                onChanged: (v) => _saveAndApply(
                                  _notifSettings.copyWith(enabled: v),
                                  provider,
                                ),
                                activeColor: AppColors.lime,
                                activeTrackColor: AppColors.lime.withOpacity(
                                  0.3,
                                ),
                              ),
                              divColor: divColor,
                              textPrimary: textPrimary,
                              showDivider: _notifSettings.enabled,
                            ),

                            if (_notifSettings.enabled) ...[
                              _ReminderRow(
                                emoji: '🌅',
                                label: l.mealBreakfast,
                                enabled: _notifSettings.breakfastEnabled,
                                time: _notifSettings.breakfastTime,
                                isDark: isDark,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                divColor: divColor,
                                accent: accent,
                                onToggle: (v) => _saveAndApply(
                                  _notifSettings.copyWith(breakfastEnabled: v),
                                  provider,
                                ),
                                onTimeTap: () => _pickTime(
                                  _notifSettings.breakfastTime,
                                  (t) => _saveAndApply(
                                    _notifSettings.copyWith(breakfastTime: t),
                                    provider,
                                  ),
                                ),
                                showDivider: true,
                              ),
                              _ReminderRow(
                                emoji: '☀️',
                                label: l.mealLunch,
                                enabled: _notifSettings.lunchEnabled,
                                time: _notifSettings.lunchTime,
                                isDark: isDark,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                divColor: divColor,
                                accent: accent,
                                onToggle: (v) => _saveAndApply(
                                  _notifSettings.copyWith(lunchEnabled: v),
                                  provider,
                                ),
                                onTimeTap: () => _pickTime(
                                  _notifSettings.lunchTime,
                                  (t) => _saveAndApply(
                                    _notifSettings.copyWith(lunchTime: t),
                                    provider,
                                  ),
                                ),
                                showDivider: true,
                              ),
                              _ReminderRow(
                                emoji: '🌙',
                                label: l.mealDinner,
                                enabled: _notifSettings.dinnerEnabled,
                                time: _notifSettings.dinnerTime,
                                isDark: isDark,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                divColor: divColor,
                                accent: accent,
                                onToggle: (v) => _saveAndApply(
                                  _notifSettings.copyWith(dinnerEnabled: v),
                                  provider,
                                ),
                                onTimeTap: () => _pickTime(
                                  _notifSettings.dinnerTime,
                                  (t) => _saveAndApply(
                                    _notifSettings.copyWith(dinnerTime: t),
                                    provider,
                                  ),
                                ),
                                showDivider: true,
                              ),
                              _ReminderRow(
                                emoji: '📊',
                                label: l.dailySummaryTitle,
                                enabled: _notifSettings.summaryEnabled,
                                time: const TimeOfDay(hour: 20, minute: 0),
                                isDark: isDark,
                                textPrimary: textPrimary,
                                textMuted: textMuted,
                                divColor: divColor,
                                accent: accent,
                                onToggle: (v) => _saveAndApply(
                                  _notifSettings.copyWith(summaryEnabled: v),
                                  provider,
                                ),
                                onTimeTap: () {}, // Sabit saat
                                showDivider: false,
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Health data ───────────────────────────────────────
                      _SectionLabel(
                        label: Localizations.localeOf(context).languageCode == 'tr'
                            ? 'SAĞLIK VERİLERİ'
                            : 'HEALTH DATA',
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const BloodTestsScreen()),
                            );
                          },
                          child: _SettingRow(
                            icon: Icons.bloodtype_rounded,
                            iconColor: AppColors.coral,
                            label: Localizations.localeOf(context).languageCode == 'tr'
                                ? 'Kan Tahlillerim'
                                : 'My Blood Tests',
                            trailing: Icon(Icons.chevron_right_rounded, size: 18, color: textMuted),
                            divColor: divColor,
                            textPrimary: textPrimary,
                            showDivider: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Subscription & Legal ──────────────────────────────
                      _SectionLabel(
                        label: l.subscriptionLegal,
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: Column(
                          children: [
                            // Restore Purchases
                            _SettingRow(
                              icon: Icons.restore_rounded,
                              iconColor: isDark
                                  ? AppColors.lime
                                  : AppColors.limeDark,
                              label: l.restorePurchases,
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: textMuted,
                              ),
                              divColor: divColor,
                              textPrimary: textPrimary,
                              showDivider: true,
                            ),
                            // Terms of Service
                            GestureDetector(
                              onTap: () => launchUrl(
                                Uri.parse('https://eatiq.app/terms'),
                                mode: LaunchMode.externalApplication,
                              ),
                              child: _SettingRow(
                                icon: Icons.description_outlined,
                                iconColor: textMuted,
                                label: l.termsOfService,
                                trailing: Icon(
                                  Icons.open_in_new_rounded,
                                  size: 16,
                                  color: textMuted,
                                ),
                                divColor: divColor,
                                textPrimary: textPrimary,
                                showDivider: true,
                              ),
                            ),
                            // Privacy Policy
                            GestureDetector(
                              onTap: () => launchUrl(
                                Uri.parse('https://eatiq.app/privacy'),
                                mode: LaunchMode.externalApplication,
                              ),
                              child: _SettingRow(
                                icon: Icons.shield_outlined,
                                iconColor: textMuted,
                                label: l.privacyPolicy,
                                trailing: Icon(
                                  Icons.open_in_new_rounded,
                                  size: 16,
                                  color: textMuted,
                                ),
                                divColor: divColor,
                                textPrimary: textPrimary,
                                showDivider: false,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Account (Danger Zone, EAT-96) ─────────────────────
                      _SectionLabel(
                        label: Localizations.localeOf(context).languageCode == 'tr'
                            ? 'HESAP'
                            : 'ACCOUNT',
                        textMuted: textMuted,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: border,
                        ),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _confirmDeleteAccount(
                            context,
                            provider,
                            isDark,
                            textPrimary,
                            textMuted,
                            accent,
                            accentFg,
                          ),
                          child: _SettingRow(
                            icon: Icons.delete_forever_rounded,
                            iconColor: const Color(0xFFFF3B30),
                            label: Localizations.localeOf(context).languageCode == 'tr'
                                ? 'Hesabımı Sil'
                                : 'Delete My Account',
                            trailing: Icon(Icons.chevron_right_rounded, size: 18, color: textMuted),
                            divColor: divColor,
                            textPrimary: textPrimary,
                            showDivider: false,
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// EAT-96: iki aşamalı onay → `deleteAccount` mutation → authLogout.
  Future<void> _confirmDeleteAccount(
    BuildContext context,
    AppProvider provider,
    bool isDark,
    Color textPrimary,
    Color textMuted,
    Color accent,
    Color accentFg,
  ) async {
    final isTr = Localizations.localeOf(context).languageCode == 'tr';
    final danger = const Color(0xFFFF3B30);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: danger, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isTr ? 'Hesabını sil?' : 'Delete your account?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isTr
              ? 'Tüm yemek geçmişin, kilo takibin, diyet planın ve kan tahlillerin kalıcı olarak silinecek. Bu işlem geri alınamaz.'
              : 'Your meal history, weight logs, diet plan, and blood tests will be permanently deleted. This cannot be undone.',
          style: TextStyle(fontSize: 14.sp, color: textMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              isTr ? 'Vazgeç' : 'Cancel',
              style: TextStyle(color: textMuted, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                isTr ? 'Sil' : 'Delete',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Blocking loader while mutation runs.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(accent),
        ),
      ),
    );

    try {
      await provider.deleteAccount();
      // authLogout zaten AuthScreen'e push ediyor; bu ekran stack'ten düştüğü
      // için ayrıca pop/push yapmamıza gerek yok.
    } on ApiException catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // loader'ı kapat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isTr
                ? 'Hesap silinemedi: ${e.message}'
                : 'Account deletion failed: ${e.message}',
          ),
          backgroundColor: danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isTr
                ? 'Beklenmeyen bir hata oluştu.'
                : 'An unexpected error occurred.',
          ),
          backgroundColor: danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showHealthPermissionDialog(
    BuildContext context,
    AppLocalizations l,
    bool isDark,
    Color accent,
    Color accentFg,
    Color textPrimary,
    Color textMuted,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFFF3B30),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              l.appleHealth,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          l.appleHealthDenied,
          style: TextStyle(fontSize: 14.sp, color: textMuted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel, style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse('app-settings:'),
                mode: LaunchMode.externalApplication,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: accentFg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                l.goToSettings,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalorieEditor(
    BuildContext context,
    AppProvider provider,
    bool isDark,
    double current,
    Color accent,
    Color accentFg,
    Color textPrimary,
    Color textMuted,
  ) {
    double value = current.clamp(1200, 4000);
    final l = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l.dailyCalorieGoal,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${value.round()} kcal',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: accent,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l.calorieRange,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: SliderComponentShape.noOverlay,
                  activeTrackColor: accent,
                  inactiveTrackColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBorder,
                  thumbColor: accent,
                ),
                child: Slider(
                  value: value,
                  min: 1200,
                  max: 4000,
                  divisions: 280,
                  onChanged: (v) => setModalState(() => value = v),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    provider.setCalorieGoalAndSave(value.roundToDouble());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: accentFg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    l.save,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textMuted;
  const _SectionLabel({required this.label, required this.textMuted});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: AppTypography.labelSmall.copyWith(
      color: textMuted,
      letterSpacing: 0.8,
    ),
  );
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;
  final Color divColor, textPrimary;
  final bool showDivider;
  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
    required this.divColor,
    required this.textPrimary,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(color: textPrimary),
              ),
            ),
            trailing,
          ],
        ),
      ),
      if (showDivider) Divider(height: 1, indent: 44, color: divColor),
    ],
  );
}

class _ReminderRow extends StatelessWidget {
  final String emoji, label;
  final bool enabled, showDivider, isDark;
  final TimeOfDay time;
  final Color textPrimary, textMuted, divColor, accent;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTimeTap;

  const _ReminderRow({
    required this.emoji,
    required this.label,
    required this.enabled,
    required this.time,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.divColor,
    required this.accent,
    required this.onToggle,
    required this.onTimeTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLarge.copyWith(color: textPrimary),
                ),
              ),
              if (enabled)
                GestureDetector(
                  onTap: onTimeTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Switch(
                value: enabled,
                onChanged: onToggle,
                activeColor: AppColors.lime,
                activeTrackColor: AppColors.lime.withOpacity(0.3),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, indent: 44, color: divColor),
      ],
    );
  }
}

class _LangTile extends StatelessWidget {
  final AppProvider provider;
  final bool isDark;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;

  const _LangTile({
    required this.provider,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.border,
  });

  static const langs = [
    ('tr', '🇹🇷', 'Türkçe'),
    ('en', '🇬🇧', 'English'),
    ('fr', '🇫🇷', 'Français'),
    ('es', '🇪🇸', 'Español'),
    ('de', '🇩🇪', 'Deutsch'),
    ('ar', '🇸🇦', 'العربية'),
    ('pt', '🇧🇷', 'Português'),
    ('it', '🇮🇹', 'Italiano'),
    ('ru', '🇷🇺', 'Русский'),
    ('ka', '🇬🇪', 'ქართული'),
  ];

  void _openSheet(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    final divColor = isDark ? AppColors.darkSurface : AppColors.lightBorder;
    final currentCode =
        provider.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: divColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  l.selectLanguage,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...langs.asMap().entries.map((e) {
                final lang = e.value;
                final selected = currentCode == lang.$1;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        provider.setLocale(Locale(lang.$1));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 13,
                        ),
                        child: Row(
                          children: [
                            Text(lang.$2, style: const TextStyle(fontSize: 22)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                lang.$3,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: textPrimary,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                            if (selected)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 13,
                                  color: accentFg,
                                ),
                              )
                            else
                              Text(
                                lang.$1.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (e.key < langs.length - 1)
                      Divider(height: 1, indent: 56, color: divColor),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCode =
        provider.locale?.languageCode ??
        Localizations.localeOf(context).languageCode;
    final current = langs.firstWhere(
      (l) => l.$1 == currentCode,
      orElse: () => langs.first,
    );
    return GestureDetector(
      onTap: () => _openSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: border,
        ),
        child: Row(
          children: [
            Text(current.$2, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Text(
              current.$3,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: textMuted),
          ],
        ),
      ),
    );
  }
}

class _UnitTile extends StatelessWidget {
  final AppProvider provider;
  final bool isDark;
  final Color cardBg, textPrimary, textMuted;
  final Border? border;

  const _UnitTile({
    required this.provider,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final options = [
      (UnitSystem.metric, '🌍', l.unitMetric, 'kg · cm'),
      (UnitSystem.imperial, '🇺🇸', l.unitImperial, 'lb · inch'),
    ];
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: border,
      ),
      child: Row(
        children: options.map((opt) {
          final (system, flag, label, units) = opt;
          final isSelected = provider.unitSystem == system;
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.setUnitSystem(system),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accent.withOpacity(isDark ? 0.15 : 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? accent.withOpacity(0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? accent : textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      units,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? accent.withOpacity(0.7)
                            : textMuted.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
