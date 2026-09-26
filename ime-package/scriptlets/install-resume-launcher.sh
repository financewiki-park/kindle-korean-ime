#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
SOURCE=./scriptlets/start-korean-ime.sh
ICON_SOURCE=./scriptlets/icon.png
RESUME="$STATE/start-korean-ime.sh"
DOCUMENT='/mnt/us/documents/Korean IME Start.sh'
ICON="$STATE/icon.png"
mkdir -p "$STATE" /mnt/us/documents
cp "$SOURCE" "$RESUME"
chmod 755 "$RESUME"
cp "$SOURCE" "$DOCUMENT"
chmod 755 "$DOCUMENT"
cp "$ICON_SOURCE" "$ICON"
echo "resume_launcher=$DOCUMENT"
