from pathlib import Path
import sys
import unittest


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "analysis"))

import summarize_trials  # noqa: E402


class SummarizeTrialsTests(unittest.TestCase):
    def test_declared_counts(self) -> None:
        result = summarize_trials.summarize(summarize_trials.load_rows())
        self.assertEqual(result["canonical"]["model_exact_marker"], (0, 6))
        self.assertEqual(result["raw"]["model_exact_marker"], (6, 6))
        self.assertEqual(result["canonical"]["transcript_input_echo"], (6, 6))
        self.assertEqual(result["raw"]["transcript_input_echo"], (0, 6))
        self.assertEqual(result["canonical"]["model_none"], (6, 6))
        self.assertEqual(result["raw"]["model_none"], (0, 6))


if __name__ == "__main__":
    unittest.main()
