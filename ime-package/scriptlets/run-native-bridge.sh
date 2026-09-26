#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime; mkdir -p "$STATE"
if [ -r "$STATE/bridge.pid" ] && kill -0 "$(cat "$STATE/bridge.pid")" 2>/dev/null; then echo 'bridge=already_running'; exit 0; fi
for target in kindlehf kindlepw2; do
  binary="./bin/$target/korean-ime-x11"
  if [ -x "$binary" ]; then
    if command -v nohup >/dev/null 2>&1; then nohup "$binary" >>"$STATE/bridge.log" 2>&1 < /dev/null & else "$binary" >>"$STATE/bridge.log" 2>&1 & fi
    echo $! >"$STATE/bridge.pid"; echo "bridge=started target=$target"; exit 0
  fi
done
echo 'bridge=no_arm_binary' >&2; exit 2
