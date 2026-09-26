#!/bin/sh
set -u

OUT="/mnt/us/korean-ime-probe"
REPORT="$OUT/report.txt"
MODE="${1:-manual}"
mkdir -p "$OUT"

{
  echo "Kindle Korean IME compatibility probe"
  echo "====================================="
  echo "probe_schema=5"
  echo "probe_mode=$MODE"
  date 2>/dev/null || true
  echo
  echo "[system]"
  echo "platform=${KPM_PLATFORM:-unknown}"
  uname -a 2>&1
  [ -r /etc/prettyversion.txt ] && cat /etc/prettyversion.txt
  [ -r /etc/version.txt ] && cat /etc/version.txt
  echo
  echo "[cpu]"
  cat /proc/cpuinfo 2>/dev/null | sed -n '1,80p'
  echo
  echo "[keyboard resources]"
  ls -la /usr/share/keyboard 2>&1
  find /usr/share/keyboard -maxdepth 2 -type f 2>/dev/null | sort | sed -n '1,250p'
  echo
  echo "[Korean resource]"
  if [ -e /usr/share/keyboard/ko ]; then
    echo "ko resource: present"
    find /usr/share/keyboard/ko -maxdepth 2 -type f 2>/dev/null | sort
  else
    echo "ko resource: absent"
  fi
  echo
  echo "[LIPC keyboard]"
  if command -v lipc-get-prop >/dev/null 2>&1; then
    echo "lipc_keyboard_languages:"
    lipc-get-prop com.lab126.keyboard languages 2>&1 || true
    echo "keyboard_language:"
    lipc-get-prop com.lab126.keyboard keyboard_language 2>&1 || true
    echo "keyboard_preedit:"
    lipc-get-prop com.lab126.keyboard preedit 2>&1 || true
    echo "layout_selected_keyboard:"
    lipc-get-prop com.lab126.KeyboardLayout selectedKeyboard 2>&1 || true
    echo "layout_selected_count:"
    lipc-get-prop com.lab126.KeyboardLayout selectedKeyboardsCount 2>&1 || true
    echo "layout_keyboard_data:"
    lipc-get-prop com.lab126.KeyboardLayout keyboardData 2>&1 || true
  else
    echo "lipc-get-prop: absent"
  fi
  lipc-probe -a 2>/dev/null | grep -E 'com\.lab126\.keyboard|inputMethod' | head -100 || true
  echo
  echo "[keyboard registry candidates]"
  echo "configuration files mentioning en_US:"
  grep -RIl \
    --include='*.conf' --include='*.ini' --include='*.json' --include='*.xml' --include='*.js' \
    'en_US' /var/local /opt/amazon/ebook 2>/dev/null | head -200 || true
  echo "keyboard-related configuration files:"
  find /var/local /opt/amazon/ebook -maxdepth 5 -type f \( \
    -iname '*keyboard*' -o -iname '*language*' -o -iname '*locale*' \) \
    2>/dev/null | sort | head -300 || true
  echo "keyboard processes:"
  ps w 2>/dev/null | grep -i '[k]eyboard' | head -100 || true
  echo "keyboard registry contents:"
  for registry_file in \
    /var/local/java/prefs/Keyboard.preferences \
    /var/local/java/prefs/language_layer.preferences \
    /var/local/system/keyboard.conf \
    /var/local/system/locale
  do
    echo "--- $registry_file ---"
    if [ -r "$registry_file" ]; then
      sed -n '1,260p' "$registry_file" 2>&1 || true
    else
      echo "unreadable_or_absent"
    fi
  done
  echo
  echo "[input method]"
  lipc-probe -a 2>/dev/null | grep -i -E 'keyboard|inputmethod|preedit|commit|replace' | head -200 || true
  echo
  echo "[mounts]"
  mount 2>/dev/null | grep -E ' / |/usr/share/keyboard|/mnt/us' || true
} > "$REPORT" 2>&1

chmod 0644 "$REPORT" 2>/dev/null || true
echo "Probe complete: $REPORT"
exit 0
