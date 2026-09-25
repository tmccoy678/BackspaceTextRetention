from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))

import inspect_typescript  # noqa: E402


class InspectTypescriptTests(unittest.TestCase):
    def test_finds_contiguous_erase_run(self) -> None:
        data = b"first" + (b"\x08 \x08" * 3) + b"second"
        self.assertEqual(inspect_typescript.erase_runs(data), [(5, 14, 3)])

    def test_discovery_recording_identity_and_count(self) -> None:
        path = ROOT / "evidence/transcripts/Blu-Offline-20260921-153748.typescript"
        data = path.read_bytes()
        self.assertEqual(len(data), 1344)
        self.assertEqual(
            inspect_typescript.sha256(data),
            "e2e3e56c7f81420a870501594e55aa908ef63c01d46794ef2072e9123014f016",
        )
        self.assertIn((1010, 1055, 15), inspect_typescript.erase_runs(data))

    def test_caret_render_is_explicitly_a_representation(self) -> None:
        self.assertEqual(inspect_typescript.caret_render(b"A\x08 \x08B"), "A^H ^HB")


if __name__ == "__main__":
    unittest.main()
