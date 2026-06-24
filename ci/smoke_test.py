#!/usr/bin/env python3
"""Smoke test for the published geospatial-python image.

Imports each bundled library and prints its version, exiting non-zero if any
import or version lookup fails. Run inside the image, e.g.

    docker run --rm -v "$PWD:/work" -w /work IMAGE python3 ci/smoke_test.py
"""
import importlib
import sys

# (module to import, attribute holding the version)
LIBRARIES = [
    ("numpy", "__version__"),
    ("osgeo.gdal", "__version__"),
    ("h5py", "__version__"),
    ("netCDF4", "__version__"),
    ("psycopg2", "__version__"),
    ("yaml", "__version__"),
    ("PIL", "__version__"),
]


def main() -> int:
    failures = []
    for module_name, version_attr in LIBRARIES:
        try:
            module = importlib.import_module(module_name)
            version = getattr(module, version_attr)
            print(f"OK   {module_name} {version}")
        except Exception as exc:  # noqa: BLE001 - report and keep going
            failures.append(f"{module_name}: {exc}")
            print(f"FAIL {module_name}: {exc}")

    if failures:
        print(f"\n{len(failures)} library check(s) failed", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
