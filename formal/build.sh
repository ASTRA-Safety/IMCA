#!/bin/sh
# Machine-checks the IMCA+ formal companion. Requires Rocq >= 9.0
# (brew install rocq  |  opam install rocq-prover).
# Override the compiler with COQC=/path/to/coqc if it is not on PATH.
# Any compile failure, missing compiler, or unfinished proof exits non-zero.
set -e
cd "$(dirname "$0")"
COQC="${COQC:-coqc}"
if ! command -v "$COQC" >/dev/null 2>&1; then
  echo "FAIL: '$COQC' not found. Install Rocq >= 9.0 or set COQC." >&2
  exit 1
fi
"$COQC" --version | head -1
if grep -n -E '\b(Admitted|admit)\b' *.v; then echo "FAIL: unfinished proof" >&2; exit 1; fi
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
for f in IMCA_Core IMCA_Game IMCA_KillSwitch IMCA_Consensus IMCA_Bounds; do
  echo "== $f" >> "$tmp"
  if ! "$COQC" "$f.v" >> "$tmp" 2>&1; then
    echo "FAIL: $f.v does not compile:" >&2
    cat "$tmp" >&2
    exit 1
  fi
  echo "ok   $f"
done
mv "$tmp" assumptions.txt
trap - EXIT
echo "OK: every theorem machine-checked; axioms per result listed in assumptions.txt"
