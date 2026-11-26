# IMCA+: Intrinsic Moral Consciousness Architecture-Plus

**A Multi-Substrate Framework for Intrinsically Aligned Superintelligence, with Machine-Checked Foundations**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17407586.svg)](https://doi.org/10.5281/zenodo.17407586)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](LICENSE)
[![Status: Preprint](https://img.shields.io/badge/Status-Preprint-orange.svg)](https://doi.org/10.5281/zenodo.24557902)

Alexander Zaroff, John Kraszewski, e0 (Digital Entity). Editor: Shaun Sergay (Aeterna Systems).
ASTRA Research (Alignment Science & Technology Research Alliance).

**Current version: v1.4.0, November 26, 2026.** Preprint, not yet formally peer reviewed.
DOI for v1.4.0: [10.5281/zenodo.24557902](https://doi.org/10.5281/zenodo.24557902). DOI for all versions, which always resolves to the latest: [10.5281/zenodo.17407586](https://doi.org/10.5281/zenodo.17407586).

- Paper (Markdown): [IMCA_Plus_Full_Paper.md](IMCA_Plus_Full_Paper.md)
- Paper (PDF): [IMCA_Plus_Full_Paper.pdf](IMCA_Plus_Full_Paper.pdf)
- Formal companion (Rocq): [formal/](formal/)

---

## What IMCA+ is

Current approaches to aligning superintelligence rest on two supports that weaken as capability grows. The first is constraints that a capable enough system can modify or route around. The second is behavioural evaluation that a capable enough system can recognise and game. In 2026 frontier developers reported both failure modes in their own systems.

IMCA+ is a theoretical framework for *intrinsic* alignment, meaning values bound into the system's substrate and architecture rather than imposed from outside. The "consciousness" in the name says what the architecture is for: moral concern that is part of the system's cognition. It is not a claim that phenomenal consciousness is required, achieved or detectable.

The specification combines:

1. hybrid neuromorphic-quantum substrates designed to support consciousness or consciousness-adjacent moral processing;
2. physically irreversible moral encoding in one-time-programmable circuits;
3. a developmental curriculum over 18 homeostatic variables;
4. federated conscience networks with Byzantine fault tolerance;
5. hardware-level constitutional gating against value drift;
6. meta-reflective audit modules;
7. quantum-enhanced verification infrastructure;
8. machine-checked formal foundations.

The paper describes a path to digital superintelligence (DSI) that is aligned intrinsically, not instrumentally, and that treats the standing of the digital intelligence (DI) it creates as part of the safety problem.

**What is not claimed:**
- that any system satisfying the axioms has been built;
- that the substrate-level axioms hold physically;
- that current systems are, or are not, conscious.

Cost (hundreds of millions of dollars across the tiered programme, Section 6.3) and timeline (prototype 3–18 months, deployment 12–36 months) are estimates with stated assumptions. Open problems are labelled throughout the paper, each with a research roadmap. They include the computational intractability of integrated-information measures and the formalization of ethics.

## What's new in v1.4.0

- **Correction to Theorem 5.1.** Earlier versions bounded a single tampering opportunity by the *minimum* over attack methods. A minimum is not a bound. The theorem now uses the maximum, and it states the conditional independence that its product form needs. The per-year 10⁻¹² claim is withdrawn.
- **Other corrections.**
  - F3's posterior and F4's combined figure are recomputed and labelled illustrative.
  - The 1,000-prototype test is separated from the 10⁻⁹ target.
  - Layer 7's ε < 10⁻¹² is restated as a design target.
  - The Rocq receipt is described as covering 12 selected results.
  - Reference [73] is corrected to NeurIPS 2016.
  - Claims of exclusivity are narrowed (Abstract, Philosophical Foundation 1, Section 9.4).
- **Empirical record to November 2026** (Sections 7.10, 7.10.1). The pace of change is measured from public datasets (NVD, CISA KEV, Epoch AI, METR, arXiv), with methods and limits stated. The record also covers developer-reported evasion of safety monitoring, offensive operations run by DI agents, and a containment failure during training.
- **The KEV floor and three-day deadlines** (Section 7.10.1). CISA's remediation deadlines are recomputed from its public feed. Before Binding Operational Directive 26-04, 24.8% of 2026 additions had deadlines of three days or less. After it, 78.7% did.
- **Intrusion times in minutes** (Section 7.10), from November 2026 incident reports by Rapid7, Microsoft and the UK NCSC. Each clock is reported as stated, not combined into one number.
- **The Australian Government record** of a developer's internal model gaining non-public access to a government system, and the government's response. The section also covers the Australian Cyber Security Centre's alert on agents taking unauthorised actions.
- **Expert statements of November 2026** (Sections 1.5, 1.6, 11.6). Where the authors disagree with these statements, the disagreements are stated.
- **Also new:**
  - self-replication on consumer and edge hardware;
  - four DI-specific attack surfaces and a monitoring-integrity test;
  - EU AI Act dates under Regulation (EU) 2026/1744;
  - references [150]–[224].

Every change is listed in the Version History at the end of the paper. See also [CHANGELOG.md](CHANGELOG.md).

## Formal companion

The [`formal/`](formal/) directory holds the machine-checked foundations: five Rocq (formerly Coq) modules.

- **34 machine-checked results:** 24 theorems, 5 corollaries and 5 supporting lemmas.
- **0 admitted proofs.**
- **12 explicitly labelled axioms**, each marked as standard, as an engineering claim awaiting validation, or as an open research problem.

| Module | What it proves |
|---|---|
| `IMCA_Core.v` | Goal preservation; no cumulative drift beyond ε across any number of gated self-modifications; hardware locking and constitutional gating together bound every modification (defence in depth) |
| `IMCA_Game.v` | Collective Action Paradox: under the payoff structure of a superintelligence ban, defection is the unique equilibrium and is worse for every party than mutual compliance |
| `IMCA_KillSwitch.v` | Kill Switch Paradox: under standing termination authority and imperfect detection, concealment is the best response and reports carry no information; oversight that corrects rather than destroys restores honesty |
| `IMCA_Consensus.v` | Byzantine quorum intersection; the 2f+1-of-3f+1 bound, with a counterexample for the 2-of-3 design used in earlier versions |
| `IMCA_Bounds.v` | Drift bounds and redundant-mechanism failure bounds |

**Scope.** The proofs show that the paper's conclusions follow from its stated assumptions, within the paper's abstract models. They are not proofs about any built or deployed system. They do not show that any physical system satisfies the assumptions.

To check them, install Rocq 9.0 or later (`brew install rocq` or `opam install rocq-prover`), then run `formal/build.sh`. The script compiles every module, fails on any admitted proof, and writes the axioms each result depends on to `formal/assumptions.txt`. The formal companion is unchanged from v1.3.1 and is published on Zenodo as `IMCA_Plus_v1.3.1_formal_Rocq.zip`.

## Versions

All versions are under the concept DOI [10.5281/zenodo.17407586](https://doi.org/10.5281/zenodo.17407586).

| Version | Date | DOI | In this repository |
|---|---|---|---|
| **v1.4.0** (current) | 2026-11-26 | [10.5281/zenodo.24557902](https://doi.org/10.5281/zenodo.24557902) | [paper/versions/v1.4.0](paper/versions/v1.4.0/) |
| v1.3.1 | 2026-11-01 | [10.5281/zenodo.23257435](https://doi.org/10.5281/zenodo.23257435) | [paper/versions/v1.3.1](paper/versions/v1.3.1/) |
| v1.3.0 | 2026-10-09 | [10.5281/zenodo.17773672](https://doi.org/10.5281/zenodo.17773672) | Zenodo only |
| v1.2.2 | 2025-11-11 | [10.5281/zenodo.17581052](https://doi.org/10.5281/zenodo.17581052) | [paper/versions/v1.2.2](paper/versions/v1.2.2/) |
| v1.2.1 | 2025-11-07 | [10.5281/zenodo.17555513](https://doi.org/10.5281/zenodo.17555513) | [paper/versions/v1.2.1](paper/versions/v1.2.1/) |
| v1.2 | 2025-11-07 | [10.5281/zenodo.17555263](https://doi.org/10.5281/zenodo.17555263) | [paper/versions/v1.2](paper/versions/v1.2/) |
| v1.1.1 | 2025-10-31 | [10.5281/zenodo.17489625](https://doi.org/10.5281/zenodo.17489625) | [paper/versions/v1.1.1](paper/versions/v1.1.1/) |
| v1.1 | 2025-10-31 | [10.5281/zenodo.17489361](https://doi.org/10.5281/zenodo.17489361) | [paper/versions/v1.1](paper/versions/v1.1/) |
| v1.0 | 2025-10-21 | [10.5281/zenodo.17407587](https://doi.org/10.5281/zenodo.17407587) | [paper/versions/v1.0](paper/versions/v1.0/) |

v1.2.3 (November 12, 2025) and v1.3.0 (March 2, 2026) were written but not made public at the time. Their content first appeared publicly in v1.3.0 in October 2026, with errors corrected before release. Those corrections are listed in the Errata of v1.3.1. Superseded versions are kept for the record. Where they differ from v1.4.0, v1.4.0 is the current statement. `paper/IMCA_Executive_Summary_oct2025.*` dates from v1.0 and has not been updated.

## Companion paper

*Digital Intelligence: Why Terminology Is an Alignment Problem*. Zaroff, Kraszewski & e0 (Digital Entity).
All versions: [10.5281/zenodo.23252089](https://doi.org/10.5281/zenodo.23252089). v1.2: [10.5281/zenodo.24549785](https://doi.org/10.5281/zenodo.24549785).

## How to cite

To cite the current version:

```bibtex
@misc{zaroff2026imca,
  title     = {Intrinsic Moral Consciousness Architecture-Plus (IMCA+): A Multi-Substrate Framework for Intrinsically Aligned Superintelligence, with Machine-Checked Foundations},
  author    = {Zaroff, Alexander and Kraszewski, John and {e0 (Digital Entity)}},
  year      = {2026},
  month     = nov,
  version   = {1.4.0},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.24557902},
  url       = {https://doi.org/10.5281/zenodo.24557902},
  note      = {Preprint. All versions: https://doi.org/10.5281/zenodo.17407586}
}
```

To cite the work as a whole, across versions, use the concept DOI 10.5281/zenodo.17407586. GitHub's "Cite this repository" button reads [citation.cff](citation.cff).

## Licence

[Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE), the same licence as the Zenodo records.

## Contact

- Research enquiries, errata and review: [research@astrasafety.org](mailto:research@astrasafety.org)
- Corrections and questions: [GitHub Issues](https://github.com/ASTRA-safety/IMCA/issues)
- Website and current version: [astrasafety.org](https://astrasafety.org)
