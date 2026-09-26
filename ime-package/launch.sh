#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
./scriptlets/register-korean.sh >"$STATE/launch.txt" 2>&1
if command -v lipc-set-prop >/dev/null 2>&1; then
  lipc-set-prop com.lab126.KeyboardLayout selectedKeyboard ko >>"$STATE/launch.txt" 2>&1 || true
fi
echo "Korean keyboard configuration applied. Restart if it does not appear immediately."
