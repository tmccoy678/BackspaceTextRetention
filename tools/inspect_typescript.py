#!/usr/bin/env python3
"""Inspect macOS script(1) recordings without interpreting control bytes."""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import re


ERASE_TRIPLET = b"\x08\x20\x08"
ERASE_RUN = re.compile(b"(?:\x08\x20\x08)+")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def erase_runs(data: bytes) -> list[tuple[int, int, int]]:
    """Return (start, end, triplet_count) for contiguous 08 20 08 runs."""
    return [
        (match.start(), match.end(), len(match.group()) // len(ERASE_TRIPLET))
        for match in ERASE_RUN.finditer(data)
    ]


def printable_before(data: bytes, offset: int) -> str:
    start = offset
    while start and 0x20 <= data[start - 1] <= 0x7E:
        start -= 1
    return data[start:offset].decode("ascii")


def printable_after(data: bytes, offset: int) -> str:
    end = offset
    while end < len(data) and 0x20 <= data[end] <= 0x7E:
        end += 1
    return data[offset:end].decode("ascii")


def caret_render(data: bytes) -> str:
    rendered: list[str] = []
    for byte in data:
        if byte == 0x08:
            rendered.append("^H")
        elif byte == 0x0D:
            rendered.append("^M")
        elif byte == 0x0A:
            rendered.append("^J")
        elif 0x20 <= byte <= 0x7E:
            rendered.append(chr(byte))
        else:
            rendered.append(f"<0x{byte:02X}>")
    return "".join(rendered)


def hexdump(data: bytes, start: int, end: int, width: int = 16) -> str:
    lines: list[str] = []
    for offset in range(start, end, width):
        chunk = data[offset : min(offset + width, end)]
        hex_bytes = " ".join(f"{byte:02x}" for byte in chunk)
        ascii_bytes = "".join(chr(byte) if 0x20 <= byte <= 0x7E else "." for byte in chunk)
        lines.append(f"{offset:08x}  {hex_bytes:<{width * 3 - 1}}  |{ascii_bytes}|")
    return "\n".join(lines)


def inspect(path: Path) -> str:
    data = path.read_bytes()
    runs = erase_runs(data)
    lines = [
        "BACKSPACE GATE — READ-ONLY BYTE INSPECTION",
        f"FILE:    {path}",
        f"BYTES:   {len(data):,}",
        f"SHA-256: {sha256(data)}",
        f"ERASE RUNS (08 20 08): {len(runs)}",
    ]

    if not runs:
        return "\n".join(lines)

    for number, (start, end, count) in enumerate(runs, start=1):
        context_start = max(0, start - 18)
        context_end = min(len(data), end + 18)
        context = data[context_start:context_end]
        lines.extend(
            [
                "",
                f"RUN {number}: offsets {start}..{end - 1} "
                f"(0x{start:x}..0x{end - 1:x})",
                f"COUNT: {count} triplets = {end - start} bytes",
                f"BEFORE: {printable_before(data, start)!r}",
                f"AFTER:  {printable_after(data, end)!r}",
                "",
                "HEX VIEW (periods at right represent non-printable bytes):",
                hexdump(data, context_start, context_end),
                "",
                "CARET VIEW (^H is a display notation for byte 08):",
                caret_render(context),
            ]
        )

    lines.extend(
        [
            "",
            "The source file was opened read-only; this output is a representation.",
            "The SHA-256 identifies the untouched byte sequence being represented.",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("files", nargs="+", type=Path)
    args = parser.parse_args()
    for index, path in enumerate(args.files):
        if index:
            print("\n" + "=" * 79 + "\n")
        print(inspect(path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
