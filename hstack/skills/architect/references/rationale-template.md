# Design rationale

Use these headings for each candidate and the parent's synthesized package. Replace the guidance with concrete content. Keep prose concise; include enough sketch detail to implement without guessing. Return candidates as agent output; keep the synthesis in the parent's OMP session notepad unless repository documentation was requested.

## Problem

State the requested outcome, scope, non-goals, and why the shape is non-obvious. Cite the grounding paths/symbols and distinguish observed constraints from assumptions. Include existing callers, ownership, and invariants the design must preserve.

## Usage (caller's view)

Write this before the types. Show what the consumer imports, calls, and receives, with realistic call sites or equivalent user interactions. Reconcile the shape to the intended usage rather than forcing callers to accommodate internal machinery.

## Shape

Sketch the module map, core types, signatures, ownership, and data flow in fenced blocks. Name the invariants encoded in types, boundary validation, and failure semantics. Explain what complexity the interface hides, what callers still need to know, and why the public surface is no larger than necessary. Keep pseudocode out of production files.

Read and apply `skill://principle-boundary-discipline` when placing validation and adapters. Cite the applicable principle skills behind load-bearing decisions rather than restating their entire guidance.

## Synthesis decision

Candidates leave this for the parent running `skill://arena`. Identify the compared candidate artifacts, screening and cross-judge results, chosen base and why, ideas incorporated from other candidates, and rejected ideas with reasons. Record actual model provenance only when known; disclose inline or same-model comparison.

## Tradeoffs accepted

Use concrete statements: “We accept X in exchange for Y.” Include costs a future maintainer might otherwise mistake for an oversight.

## Alternatives considered

Name at least one structurally different alternative. Compare ownership, interface depth, migration cost, and complexity hidden versus exposed to callers. Variations in naming or file placement alone are not alternate architectures. Explain why an alternative lost or was infeasible.

## Open questions and risks

Separate unanswered user decisions from engineering risks and evidence gaps. Resolve repository-answerable questions through investigation. State any blocking decision explicitly; do not turn every tradeoff into an approval request.

## Implementation and verification

Name the first implementation step, affected callers, clean-cutover order, and any strictly dependent steps. Define an observable scenario proving the requested behavior and the relevant existing checks. No placeholder implementation counts as completion.
