#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
sh ./scriptlets/preflight.sh >"$STATE/launch.txt" 2>&1
sh ./scriptlets/native-input-probe.sh >"$STATE/native-input.txt" 2>&1
if [ -r "$STATE/watch.pid" ] && kill -0 "$(cat "$STATE/watch.pid")" 2>/dev/null; then
  echo "Native keyboard watch is already running."
  exit 0
fi
if command -v nohup >/dev/null 2>&1; then
  nohup sh ./scriptlets/watch-keyboard-state.sh >"$STATE/live-keyboard.log" 2>&1 < /dev/null &
else
  sh ./scriptlets/watch-keyboard-state.sh >"$STATE/live-keyboard.log" 2>&1 &
fi
echo $! >"$STATE/watch.pid"
echo "Native keyboard watch started for 90 seconds. It continues after KTerm closes. No Kindle keyboard setting was changed."
