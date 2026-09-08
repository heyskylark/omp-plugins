---
name: architect
description: Design caller-first types, signatures, and module boundaries before implementing non-trivial changes. Use /skill:architect to compare distinct designs, synthesize a grounded contract, and implement it; add "with checkpoint" to review the design before code changes.
disable-model-invocation: true
---

# Architect

Design before implementing. Ground the existing system, compare at least two structurally different designs, choose a contract, and implement it completely. If repeated implementation friction disproves the design, re-ground and replace it rather than accumulating workarounds.

This workflow uses native OMP tools and the three bundled references under `skill://architect/references/`. It does not require pstack's `how`, `why`, `arena`, `interrogate`, or principle skills, external runner CLIs, or particular model subscriptions.

## Start and preserve state

The parent owns the OMP `todo` list. Track grounding, candidate design and synthesis, implementation, and behavioral verification. Add an approval step only when requested; treat redesign as a conditional return to grounding, not a mandatory destructive phase. Update existing tasks rather than replacing an active caller plan. Children return results instead of maintaining the parent's todo list.

Use a scoped session-local artifact such as `local://architect-notepad.md` as the notepad. OMP has no separate native notepad API. Reuse the current workflow's artifact when one exists; keep grounding, candidate artifact links, the chosen sketch, rationale, deviations, and verification evidence there. The parent is its sole writer. Children share the parent's `local://` root but do not inherit the conversation, so pass exact artifact URIs. Plan-mode children are read-only and must return their designs as agent output. Keep sketches in fenced blocks in session artifacts, not as throwing stubs or pseudocode in production files. Create repository design documents only when requested or required by repository policy.

## 1. Ground the problem

Resolve requirements and integration constraints from the repository before asking the user. Trace the affected path from caller entry point through types, data transformations, state ownership, external boundaries, and observable results. Read complete relevant sections, not just names or search hits. Use OMP `read`, `grep`, and `glob` for evidence; use the available LSP for symbol definitions, references, and types, including references before changing exported symbols.

Record paths and symbols, invariants, error behavior, existing tests, extension seams, and unknowns. When changing ownership or layering, investigate the rationale in existing docs, call sites, and history. Distinguish observed facts from inference. Truly greenfield work may omit existing-system traces, but must still state external contracts and constraints.

Investigate inline first. If two or more substantial independent subsystems need research, use one `task` batch of read-only `scout` agents with bounded scopes. Do not delegate design reasoning to scouts. Verify their evidence and consolidate the grounding before candidate generation.

## 2. Design twice, then synthesize

Write the consumer's intended usage first. Define at least two whole-shape alternatives that meet the same requirements but differ in ownership, data representation, or module boundaries—not merely names or file placement. Give each a fair treatment even if the first looks sufficient.

For substantial independent candidate work, dispatch one OMP `task` batch. Use available design-capable agents; omit `agent` only when the configured default fits. The normal general-purpose task agent can produce candidate designs. Model diversity is optional: select already configured role-backed agents when available, never hardcode upstream model IDs or pass an unsupported `model` field to `task`. A same-model comparison is valid but must not be described as multi-model evidence.

The shared `context` must contain `# Goal`, `# Constraints`, and `# Contract`: requirement, scope/non-goals, grounding URIs, common invariants, and the candidate output format. Each task must contain `# Target`, `# Change`, and `# Acceptance`: its assigned structural alternative, exact evidence and reference URIs, and the complete expected package. Require every candidate to read:

- `skill://architect/references/runner-prompt.md`
- `skill://architect/references/rationale-template.md`
- `skill://architect/references/design-red-flags.md`

Candidates are repository-read-only, do not spawn children, and skip builds, formatters, linters, and tests. They return their package as agent output; no worktree or shared output file is needed. Use returned `agent://` URIs, not guessed IDs, to recover full results. Use `hub` for follow-up with actual returned agent IDs. Continue independent work while results run; wait only when blocked, and do not poll for auto-delivered results.

Follow the tool schema actually exposed by the session. If batching is disabled, use its flat task form with the same shared grounding artifact. If delegation is unavailable, depth-limited, disallowed, or disproportionate for the scope, produce both candidates inline and disclose that limitation. Never drop the second design to work around tooling restrictions.

Screen every candidate using the red-flags reference; revise or reject unsuitable shapes before synthesis. Compare interface depth, ownership, invariants, caller complexity, migration cost, and failure behavior. Prefer the smallest useful public surface hiding the needed complexity, not the most layers or the fewest implementation lines. The parent writes one synthesized package using the rationale template: chosen base, incorporated ideas, rejected alternatives with reasons, and implementation/verification order. Do not treat an agent's successful exit as acceptance of its design.

## 3. Agree only when requested

By default continue directly from synthesis into implementation. If the user requests “with checkpoint,” “show me before implementing,” or design-only work, present the sketch, rationale, alternatives, and open decisions before changing product code. For a checkpoint, mark implementation blocked pending approval and stop for the user's response; design-only delivery ends with the design.

This is a human design checkpoint, not an instruction to invoke OMP's context `checkpoint`/`rewind` tools, which do not restore files. Respect active OMP plan-mode write restrictions and its approval flow; the skill never grants permission to leave plan mode or start implementation. Do not commit a broken scaffold. Human feedback that changes the shape becomes grounding evidence; rework the candidates before writing code.

## 4. Implement the chosen contract

Implement real behavior against the sketch. Reuse repository conventions and migrate all affected callers without compatibility shims unless explicitly required. For substantial independent implementation slices, define interfaces and ownership before dispatching one `task` batch; use filesystem isolation for editing agents when available. If isolation is unavailable, keep edits with one owner rather than allowing competing writes. Keep tightly coupled changes together. Children skip validation while edits are in flight; the integration owner verifies the integrated result.

Record meaningful deviations and why they occurred. A missing parameter may reveal a missed requirement, a mistaken boundary, or implementation overreach; investigate rather than silently expanding the interface.

If two or more independent deviations repeat the same workaround, optional fields are always required in practice, state unexpectedly needs locks, or callers must learn internal ordering rules, reassess the shape. Legitimate domain edge cases alone do not condemn it. Trace what was built, incorporate the new constraints, subtract unnecessary structure, and return to design comparison. Replace only in-scope obsolete work; preserve unrelated user changes.

## 5. Verify and deliver

Exercise the requested behavior through the real surface and inspect its result. Use the repository's verification skill when applicable, OMP browser/native drivers for UI, `hub`-supervised processes for services and interactive CLIs, and relevant existing checks. Verify the integrated change after agents finish; type-checking a sketch is not behavioral proof. Keep a regression test for a plausible bug or genuinely uncertain invariant, not just to assert implementation wiring.

After proof, remove throwaway scaffolds and scratch scripts, update affected documentation where appropriate, and retain evidence. Report the chosen architecture, accepted tradeoffs, implementation scope, meaningful deviations, exact checks and observed results, and any blockers. Reference the session rationale and candidate artifacts; never describe an unimplemented sketch as completed code.
