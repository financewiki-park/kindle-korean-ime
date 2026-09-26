#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
sh ./scriptlets/preflight.sh >"$STATE/preflight.txt" 2>&1
sh ./scriptlets/native-input-probe.sh >"$STATE/native-input.txt" 2>&1
sh ./scriptlets/activate-korean.sh >"$STATE/install.txt" 2>&1
sh ./scriptlets/run-native-bridge.sh >>"$STATE/install.txt" 2>&1
echo "Korean layout and native-focus composer installed. Re-launch after a reboot."
