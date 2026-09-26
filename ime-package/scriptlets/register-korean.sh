#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
BACKUP="$STATE/backup"
CONFIG=/var/local/system/keyboard.conf
PREF=/var/local/java/prefs/Keyboard.preferences
TMP="$STATE/keyboard.conf.new"
mkdir -p "$BACKUP"
[ -r "$CONFIG" ] && [ -r /usr/share/keyboard/ko/ko.kdb ]
[ -r "$BACKUP/keyboard.conf.pre-ko" ] || cp "$CONFIG" "$BACKUP/keyboard.conf.pre-ko"
[ -r "$PREF" ] && [ -r "$BACKUP/Keyboard.preferences.pre-ko" ] || cp "$PREF" "$BACKUP/Keyboard.preferences.pre-ko"
if grep -q '"id"[[:space:]]*:[[:space:]]*"ko"' "$CONFIG"; then
  cp "$CONFIG" "$TMP"
else
  awk '/"all"[[:space:]]*:/ { sub(/\[\{/, "["); print; print "\t\t{\"id\": \"ko\", \"name\": \"Korean\"}, {"; next } { print }' "$CONFIG" >"$TMP"
fi
sed -i -e 's/"selected"[[:space:]]*:[[:space:]]*"[^"]*"/"selected": "ko"/' -e 's/"current"[[:space:]]*:[[:space:]]*"[^"]*"/"current": "ko"/' "$TMP"
grep -q '"id"[[:space:]]*:[[:space:]]*"ko"' "$TMP"
grep -q '"selected"[[:space:]]*:[[:space:]]*"ko"' "$TMP"
cp "$TMP" "$CONFIG"
sed -i -e 's/^keyboard=.*/keyboard=ko/' "$PREF"
echo "status=registered"
