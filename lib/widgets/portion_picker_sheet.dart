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
}

class PortionPickerSheet extends StatefulWidget {
  const PortionPickerSheet({super.key});

  @override
  State<PortionPickerSheet> createState() => _PortionPickerSheetState();
}

class _PortionPickerSheetState extends State<PortionPickerSheet> {
  double _grams = 250;
  CookingMethod _cooking = CookingMethod.grill;

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

          // Gram slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ortalama Miktar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_grams.round()} g',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('50g', style: TextStyle(fontSize: 11, color: textMuted)),
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
                    value: _grams,
                    min: 50,
                    max: 800,
                    divisions: 75,
                    onChanged: (v) => setState(() => _grams = v),
                  ),
                ),
              ),
              Text('800g', style: TextStyle(fontSize: 11, color: textMuted)),
            ],
          ),
          _referenceHint(textMuted),
          const SizedBox(height: 20),

          // Cooking method
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

          // Analiz Et button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(
                context,
                (grams: _grams.round(), cooking: _cooking),
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
    final g = _grams.round();
    String hint;
    if (g <= 100) {
      hint = '≈ avuç içi kadar';
    } else if (g <= 200) {
      hint = '≈ yumruk büyüklüğünde';
    } else if (g <= 350) {
      hint = '≈ orta tabak';
    } else if (g <= 500) {
      hint = '≈ büyük tabak';
    } else {
      hint = '≈ çok büyük porsiyon';
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 2),
      child: Text(hint, style: TextStyle(fontSize: 11, color: textMuted)),
    );
  }
}
