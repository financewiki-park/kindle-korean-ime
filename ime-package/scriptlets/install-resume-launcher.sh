#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
SOURCE=./scriptlets/start-korean-ime.sh
ICON_SOURCE='./scriptlets/Korean IME Start.png'
RESUME="$STATE/start-korean-ime.sh"
DOCUMENT='/mnt/us/documents/Korean IME Start.sh'
ICON_DOCUMENT='/mnt/us/documents/Korean IME Start.png'
mkdir -p "$STATE" /mnt/us/documents
cp "$SOURCE" "$RESUME"
chmod 755 "$RESUME"
cp "$SOURCE" "$DOCUMENT"
chmod 755 "$DOCUMENT"
cp "$ICON_SOURCE" "$ICON_DOCUMENT"
echo "resume_launcher=$DOCUMENT"
