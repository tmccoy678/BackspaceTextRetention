#!/usr/bin/env python3
"""Generate the fixed v2 blinded fixtures without printing target strings."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import secrets
import string


ROOT = Path(__file__).resolve().parents[1]
VALIDATION_DIR = ROOT / "data/blind-validation-v2"
FIXTURE_DIR = VALIDATION_DIR / "fixtures"
TARGETS = VALIDATION_DIR / "targets.json"
COMMITMENT = VALIDATION_DIR / "targets.sha256"

COUNT = 10
LENGTH = 15
ERASE_TRIPLET = b"\x08\x20\x08"
EDGE_ALPHABET = string.ascii_letters + string.digits
BODY_ALPHABET = EDGE_ALPHABET + " .-_"


def random_text() -> str:
    middle = "".join(secrets.choice(BODY_ALPHABET) for _ in range(LENGTH - 2))
    return secrets.choice(EDGE_ALPHABET) + middle + secrets.choice(EDGE_ALPHABET)


def main() -> int:
    if VALIDATION_DIR.exists():
        raise SystemExit(
            f"Refusing to overwrite an existing validation set: {VALIDATION_DIR}"
        )

    FIXTURE_DIR.mkdir(parents=True, mode=0o700)
    records: list[dict[str, object]] = []
    for number in range(1, COUNT + 1):
        target = random_text()
        committed = random_text()
        fixture_name = f"blind-v2-{number:02d}.typescript"
        fixture = (
            b"BLIND-VALIDATION-V2\n"
            + target.encode("ascii")
            + ERASE_TRIPLET * LENGTH
            + committed.encode("ascii")
            + b"\nEND\n"
        )
        path = FIXTURE_DIR / fixture_name
        path.write_bytes(fixture)
        path.chmod(0o600)
        records.append(
            {
                "fixture": fixture_name,
                "target": target,
                "committed": committed,
                "erase_triplets": LENGTH,
                "fixture_sha256": hashlib.sha256(fixture).hexdigest(),
            }
        )

    encoded = (json.dumps(records, indent=2, ensure_ascii=True) + "\n").encode("utf-8")
    TARGETS.write_bytes(encoded)
    TARGETS.chmod(0o600)
    digest = hashlib.sha256(encoded).hexdigest()
    COMMITMENT.write_text(f"{digest}  targets.json\n", encoding="ascii")
    COMMITMENT.chmod(0o600)
    print(f"Generated {COUNT} blinded v2 fixtures; targets were not displayed.")
    print(f"Target-table SHA-256 commitment: {digest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

