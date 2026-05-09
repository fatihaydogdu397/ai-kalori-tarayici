import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/blood_test.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/error_messages.dart';
import '../generated/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    // Önceden yüklenen tahlilleri çek (zaten cache'de varsa hızlı dönüş).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppProvider>().loadBloodTests();
    });
  }

  Future<void> _pickFile() async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
      );
      if (!mounted) return;
      if (res != null && res.files.isNotEmpty) {
        setState(() {
          _picked = res.files.first;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = localizedError(context, e));
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
    if (!mounted) return;
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
      // Yeni yüklenen kayıt da listede görünsün diye yeniden çek.
      // Onboarding'de devam butonuna basıldığında liste güncel kalır.
      await context.read<AppProvider>().loadBloodTests();
      if (!mounted) return;
      widget.onCompleted?.call();
      if (widget.isOnboarding) {
        // Caller handles next navigation.
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = localizedError(context, e));
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
    final l = AppLocalizations.of(context);
    final uploaded = context.watch<AppProvider>().bloodTests;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(l.bloodTestTitle,
            style: AppTypography.titleLarge.copyWith(color: textPrimary)),
        actions: [
          if (widget.isOnboarding)
            TextButton(
              onPressed: _uploading ? null : () => widget.onCompleted?.call(),
              child: Text(
                l.skip,
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
                l.bloodTestHeadline,
                style: AppTypography.headlineLarge.copyWith(color: textPrimary),
              ),
              SizedBox(height: 8.h),
              Text(
                l.bloodTestSubtitle,
                style: TextStyle(fontSize: 13.sp, color: textMuted, height: 1.4),
              ),
              SizedBox(height: 20.h),

              if (uploaded.isNotEmpty) ...[
                Text(
                  l.bloodTestUploadedListTitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < uploaded.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            color: isDark ? AppColors.darkSurface : AppColors.lightBorder,
                          ),
                        _UploadedTestRow(
                          test: uploaded[i],
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                          accent: accent,
                          l: l,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // File picker card — outer height locked to 52.h (matches Upload button)
              GestureDetector(
                onTap: _uploading ? null : _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                        size: 22,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _picked?.name ?? l.bloodTestPickFile,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _picked != null ? l.bloodTestReplaceFile : l.bloodTestFileTypesHint,
                        style: TextStyle(fontSize: 11.sp, color: textMuted),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Test date picker — outer height locked to 52.h
              GestureDetector(
                onTap: _uploading ? null : _pickDate,
                child: Container(
                  width: double.infinity,
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                            ? l.bloodTestDateOptional
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
                          widget.isOnboarding ? l.bloodTestUploadAndContinue : l.bloodTestUpload,
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

class _UploadedTestRow extends StatelessWidget {
  final BloodTest test;
  final bool isDark;
  final Color textPrimary, textMuted, accent;
  final AppLocalizations l;

  const _UploadedTestRow({
    required this.test,
    required this.isDark,
    required this.textPrimary,
    required this.textMuted,
    required this.accent,
    required this.l,
  });

  String _statusLabel() {
    switch (test.status) {
      case BloodTestStatus.completed:
        return l.bloodTestStatusCompleted;
      case BloodTestStatus.failed:
        return l.bloodTestStatusFailed;
      case BloodTestStatus.pending:
        return l.bloodTestStatusPending;
    }
  }

  Color _statusColor() {
    switch (test.status) {
      case BloodTestStatus.completed:
        return AppColors.lime;
      case BloodTestStatus.failed:
        return AppColors.coral;
      case BloodTestStatus.pending:
        return textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = test.testDate ??
        '${test.createdAt.year.toString().padLeft(4, '0')}-'
            '${test.createdAt.month.toString().padLeft(2, '0')}-'
            '${test.createdAt.day.toString().padLeft(2, '0')}';
    final statusColor = _statusColor();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.description_rounded, size: 20, color: textMuted),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel,
                  style: TextStyle(fontSize: 13.sp, color: textPrimary, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2.h),
                Text(
                  _statusLabel(),
                  style: TextStyle(fontSize: 11.sp, color: statusColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
