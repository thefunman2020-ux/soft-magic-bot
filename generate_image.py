import os
import requests
import random
import time
from pathlib import Path

HF_TOKEN = os.getenv("HF_API_TOKEN")
if not HF_TOKEN:
    raise RuntimeError("HF_API_TOKEN is missing")

MODEL = "CompVis/stable-diffusion-v1-4"
API_URL = f"https://router.huggingface.co/hf-inference/models/{MODEL}"

HEADERS = {
    "Authorization": f"Bearer {HF_TOKEN}",
    "Content-Type": "application/json",
}

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
    return requests.post(
        API_URL,
        headers=HEADERS,
        json={"inputs": prompt},
        timeout=90
    )

response = generate()
print("Status:", response.status_code)

# Retry if model is loading
if response.status_code == 503:
    print("Model loading, retrying...")
    time.sleep(20)
    response = generate()
    print("Retry status:", response.status_code)

if response.status_code != 200:
    print("Response text:", response.text)
    raise RuntimeError("Image generation failed")

Path("assets").mkdir(exist_ok=True)

with open("assets/object.png", "wb") as f:
    f.write(response.content)

print("AI image generated successfully")
