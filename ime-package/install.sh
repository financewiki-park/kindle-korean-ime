#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
sh ./scriptlets/preflight.sh >"$STATE/preflight.txt" 2>&1
sh ./scriptlets/native-input-probe.sh >"$STATE/native-input.txt" 2>&1
echo "Native-input diagnostics saved. No Kindle keyboard setting was changed."
