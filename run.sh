#!/bin/bash

SOURCE="http://s.only4.tv/0151/video.m3u8?token=Fi3uUm4NH5"
DEST="rtmps://dc4-1.rtmp.t.me/s/1395908251:5GXfWknZ_38cNuLKoKSTUg"

echo "Starting stream..."
ffmpeg -re -i "$SOURCE" \
  -c:v libx264 -preset veryfast -b:v 2500k \
  -c:a aac -b:a 128k -ar 44100 \
  -f flv "$DEST"
