#!/bin/bash
set -e

mkdir -p output tmp

BG_COLOR="#FFFDF8"
BOUNCE_AMPLITUDE=160
BOUNCE_PERIOD=1.6

# ---------- SEGMENT 1: POP IN (BLUE) ----------
ffmpeg -y \
  -f lavfi -i "color=${BG_COLOR}:1080x1920:duration=1" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]scale=700:-1,format=rgba,fade=t=in:st=0:d=0.4:alpha=1[obj];
    [0:v][obj]overlay=
      x=(W-w)/2:
      y=(H-h)/2+${BOUNCE_AMPLITUDE}*abs(sin(2*PI*t/${BOUNCE_PERIOD}))
  " \
  -t 1 \
  -r 25 \
  -pix_fmt yuv420p \
  tmp/part1.mp4

# ---------- SEGMENT 2: COLOR CHANGE (YELLOW) ----------
ffmpeg -y \
  -f lavfi -i "color=${BG_COLOR}:1080x1920:duration=5" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]scale=700:-1,format=rgba,
         colorchannelmixer=rr=1.2:gg=1.1:bb=0.6[obj];
    [0:v][obj]overlay=
      x=(W-w)/2:
      y=(H-h)/2+${BOUNCE_AMPLITUDE}*abs(sin(2*PI*t/${BOUNCE_PERIOD}))
  " \
  -t 5 \
  -r 25 \
  -pix_fmt yuv420p \
  tmp/part2.mp4

# ---------- SEGMENT 3: FADE OUT ----------
ffmpeg -y \
  -f lavfi -i "color=${BG_COLOR}:1080x1920:duration=2" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]scale=700:-1,format=rgba,fade=t=out:st=0:d=1:alpha=1[obj];
    [0:v][obj]overlay=
      x=(W-w)/2:
      y=(H-h)/2
  " \
  -t 2 \
  -r 25 \
  -pix_fmt yuv420p \
  tmp/part3.mp4

# ---------- CONCAT ----------
printf "file 'part1.mp4'\nfile 'part2.mp4'\nfile 'part3.mp4'\n" > tmp/list.txt

ffmpeg -y \
  -f concat -safe 0 -i tmp/list.txt \
  -c copy \
  output/short.mp4

echo "Final kid-friendly animated short generated"
