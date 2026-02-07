import os
import requests
import random
import time
from pathlib import Path

HF_TOKEN = os.getenv("HF_API_TOKEN")
if not HF_TOKEN:
    raise RuntimeError("HF_API_TOKEN is missing")

API_URL = "https://api-inference.huggingface.co/models/CompVis/stable-diffusion-v1-4"
HEADERS = {"Authorization": f"Bearer {HF_TOKEN}"}

objects = [
    "star", "ball", "heart", "circle", "square",
    "apple", "banana", "car", "cloud", "sun"
]

prompt = (
    f"flat cute cartoon {random.choice(objects)}, "
    "simple rounded shape, solid color, "
    "no face, no text, no outline, no shadow, "
    "minimal vector style, plain background, for toddlers"
)

print("Prompt:", prompt)

def generate():
    r = requests.post(
        API_URL,
        headers=HEADERS,
        json={"inputs": prompt},
        timeout=90
    )
    print("Status:", r.status_code)
    return r

response = generate()

# Retry once if model is loading
if response.status_code == 503:
    print("Model loading, retrying...")
    time.sleep(20)
    response = generate()

if response.status_code != 200:
    print("Response text:", response.text)
    raise RuntimeError("Image generation failed")

Path("assets").mkdir(exist_ok=True)

with open("assets/object.png", "wb") as f:
    f.write(response.content)

print("AI image generated successfully")
