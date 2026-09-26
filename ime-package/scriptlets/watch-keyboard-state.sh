#!/bin/sh
# Read-only snapshot loop. Run it, then open a native Kindle text field.
set -u

echo "native_keyboard_watch_schema=1"
echo "samples=90"
sample=0
while [ "$sample" -lt 90 ]; do
  echo "[sample $sample]"
  date 2>/dev/null || true
  for property in appID flags show preedit keyboard_language language languages bounds; do
    printf '%s=' "$property"
    lipc-get-prop com.lab126.keyboard "$property" 2>&1 || true
  done
  sample=$((sample + 1))
  sleep 1
done
