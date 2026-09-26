#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
./scriptlets/preflight.sh >"$STATE/preflight.txt" 2>&1
./scriptlets/register-korean.sh >"$STATE/install.txt" 2>&1
echo "Korean keyboard registered. Restart the Kindle to load it, or launch this package."
