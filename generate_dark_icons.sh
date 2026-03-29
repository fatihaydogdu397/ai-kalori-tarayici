#!/bin/bash
SVG="/Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/assets/icons/eatiq_dark.svg"
OUT="/Users/fatihaydogdu/Claude/devforge/ai_kalori_tarayici/ios/Runner/Assets.xcassets/AppIcon.appiconset"

sizes=(
  "Icon-App-20x20@2x-dark.png:40"
  "Icon-App-20x20@3x-dark.png:60"
  "Icon-App-29x29@1x-dark.png:29"
  "Icon-App-29x29@2x-dark.png:58"
  "Icon-App-29x29@3x-dark.png:87"
  "Icon-App-40x40@2x-dark.png:80"
  "Icon-App-40x40@3x-dark.png:120"
  "Icon-App-57x57@1x-dark.png:57"
  "Icon-App-57x57@2x-dark.png:114"
  "Icon-App-60x60@2x-dark.png:120"
  "Icon-App-60x60@3x-dark.png:180"
  "Icon-App-20x20@1x-dark.png:20"
  "Icon-App-40x40@1x-dark.png:40"
  "Icon-App-50x50@1x-dark.png:50"
  "Icon-App-50x50@2x-dark.png:100"
  "Icon-App-72x72@1x-dark.png:72"
  "Icon-App-72x72@2x-dark.png:144"
  "Icon-App-76x76@1x-dark.png:76"
  "Icon-App-76x76@2x-dark.png:152"
  "Icon-App-83.5x83.5@2x-dark.png:167"
  "Icon-App-1024x1024@1x-dark.png:1024"
)

for entry in "${sizes[@]}"; do
  filename="${entry%%:*}"
  size="${entry##*:}"
  rsvg-convert -w $size -h $size "$SVG" -o "$OUT/$filename"
  echo "Generated $filename ($size x $size)"
done
echo "Done."
