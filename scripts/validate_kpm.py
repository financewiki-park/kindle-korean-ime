#!/usr/bin/env python3
"""Small offline check for the KPM repository manifest and produced archives."""
import json
import sys
import tarfile

repo_path, *archives = sys.argv[1:]
repo = json.load(open(repo_path, encoding="utf-8"))
assert repo["manifest_version"] == 2
assert repo["id"] == "korean-ime"
for package in repo["packages"].values():
    assert package["artifacts"]
    for artifact in package["artifacts"]:
        assert len(artifact["version"]) == 3
        assert set(artifact["supported_platforms"]) == {"kindlehf", "kindlepw2"}
for archive in archives:
    with tarfile.open(archive, "r:gz") as tar:
        names = {n.lstrip("./") for n in tar.getnames()}
        assert "manifest.json" in names, archive
        member = next(n for n in tar.getmembers() if n.name.lstrip("./") == "manifest.json")
        manifest = json.load(tar.extractfile(member))
        assert manifest["manifest_version"] == 3
        assert "install.sh" in names and "uninstall.sh" in names
print("KPM manifest/archive validation: ok")
