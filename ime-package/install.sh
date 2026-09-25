#!/bin/sh
set -u
STATE=/mnt/us/korean-ime
mkdir -p "$STATE"
./scriptlets/preflight.sh >"$STATE/preflight.txt" 2>&1 || true
if grep -q '^status=ready-for-device-policy$' "$STATE/preflight.txt"; then
  echo "Korean IME payload installed; device policy is still required before activation."
else
  echo "Korean IME payload staged safely. Read $STATE/preflight.txt."
fi
exit 0
