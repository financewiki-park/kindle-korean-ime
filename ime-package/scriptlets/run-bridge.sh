#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
if [ -r "$STATE/bridge.pid" ] && kill -0 "$(cat "$STATE/bridge.pid")" 2>/dev/null; then exit 0; fi
for target in kindlehf kindlepw2; do
  if [ -x "./bin/$target/korean-ime-x11" ]; then
    "./bin/$target/korean-ime-x11" >>"$STATE/bridge.log" 2>&1 &
    echo $! >"$STATE/bridge.pid"
    exit 0
  fi
done
echo "No ARM bridge binary found" >&2
exit 2
