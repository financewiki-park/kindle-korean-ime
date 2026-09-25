#!/bin/sh
set -u
# No rootfs file, LIPC property, keyboard configuration or daemon is installed.
# Preserve probe evidence; remove only this package's mutable staging state.
rm -f /mnt/us/korean-ime/preflight.txt
exit 0
