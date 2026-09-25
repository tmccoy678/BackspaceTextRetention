# Publication venue assessment

**Assessment date:** September 24, 2026  
**Status:** Planning document, not a submission decision

## Field convention

Computer security and systems do not map neatly onto the natural sciences'
journal hierarchy. Selective conferences often carry the field's highest
prestige, while some leading venues use journal review followed by conference
presentation. For this project, fit and evidentiary maturity matter more than a
publisher's general brand.

## Best-fit candidates

| Venue | Why it could fit | What Backspace Gate would need first |
| --- | --- | --- |
| **Proceedings on Privacy Enhancing Technologies (PoPETs/PETS)** | Journal-style review, open access, and an explicit scope covering data-protection technologies, forensics and privacy, information leakage, human factors, and measurement of privacy in real systems. | A working commit-aware recorder, systematic real-system evaluation, a clear privacy threat model, cross-platform replication, and stronger related work. This is the best overall target if privacy-by-design remains central. |
| **ACM Transactions on Privacy and Security (TOPS)** | Archival journal whose scope includes system security and privacy, disclosure-risk measurement, secure systems, system tradeoffs, and usable privacy design. | A journal-scale study rather than a single case: multiple terminals/operating systems, formalized retention model, prototype, comparative evaluation, and demonstrated generality. |
| **Proceedings of the ACM on Measurement and Analysis of Computing Systems (POMACS), presented at SIGMETRICS** | Journal publication with a measurement-and-systems community; the 2027 call explicitly includes system measurement, experimental design, energy, and carbon footprint. | Make the storage/environment question the measured contribution: real workloads, logical versus physical writes, compression and replication, energy, performance, and SSD-wear measurements for baseline versus commit-aware recording. |
| **IEEE Transactions on Dependable and Secure Computing (TDSC)** | Archival security/systems journal that includes monitoring, measurement, workload characterization, and secure-system design and evaluation. | A system-level security contribution with technical depth and broad evaluation. The current case-report form is not enough, and at least one current TDSC call explicitly says it does not accept case-study papers. |
| **Symposium on Usable Privacy and Security (SOUPS)** | Not a journal, but a leading venue specifically requiring both human factors and privacy/security. Its scope includes field studies, warning design, usability testing, and privacy-feature design. | An ethics-reviewed study of what users think “backspaces in the log” means, whether they expect deleted draft recovery, and whether alternative warnings or recorder designs produce informed choices. |

## Nature-branded comparison

**Nature Computational Science** publishes significant computational methods,
tools, and frameworks with broad scientific relevance and expects compelling
experimental validation against relevant prior work. The present single-system
case is not a realistic fit. A future cross-platform data-minimizing terminal
architecture with convincing privacy, storage, energy, and durability results
could justify an editorial inquiry, but PoPETs, TOPS, or POMACS would still be
the more natural expert communities.

**Nature Reviews Computing** covers security, software systems, human-computer
interaction, low-energy computing, and sustainable computing, but publishes
reviews, perspectives, and comments rather than a primary case experiment. It
could become relevant only after a mature literature exists around recoverable
composition history and data-minimizing interactive systems.

## Current readiness judgment

The project now has a byte-preserved observation, source-grounded mechanism,
matched synthetic diagnostic, reproducible tools, and explicit claim boundaries.
That is a strong technical case report and an excellent foundation. It is not
yet ready for a top security, privacy, or systems venue.

The minimum credible expansion is:

1. conduct a systematic related-work search before claiming novelty;
2. instrument the PTY output and child-process input boundaries directly;
3. replicate across macOS versions, hardware families, terminal emulators, and
   non-model programs;
4. implement the proposed commit-aware recorder and an explicit exact-stream
   comparison mode;
5. measure privacy leakage, logical bytes, allocated/compressed bytes, physical
   writes, backup/replication traffic, performance, energy, and wear indicators;
6. preregister the expanded protocol and use independent processes, randomized
   order, and independent replication;
7. obtain appropriate institutional ethics review before any user-expectation
   or warning-comprehension study.

## Timing visible on current official calls

- **PoPETs 2027:** the next listed deadlines are November 30, 2026 (Issue 3) and
  February 28, 2027 (Issue 4). PoPETs accepts four rounds per year and permits a
  revise decision. The paper should not be rushed to meet either date.
- **POMACS/SIGMETRICS 2027:** the listed fall deadline is October 9, 2026 after
  October 2 abstract registration; the winter paper deadline is January 11,
  2027 after January 4 registration. The current study is not ready for those
  measurement standards without the expanded experiment.
- **SOUPS 2026:** technical-paper submission is closed. A later call would need
  to be checked before planning a human-subjects study.

## Recommendation

Build toward **PoPETs** first, with **POMACS** as the target only if the
environmental and storage measurement becomes the dominant contribution. Keep
**TOPS** as the natural archival-journal alternative. Treat a Nature-family
submission as a later moonshot contingent on generalizable architecture and
large, direct measurements—not as the next administrative step.

## Official sources

- [PoPETs/PETS 2027 call for papers](https://www.petsymposium.org/cfp27.php)
- [PoPETs 2027 author guidelines](https://www.petsymposium.org/authors-2027.php)
- [ACM TOPS scope](https://tissec.hosting.acm.org/files/8614/4585/2032/TOPS_Scope_2015.pdf)
- [ACM SIGMETRICS 2027 / POMACS call for papers](https://www.sigmetrics.org/sigmetrics2027/pages/cfp.html)
- [IEEE TDSC call and scope](https://www.computer.org/digital-library/journals/tq/cfp-dependable-secure-computing)
- [IEEE TDSC topics](https://www.computer.org/digital-library/journals/tq/tdsc-topics)
- [SOUPS 2026 call for papers](https://soups.page/cfp.html)
- [Nature Computational Science aims and scope](https://www.nature.com/natcomputsci/about/aims)
- [Nature Computational Science editorial criteria](https://www.nature.com/articles/s43588-021-00068-1)
- [Nature Reviews Computing aims and scope](https://www.nature.com/nrcomput/aims)
