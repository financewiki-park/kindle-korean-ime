#!/bin/sh
set -u
echo "preflight_schema=2"
echo "status=diagnostic_only"
echo "reason=x11_bridge_disabled_after_runtime_failure"
echo "keyboard_settings_changed=no"
exit 0
