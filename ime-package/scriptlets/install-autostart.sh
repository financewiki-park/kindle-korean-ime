#!/bin/sh
set -eu
STATE=/mnt/us/korean-ime
JOB=/etc/upstart/korean-ime.conf
SOURCE=./startup/korean-ime.conf
mkdir -p "$STATE/backup"
[ "$(id -u)" = 0 ] || { echo 'autostart=blocked:not_root'; exit 2; }
[ -d /etc/upstart ] && [ -r "$SOURCE" ] || { echo 'autostart=blocked:upstart_unavailable'; exit 2; }
if [ -e "$JOB" ] && ! grep -q '^# Korean IME persistent bridge' "$JOB"; then
  echo 'autostart=blocked:foreign_job_exists'; exit 2
fi
if [ -e "$JOB" ] && [ ! -e "$STATE/backup/korean-ime.conf.pre-package" ]; then
  cp "$JOB" "$STATE/backup/korean-ime.conf.pre-package"
fi
cp "$SOURCE" "$JOB.new"
mv "$JOB.new" "$JOB"
if command -v initctl >/dev/null 2>&1; then initctl reload-configuration 2>/dev/null || true; fi
echo 'autostart=installed:framework_ready'
