#!/bin/sh
set -u
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
./scriptlets/preflight.sh >"$STATE/preflight.txt" 2>&1 || true
echo "Activation is intentionally disabled until a reviewed device policy exists." >>"$STATE/preflight.txt"
exit 1
