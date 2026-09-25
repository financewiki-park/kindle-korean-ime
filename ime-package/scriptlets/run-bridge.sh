#!/bin/sh
set -u
case "${KPM_PLATFORM:-}" in
  kindlehf) exec ./bin/kindlehf/korean-ime-x11 ;;
  kindlepw2) exec ./bin/kindlepw2/korean-ime-x11 ;;
  *) echo "Unsupported KPM platform: ${KPM_PLATFORM:-unknown}" >&2; exit 2 ;;
esac
