# Compatibility probe

The 0.2.x package is a read-only discovery step and can be repeated through KPM Launch.

It records:

- firmware/version information
- CPU/ABI clues
- contents of `/usr/share/keyboard`
- whether a Korean keyboard resource already exists
- `com.lab126.keyboard languages`
- discoverable keyboard/input-method LIPC interfaces
- relevant mounts

The report is written to:

`/mnt/us/korean-ime-probe/report.txt`

The probe does **not** remount rootfs read/write, install an Upstart service, replace keyboard resources, or change the active language list.
