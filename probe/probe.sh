#!/bin/sh
set -u

OUT="/mnt/us/korean-ime-probe"
REPORT="$OUT/report.txt"
mkdir -p "$OUT"

{
  echo "Kindle Korean IME compatibility probe"
  echo "====================================="
  date 2>/dev/null || true
  echo
  echo "[system]"
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
  lipc-get-prop com.lab126.keyboard languages 2>&1 || true
  lipc-probe -a 2>/dev/null | grep -E 'com\.lab126\.keyboard|inputMethod' | head -100 || true
  echo
  echo "[input method]"
  lipc-probe -a 2>/dev/null | grep -i -E 'keyboard|inputmethod|preedit|commit|replace' | head -200 || true
  echo
  echo "[mounts]"
  mount 2>/dev/null | grep -E ' / |/usr/share/keyboard|/mnt/us' || true
} > "$REPORT" 2>&1

echo "Probe complete: $REPORT"
exit 0
