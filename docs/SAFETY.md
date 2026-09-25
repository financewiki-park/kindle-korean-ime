# Safety and lifecycle

`korean-ime-probe` only reads device data and writes `/mnt/us/korean-ime-probe/report.txt`. Its KPM `install.sh` and `launch.sh` run the same probe, so it can be repeated without reinstalling.

`korean-ime` carries both ARM bridge binaries but is intentionally *staged*, not activated. Its install hook creates only `/mnt/us/korean-ime/preflight.txt`; it never writes rootfs, changes `/usr/share/keyboard`, starts a daemon, changes LIPC properties, or edits a boot hook. `launch.sh` refuses activation until a reviewed model/firmware/window/keycode policy is committed after a real Probe result.

KPM runs `uninstall.sh upgrade` before extracting an upgrade. The uninstall hook removes only its disposable preflight state, leaving the Probe report intact. A failed KPM install invokes the package uninstall hook and removes its package directory, so there is no partial rootfs state to roll back.

The eventual activation policy must be a versioned allowlist keyed by model, firmware family, KPM platform, verified X11 keycode range, and observed keyboard/LIPC behavior. A report that is merely syntactically valid is not permission to activate the bridge.
