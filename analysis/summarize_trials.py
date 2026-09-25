#!/usr/bin/env python3
"""Reproduce the preregistered descriptive statistics."""

from __future__ import annotations

import csv
from collections import defaultdict
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data/trial-outcomes.csv"
ENDPOINTS = ("model_exact_marker", "transcript_input_echo", "model_none")


def load_rows(path: Path = DATA) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def summarize(rows: list[dict[str, str]]) -> dict[str, dict[str, tuple[int, int]]]:
    grouped: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        grouped[row["condition"]].append(row)

    result: dict[str, dict[str, tuple[int, int]]] = {}
    for condition in ("canonical", "raw"):
        condition_rows = grouped[condition]
        if len(condition_rows) != 6:
            raise ValueError(f"Expected six {condition} rows; found {len(condition_rows)}")
        result[condition] = {
            endpoint: (sum(int(row[endpoint]) for row in condition_rows), len(condition_rows))
            for endpoint in ENDPOINTS
        }
    return result


def main() -> int:
    summary = summarize(load_rows())
    print("BACKSPACE GATE — PREDECLARED DESCRIPTIVE ENDPOINTS")
    for endpoint in ENDPOINTS:
        canonical_yes, canonical_n = summary["canonical"][endpoint]
        raw_yes, raw_n = summary["raw"][endpoint]
        difference = (raw_yes / raw_n) - (canonical_yes / canonical_n)
        print(
            f"{endpoint}: canonical={canonical_yes}/{canonical_n}; "
            f"raw={raw_yes}/{raw_n}; raw-minus-canonical={difference:+.0%}"
        )
    print("Inferential tests: not performed (predeclared single-process boundary).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
