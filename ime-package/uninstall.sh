#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
BACKUP="$STATE/backup"
CONFIG=/var/local/system/keyboard.conf
PREF=/var/local/java/prefs/Keyboard.preferences
RESUME="$STATE/start-korean-ime.sh"
DOCUMENT='/mnt/us/documents/Korean IME Start.sh'
ICON_SOURCE='./scriptlets/Korean IME Start.png'
ICON_DOCUMENT='/mnt/us/documents/Korean IME Start.png'
if [ -r "$STATE/bridge.pid" ]; then
  pid="$(cat "$STATE/bridge.pid" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && [ -r "/proc/$pid/cmdline" ] && grep -aq 'korean-ime-x11' "/proc/$pid/cmdline"; then
    kill "$pid" 2>/dev/null || true
  fi
  rm -f "$STATE/bridge.pid"
fi
if [ -r "$BACKUP/keyboard.conf.pre-ko" ]; then cp "$BACKUP/keyboard.conf.pre-ko" "$CONFIG"; fi
if [ -r "$BACKUP/Keyboard.preferences.pre-ko" ]; then cp "$BACKUP/Keyboard.preferences.pre-ko" "$PREF"; fi
if [ -f "$RESUME" ] && grep -q '^# korean-ime-resume-launcher$' "$RESUME"; then rm -f "$RESUME"; fi
if [ -f "$DOCUMENT" ] && grep -q '^# korean-ime-resume-launcher$' "$DOCUMENT"; then rm -f "$DOCUMENT"; fi
if [ -f "$ICON_DOCUMENT" ] && [ -r "$ICON_SOURCE" ] && cmp -s "$ICON_SOURCE" "$ICON_DOCUMENT"; then rm -f "$ICON_DOCUMENT"; fi
if command -v lipc-set-prop >/dev/null 2>&1; then lipc-set-prop com.lab126.KeyboardLayout selectedKeyboard en_US 2>/dev/null || true; fi
echo "Korean keyboard configuration, resume launcher, and running bridge removed."
