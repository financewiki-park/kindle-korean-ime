#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
BACKUP="$STATE/backup"
CONFIG=/var/local/system/keyboard.conf
PREF=/var/local/java/prefs/Keyboard.preferences
if [ -r "$BACKUP/keyboard.conf.pre-ko" ]; then cp "$BACKUP/keyboard.conf.pre-ko" "$CONFIG"; fi
if [ -r "$BACKUP/Keyboard.preferences.pre-ko" ]; then cp "$BACKUP/Keyboard.preferences.pre-ko" "$PREF"; fi
if command -v lipc-set-prop >/dev/null 2>&1; then lipc-set-prop com.lab126.KeyboardLayout selectedKeyboard en_US 2>/dev/null || true; fi
echo "Korean keyboard configuration restored from backup. Restart the Kindle."
