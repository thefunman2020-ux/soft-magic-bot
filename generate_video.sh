#!/bin/bash
set -e

mkdir -p output

# Strong visible motion (kids need BIG movement)
FLOAT_AMPLITUDE=160
FLOAT_PERIOD=1.8

# Background (soft, clean)
BG_COLOR="#FFFDF8"

ffmpeg -y \
  -f lavfi -i "color=${BG_COLOR}:1080x1920:duration=8" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]scale=700:-1,format=rgba,
         fade=t=in:st=0:d=0.6:alpha=1,
         fade=t=out:st=7:d=0.8:alpha=1
         [obj];

    [0:v][obj]overlay=
         x=(W-w)/2:
         y=(H-h)/2+${FLOAT_AMPLITUDE}*sin(2*PI*t/${FLOAT_PERIOD})
  " \
  -t 8 \
  -r 25 \
  -pix_fmt yuv420p \
  output/short.mp4

echo "Kid-friendly animated video generated"
