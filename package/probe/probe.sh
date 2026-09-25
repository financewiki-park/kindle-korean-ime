#!/bin/sh
set -u

OUT="/mnt/us/korean-ime-probe"
REPORT="$OUT/report.txt"
MODE="${1:-manual}"
mkdir -p "$OUT"

{
  echo "Kindle Korean IME compatibility probe"
  echo "====================================="
  echo "probe_schema=3"
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
  echo "[input method]"
  lipc-probe -a 2>/dev/null | grep -i -E 'keyboard|inputmethod|preedit|commit|replace' | head -200 || true
  echo
  echo "[mounts]"
  mount 2>/dev/null | grep -E ' / |/usr/share/keyboard|/mnt/us' || true
} > "$REPORT" 2>&1

chmod 0644 "$REPORT" 2>/dev/null || true
echo "Probe complete: $REPORT"
exit 0
