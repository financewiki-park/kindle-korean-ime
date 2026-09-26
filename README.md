# Kindle Korean IME

KPM-installable Korean keyboard / IME for jailbroken Kindle devices.

Korean installation guide: [docs/BLOG-KO-INSTALL.md](docs/BLOG-KO-INSTALL.md)

## Status

**Development / guarded staging stage (0.2.0).**

The Probe is read-only and repeatable from KPM's Launch action. The IME package now contains tested Dubeolsik composition code and both ARM bridge builds, but activation remains blocked until a real Probe report establishes the device-specific X11/LIPC contract.

## Goal

- Install, update and uninstall through KPM
- Native Kindle keyboard integration
- Dubeolsik Korean layout
- Hangul composition including compound vowels/finals
- Correct composition-aware Backspace
- English/Korean switching through the native keyboard language control
- Clean rollback on uninstall

## Development plan

1. Compatibility probe
2. Device-specific ARM builds and native keyboard integration
3. KPM-distributed Korean Keyboard package
4. Native preedit/commit/replace integration where supported

## Safety

Do not install an experimental IME binary on a Kindle until its model/firmware has passed the compatibility probe. The probe itself is designed not to modify rootfs or keyboard configuration.

## Credits

The project design references the MIT-licensed Kingul project by hy1o and current KindleModding/KPM conventions. New composition/backspace logic and packaging are being developed separately for this project.
