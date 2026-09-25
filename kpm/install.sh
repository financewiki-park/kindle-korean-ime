#!/bin/sh
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec /bin/sh "$ROOT/probe/probe.sh"
