#!/bin/bash
LIGHT_SVG="/Users/fatihaydogdu/Downloads/eatiq_icon_light.svg"
DARK_SVG="/Users/fatihaydogdu/Downloads/eatiq_icon_dark.svg"
OUT="/Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/ios/Runner/Assets.xcassets/AppIcon.appiconset"
TMP="/tmp/eatiq_icons"
mkdir -p "$TMP"

sizes=(20 29 40 50 57 58 60 72 76 80 87 100 114 120 144 152 167 180 1024)

for s in "${sizes[@]}"; do
  qlmanage -t -s $s -o "$TMP/" "$LIGHT_SVG" 2>/dev/null
  mv "$TMP/eatiq_icon_light.svg.png" "$TMP/light_${s}.png"
  qlmanage -t -s $s -o "$TMP/" "$DARK_SVG" 2>/dev/null
  mv "$TMP/eatiq_icon_dark.svg.png" "$TMP/dark_${s}.png"
done

# Light icons
cp "$TMP/light_40.png"   "$OUT/Icon-App-20x20@2x.png"
cp "$TMP/light_60.png"   "$OUT/Icon-App-20x20@3x.png"
cp "$TMP/light_29.png"   "$OUT/Icon-App-29x29@1x.png"
cp "$TMP/light_58.png"   "$OUT/Icon-App-29x29@2x.png"
cp "$TMP/light_87.png"   "$OUT/Icon-App-29x29@3x.png"
cp "$TMP/light_80.png"   "$OUT/Icon-App-40x40@2x.png"
cp "$TMP/light_120.png"  "$OUT/Icon-App-40x40@3x.png"
cp "$TMP/light_57.png"   "$OUT/Icon-App-57x57@1x.png"
cp "$TMP/light_114.png"  "$OUT/Icon-App-57x57@2x.png"
cp "$TMP/light_120.png"  "$OUT/Icon-App-60x60@2x.png"
cp "$TMP/light_180.png"  "$OUT/Icon-App-60x60@3x.png"
cp "$TMP/light_20.png"   "$OUT/Icon-App-20x20@1x.png"
cp "$TMP/light_40.png"   "$OUT/Icon-App-40x40@1x.png"
cp "$TMP/light_50.png"   "$OUT/Icon-App-50x50@1x.png"
cp "$TMP/light_100.png"  "$OUT/Icon-App-50x50@2x.png"
cp "$TMP/light_72.png"   "$OUT/Icon-App-72x72@1x.png"
cp "$TMP/light_144.png"  "$OUT/Icon-App-72x72@2x.png"
cp "$TMP/light_76.png"   "$OUT/Icon-App-76x76@1x.png"
cp "$TMP/light_152.png"  "$OUT/Icon-App-76x76@2x.png"
cp "$TMP/light_167.png"  "$OUT/Icon-App-83.5x83.5@2x.png"
cp "$TMP/light_1024.png" "$OUT/Icon-App-1024x1024@1x.png"

# Dark icons
cp "$TMP/dark_40.png"   "$OUT/Icon-App-20x20@2x-dark.png"
cp "$TMP/dark_60.png"   "$OUT/Icon-App-20x20@3x-dark.png"
cp "$TMP/dark_29.png"   "$OUT/Icon-App-29x29@1x-dark.png"
cp "$TMP/dark_58.png"   "$OUT/Icon-App-29x29@2x-dark.png"
cp "$TMP/dark_87.png"   "$OUT/Icon-App-29x29@3x-dark.png"
cp "$TMP/dark_80.png"   "$OUT/Icon-App-40x40@2x-dark.png"
cp "$TMP/dark_120.png"  "$OUT/Icon-App-40x40@3x-dark.png"
cp "$TMP/dark_57.png"   "$OUT/Icon-App-57x57@1x-dark.png"
cp "$TMP/dark_114.png"  "$OUT/Icon-App-57x57@2x-dark.png"
cp "$TMP/dark_120.png"  "$OUT/Icon-App-60x60@2x-dark.png"
cp "$TMP/dark_180.png"  "$OUT/Icon-App-60x60@3x-dark.png"
cp "$TMP/dark_20.png"   "$OUT/Icon-App-20x20@1x-dark.png"
cp "$TMP/dark_40.png"   "$OUT/Icon-App-40x40@1x-dark.png"
cp "$TMP/dark_50.png"   "$OUT/Icon-App-50x50@1x-dark.png"
cp "$TMP/dark_100.png"  "$OUT/Icon-App-50x50@2x-dark.png"
cp "$TMP/dark_72.png"   "$OUT/Icon-App-72x72@1x-dark.png"
cp "$TMP/dark_144.png"  "$OUT/Icon-App-72x72@2x-dark.png"
cp "$TMP/dark_76.png"   "$OUT/Icon-App-76x76@1x-dark.png"
cp "$TMP/dark_152.png"  "$OUT/Icon-App-76x76@2x-dark.png"
cp "$TMP/dark_167.png"  "$OUT/Icon-App-83.5x83.5@2x-dark.png"
cp "$TMP/dark_1024.png" "$OUT/Icon-App-1024x1024@1x-dark.png"

echo "Done."
