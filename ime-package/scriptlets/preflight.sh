#!/bin/sh
set -u
REPORT=/mnt/us/korean-ime-probe/report.txt
echo "preflight_schema=1"
if [ ! -r "$REPORT" ]; then
  echo "status=blocked"
  echo "reason=missing_probe_report"
  exit 1
fi
if ! grep -q '^probe_schema=5$' "$REPORT"; then
  echo "status=blocked"
  echo "reason=unsupported_probe_schema"
  exit 1
fi
if ! grep -q '/usr/share/keyboard/ko/ko.kdb' "$REPORT" || ! grep -q '/var/local/system/keyboard.conf' "$REPORT"; then
  echo "status=blocked"
  echo "reason=missing_korean_resource_or_registry"
  exit 1
fi
echo "status=ready"
echo "reason=bellatrix_registry_path_confirmed"
exit 0
