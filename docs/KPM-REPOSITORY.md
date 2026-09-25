# KPM repository

Repository manifest:

https://raw.githubusercontent.com/financewiki-park/kindle-korean-ime/main/manifest.v2.json

Generated artifacts are stored under:

`packages/korean-ime-probe/artifacts/` and `packages/korean-ime/artifacts/`.

The packages are gzip-compressed tar archives, matching KPM manifest v3 packaging behavior. The Probe is read-only and writes its report to `/mnt/us/korean-ime-probe/report.txt`; use KPM Launch to repeat it.
