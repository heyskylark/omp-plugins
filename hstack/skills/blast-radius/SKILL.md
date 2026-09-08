---
name: blast-radius
description: "Find what a change could break beyond the diff and prove the one fact its safety depends on by running real code. Use for 'blast radius of X', 'what could this break', or reviewing a small diff you do not trust."
disable-model-invocation: true
---

# Blast radius

Find what a change breaks somewhere else, before it ships. Listing callers is not the job. The job is the breakage a symbol search will not show you.

Companion to `skill://how` and `skill://why`: how explains runtime behavior, why explains the forces behind the design, and blast-radius investigates downstream breakage. Read and apply either companion to a bounded question when needed; reuse its findings rather than starting a recursive investigation of the same question.

## Do not trust your own writeup

A convincing writeup is not proof. Find the one or two facts the change's safety depends on and prove them by running real code, not by expanding the list of hypothetical risks.

For each safety fact, reach the strongest evidence level that is cheap and safe, and report where you stopped:

1. **Assertion.** You said so. Worthless on its own.
2. **Source.** A real `file:line`, including the library's own source when relevant.
3. **Failure-path analysis.** Walk the bad case step by step and show why it cannot reach the failure.
4. **Executed proof.** A script or test calls the real code and fails loudly if the premise is false.
5. **Running-app evidence.** Exercise the actual application and observe the relevant behavior.

Any safety fact below level 4 is **unproven**, not settled. Level 4 is often a small script importing the exact library version the application ships and calling the exact function in question. A mock echo, clean typecheck, plausible explanation, or another agent's confidence is not that proof.

## Workflow

### 1. Read and anchor the change

Establish the exact comparison: working changes, a supplied diff, commit range, or PR. Read the changed code and the symbols it adds, changes, and deletes. Explain what it now does differently, including behavior the diff does not spell out. Preserve unrelated user changes; this investigation is not permission to fix code, reset the checkout, commit, push, or merge.

Read and apply Step 2 of `skill://why` to anchor relevant files, symbols, commits, and PR discussion. Read and apply `skill://why/references/epistemics.md` for confidence and citation discipline. Record unavailable history or remote access rather than inventing rationale.

Scope inline with `read`, `glob`, and `grep` before considering delegation. When available, use native LSP `definition`, `references`, `type_definition`, and `implementation` to trace actual symbols; position-based references use the real `file`, 1-indexed `line`, and `symbol`. Inspect returned callers, not just the count. If language-server support is absent or incomplete, disclose it and use scoped source searches. Neither an empty lookup nor a declaration-only result proves there are no consumers.

### 2. Find the safety premise

Name the single fact that clears the largest number of risky cases if true. For example: “this call only drops already-dead cache entries and has no other effects.” Make it falsifiable: state the input, state, timing, and side-effect conditions that must hold, and what observation would disprove it.

Use two premises only when the change truly depends on both. Spend effort establishing them, not padding the report with maybes.

### 3. Trace beyond symbols

Follow the actual behavioral and data contracts past the edited files:

- Read the called library's source at the application's pinned version, including lockfile resolution and local patches; current documentation for another version is not evidence about the shipped code.
- Work out execution order: synchronous effects, microtasks, scheduling, unmount, cleanup, teardown, and framework-specific behavior such as Solid versus React. Do not transfer one framework's lifecycle assumptions to another.
- Follow API JSON, database columns, serialization and wire formats, consumers in other languages reading the same bytes, feature flags, and code three hops downstream.
- Identify direct and transitive consumers, hidden side effects, invariants, and the conditions under which a failure is reachable. A search finding nothing is still evidence when its query and scope are recorded, but not proof beyond that scope.

For two or more substantial independent research slices, use one native `task` batch with `agent: scout` for scoped code/source research. The parent frames and synthesizes; do not delegate a lone small lookup or reasoning disguised as research. Shared `context` has `# Goal`, `# Constraints`, and `# Contract`; each assignment has `# Target`, `# Change`, and `# Acceptance`. Supply the original question, exact change/baseline, symbols, premise, owned source boundary, and expected evidence format because children do not inherit conversation history.

Require no edits, child todos, recursive orchestration, tests, builds, linters, or formatters. Children return cited traces, scoped null results, candidate counterexamples, and proof suggestions through `agent://` outputs. The parent owns its todo state and a scoped `local://` evidence notepad when needed. Read full results, use known `hub` IDs for follow-up, and consult `history://` only for known task sessions. Respect live spawn, tool, concurrency, and plan-mode limits; do available work inline and disclose missing coverage when delegation is unavailable.

### 4. Separate real risks from cleared cases

Give each candidate failure a genuine chance to occur, not just a scary description. Keep confirmed risks separate from checked-and-cleared cases. Each retained risk names the reachable failure sequence, real `file:line`, likelihood and its basis, impact, and the cheapest discriminating check. Label inference and uncertainty; do not invent probabilities, callers, or APIs.

Accept user-reported failures and observations as ground truth. Do not rerun a reported failure merely to confirm it. Reuse that evidence, trace its cause and reach, and execute a new check only to answer an unresolved premise or to verify an authorized fix.

### 5. Execute the decisive proof in the parent

Before running anything, establish the relevant baseline and safety boundary: exact revision and dependency version, current relevant user changes, inputs, runtime/configuration/flag state, and expected observable result. Inspect the proposed command or script for side effects. Use local disposable fixtures or a safe existing development environment, never live customer data or a production write. Investigation does not authorize dependency installation, destructive cleanup, external publication, or sensitive remote actions.

Write the smallest throwaway script or use an existing focused test that imports and exercises the real implementation. Include an assertion that would fail if the safety premise were false; exercise the meaningful boundary or bad case, not only the happy path. Keep permanent tests only when they defend a plausible regression or the user requests one. Do not introduce a mock substitute for the behavior under investigation.

The parent executes the decisive proof after research has settled and records the command/script, relevant environment, actual output and exit result, and the precise claim supported. Children may propose checks, but their summaries do not substitute for parent-owned proof. If comparing old and new behavior is necessary, use a safe separate baseline rather than reverting user work. Do not repeat an already reported failure just to obtain your own baseline output.

Use native `debug` when the unresolved fact concerns program state, stack frames, timing, or side effects: launch or attach to an authorized target, set breakpoints, then inspect `stack_trace`, `scopes`, and `variables`. Only one root debug session is supported; coordinate ownership and do not interrupt an unrelated session. Expression evaluation can execute code, so prefer inspection and treat evaluation as potentially mutating. Capture actual observations and terminate only the session you own. Missing adapters or unsupported capabilities are evidence limitations, not proof.

For level 5, exercise the real application through the available native surface; read and apply `skill://how` for the bounded runtime trace if needed. Do not claim an app reproduction from an isolated library script. If execution is unavailable, prohibited by plan mode or user instruction, unsafe, or not cheap enough, preserve the exact proposed check and mark the premise **unproven**, with the missing prerequisite. Never imply an unrun check passed.

Remove only throwaway files or processes created for this investigation after capturing enough script content and output for reproduction; retain any requested artifact. Do not alter unrelated files or leave temporary instrumentation behind.

### 6. Widen the review when warranted

For a big or wide change, read and apply `skill://arena` to the same blast-radius question. Use independent evidence-backed review reports, not competing edits. Use configured general task agents for design critique, blast-radius confidence, and custom evidence judgments, or a discovered specialist whose role scope, tools, and output contract explicitly fit. Reserve bundled `reviewer` for patch-introduced code bugs anchored to changed diff lines, using its native findings/correctness output; `security-reviewer` is only for a compatible source-security slice using its own output contract. Inspect full outputs before the parent normalizes findings into the evidence report; neither correctness nor an empty findings list proves runtime safety or coverage. A prompt or schema override cannot turn patch review into general judgment. Models come from existing agent configuration, never a per-task model field or a new required role.

Preserve the same change, baseline, premises, and question for each candidate; merge grounded findings and resolve contradictions against code and executed evidence. Optional configured model diversity can expose different bugs, but repeated runs of one model are not multi-model coverage. Report actual known diversity, dropouts, and unavailable independence honestly. The parent retains final proof ownership; a panel vote does not establish safety. Do not let children invoke arena or this orchestration recursively.

## What to hand back

- **What it does.** What changed, including the non-obvious behavior and traced downstream contract.
- **The one fact it is safe because of.** The falsifiable premise, evidence level reached, and actual proof. Write **unproven** if execution did not establish it; a disproven premise is a risk, not a cleared case.
- **Risks.** Only the real ones: how each breaks, `file:line`, likelihood and basis, impact, and how to check. Include executed evidence for the risks that matter.
- **Cleared.** Cases checked and why they are fine, with evidence and scope limits.
- **Before you merge.** The cheapest test or reproduction that catches the real bug, including the script used, observed output, and any remaining unrun obligation. This is advice, not authorization to merge.

Read and apply `skill://unslop` to the final writeup without erasing uncertainty, evidence levels, or citations. Strip private details and secrets before any public output; do not publish externally without authorization. Return the writeup with its central safety premise either proven at its stated level or explicitly unproven.
