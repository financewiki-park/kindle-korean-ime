#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime; mkdir -p "$STATE"
# A PID alone is not an identity: after a Kindle reboot it can be reused by an
# unrelated process.  Only retain it when /proc confirms it is our bridge.
if [ -r "$STATE/bridge.pid" ]; then
  pid="$(cat "$STATE/bridge.pid" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && [ -r "/proc/$pid/cmdline" ] && grep -aq 'korean-ime-x11' "/proc/$pid/cmdline"; then
    echo 'bridge=already_running'; exit 0
  fi
  rm -f "$STATE/bridge.pid"
fi
for target in kindlehf kindlepw2; do
  binary="./bin/$target/korean-ime-x11"
  if [ -x "$binary" ]; then
    : >"$STATE/bridge.log"
    if command -v nohup >/dev/null 2>&1; then nohup "$binary" --diagnose >>"$STATE/bridge.log" 2>&1 < /dev/null & else "$binary" --diagnose >>"$STATE/bridge.log" 2>&1 & fi
    echo $! >"$STATE/bridge.pid"; echo "bridge=started target=$target"; exit 0
  fi
done
echo 'bridge=no_arm_binary' >&2; exit 2
