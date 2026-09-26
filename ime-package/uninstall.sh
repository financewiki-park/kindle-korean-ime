#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
BACKUP="$STATE/backup"
CONFIG=/var/local/system/keyboard.conf
PREF=/var/local/java/prefs/Keyboard.preferences
JOB=/etc/upstart/korean-ime.conf
if [ -r "$STATE/bridge.pid" ]; then
  pid="$(cat "$STATE/bridge.pid" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && [ -r "/proc/$pid/cmdline" ] && grep -aq 'korean-ime-x11' "/proc/$pid/cmdline"; then
    kill "$pid" 2>/dev/null || true
  fi
  rm -f "$STATE/bridge.pid"
fi
if [ -e "$JOB" ] && grep -q '^# Korean IME persistent bridge' "$JOB"; then
  if command -v initctl >/dev/null 2>&1; then initctl stop korean-ime 2>/dev/null || true; fi
  rm -f "$JOB"
  if command -v initctl >/dev/null 2>&1; then initctl reload-configuration 2>/dev/null || true; fi
fi
if [ -r "$BACKUP/keyboard.conf.pre-ko" ]; then cp "$BACKUP/keyboard.conf.pre-ko" "$CONFIG"; fi
if [ -r "$BACKUP/Keyboard.preferences.pre-ko" ]; then cp "$BACKUP/Keyboard.preferences.pre-ko" "$PREF"; fi
if command -v lipc-set-prop >/dev/null 2>&1; then lipc-set-prop com.lab126.KeyboardLayout selectedKeyboard en_US 2>/dev/null || true; fi
echo "Korean keyboard configuration, boot bridge, and running bridge removed."
