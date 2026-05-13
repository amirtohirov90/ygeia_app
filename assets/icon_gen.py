"""Generate ygeia app icon: 1024x1024 sage-green canvas with 'ygeía' in cream.

Spec:
  - Background: #5B7F6A (YgeiaColors.accent)
  - Text: "ygeía" in #F2EAE0 (YgeiaColors.bgBase)
  - Font: Century Gothic Regular (fallback chain inside)
  - Size: ~42% of canvas height
  - Letter spacing: 2% of font size
  - Vertical position: optical center (2% above geometric center)
"""
import os
import sys

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("ERROR: Pillow not installed. Run: pip install Pillow",
          file=sys.stderr)
    sys.exit(1)

SIZE = 1024
BG = (0x5B, 0x7F, 0x6A)
FG = (0xF2, 0xEA, 0xE0)
TEXT = "ygeía"
TARGET_FONT_SIZE = 430                     # ~42% of canvas (target — auto-fit may shrink)
MAX_TEXT_WIDTH = int(SIZE * 0.84)          # leave ~8% margin per side
LETTER_SPACING_FRACTION = 0.02             # 2% of em
Y_OFFSET = int(SIZE * -0.02)               # 2% above geometric center

# Priority: Century Gothic → URW Gothic → Futura → Avenir Next →
#           Twentieth Century → Avant Garde → generic Windows fallbacks.
FONT_CANDIDATES = [
    r"C:\Windows\Fonts\GOTHIC.TTF",
    r"C:\Windows\Fonts\URWGothic.ttf",
    r"C:\Windows\Fonts\Futura.ttf",
    r"C:\Windows\Fonts\AvenirNext.ttf",
    r"C:\Windows\Fonts\TwentiethCentury.ttf",
    r"C:\Windows\Fonts\AvantGarde.ttf",
    r"C:\Windows\Fonts\segoeui.ttf",
    r"C:\Windows\Fonts\calibri.ttf",
    r"C:\Windows\Fonts\arial.ttf",
]


def find_font_path():
    for path in FONT_CANDIDATES:
        if os.path.exists(path):
            print(f"Font: {path}")
            return path
    return None


def measure(font, spacing):
    advances = [font.getlength(ch) for ch in TEXT]
    return advances, sum(advances) + spacing * (len(TEXT) - 1)


def fit_font(path, target_size, max_width):
    """Start at target_size and shrink until text fits within max_width."""
    size = target_size
    while size > 80:
        font = ImageFont.truetype(path, size=size)
        spacing = max(1, int(size * LETTER_SPACING_FRACTION))
        _, total = measure(font, spacing)
        if total <= max_width:
            return font, size, spacing
        # Proportional shrink with safety margin.
        size = int(size * max_width / total) - 1
    raise RuntimeError("Could not fit text within canvas")


def main():
    font_path = find_font_path()
    if font_path is None:
        print("ERROR: no suitable font found", file=sys.stderr)
        sys.exit(1)

    font, size, LETTER_SPACING = fit_font(
        font_path, TARGET_FONT_SIZE, MAX_TEXT_WIDTH)
    print(f"Font size: {size}px (target {TARGET_FONT_SIZE}px), "
          f"letter-spacing: {LETTER_SPACING}px")

    img = Image.new("RGB", (SIZE, SIZE), BG)
    draw = ImageDraw.Draw(img)

    # Per-character advance widths (manual letter-spacing).
    advances, total_w = measure(font, LETTER_SPACING)

    # Full-text bbox relative to baseline (default anchor 'la').
    bbox = draw.textbbox((0, 0), TEXT, font=font)
    bbox_t, bbox_b = bbox[1], bbox[3]

    # Place bbox-center at canvas-center + Y_OFFSET (negative = upward).
    target_cy = SIZE / 2 + Y_OFFSET
    baseline_y = target_cy - (bbox_t + bbox_b) / 2
    x_start = SIZE / 2 - total_w / 2

    cur_x = x_start
    for ch, adv in zip(TEXT, advances):
        draw.text((cur_x, baseline_y), ch, font=font, fill=FG)
        cur_x += adv + LETTER_SPACING

    out_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "icon.png")
    img.save(out_path, "PNG")
    print(f"Saved: {out_path} ({SIZE}x{SIZE})")


if __name__ == "__main__":
    main()
