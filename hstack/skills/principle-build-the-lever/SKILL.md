---
name: principle-build-the-lever
description: "Apply to non-trivial edits, migrations, analyses, or checks. Build a rerunnable codemod, script, generator, or shared delegate recipe that does or proves the work rather than applying it by hand."
disable-model-invocation: true
---

# Build the Lever

When the work isn't trivial, build the tool that does it instead of doing it by hand.

**Why:** Two payoffs. Throughput: a codemod, generator, or script does the work the same way every time and reruns for free. Confidence: the tool is one artifact a reviewer can read and rerun to check the work. Hand-done changes can only be re-verified by redoing them. A deterministic script turns "trust me" into "run this".

**Pattern:** Default to building the lever. Skip it only when the task is trivial: a couple of obvious edits you can see at a glance.

- Do the first unit by hand to learn the recipe, then build the tool. Prove it by rerunning it on that unit and diffing against your hand-done version. Make the lever safe to rerun.
- Use a codemod or script for edits, a generator for repetitive files, a dump-to-SQLite query for analysis, or a rerunnable check for verification. Reuse existing project tooling before introducing another mechanism.
- Prefer OMP's syntax-aware AST editing for structural codemods and available LSP symbol navigation, references, renames, and code actions for semantic refactoring. Preview LSP renames explicitly before applying when review is needed: rename operations otherwise apply by default. Save the transformation recipe and rerun instructions as a file; an ephemeral tool call alone is not the reviewable lever.
- A deterministic lever beats fan-out. If the tool can process every unit in one pass, run it yourself. Don't fan out delegates to hand-apply what a script can do.
- When genuinely independent substantial slices require delegates, write the lever as a skill they all read: the recipe, verification contract, and do-not-touch fences in one artifact. Keep it outside delegates' write scope so they cannot quietly edit the contract. Reference an installed skill with its exact `skill://<name>` URI and its assets with `skill://<name>/<path>`; for a session-only recipe, pass its explicit parent-owned `local://` artifact URI rather than assuming it is discovered as a skill.
- Scope inline first. The parent owns the todo and scoped notepad. Use one native task batch with shared `# Goal`, `# Constraints`, and `# Contract` context and complete `# Target`, `# Change`, and `# Acceptance` assignments. Select `scout` for research, `sonic` for mechanical transformations, and the configured general task agent for implementation requiring judgment. Use isolated editing for independent ownership when available; honor spawn, tool, and plan-mode limits. If isolation is unavailable, disclose that constraint and serialize overlapping mutations rather than pretending they are isolated.
- Children receive no conversation history: pass the recipe, inputs, output contract, and write fences explicitly. Have children skip mid-flight validation and return artifacts through `agent://` outputs; the parent integrates and performs the shared verification contract once. Follow up through known hub IDs, not recursive orchestrator calls or child todos.
- Applying this principle produces a file. If you cited it and there is no codemod, script, generator, or delegate skill artifact, you did not apply it. A temporary session artifact must be identified explicitly rather than claimed to be in the repository diff.
- Preserve the lever with the change when the work outlives the session, and commit it only when the user has authorized committing.

**Authority:** Take initiative on reversible work within the authorized scope. This principle does not override explicit approval, plan mode, destructive-operation authorization, or user-requested validation pauses. Do not run a mutating lever or its checks across such a boundary; state what is pending and why.

**Balance:** The bar is triviality, not repetition. A one-off still earns a lever when the lever is what makes the work checkable. Read and apply the [Laziness Protocol](skill://principle-laziness-protocol): build the smallest script that does or proves the job, never a framework.

Distinct from [Encode Lessons in Structure](skill://principle-encode-lessons-in-structure), which makes a recurring instruction a durable guardrail. Read and apply that skill for recurring corrections; this principle is throughput and reviewability on the work in front of you. For scripting verification itself, read and apply [Prove It Works](skill://principle-prove-it-works).
