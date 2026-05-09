from PIL import Image, ImageDraw, ImageFilter, ImageFont
import os

OUT_DIR = os.path.dirname(__file__)
SIZE = 1024
GREEN = (45, 106, 79)  # #2D6A4F
DARK_GREEN = (27, 67, 50)  # #1B4332
WHITE = (255, 255, 255)


def make_icon(filename, with_padding=False):
    pad = 128 if with_padding else 0
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Background circle/square
    if with_padding:
        # Adaptive icon foreground - just the symbol on transparent
        bg_color = (0, 0, 0, 0)
    else:
        # Full background
        draw.rectangle([0, 0, SIZE, SIZE], fill=GREEN)

    # Draw a stylized leaf
    cx, cy = SIZE // 2, SIZE // 2
    leaf_size = 380 if not with_padding else 320

    # Leaf shape - elegant teardrop
    # Outer leaf
    leaf_color = WHITE
    points_outer = []
    import math
    for i in range(60):
        t = i / 59
        # Leaf parametric curve
        angle = math.pi * t
        r = leaf_size * (1 - 0.3 * abs(math.cos(angle * 2)))
        x = cx + r * math.sin(angle - math.pi / 2) * 0.7
        y = cy - leaf_size + r * (1 - math.cos(angle - math.pi / 2)) * 0.85
        points_outer.append((x, y))
    for i in range(60):
        t = i / 59
        angle = math.pi * t
        r = leaf_size * (1 - 0.3 * abs(math.cos(angle * 2)))
        x = cx - r * math.sin(angle - math.pi / 2) * 0.7
        y = cy + leaf_size - r * (1 - math.cos(angle - math.pi / 2)) * 0.85
        points_outer.append((x, y))

    # Simpler approach: draw leaf as ellipse-like shape with two arcs
    img2 = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    d2 = ImageDraw.Draw(img2)

    # Leaf body
    leaf_w = 380
    leaf_h = 520
    leaf_box = [cx - leaf_w // 2, cy - leaf_h // 2, cx + leaf_w // 2, cy + leaf_h // 2]
    d2.ellipse(leaf_box, fill=WHITE)

    # Cut top-right and bottom-left to create leaf shape
    # Leaf stem indicator - vein down the middle
    stem_w = 12
    d2.rectangle([cx - stem_w // 2, cy - leaf_h // 2 + 80, cx + stem_w // 2, cy + leaf_h // 2 - 80], fill=GREEN)

    # Combine
    if not with_padding:
        img.paste(img2, (0, 0), img2)
    else:
        img = img2

    img.save(os.path.join(OUT_DIR, filename))
    print(f"Saved {filename}")


def make_simple_letter_icon(filename):
    """Simple icon with letter y on green background"""
    img = Image.new('RGBA', (SIZE, SIZE), GREEN + (255,))
    draw = ImageDraw.Draw(img)

    # Try to find a serif font
    font_paths = [
        'C:/Windows/Fonts/georgia.ttf',
        'C:/Windows/Fonts/times.ttf',
        'C:/Windows/Fonts/timesbd.ttf',
        'C:/Windows/Fonts/cambriab.ttf',
    ]
    font = None
    for fp in font_paths:
        if os.path.exists(fp):
            font = ImageFont.truetype(fp, 720)
            break

    if font is None:
        font = ImageFont.load_default()

    # Draw 'y' centered
    text = 'y'
    bbox = draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    x = (SIZE - tw) // 2 - bbox[0]
    y = (SIZE - th) // 2 - bbox[1] - 40

    draw.text((x, y), text, fill=WHITE, font=font)

    img.save(os.path.join(OUT_DIR, filename))
    print(f"Saved {filename}")


def make_leaf_icon(filename):
    """Icon with elegant leaf on green background"""
    img = Image.new('RGBA', (SIZE, SIZE), GREEN + (255,))
    draw = ImageDraw.Draw(img)

    cx, cy = SIZE // 2, SIZE // 2

    # Draw leaf using a custom shape
    # Leaf: ellipse rotated, with point at top
    import math

    # Create leaf shape with points
    points = []
    leaf_height = 540
    leaf_width = 360

    for i in range(0, 181, 2):
        angle = math.radians(i)
        # Right side of leaf
        x = cx + math.sin(angle) * leaf_width / 2
        y = cy - leaf_height / 2 + (1 - math.cos(angle)) * leaf_height / 2
        # Pinch at top
        if i < 30:
            x = cx + math.sin(angle) * (leaf_width / 2) * (i / 30) * 0.7
        if i > 150:
            x = cx + math.sin(angle) * (leaf_width / 2) * ((180 - i) / 30) * 0.85
        points.append((x, y))

    for i in range(180, 361, 2):
        angle = math.radians(i)
        x = cx + math.sin(angle) * leaf_width / 2
        y = cy - leaf_height / 2 + (1 - math.cos(angle)) * leaf_height / 2
        points.append((x, y))

    # Simpler: just draw an asymmetric leaf
    points = []
    n = 200
    for i in range(n):
        t = i / (n - 1)
        # Parametric leaf shape
        u = t * 2 * math.pi
        r = (1 - 0.35 * math.cos(2 * u)) * 200
        x = cx + r * math.sin(u) * 0.85
        y = cy + r * math.cos(u) * 1.3 - 30
        points.append((x, y))

    draw.polygon(points, fill=WHITE)

    # Draw a thin vein down the middle
    draw.line([(cx, cy - 200), (cx, cy + 220)], fill=GREEN, width=10)

    img.save(os.path.join(OUT_DIR, filename))
    print(f"Saved {filename}")


if __name__ == '__main__':
    make_simple_letter_icon('icon.png')
    make_leaf_icon('icon_leaf.png')
