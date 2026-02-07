import requests
import random
from pathlib import Path

API_URL = "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2-1"
HEADERS = {"Authorization": f"Bearer {__import__('os').environ['HF_API_TOKEN']}"}

objects = [
    "star", "ball", "heart", "circle", "square",
    "apple", "banana", "car", "cloud", "sun"
]

prompt = (
    f"Flat cute cartoon {random.choice(objects)}, "
    "simple rounded shape, solid color, "
    "no face, no text, no outline, no shadow, "
    "minimal vector style, for toddlers, plain background"
)

response = requests.post(
    API_URL,
    headers=HEADERS,
    json={"inputs": prompt}
)

Path("assets").mkdir(exist_ok=True)

with open("assets/object.png", "wb") as f:
    f.write(response.content)

print("AI image generated successfully")
