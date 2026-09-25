#!/bin/sh
set -u
# KPM's launch hook makes the read-only probe repeatable without reinstalling.
exec /bin/sh ./probe/probe.sh launch
