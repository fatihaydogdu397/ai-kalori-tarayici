import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/food_analysis.dart';
import '../services/app_provider.dart';
import '../theme/app_theme.dart';
import '../generated/app_localizations.dart';

class ManualEntryScreen extends StatefulWidget {
  /// null → yeni öğün, non-null → düzenleme modu
  final FoodAnalysis? existing;
  const ManualEntryScreen({super.key, this.existing});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _portionCtrl; // gram — opsiyonel ama validasyona giriyor
  late final TextEditingController _calCtrl;
  late final TextEditingController _protCtrl;
  late final TextEditingController _carbCtrl;
  late final TextEditingController _fatCtrl;
  late MealCategory _category;
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.summary ?? '');
    _portionCtrl = TextEditingController(text: e != null && e.foods.isNotEmpty ? e.foods.first.portion.toStringAsFixed(0) : '');
    _calCtrl = TextEditingController(text: e != null ? e.totalNutrients.calories.toStringAsFixed(0) : '');
    _protCtrl = TextEditingController(text: e != null && e.totalNutrients.protein > 0 ? e.totalNutrients.protein.toStringAsFixed(0) : '');
    _carbCtrl = TextEditingController(text: e != null && e.totalNutrients.carbs > 0 ? e.totalNutrients.carbs.toStringAsFixed(0) : '');
    _fatCtrl = TextEditingController(text: e != null && e.totalNutrients.fat > 0 ? e.totalNutrients.fat.toStringAsFixed(0) : '');
    _category = e?.mealCategory ?? MealCategoryX.fromTime(DateTime.now());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _portionCtrl.dispose();
    _calCtrl.dispose();
    _protCtrl.dispose();
    _carbCtrl.dispose();
    _fatCtrl.dispose();
    super.dispose();
  }

  // ── Validation helpers ────────────────────────────────────────────────────

  double? _val(TextEditingController c) => double.tryParse(c.text);

  /// Porsiyon gram cinsinden girilmişse makroların mantıklı olup olmadığını kontrol eder.
  String? _validateMacro(String? v, String macroName, AppLocalizations l) {
    if (v == null || v.isEmpty) return null; // opsiyonel
    final d = double.tryParse(v);
    if (d == null) return l.validNumber;
    if (d < 0) return l.validNegative;

    // Üst sınır: tek bir makro 1000g'ı geçemez
    if (d > 1000) return l.validMacroMax(macroName);

    // Porsiyon girilmişse makro > porsiyon olamaz
    final portion = _val(_portionCtrl);
    if (portion != null && portion > 0 && d > portion) {
      return l.validMacroPortion(macroName, portion.toStringAsFixed(0));
    }

    // Toplam makro > porsiyon olamaz
    final prot = _val(_protCtrl) ?? 0;
    final carb = _val(_carbCtrl) ?? 0;
    final fat = _val(_fatCtrl) ?? 0;
    if (portion != null && portion > 0) {
      final total = prot + carb + fat;
      if (total > portion) {
        return l.validMacroTotal(total.toStringAsFixed(0));
      }
    }
    return null;
  }

  String? _validateCalories(String? v, AppLocalizations l) {
    if (v == null || v.isEmpty) return l.validCalRequired;
    final cal = double.tryParse(v);
    if (cal == null) return l.validNumber;
    if (cal <= 0) return l.validPositive;
    if (cal > 5000) return l.validCalMax;

    // Makrolarla tutarlılık kontrolü
    final prot = _val(_protCtrl) ?? 0;
    final carb = _val(_carbCtrl) ?? 0;
    final fat = _val(_fatCtrl) ?? 0;
    if (prot + carb + fat > 0) {
      final estimated = prot * 4 + carb * 4 + fat * 9;
      if (estimated > 0 && (cal > estimated * 2.5 || cal < estimated * 0.3)) {
        return l.validCalInconsistent(estimated.toStringAsFixed(0));
      }
    }
    return null;
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final now = widget.existing?.analyzedAt ?? DateTime.now();
    final analysis = FoodAnalysis(
      id: widget.existing?.id ?? 'manual_${DateTime.now().millisecondsSinceEpoch}',
      imagePath: widget.existing?.imagePath ?? '',
      foods: [],
      totalNutrients: NutrientInfo(
        calories: _val(_calCtrl) ?? 0,
        protein: _val(_protCtrl) ?? 0,
        carbs: _val(_carbCtrl) ?? 0,
        fat: _val(_fatCtrl) ?? 0,
        fiber: 0,
        sugar: 0,
      ),
      summary: _nameCtrl.text.trim(),
      advice: '',
      analyzedAt: now,
      mealCategory: _category,
    );

    final provider = context.read<AppProvider>();
    if (_isEdit) {
      await provider.updateAnalysis(analysis);
    } else {
      await provider.saveManualEntry(analysis);
    }

    if (mounted) Navigator.pop(context, true);
  }

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardBg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.lime : AppColors.void_;
    final accentFg = isDark ? AppColors.void_ : AppColors.lime;
    final border = isDark ? null : Border.all(color: AppColors.lightBorder, width: 0.5);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10), border: border),
                      child: Icon(Icons.chevron_left_rounded, color: textMuted, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isEdit ? l.editMeal : l.addManualMeal,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Öğün adı
                      _Label(l.mealNameLabel, textMuted),
                      const SizedBox(height: 8),
                      _Field(
                        controller: _nameCtrl,
                        hint: l.hintMealName,
                        isDark: isDark,
                        cardBg: cardBg,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        validator: (v) => (v == null || v.trim().isEmpty) ? l.mealNameRequired : null,
                      ),
                      const SizedBox(height: 20),

                      // Kategori
                      _Label(l.categoryLabel, textMuted),
                      const SizedBox(height: 8),
                      _CategoryPicker(selected: _category, isDark: isDark, cardBg: cardBg, onChanged: (cat) => setState(() => _category = cat)),
                      const SizedBox(height: 20),

                      // Porsiyon ağırlığı — opsiyonel, validator için referans
                      _Label(l.portionWeightLabel, textMuted),
                      const SizedBox(height: 4),
                      Text(l.portionHint, style: TextStyle(fontSize: 11, color: textMuted.withOpacity(0.6))),
                      const SizedBox(height: 8),
                      _Field(
                        controller: _portionCtrl,
                        hint: l.hintPortion,
                        isDark: isDark,
                        cardBg: cardBg,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        numeric: true,
                        suffix: 'g',
                        validator: (v) {
                          if (v == null || v.isEmpty) return null;
                          final d = double.tryParse(v);
                          if (d == null) return l.validNumber;
                          if (d <= 0 || d > 5000) return l.validPortionRange;
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Kalori
                      _Label('Kalori (kcal) *', textMuted),
                      const SizedBox(height: 8),
                      _Field(
                        controller: _calCtrl,
                        hint: l.hintCalories,
                        isDark: isDark,
                        cardBg: cardBg,
                        textPrimary: textPrimary,
                        textMuted: textMuted,
                        numeric: true,
                        suffix: 'kcal',
                        accentColor: isDark ? AppColors.lime : AppColors.limeDeep,
                        validator: (v) => _validateCalories(v, l),
                      ),
                      const SizedBox(height: 20),

                      // Makrolar
                      _Label(l.macrosLabel, textMuted),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _Field(
                              controller: _protCtrl,
                              hint: l.hintProtein,
                              isDark: isDark,
                              cardBg: cardBg,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              numeric: true,
                              accentColor: isDark ? AppColors.violet : AppColors.violetDark,
                              validator: (v) => _validateMacro(v, l.hintProtein, l),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Field(
                              controller: _carbCtrl,
                              hint: l.hintCarbs,
                              isDark: isDark,
                              cardBg: cardBg,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              numeric: true,
                              accentColor: isDark ? AppColors.amber : AppColors.amberDark,
                              validator: (v) => _validateMacro(v, l.hintCarbs, l),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _Field(
                              controller: _fatCtrl,
                              hint: l.hintFat,
                              isDark: isDark,
                              cardBg: cardBg,
                              textPrimary: textPrimary,
                              textMuted: textMuted,
                              numeric: true,
                              accentColor: isDark ? AppColors.coral : AppColors.coralDark,
                              validator: (v) => _validateMacro(v, l.hintFat, l),
                            ),
                          ),
                        ],
                      ),

                      // Makro özet chip'leri (canlı gösterim)
                      const SizedBox(height: 12),
                      _MacroSummary(
                        prot: _val(_protCtrl) ?? 0,
                        carb: _val(_carbCtrl) ?? 0,
                        fat: _val(_fatCtrl) ?? 0,
                        portion: _val(_portionCtrl),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: accentFg,
                            disabledBackgroundColor: accent.withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _saving
                              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: accentFg, strokeWidth: 2))
                              : Text(_isEdit ? l.update : l.save, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Live macro summary
// ---------------------------------------------------------------------------

class _MacroSummary extends StatelessWidget {
  final double prot, carb, fat;
  final double? portion;
  final bool isDark;
  const _MacroSummary({required this.prot, required this.carb, required this.fat, required this.portion, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final total = prot + carb + fat;
    if (total == 0) return const SizedBox.shrink();
    final estimated = prot * 4 + carb * 4 + fat * 9;
    final textMuted = isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary;

    final overPortion = portion != null && portion! > 0 && total > portion!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: overPortion ? AppColors.coral.withOpacity(0.08) : (isDark ? AppColors.darkCard : AppColors.lightCard),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: overPortion ? AppColors.coral.withOpacity(0.3) : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(overPortion ? Icons.warning_amber_rounded : Icons.info_outline_rounded, size: 14, color: overPortion ? AppColors.coral : textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              overPortion
                  ? 'Toplam makro (${total.toStringAsFixed(0)}g) porsiyon ağırlığını aşıyor'
                  : 'Toplam ${total.toStringAsFixed(0)}g makro · Tahmini ${estimated.toStringAsFixed(0)} kcal',
              style: TextStyle(fontSize: 11, color: overPortion ? AppColors.coral : textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  const _Label(this.text, this.color);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark, numeric;
  final Color cardBg, textPrimary, textMuted;
  final Color? accentColor;
  final String? suffix;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.cardBg,
    required this.textPrimary,
    required this.textMuted,
    this.numeric = false,
    this.accentColor,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = accentColor ?? (isDark ? AppColors.darkSurface : AppColors.lightBorder);
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      inputFormatters: numeric ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))] : null,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: textMuted, fontWeight: FontWeight.w400),
        suffixText: suffix,
        suffixStyle: TextStyle(fontSize: 12, color: textMuted),
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor ?? AppColors.lime, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.coral, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
        ),
        errorMaxLines: 2,
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  final MealCategory selected;
  final bool isDark;
  final Color cardBg;
  final ValueChanged<MealCategory> onChanged;

  const _CategoryPicker({required this.selected, required this.isDark, required this.cardBg, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cats = [
      (MealCategory.breakfast, '🌅', l.mealBreakfast),
      (MealCategory.lunch, '☀️', l.mealLunch),
      (MealCategory.dinner, '🌙', l.mealDinner),
      (MealCategory.snack, '🍎', l.mealSnack),
    ];
    final activeColor = isDark ? AppColors.lime : AppColors.void_;

    return Row(
      children: cats.map((item) {
        final (cat, emoji, label) = item;
        final isSelected = selected == cat;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(isDark ? 0.2 : 0.12) : cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? activeColor : (isDark ? AppColors.darkSurface : AppColors.lightBorder),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? activeColor : (isDark ? AppColors.darkTextMuted : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
