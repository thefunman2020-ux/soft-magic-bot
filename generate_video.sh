#!/bin/bash
set -e

mkdir -p output

# --- Timing (kid-optimized) ---
DURATION=8
POP_TIME=0.4
FADE_OUT_START=6.8

# --- Motion (visible, playful) ---
BOUNCE_AMPLITUDE=160
BOUNCE_PERIOD=1.6

# --- Colors (magic change) ---
COLOR_A="#4FC3F7"   # blue
COLOR_B="#FFD54F"   # yellow
BG_COLOR="#FFFDF8"

ffmpeg -y \
  -f lavfi -i "color=${BG_COLOR}:1080x1920:duration=${DURATION}" \
  -loop 1 -i assets/object.png \
  -filter_complex "
    [1:v]
      scale=700:-1,
      format=rgba,
      colorchannelmixer=rr=1:gg=1:bb=1,
      fade=t=in:st=0:d=${POP_TIME}:alpha=1,
      fade=t=out:st=${FADE_OUT_START}:d=0.8:alpha=1,
      scale=
        iw*if(lt(t,${POP_TIME}),t/${POP_TIME},1):
        ih*if(lt(t,${POP_TIME}),t/${POP_TIME},1),
      colorbalance=
        rs=if(gt(t,4),0.4,0):
        gs=if(gt(t,4),0.2,0):
        bs=if(gt(t,4),-0.2,0)
      [obj];

    [0:v][obj]overlay=
      x=(W-w)/2:
      y=(H-h)/2+${BOUNCE_AMPLITUDE}*abs(sin(2*PI*t/${BOUNCE_PERIOD}))
  " \
  -t ${DURATION} \
  -r 25 \
  -pix_fmt yuv420p \
  output/short.mp4

echo "Event-driven kid animation generated"
