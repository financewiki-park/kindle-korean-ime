#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime; BACKUP="$STATE/backup"; CONFIG=/var/local/system/keyboard.conf; PREF=/var/local/java/prefs/Keyboard.preferences; TMP="$STATE/keyboard.conf.new"
mkdir -p "$BACKUP"
[ -r "$CONFIG" ] && [ -r "$PREF" ] && [ -r /usr/share/keyboard/ko/ko.kdb ]
[ -r "$BACKUP/keyboard.conf.pre-ko" ] || cp "$CONFIG" "$BACKUP/keyboard.conf.pre-ko"
[ -r "$BACKUP/Keyboard.preferences.pre-ko" ] || cp "$PREF" "$BACKUP/Keyboard.preferences.pre-ko"
if grep -q '"id"[[:space:]]*:[[:space:]]*"ko"' "$CONFIG"; then cp "$CONFIG" "$TMP"; else awk '/"all"[[:space:]]*:/ { sub(/\[\{/, "["); print; print "\t\t{\"id\": \"ko\", \"name\": \"Korean\"}, {"; next } { print }' "$CONFIG" >"$TMP"; fi
sed -i -e 's/"selected"[[:space:]]*:[[:space:]]*"[^"]*"/"selected": "ko"/' -e 's/"current"[[:space:]]*:[[:space:]]*"[^"]*"/"current": "ko"/' "$TMP"
grep -q '"id"[[:space:]]*:[[:space:]]*"ko"' "$TMP" && grep -q '"selected"[[:space:]]*:[[:space:]]*"ko"' "$TMP"
cp "$TMP" "$CONFIG"; sed -i -e 's/^keyboard=.*/keyboard=ko/' "$PREF"
if command -v lipc-set-prop >/dev/null 2>&1; then
  languages="$(lipc-get-prop com.lab126.keyboard languages 2>/dev/null || true)"
  case ":$languages:" in *:ko:*) ;; *) languages="${languages:+$languages:}ko";; esac
  [ -n "$languages" ] && lipc-set-prop com.lab126.keyboard languages "$languages" 2>/dev/null || true
  lipc-set-prop com.lab126.keyboard language ko 2>/dev/null || true
  lipc-set-prop com.lab126.KeyboardLayout selectedKeyboard ko 2>/dev/null || true
fi
echo 'status=activated'
