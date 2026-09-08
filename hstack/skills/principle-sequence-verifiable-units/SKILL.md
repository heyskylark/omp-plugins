---
name: principle-sequence-verifiable-units
description: "Apply to sweeps, migrations, repeated edits, and commit or PR stacks. Break work into small units with meaningful checks and order execution and delivery so each unit proves the next has a sound base."
disable-model-invocation: true
---

# Sequence Work into Verifiable Units

Order work as a sequence of small units, each ending in a state you can check. Do not build dependent work on an unchecked or broken base.

**Why:** A break caught at the unit that caused it is cheap to localize. A break caught after a batch is buried, and further work may already depend on it. Sequencing those units into a delivery a reviewer can replay turns “trust me” into “watch it go red, then green.”

**Execution.** In a sweep, migration, or run of similar edits, use a before/after bracket: known baseline, one coherent change, its focused check, then the dependent next change. Start from clean, current trunk when the authorized workflow permits; rebase first only when branch policy and user authorization permit it, never by rewriting or discarding unrelated work. Otherwise record the actual baseline and its limitations. When a lever performs the edits, the per-unit check is nearly free. Run it anyway when verification is permitted.

**Delivery.** Stack commits and PRs in the order that proves the work. The canonical demonstration is a failing regression test first, then the fix on top. Other story orders are a subtraction before the reshape, a baseline capture before the treatment, or a scaffold before the complete feature. Make each independently landable delivery unit coherent; where branch policy requires green commits, keep the red-to-green demonstration as evidence and deliver the test with its fix. The sequence should read as an argument, not a pile of incidental edits. This ordering is not permission to commit, push, rebase, or merge without authorization, nor to present an unfinished scaffold as the requested feature.

**Pattern:**
- Pick the smallest coherent unit that ends in a meaningful check: an edit plus its behavioral exercise, a complete symbol rename including affected callers, or a commit that stands alone.
- Verify before advancing dependent work. Preserve the red-to-green evidence for each unit rather than discovering a broken foundation at the end.
- Order units so the sequence builds confidence on its own, both while executing and when a reviewer reads the stack.
- Honor explicit verification pauses or instructions to skip gates. Record checks as deferred, never green, and do not run them indirectly through another tool or agent.

**OMP execution.** Scope the dependency graph inline first. The parent owns todo state, acceptance checks, and a scoped `local://` notepad. For symbol migrations, use available LSP definitions and references to identify the complete unit; prefer LSP rename or refactoring actions over textual replacement when supported. Preview a rename with `apply: false` before applying it when the change needs inspection. A syntax-aware codemod is appropriate for repeated structural edits; neither it nor an LSP edit proves behavior by itself.

Independent substantial units may run in one native task batch with explicit file ownership and shared interface contracts. Use isolated editing tasks when supported and authorized; native isolated results can apply to the parent, so isolation is not a review-only proposal mechanism. Children return `agent://` results and do not own todos or run mid-flight build, lint, format, or test gates against siblings' changes. The parent integrates a coherent wave, runs its focused checks, and only then starts dependent work; project-wide gates run once at the end. Respect active spawn, concurrency, and plan-mode limits; if isolation is unavailable, keep edits inline or serialize the shared mutation boundary and disclose the constraint.

This is the sequencing complement to two source principles: read and apply `skill://principle-prove-it-works` to keep each check real, and `skill://principle-build-the-lever` to make repeated edits and per-unit checks cheap.
