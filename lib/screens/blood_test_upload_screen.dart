import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../services/app_provider.dart';
import '../services/api/api_exception.dart';
import '../theme/app_theme.dart';

/// Full l10n migration is tracked in a follow-up task; for now we ship TR/EN
/// inline so the feature is usable immediately.
String _t(BuildContext ctx, String tr, String en) =>
    Localizations.localeOf(ctx).languageCode == 'tr' ? tr : en;

/// Kan tahlili / sağlık raporu yükleme ekranı. İki yerden çağrılır:
///   - Onboarding (`isOnboarding: true`): skip + devam butonu.
///   - Settings > Kan tahlillerim (`isOnboarding: false`): tek "Yükle" butonu,
///     yükleme sonrası pop.
class BloodTestUploadScreen extends StatefulWidget {
  final bool isOnboarding;
  final VoidCallback? onCompleted;

  const BloodTestUploadScreen({
    super.key,
    this.isOnboarding = false,
    this.onCompleted,
  });

  @override
  State<BloodTestUploadScreen> createState() => _BloodTestUploadScreenState();
}

class _BloodTestUploadScreenState extends State<BloodTestUploadScreen> {
  PlatformFile? _picked;
  DateTime? _testDate;
  bool _uploading = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
      );
      if (res != null && res.files.isNotEmpty) {
        setState(() {
          _picked = res.files.first;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: context,
      initialDate: _testDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    if (res != null) setState(() => _testDate = res);
  }

  String _mimeFor(String ext) {
    switch (ext.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  Future<void> _upload() async {
    final file = _picked;
    if (file == null || file.path == null) return;

    setState(() {
      _uploading = true;
      _errorMessage = null;
    });

    try {
      final bytes = await File(file.path!).readAsBytes();
      final b64 = base64Encode(bytes);
      final ext = (file.extension ?? 'jpg');
      final mime = _mimeFor(ext);
      final iso = _testDate?.toIso8601String().substring(0, 10);

      await context.read<AppProvider>().uploadBloodTest(
            base64: b64,
            mimeType: mime,
            testDate: iso,
          );

      if (!mounted) return;
      widget.onCompleted?.call();
      if (widget.isOnboarding) {
        // Caller handles next navigation.
      } else {
        Navigator.pop(context, true);
      }
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final accent = isDark ? AppColors.lime : AppColors.void_;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(_t(context, 'Kan Tahlili', 'Blood Test'),
            style: AppTypography.titleLarge.copyWith(color: textPrimary)),
        actions: [
          if (widget.isOnboarding)
            TextButton(
              onPressed: _uploading ? null : () => widget.onCompleted?.call(),
              child: Text(
                _t(context, 'Atla', 'Skip'),
                style: TextStyle(color: textMuted, fontSize: 14.sp),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t(context, 'Sağlık raporunu yükle', 'Upload your health report'),
                style: AppTypography.headlineLarge.copyWith(color: textPrimary),
              ),
              SizedBox(height: 8.h),
              Text(
                _t(
                  context,
                  'Kan tahlilini yüklersen diyet planın ve önerilerimiz sana daha özel olur. Opsiyoneldir, istediğin zaman profilinden ekleyebilirsin.',
                  'Uploading your lab report lets us personalize your plan and advice. Optional — you can add it any time from your profile.',
                ),
                style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.4),
              ),
              SizedBox(height: 24.h),

              // File picker card
              GestureDetector(
                onTap: _uploading ? null : _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: _picked != null ? accent : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _picked != null ? Icons.description_rounded : Icons.upload_file_rounded,
                        color: _picked != null ? accent : textMuted,
                        size: 28,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _picked?.name ?? _t(context, 'Dosya seç', 'Pick a file'),
                              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              _picked != null
                                  ? _t(context, 'Değiştirmek için dokun', 'Tap to replace')
                                  : _t(context, 'PDF veya görsel (JPG/PNG)', 'PDF or image (JPG/PNG)'),
                              style: TextStyle(fontSize: 11.sp, color: textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Test date picker
              GestureDetector(
                onTap: _uploading ? null : _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: isDark ? AppColors.darkSurface : AppColors.lightBorder, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, color: textMuted, size: 20),
                      SizedBox(width: 12.w),
                      Text(
                        _testDate == null
                            ? _t(context, 'Test tarihi (opsiyonel)', 'Test date (optional)')
                            : _testDate!.toIso8601String().substring(0, 10),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _testDate == null ? textMuted : textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_errorMessage != null) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.coral.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(_errorMessage!, style: TextStyle(color: AppColors.coral, fontSize: 12.sp)),
                ),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: (_picked == null || _uploading) ? null : _upload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: isDark ? AppColors.void_ : Colors.white,
                    disabledBackgroundColor: accent.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                    elevation: 0,
                  ),
                  child: _uploading
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: isDark ? AppColors.void_ : Colors.white,
                          ),
                        )
                      : Text(
                          widget.isOnboarding
                              ? _t(context, 'Yükle ve devam et', 'Upload & continue')
                              : _t(context, 'Yükle', 'Upload'),
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
