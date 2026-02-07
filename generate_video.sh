#!/bin/bash
set -e

mkdir -p output

# Randomized parameters (safe ranges)
FLOAT_PERIOD=$(awk -v min=90 -v max=150 'BEGIN{srand(); print int(min+rand()*(max-min))}')
FLOAT_AMPLITUDE=$(awk -v min=15 -v max=40 'BEGIN{srand(); print int(min+rand()*(max-min))}')
SCALE_FACTOR=$(awk -v min=0.9 -v max=1.1 'BEGIN{srand(); print min+rand()*(max-min)}')
FADE_TIME=$(awk -v min=0.8 -v max=1.4 'BEGIN{srand(); print min+rand()*(max-min)}')

# Random pastel background
BG_COLORS=("white" "#FFF4E6" "#E6F7FF" "#F3E6FF" "#E6FFF2")
BG_COLOR=${BG_COLORS[$RANDOM % ${#BG_COLORS[@]}]}

ffmpeg -y \
  -loop 1 -i assets/object.png \
  -filter_complex "
    scale=iw*${SCALE_FACTOR}:-1,
    format=rgba,
    fade=t=in:st=0:d=${FADE_TIME}:alpha=1,
    fade=t=out:st=7:d=${FADE_TIME}:alpha=1,
    pad=1080:1920:(ow-iw)/2:(oh-ih)/2:color=${BG_COLOR},
    zoompan=
      z='1.0':
      x='iw/2-(iw/2)':
      y='ih/2-(ih/2)+${FLOAT_AMPLITUDE}*sin(2*PI*on/${FLOAT_PERIOD})':
      d=1:
      s=1080x1920
  " \
  -t 8 \
  -pix_fmt yuv420p \
  -r 25 \
  output/short.mp4

echo "Video generated successfully"
