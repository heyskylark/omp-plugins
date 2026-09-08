---
name: architect
description: Design caller-first types, signatures, and module boundaries before implementing non-trivial changes. Use /skill:architect to compare distinct designs, synthesize a grounded contract, and implement it; add "with checkpoint" to review the design before code changes.
disable-model-invocation: true
---

# Architect

Design before implementing. Ground the existing system, compare at least two structurally different designs, choose a contract, and implement it completely. If repeated implementation friction disproves the design, re-ground and replace it rather than accumulating workarounds.

This workflow composes the bundled `how`, `why`, `arena`, `interrogate`, and principle skills. At each phase, read the named `skill://` resources and apply their instructions in the current workflow. A skill call is a read-and-follow operation, not a new orchestration agent. Keep the same parent, progress list, and design notepad across phases.

## Start and preserve state

The parent owns the OMP `todo` list. Track grounding, candidate design and synthesis, implementation, and behavioral verification. Add an approval step only when requested; treat redesign as a conditional return to grounding, not a mandatory destructive phase. Update existing tasks rather than replacing an active caller plan. Children return results instead of maintaining the parent's todo list.

Use a scoped session-local artifact such as `local://architect-notepad.md` as the notepad. OMP has no separate native notepad API. Reuse the current workflow's artifact when one exists; keep grounding, candidate artifact links, the chosen sketch, rationale, deviations, and verification evidence there. The parent is its sole writer. Children share the parent's `local://` root but do not inherit the conversation, so pass exact artifact URIs. Plan-mode children are read-only and must return their designs as agent output. Keep sketches in fenced blocks in session artifacts, not as throwing stubs or pseudocode in production files. Create repository design documents only when requested or required by repository policy.

## 1. Ground the problem

Read and run `skill://how` over every affected subsystem. Naming a file is not grounding: produce its traced runtime model from caller entry point through types, transformations, state ownership, external boundaries, and observable results. Use its inline or parallel research path according to scope, and verify source evidence before designing.

If changing ownership or layering, also read and run `skill://why` to recover the rationale behind the existing shape. Carry its Preserve / Change / Avoid / Risk constraints into the design, retaining its distinction between observed facts and inference. Do not recursively alternate `how` and `why`; reuse their completed artifacts within this investigation.

Record the model, constraints, evidence links, and unresolved questions in the parent notepad. Truly greenfield work may omit existing-system traces but must still establish external contracts and invariants. Use available LSP references before changing exported symbols.

## 2. Design twice, then synthesize

Read and apply `skill://principle-exhaust-the-design-space`. Write the consumer's intended usage first. Require at least two whole-shape alternatives that meet the same requirements but differ in ownership, data representation, or module boundaries—not merely names or file placement.

Read and run `skill://arena` with this contract:

- Artifact: a candidate design package, not repository edits. Use `skill://architect/references/runner-prompt.md` as each candidate's instructions and `skill://architect/references/rationale-template.md` as the output shape.
- Grounding: the completed `how` model, applicable `why` constraints, the requirement, scope/non-goals, and parent notepad URI.
- Candidates: assign structurally distinct directions while preserving the same requirements and output contract. Two viable distinct candidates are required before synthesis; replace a dropout rather than silently proceeding with one.
- Screening: use `skill://architect/references/design-red-flags.md` before scoring. Reject or revise shallow modules, leaked information, temporal decomposition, and pass-through layers.
- Rubric: interface depth, explicit state ownership and invariants, caller complexity, migration cost, and failure behavior. Prefer the smallest useful public surface hiding the required complexity.
- Ownership: candidates are repository-read-only and return `agent://` artifacts. They do not spawn children, update the parent notepad, or run builds, formatters, linters, or tests.

Apply arena's cross-judgment, base selection, and synthesis phases. The parent writes one coherent package and fills its “Synthesis decision” section with the base, incorporated ideas, rejected alternatives, dropouts, and judge's assessment. Design verification checks usage/signature agreement and constraints; it does not claim implemented behavior. Model diversity and any restricted-mode limitations follow arena's OMP policy and must be disclosed honestly.

## 3. Agree only when requested

By default continue directly from synthesis into implementation. If the user requests “with checkpoint,” “show me before implementing,” or design-only work, present the sketch, rationale, alternatives, and open decisions before changing product code. For a checkpoint, mark implementation blocked pending approval and stop for the user's response; design-only delivery ends with the design.

This is a human design checkpoint, not an instruction to invoke OMP's context `checkpoint`/`rewind` tools, which do not restore files. Respect active OMP plan-mode write restrictions and its approval flow; the skill never grants permission to leave plan mode or start implementation. Do not commit a broken scaffold. Human feedback that changes the shape becomes grounding evidence; rework the candidates before writing code.

Read and apply `skill://principle-foundational-thinking` and `skill://principle-outcome-oriented-execution`: establish the contract first, then complete working behavior without leaving a broken scaffold. When the user requests adversarial pressure before implementation, read and run `skill://interrogate` on the synthesized sketch and grounding. Incorporate accepted findings into the design; interrogate itself returns a verdict and does not apply changes.

## 4. Implement the chosen contract

Implement real behavior against the sketch. Reuse repository conventions and migrate all affected callers without compatibility shims unless explicitly required. For substantial independent implementation slices, define interfaces and ownership before dispatching one `task` batch; use filesystem isolation for editing agents when available. If isolation is unavailable, keep edits with one owner rather than allowing competing writes. Keep tightly coupled changes together. Children skip validation while edits are in flight; the integration owner verifies the integrated result.

Record meaningful deviations and why they occurred. A missing parameter may reveal a missed requirement, a mistaken boundary, or implementation overreach; investigate rather than silently expanding the interface.

If two or more independent deviations repeat the same workaround, optional fields are always required in practice, state unexpectedly needs locks, or callers must learn internal ordering rules, reassess the shape. Legitimate domain edge cases alone do not condemn it. Read and apply `skill://principle-fix-root-causes`, `skill://principle-redesign-from-first-principles`, and `skill://principle-subtract-before-you-add`. Run `skill://how` on what was built, incorporate the new constraints, subtract unnecessary structure, and return to `skill://arena` for design comparison. Replace only in-scope obsolete work; preserve unrelated user changes.

## 5. Verify and deliver

Read and apply `skill://principle-prove-it-works`. Exercise the requested behavior through the real surface and inspect its result. Use the repository's verification skill when applicable, OMP browser/native drivers for UI, `hub`-supervised processes for services and interactive CLIs, and relevant existing checks. Verify the integrated change after agents finish; type-checking a sketch is not behavioral proof. Keep a regression test for a plausible bug or genuinely uncertain invariant, not just to assert implementation wiring.

After proof, remove throwaway scaffolds and scratch scripts, update affected documentation where appropriate, and retain evidence. Report the chosen architecture, accepted tradeoffs, implementation scope, meaningful deviations, exact checks and observed results, and any blockers. Reference the session rationale and candidate artifacts; never describe an unimplemented sketch as completed code.
