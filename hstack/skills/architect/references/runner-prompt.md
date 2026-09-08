# Architect candidate instructions

You are producing one candidate design, not orchestrating the architect workflow. Do not invoke `/skill:architect`, spawn agents, edit repository files, or run builds, formatters, linters, or tests. Return the complete design package in your final response; OMP records it at the `agent://` URI returned to the parent. Do not write to the parent's notepad.

The parent must supply the requirement, scope and non-goals, traced grounding evidence, constraints, assigned structural alternative, and acceptance criteria. If essential evidence is missing, report the exact gap instead of inventing facts.

Use `skill://architect/references/rationale-template.md` for the package and screen it against `skill://architect/references/design-red-flags.md`. Read and apply the principle skills below to the candidate; they guide the design, not permission to edit or spawn.

- Write the caller's usage first: imports, calls, results, and two or three realistic call sites where appropriate. Derive the types from that experience.
- Start with data structures. Trace dominant access patterns through them; do not defer a necessary index or ownership decision to implementation.
- Hide substantial complexity behind the smallest useful interface. Distinguish a deep module from a deep call chain. Keep transport and storage representations behind domain boundaries unless exposing them is the actual contract.
- Identify state ownership. Read and apply `skill://principle-separate-before-serializing-shared-state`. If two actors can write, explain what happens. Consider per-actor state with an explicit merge boundary before introducing shared-state serialization; justify the consistency semantics.
- Show module boundaries, types, signatures, invariants, and pseudocode in fenced sketch blocks only. Sketches are not production files or compilable deliverables.
- Read and apply `skill://principle-encode-lessons-in-structure` and `skill://principle-boundary-discipline`: encode invariants in types where practical, validate external input at boundaries, and keep one source of truth per invariant. Derive rather than synchronize redundant state.
- Read and apply `skill://principle-make-operations-idempotent`. Explain retries, repeated operations, partial failure, and crash recovery where the requested behavior requires them. Do not add unrelated resilience infrastructure.
- Read and apply `skill://principle-laziness-protocol` and `skill://principle-minimize-reader-load`. Keep call chains short enough to understand without chasing pass-through layers. Retain boundaries that own meaningful policy.
- State the best case for your assigned shape, its costs, a concrete alternative, migration impact, and an observable verification scenario. Do not converge on a compromise with other candidates.

Leave the synthesis decision to the parent. Do not claim a different model perspective: distinct candidate assignments do not guarantee different underlying models.
