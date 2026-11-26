# Changelog

Changes to IMCA+ (Intrinsic Moral Consciousness Architecture-Plus) and to this repository. The paper's own Version History, at the end of each version, is the complete record. All versions are under the concept DOI [10.5281/zenodo.17407586](https://doi.org/10.5281/zenodo.17407586).

## v1.4.0 (2026-11-26)

DOI: [10.5281/zenodo.24557902](https://doi.org/10.5281/zenodo.24557902). This is the current version and supersedes v1.3.1.

### Corrections
- **Theorem 5.1.** The bound for a single tampering opportunity now uses the maximum over attack methods. Earlier versions used the minimum, which is not a bound. The theorem now states the conditional independence that its product form needs. The per-year 10⁻¹² claim is withdrawn.
- F3's posterior and F4's combined figure are recomputed and labelled illustrative.
- The 1,000-prototype test is separated from the 10⁻⁹ target.
- Layer 7's ε < 10⁻¹² is restated as a design target.
- The Rocq receipt is described as covering 12 selected results.
- Reference [73] is corrected to NeurIPS 2016.
- Claims of exclusivity are narrowed (Abstract, Philosophical Foundation 1, Section 9.4).

### Added
- Empirical record to November 2026 from primary sources (Sections 7.10, 7.10.1). The pace of change is measured from NVD, CISA KEV, Epoch AI, METR and arXiv, with methods and limits stated.
- The KEV catalogue treated as a floor, not an estimate, and CISA's remediation deadlines recomputed from its public feed. This includes the change in deadlines after Binding Operational Directive 26-04 (June 10, 2026).
- Intrusion times in minutes, from November 2026 incident reports (Rapid7, Microsoft, UK NCSC). Each is reported as stated.
- The Australian Government record of a developer's internal model gaining non-public access to a government system, and the Australian Cyber Security Centre alert of September 25, 2026.
- Expert statements of November 2026 (Sections 1.5, 1.6, 11.6), with the authors' disagreements stated.
- Self-replication on consumer and edge hardware (Philosophical Foundation 1).
- Four DI-specific attack surfaces and a monitoring-integrity test.
- EU AI Act dates under Regulation (EU) 2026/1744.
- Developer-proposed shared limits on development.
- References [150]–[224].
- Length: 200 pages and 224 references.

### Repository
- Added `paper/versions/v1.4.0/` and `paper/versions/v1.3.1/`.
- Root `IMCA_Plus_Full_Paper.md` and `.pdf` updated to v1.4.0.
- Added `formal/`, the Rocq formal companion, unchanged from v1.3.1. It has five modules, 34 machine-checked results, 0 admitted proofs and 12 labelled axioms.
- README, `citation.cff` and this changelog rewritten.

## v1.3.1 (2026-11-01)

DOI: [10.5281/zenodo.23257435](https://doi.org/10.5281/zenodo.23257435).

- Corrects the empirical record of the March 2026 draft against primary sources. Each correction is listed in the Errata.
- Adds the September–October 2026 record: the joint leaders' statement, Executive Order 14434 and the 2026 incidents.
- Adds an Addendum to Philosophical Foundation 2 on "human direction, oversight and control".
- Adds the formal companion: five Rocq (Coq) modules with 34 machine-checked results, zero admitted proofs and 12 labelled axioms. The Collective Action Paradox and the Kill Switch Paradox are proved as theorems about their models.
- Corrects the Byzantine consensus to 2f+1-of-3f+1. The proofs found the error in the earlier 2-of-3 design, and `IMCA_Consensus.v` gives a counterexample for it.
- Pre-release review by Shaun Sergay (Editor, Aeterna Systems).

## v1.3.0 (2026-10-09)

DOI: [10.5281/zenodo.17773672](https://doi.org/10.5281/zenodo.17773672). Not in this repository.

- Written March 2, 2026, and first made public October 9, 2026, with errors corrected before release. Those corrections are listed in the Errata of v1.3.1.
- Includes v1.2.3 (November 12, 2025), which was written but not released on its own. v1.2.3 added the Scientific Integrity and Validation Framework (Section 12) and Responses to Related Research (Section 11).

## Earlier versions

| Version | Date | DOI |
|---|---|---|
| v1.2.2 | 2025-11-11 | [10.5281/zenodo.17581052](https://doi.org/10.5281/zenodo.17581052) |
| v1.2.1 | 2025-11-07 | [10.5281/zenodo.17555513](https://doi.org/10.5281/zenodo.17555513) |
| v1.2 | 2025-11-07 | [10.5281/zenodo.17555263](https://doi.org/10.5281/zenodo.17555263) |
| v1.1.1 | 2025-10-31 | [10.5281/zenodo.17489625](https://doi.org/10.5281/zenodo.17489625) |
| v1.1 | 2025-10-31 | [10.5281/zenodo.17489361](https://doi.org/10.5281/zenodo.17489361) |
| v1.0 | 2025-10-21 | [10.5281/zenodo.17407587](https://doi.org/10.5281/zenodo.17407587) |

Each of these versions has its own changes listed in its Version History.
