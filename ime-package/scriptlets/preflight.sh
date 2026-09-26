#!/bin/sh
set -u
REPORT=/mnt/us/korean-ime-probe/report.txt
echo "preflight_schema=1"
if [ ! -r "$REPORT" ]; then
  echo "status=blocked"
  echo "reason=missing_probe_report"
  exit 1
fi
if ! grep -Eq '^probe_schema=(2|3|4|5)$' "$REPORT"; then
  echo "status=blocked"
  echo "reason=unsupported_probe_schema"
  exit 1
fi
if ! grep -q '^platform=\(kindlepw2\|kindlehf\)$' "$REPORT"; then
  echo "status=blocked"
  echo "reason=unknown_or_unsupported_platform"
  exit 1
fi
if ! grep -q '^\[LIPC keyboard\]$' "$REPORT"; then
  echo "status=blocked"
  echo "reason=keyboard_probe_incomplete"
  exit 1
fi
echo "status=ready-for-device-policy"
echo "reason=report_present_but_no_model_firmware_window_allowlist"
exit 0
