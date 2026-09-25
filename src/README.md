# IME engine

The guarded production composition core and X11 bridge live here.

Design target:

1. Dubeolsik key -> compatibility jamo mapping.
2. Stateful choseong/jungseong/jongseong composition.
3. Compound vowels and final consonants.
4. Composition-aware Backspace.
5. Output adapter separated from the Hangul state machine.
6. Prefer Kindle native preedit/commit/replace APIs where present; retain an X11 adapter only as a compatibility fallback.

Both ARM variants are packaged, but their launch hook remains blocked until the device compatibility report is reviewed and an allowlist is committed.
