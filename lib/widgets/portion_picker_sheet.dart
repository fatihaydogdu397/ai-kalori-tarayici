import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum CookingMethod { grill, boil, fry, oven, raw }

extension CookingMethodX on CookingMethod {
  String label(BuildContext context) => switch (this) {
        CookingMethod.grill => 'Izgara',
        CookingMethod.boil => 'Haşlama',
        CookingMethod.fry => 'Kızartma',
        CookingMethod.oven => 'Fırın',
        CookingMethod.raw => 'Çiğ/Salata',
      };

  String get emoji => switch (this) {
        CookingMethod.grill => '🔥',
        CookingMethod.boil => '💧',
        CookingMethod.fry => '🫒',
        CookingMethod.oven => '🫙',
        CookingMethod.raw => '🥗',
      };

  String get promptText => switch (this) {
        CookingMethod.grill => 'grilled',
        CookingMethod.boil => 'boiled/steamed',
        CookingMethod.fry => 'fried in oil',
        CookingMethod.oven => 'oven-baked',
        CookingMethod.raw => 'raw/salad',
      };

  /// Maps to BE `CookingMethod` GraphQL enum values (analyze-food.input.ts).
  String get backendKey => switch (this) {
        CookingMethod.grill => 'GRILLED',
        CookingMethod.boil => 'BOILED',
        CookingMethod.fry => 'FRIED',
        CookingMethod.oven => 'BAKED',
        CookingMethod.raw => 'RAW',
      };
}

class PortionPickerSheet extends StatefulWidget {
  const PortionPickerSheet({super.key});

  @override
  State<PortionPickerSheet> createState() => _PortionPickerSheetState();
}

class _PortionPickerSheetState extends State<PortionPickerSheet> {
  bool _isLiquid = false;
  double _amount = 250;
  CookingMethod _cooking = CookingMethod.grill;

  double get _min => _isLiquid ? 50 : 50;
  double get _max => _isLiquid ? 1000 : 800;
  int get _divisions => _isLiquid ? 95 : 75;
  String get _unit => _isLiquid ? 'ml' : 'g';

  void _onToggle(bool liquid) {
    setState(() {
      _isLiquid = liquid;
      // Reset to sensible default for each type
      _amount = liquid ? 250 : 250;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textPrimary = isDark ? AppColors.darkText : AppColors.lightText;
    final textMuted = isDark ? AppColors.darkTextMuted : const Color(0xFFAAAAAA);
    final accent = isDark ? AppColors.lime : AppColors.limeDeep;
    final chipBg = isDark ? AppColors.darkSurface : AppColors.lightBg;
    final selectedChipBg = isDark ? const Color(0xFF1A2010) : const Color(0xFFEEF5E0);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Katı / Sıvı toggle
          Text('Gıda Türü', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
          const SizedBox(height: 10),
          Row(
            children: [
              _TypeChip(
                label: '🍽️  Katı Gıda',
                selected: !_isLiquid,
                accent: accent,
                chipBg: chipBg,
                selectedBg: selectedChipBg,
                textMuted: textMuted,
                onTap: () => _onToggle(false),
              ),
              const SizedBox(width: 10),
              _TypeChip(
                label: '🥤  İçecek / Sıvı',
                selected: _isLiquid,
                accent: accent,
                chipBg: chipBg,
                selectedBg: selectedChipBg,
                textMuted: textMuted,
                onTap: () => _onToggle(true),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Amount slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Miktar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_amount.round()} $_unit',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('$_min$_unit', style: TextStyle(fontSize: 11, color: textMuted)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: accent,
                    inactiveTrackColor: accent.withOpacity(0.2),
                    thumbColor: accent,
                    overlayColor: accent.withOpacity(0.15),
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: _amount.clamp(_min, _max),
                    min: _min,
                    max: _max,
                    divisions: _divisions,
                    onChanged: (v) => setState(() => _amount = v),
                  ),
                ),
              ),
              Text('${_max.round()}$_unit', style: TextStyle(fontSize: 11, color: textMuted)),
            ],
          ),
          _referenceHint(textMuted),
          const SizedBox(height: 20),

          // Cooking method — sadece katı gıdalarda göster
          if (!_isLiquid) ...[
            Text('Pişirme Yöntemi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CookingMethod.values.map((m) {
                final selected = m == _cooking;
                return GestureDetector(
                  onTap: () => setState(() => _cooking = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? selectedChipBg : chipBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? accent : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(m.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 5),
                        Text(
                          m.label(context),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? accent : textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 4),

          // Analiz Et button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                (amount: _amount.round(), isLiquid: _isLiquid, cooking: _isLiquid ? null : _cooking),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.lime : AppColors.void_,
                foregroundColor: isDark ? AppColors.void_ : AppColors.lime,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: const Text('Analiz Et', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _referenceHint(Color textMuted) {
    final a = _amount.round();
    String hint;
    if (_isLiquid) {
      if (a <= 100) {
        hint = '≈ espresso / shot';
      } else if (a <= 200) {
        hint = '≈ küçük bardak';
      } else if (a <= 350) {
        hint = '≈ standart bardak';
      } else if (a <= 500) {
        hint = '≈ büyük bardak / kutu';
      } else {
        hint = '≈ büyük şişe';
      }
    } else {
      if (a <= 100) {
        hint = '≈ avuç içi kadar';
      } else if (a <= 200) {
        hint = '≈ yumruk büyüklüğünde';
      } else if (a <= 350) {
        hint = '≈ orta tabak';
      } else if (a <= 500) {
        hint = '≈ büyük tabak';
      } else {
        hint = '≈ çok büyük porsiyon';
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 2),
      child: Text(hint, style: TextStyle(fontSize: 11, color: textMuted)),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color accent, chipBg, selectedBg, textMuted;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.chipBg,
    required this.selectedBg,
    required this.textMuted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? selectedBg : chipBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? accent : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? accent : textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
