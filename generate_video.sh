#!/bin/bash
set -e

mkdir -p output

# Strong, visible parameters
FLOAT_AMPLITUDE=120          # very visible movement
FLOAT_PERIOD=3               # slow enough for kids
POP_TIME=0.6
HOLD_TIME=2
FADE_TIME=0.8

# Two contrasting colors for magic effect
COLORS=("#FF5252" "#4FC3F7" "#81C784" "#FFD54F" "#BA68C8")
COLOR1=${COLORS[$RANDOM % ${#COLORS[@]}]}
COLOR2=${COLORS[$RANDOM % ${#COLORS[@]}]}

# Soft background
BG="#FFFDF8"

ffmpeg -y \
  -f lavfi -i "color=${BG}:1080x1920:duration=8" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]scale=700:-1,format=rgba,
         colorchannelmixer=rr=1:gg=1:bb=1,
         scale=iw*if(lt(t,${POP_TIME}),t/${POP_TIME},1):
               ih*if(lt(t,${POP_TIME}),t/${POP_TIME},1),
         fade=t=in:st=0:d=${POP_TIME}:alpha=1,
         fade=t=out:st=7:d=${FADE_TIME}:alpha=1
         [obj];

    [0:v][obj]overlay=
         x=(W-w)/2:
         y=(H-h)/2
           +${FLOAT_AMPLITUDE}*sin(2*PI*(t-${POP_TIME})/${FLOAT_PERIOD})
  " \
  -t 8 \
  -r 25 \
  -pix_fmt yuv420p \
  output/short.mp4

echo "Kid-friendly magic video generated"
