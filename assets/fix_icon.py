# -*- coding: utf-8 -*-
from PIL import Image

path = r'C:\Users\Ноутбук\ygeia_app\assets\icon.png'

icon = Image.open(path).convert('RGBA')
GREEN = (38, 92, 66)
bg = Image.new('RGBA', icon.size, GREEN + (255,))
result = Image.alpha_composite(bg, icon)
result.save(path)
print("Fixed")
