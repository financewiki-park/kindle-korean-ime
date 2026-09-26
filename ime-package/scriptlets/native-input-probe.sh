#!/bin/sh
# Read-only evidence capture for the native Kindle keyboard path.
set -u

echo "Kindle Korean IME native-input probe"
echo "===================================="
date 2>/dev/null || true
echo
echo "[keyboard service metadata]"
lipc-probe com.lab126.keyboard 2>&1 || true
echo
echo "[keyboard layout metadata]"
lipc-probe com.lab126.KeyboardLayout 2>&1 || true
echo
echo "[input method candidates]"
for service in com.amazon.kindle.inputMethod com.lab126.inputMethod; do
  echo "--- $service ---"
  lipc-probe "$service" 2>&1 || true
done
echo
echo "[live keyboard state]"
for property in appID flags show preedit keyboard_language language languages rescan; do
  printf '%s=' "$property"
  lipc-get-prop com.lab126.keyboard "$property" 2>&1 || true
done
echo
echo "[framework process candidates]"
ps w 2>/dev/null | grep -Ei '[k]eyboard|[i]nput|framework|cvm' | head -100 || true
