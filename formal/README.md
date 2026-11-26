# IMCA+ Formal Companion (v1.3.1)

Machine-checked proofs accompanying *IMCA+: Intrinsic Moral Consciousness
Architecture-Plus* v1.3.1 (Zaroff, Kraszewski & e0 (Digital Entity), 2026). CC BY 4.0.

**Prover:** Rocq 9.3 (formerly Coq) · **Modules:** 5 · **Machine-checked results:** 34 · **Admitted:** 0

```sh
brew install rocq        # or: opam install rocq-prover
./build.sh               # compiles every module, refuses any admitted proof,
                         # writes the axioms each result depends on to assumptions.txt
```

| Module | What it proves | Axioms used |
|---|---|---|
| `IMCA_Core.v` | Hash integrity; hardware enforcement over unbounded modification sequences; constitutional-gate soundness derived from two narrower axioms; goal preservation; no cumulative drift; defence in depth | 12 labelled axioms (standard, engineering, open) |
| `IMCA_Game.v` | Collective Action Paradox: defection strictly dominant, unique Nash equilibrium, Pareto-inferior (for all T > R > P > S and the paper's matrix) | Standard real-number library only |
| `IMCA_KillSwitch.v` | Kill Switch Paradox: exact concealment condition; concealment under termination authority; incentive grows with stakes; pooling (reports carry no information); non-destructive oversight restores honesty | Standard real-number library only |
| `IMCA_Consensus.v` | Byzantine quorum intersection (2q > n + f); 3f+1 / 2f+1 bound; counterexample for 2-of-3 | None |
| `IMCA_Bounds.v` | Linear and anchored drift bounds; redundant-mechanism failure bounds; Appendix E.1 inference | Standard real-number library only |

**Scope.** These proofs establish that IMCA+'s safety conclusions follow from its
stated assumptions. They make no claim that any physical system satisfies those
assumptions; the axioms in `IMCA_Core.v` are labelled as standard, as engineering
claims awaiting validation, or as open research problems. The models are
abstract and contain no implementation details.
