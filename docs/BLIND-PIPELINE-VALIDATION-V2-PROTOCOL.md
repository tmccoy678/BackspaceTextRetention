# Blinded byte-recovery validation v2

**Declared before generation and decoding on 2026-09-24.**

The earlier ten-fixture pilot is excluded because its decoded strings were
displayed before a recovery table was frozen. This restart incorporates the
requested quantitative Excel and R workflow from the outset.

## Objective

Estimate exact recovery performance of the current read-only byte-inspection
pipeline on ten previously unseen synthetic transcript-like byte sequences.
This tests fixture parsing, display, and exact transcription. It does not
estimate every possible error in the historical experiment and does not test
whether a cloud service receives text before submission.

## Fixed procedure

1. Generate ten hidden 15-character ASCII targets with Python's `secrets`
   module. Mixed case, digits, spaces, `.`, `-`, and `_` are eligible; the first
   and last characters are alphanumeric.
2. Place each target after a non-printing boundary and before exactly fifteen
   `08 20 08` erase triplets, followed by a separate committed string.
3. Save and hash the target table without displaying it. Commit the protocol,
   generator, fixtures, targets, and SHA-256 commitment before decoding.
4. Decode with the existing repository inspection tool. Freeze each reported
   draft and erase count in `recoveries.csv`, then commit that file before
   opening or comparing the hidden target table.
5. Unblind once. Produce row-level and summary CSV files, an Excel `.xlsx`
   workbook, and an R `binom.test` report.
6. Verify that Python and R agree on counts and that the workbook is a valid ZIP
   container with the expected worksheets.

The blinding is procedural, not cryptographic: the target file exists locally
but must not be opened or displayed until recoveries are fixed.

## Quantitative endpoints

- Fixture-level exact recovery: exact case-, space-, punctuation-, and
  position-sensitive equality, reported as `x/10`.
- Character agreement: matching positions out of 150, reported descriptively;
  characters within a string are not treated as independent experimental
  units.
- Edit distance for each recovered string.
- Erase-count agreement: fixtures with exactly 15 recovered triplets out of 10.
- Two-sided 95% Clopper-Pearson interval for fixture-level exact recovery,
  calculated with R's `binom.test`.

A *t* test is not used because the primary data are binary exact-match outcomes,
not independent continuous means. A 10/10 result means zero observed errors in
ten fixtures; it does not establish a zero population error rate.

