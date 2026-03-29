#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import math, os

FONT_PATH = "/System/Library/Fonts/Supplemental/Arial Black.ttf"
OUT_DIR = "ios/Runner/Assets.xcassets/AppIcon.appiconset"

LIGHT = {
    "bg": (200, 241, 53),       # #C8F135
    "dot": (15, 15, 20),        # #0F0F14
    "pill": (15, 15, 20),       # #0F0F14
    "pill_stroke": None,
    "eat": (240, 238, 248),     # #F0EEF8
    "iq": (200, 241, 53),       # #C8F135
}

DARK = {
    "bg": (15, 15, 20),         # #0F0F14
    "dot": (200, 241, 53),      # #C8F135
    "pill": (28, 28, 42),       # #1C1C2A
    "pill_stroke": (200, 241, 53),
    "eat": (240, 238, 248),
    "iq": (200, 241, 53),
}

def draw_icon(size, theme):
    img = Image.new("RGBA", (size, size), theme["bg"])
    draw = ImageDraw.Draw(img)

    # Dots pattern
    dot_spacing = int(52 * size / 1024)
    dot_r = max(1, int(6 * size / 1024))
    dot_color = theme["dot"] + (int(0.15 * 255),)
    for x in range(dot_spacing // 2, size, dot_spacing):
        for y in range(dot_spacing // 2, size, dot_spacing):
            draw.ellipse([x - dot_r, y - dot_r, x + dot_r, y + dot_r], fill=dot_color)

    # Pill
    px, py = int(72 * size / 1024), int(352 * size / 1024)
    pw, ph = int(880 * size / 1024), int(320 * size / 1024)
    rx = int(160 * size / 1024)
    pill_box = [px, py, px + pw, py + ph]
    draw.rounded_rectangle(pill_box, radius=rx, fill=theme["pill"])
    if theme["pill_stroke"]:
        sw = max(1, int(22 * size / 1024))
        for i in range(sw):
            draw.rounded_rectangle(
                [px + i, py + i, px + pw - i, py + ph - i],
                radius=rx - i,
                outline=theme["pill_stroke"]
            )

    # Text
    font_size = int(210 * size / 1024)
    font = ImageFont.truetype(FONT_PATH, font_size)

    # Measure combined text
    test_draw = ImageDraw.Draw(Image.new("RGBA", (1, 1)))
    eat_bbox = test_draw.textbbox((0, 0), "eat", font=font)
    iq_bbox = test_draw.textbbox((0, 0), "iq", font=font)
    eat_w = eat_bbox[2] - eat_bbox[0]
    iq_w = iq_bbox[2] - iq_bbox[0]
    total_w = eat_w + iq_w

    text_h = eat_bbox[3] - eat_bbox[1]
    x = (size - total_w) // 2
    y = int(570 * size / 1024) - text_h - eat_bbox[1]

    draw.text((x, y), "eat", font=font, fill=theme["eat"])
    draw.text((x + eat_w, y), "iq", font=font, fill=theme["iq"])

    return img

SIZES = [
    ("Icon-App-20x20@2x.png",    40,  "light"),
    ("Icon-App-20x20@3x.png",    60,  "light"),
    ("Icon-App-29x29@1x.png",    29,  "light"),
    ("Icon-App-29x29@2x.png",    58,  "light"),
    ("Icon-App-29x29@3x.png",    87,  "light"),
    ("Icon-App-40x40@2x.png",    80,  "light"),
    ("Icon-App-40x40@3x.png",   120,  "light"),
    ("Icon-App-57x57@1x.png",    57,  "light"),
    ("Icon-App-57x57@2x.png",   114,  "light"),
    ("Icon-App-60x60@2x.png",   120,  "light"),
    ("Icon-App-60x60@3x.png",   180,  "light"),
    ("Icon-App-20x20@1x.png",    20,  "light"),
    ("Icon-App-40x40@1x.png",    40,  "light"),
    ("Icon-App-50x50@1x.png",    50,  "light"),
    ("Icon-App-50x50@2x.png",   100,  "light"),
    ("Icon-App-72x72@1x.png",    72,  "light"),
    ("Icon-App-72x72@2x.png",   144,  "light"),
    ("Icon-App-76x76@1x.png",    76,  "light"),
    ("Icon-App-76x76@2x.png",   152,  "light"),
    ("Icon-App-83.5x83.5@2x.png",167, "light"),
    ("Icon-App-1024x1024@1x.png",1024,"light"),
    # Dark variants
    ("Icon-App-20x20@2x-dark.png",    40,  "dark"),
    ("Icon-App-20x20@3x-dark.png",    60,  "dark"),
    ("Icon-App-29x29@1x-dark.png",    29,  "dark"),
    ("Icon-App-29x29@2x-dark.png",    58,  "dark"),
    ("Icon-App-29x29@3x-dark.png",    87,  "dark"),
    ("Icon-App-40x40@2x-dark.png",    80,  "dark"),
    ("Icon-App-40x40@3x-dark.png",   120,  "dark"),
    ("Icon-App-57x57@1x-dark.png",    57,  "dark"),
    ("Icon-App-57x57@2x-dark.png",   114,  "dark"),
    ("Icon-App-60x60@2x-dark.png",   120,  "dark"),
    ("Icon-App-60x60@3x-dark.png",   180,  "dark"),
    ("Icon-App-20x20@1x-dark.png",    20,  "dark"),
    ("Icon-App-40x40@1x-dark.png",    40,  "dark"),
    ("Icon-App-50x50@1x-dark.png",    50,  "dark"),
    ("Icon-App-50x50@2x-dark.png",   100,  "dark"),
    ("Icon-App-72x72@1x-dark.png",    72,  "dark"),
    ("Icon-App-72x72@2x-dark.png",   144,  "dark"),
    ("Icon-App-76x76@1x-dark.png",    76,  "dark"),
    ("Icon-App-76x76@2x-dark.png",   152,  "dark"),
    ("Icon-App-83.5x83.5@2x-dark.png",167, "dark"),
    ("Icon-App-1024x1024@1x-dark.png",1024,"dark"),
]

os.makedirs(OUT_DIR, exist_ok=True)
for filename, size, mode in SIZES:
    theme = LIGHT if mode == "light" else DARK
    img = draw_icon(size, theme)
    img.convert("RGB").save(os.path.join(OUT_DIR, filename))
    print(f"  {filename} ({size}px)")

print("Done.")
