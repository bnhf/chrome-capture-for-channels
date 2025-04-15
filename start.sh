#!/bin/bash
# start.sh
# 2025.04.14

# Usage: node main.js [options]

# Options:
#   -v, --videoBitrate  Video bitrate in bits per second  [number] [default: 6000000]
#   -a, --audioBitrate  Audio bitrate in bits per second  [number] [default: 256000]
#   -f, --frameRate     Minimum frame rate  [number] [default: 30]
#   -p, --port          Port number for the server  [number] [default: 5589]
#   -w, --width         Video width in pixels (e.g., 1920 for 1080p)  [number] [default: 1920]
#   -h, --height        Video height in pixels (e.g., 1080 for 1080p)  [number] [default: 1080]
#   -i, --videoCodec    Video codec (e.g., h264_nvenc, h264_qsv, h264_amf, h264_vaapi)  [string] [default: "h264_nvenc"]
#   -u, --audioCodec    Audio codec (e.g., aac, opus)  [string] [default: "aac"]
#   -?, --help          Show help  [boolean]

# Examples:
#   node main.js -v 6000000 -a 192000 -f 30 -w 1920 -h 1080
#   node main.js --videoBitrate 8000000 --frameRate 60 --width 1920 --height 1080

[[ -f /dev/dri/renderD128 ]] && chown 0:107 /dev/dri/renderD128 # Correct group for node:lts-bullseye-slim

trap 'echo "Cleaning up..."; pkill -f "Xvfb :99"; pkill -f "x11vnc"; exit' SIGINT SIGTERM EXIT

Xvfb :99 -screen 0 1920x1080x16 &
x11vnc -quiet -nopw -display :99 -forever >x11vnc.log 2>&1 &
sleep 1
awk 'NR > 2' x11vnc.log
sleep 1
node main.js -v $VIDEO_BITRATE -a $AUDIO_BITRATE -f $FRAMERATE -p $CC4C_PORT -w $VIDEO_WIDTH -h $VIDEO_HEIGHT -i $VIDEO_CODEC -u $AUDIO_CODEC
