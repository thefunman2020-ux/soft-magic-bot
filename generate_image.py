from PIL import Image, ImageDraw
import random
from pathlib import Path

# Canvas
W, H = 1024, 1024
img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# Random choices
shapes = ["circle", "square", "star"]
colors = [
    (255, 99, 71),    # red
    (255, 215, 0),    # yellow
    (135, 206, 235),  # blue
    (144, 238, 144),  # green
    (221, 160, 221)   # purple
]

shape = random.choice(shapes)
color = random.choice(colors)

margin = 200

if shape == "circle":
    draw.ellipse(
        [margin, margin, W - margin, H - margin],
        fill=color
    )

elif shape == "square":
    draw.rounded_rectangle(
        [margin, margin, W - margin, H - margin],
        radius=120,
        fill=color
    )

elif shape == "star":
    cx, cy = W // 2, H // 2
    r1, r2 = 300, 130
    points = []
    for i in range(10):
        angle = i * 36
        r = r1 if i % 2 == 0 else r2
        x = cx + r * __import__("math").cos(__import__("math").radians(angle))
        y = cy + r * __import__("math").sin(__import__("math").radians(angle))
        points.append((x, y))
    draw.polygon(points, fill=color)

Path("assets").mkdir(exist_ok=True)
img.save("assets/object.png")

print("Image generated successfully")
