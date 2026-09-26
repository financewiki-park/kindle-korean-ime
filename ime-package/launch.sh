#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
sh ./scriptlets/preflight.sh >"$STATE/launch.txt" 2>&1
sh ./scriptlets/native-input-probe.sh >"$STATE/native-input.txt" 2>&1
sh ./scriptlets/activate-korean.sh >>"$STATE/launch.txt" 2>&1
sh ./scriptlets/run-native-bridge.sh >>"$STATE/launch.txt" 2>&1
echo "Korean layout and native-focus bridge started. Do not reboot during the trial."
