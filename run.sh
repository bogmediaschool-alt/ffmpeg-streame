#!/bin/bash
SOURCE="http://s.only4.tv/0151/video.m3u8?token=Fi3uUm4NH5"
DEST="rtmps://dc4-1.rtmp.t.me/s/1395908251:5GXfWknZ_38cNuLKoKSTUg"

ffmpeg -re -i "$SOURCE" \
  -vf "scale=640:360" \
  -c:v libx264 -preset ultrafast -tune zerolatency -b:v 800k \
  -c:a aac -b:a 96k -ar 44100 -ac 2 \
  -f flv "$DEST"
