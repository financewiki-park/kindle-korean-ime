#!/bin/sh
set -u
echo "preflight_schema=3"
[ -r /var/local/system/keyboard.conf ] && [ -r /var/local/java/prefs/Keyboard.preferences ] && [ -r /usr/share/keyboard/ko/ko.kdb ]
echo "status=ready"
echo "reason=native_gtk_input_method_observed"
exit 0
