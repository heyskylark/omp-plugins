---
name: figure-it-out
description: "Design and execute an auditable playbook when no narrower workflow fits: large migrations, ambitious multi-part changes, or work reviewed after someone steps away. Scale rigor to risk, test hypotheses against real artifacts, and maintain an evidence-backed decision trail."
disable-model-invocation: true
---

# Figure it out

When no narrower playbook fits, design one. The deliverable before product code is the workflow itself: concrete phases, scaled rigor, a scientific-method loop, and a decision trail a human can audit after stepping away. Bias toward more rigor: building the wrong thing costs more than grounding the work. Rigor means useful gates and evidence, not ceremony.

## Start and preserve state

The parent owns the OMP `todo` list. Its first item is to read `skill://sky-mode` and apply its Principles section; then add Phases A–E below. Reuse a caller's active plan rather than replacing it. Children do not own todos, recursively invoke this orchestrator, or rewrite shared notes.

Keep the designed workflow in a scoped artifact such as `local://figure-it-out-plan.md`, and retain grounding, hypotheses, decisions, unresolved questions, and returned artifact links in the parent's existing scoped notepad or `local://figure-it-out-notepad.md`. The parent is the sole writer. These are session artifacts, not a new orchestration database or a guarantee of cross-session discovery. For a durable handoff, use user-approved repository documentation and evidence that survives outside the session; do not silently add repository documents.

Every named skill below means read and apply the exact `skill://` resource in this workflow, retaining the same parent and artifacts. Honor available tools, spawn policy, concurrency/depth limits, isolation availability, and plan-mode restrictions. If a required unit cannot run, keep it visibly blocked or INCONCLUSIVE and disclose why; do not silently omit it or claim an inline substitute is an independent review.

## Phase A: Frame

Ground first, then commit to the run. Inspect the actual system and existing conventions inline before deciding whether substantial independent research warrants `scout` tasks. State:

- **Definition of done:** a falsifiable predicate, following `skill://principle-prove-it-works`. Identify the real product surface, measurement, expected result, and evidence that could disprove success.
- **Quantified scope:** rough work units and effort, affected surfaces, dependencies, non-goals, and blockers grounding surfaced. Distinguish measured facts from estimates.
- **Rigor level:** bias high for one-way doors and broad blast radius; use fewer gates for reversible low-stakes work. Name the gates and artifacts that implement that rigor, and explain the tradeoff.

Present this framing before a long run. Read and apply `skill://principle-never-block-on-the-human`: continue authorized, reversible work without unnecessary questions, but a multi-hour run earns one checkpoint before committing to its execution. Existing explicit approval can satisfy that checkpoint; otherwise present the phase plan for the user's decision. Autonomy does not authorize commits, pushes, merges, installation, destructive changes, or sensitive external actions.

In active OMP plan mode, keep the plan in the permitted `local://<slug>-plan.md` artifact and submit its slug by plain-text `write` to `xd://propose`. This device is valid only in plan mode; outside it, use a normal human checkpoint. Never bypass a plan-mode restriction through another tool.

## Phase B: Design the workflow

Decompose the outcome into atomic, independently landable units. Sequence the riskiest unknown first. Read and apply `skill://principle-foundational-thinking`: establish the working scaffold and verification before dependent features, not a broken scaffold disguised as progress.

1. **Build the verification harness first.** Capture a pre-change baseline before altering behavior. Choose a real observation that can compare old value with new value under equivalent conditions; preserve input, environment assumptions, procedure, and baseline evidence. A harness passing is not yet the whole-product predicate passing.
2. **Resolve one-way-door design decisions.** Read and apply `skill://architect`, which runs `skill://arena`. Give it the Phase A predicate, grounded constraints, and required checkpoint so it does not implement prematurely. Skip this design comparison only for mechanical work whose shape is already concrete. Read `skill://principle-laziness-protocol`: do not run a second arena over a settled design without new evidence that invalidates it.
3. **Choose real parallel seams.** Read and apply `skill://principle-separate-before-serializing-shared-state`. Define interfaces, file ownership, input/output contracts, dependencies, integration owner, and judges before spawning. Fan out only substantial independent slices; keep coupled work together and do not over-fan. Use one `task` batch with shared `# Goal`, `# Constraints`, and `# Contract`, and complete per-item `# Target`, `# Change`, and `# Acceptance` instructions. Use `scout` for repository/search research, `reviewer` for compatible patch bug review, `security-reviewer` only for compatible source-security review, `sonic` for mechanical edits, and the configured general task agent for reasoning/implementation, design and experiment judgment, custom verdicts, and executable proof. A discovered specialist is suitable only if its role scope, tools, and output contract fit; overriding the prompt or schema does not broaden a patch-only role. Select roles, not per-call models.
4. **Separate editing workspaces.** Request native `isolated: true` for independent editing tasks when available and permitted. If isolation is unavailable, keep edits with one owner and parallelize only non-editing work. Native task isolation may automatically apply changes: competing alternatives must remain read-only proposals, or use documented eval `agent()` controls with `isolated: true, apply: false, merge: false` outside plan mode. Never integrate all competing candidates. The parent selects and integrates only the accepted result through supported patch/edit tools.
5. **Write the phase list for review.** Each unit needs a hypothesis, target/owner, inputs and predecessors, smallest intended change, measurement and baseline, acceptance predicate, judge, evidence location, and safe rollback boundary. Include the whole-product final check and audit review. Record selected rigor and any unresolved approval or tool prerequisites.

Then execute the design: insert its concrete unit steps after the Phase C entry and before Phase D in the parent's todo list. Phase C governs each unit; Phase D runs throughout, one row as a consequential decision occurs or unit lands, not as a retrospective reconstruction.

## Phase C: Run the experiment loop

Read and apply `skill://principle-sequence-verifiable-units`. For every unit:

1. State the hypothesis and the observation that would refute it.
2. Make the smallest complete change that tests it.
3. Measure the real artifact against the predicate and captured baseline.
4. Keep the change if it advances the outcome. Otherwise revert only that unit's owned change, preserving unrelated user work, and record what the experiment taught you.
5. Record the evidence and verdict before advancing dependent work.

Verify each unit before its successor rather than batching all checks at the end. For a parallel wave, workers skip tests, builds, linters, and formatters while sibling edits are in flight. The parent waits for the wave's required artifacts, verifies each integrated unit and shared contracts at that boundary, and only then begins dependent units. Independent concurrency does not waive any unit's acceptance gate.

Inspect artifacts, never trust self-reports. If success comes suspiciously easily, test the observation method before trusting the system. Pair delegated work with a judge and audit its artifact yourself. Give the judge the actual change, baseline, predicate, and evidence, not just the worker's conclusion. If a worker games the gate, reject that result and harden the contract. If the gate is wrong, repair it as its own recorded change, rather than routing around it. Do not count a judge who merely repeats a worker's report as independent verification.

Children receive no conversation history: pass complete requirements and exact artifact URIs. General judgment and proof agents return evidence, verdicts, and proposed audit rows through their `agent://` outputs. Bundled `reviewer` instead returns its native findings/correctness schema for patch-introduced bugs anchored to changed diff lines; compatible source-security review retains its own native contract. The parent inspects full outputs before normalizing these findings into audit rows; patch correctness is not an experimental verdict, runtime PASS, or coverage proof. Use `hub` with returned agent IDs for follow-up; use `history://` only for known task sessions. Results auto-deliver when async execution is enabled. Keep working on independent responsibilities instead of polling; wait through `hub` only when genuinely blocked. For an eval-owned fixed handle wave, `wait(handles)` is the barrier; neither orchestration route removes spawn or plan limits.

Use native tools for real observations: `hub` start/readiness/logs/send/stop for long-running services and interactive CLIs, the browser prelude for web/CDP surfaces, and the appropriate product driver for other artifacts. Process creation is not readiness. Do not start a replacement worker fleet or scheduler. Stop owned temporary processes after their evidence is captured unless their continued operation was requested.

Each verdict is **VERIFIED**, **NOT VERIFIED**, or **INCONCLUSIVE**. Inconclusive is not a pass; absent evidence is not proof of failure. Do not conceal a negative result or continue dependent work as if an unmet predicate passed.

## Phase D: Keep the audit trail throughout

Read and apply `skill://show-me-your-work`. Maintain its one canonical TSV with a row per consequential decision and per unit, and links to actual evidence. Reuse its header, helper, review procedure, and existing log rather than inventing another format. The parent writes it; children propose rows in returned artifacts. Append pivots, rejected alternatives, reversions, blockers, and gate repairs as they happen.

Use a scoped session-local log by default. Ambitious work often needs a durable PR-readable trail: propose retaining the trail and supporting evidence in the repository's established audit location when confidence must be shown. Write repository documentation only when requested or required by policy, and commit only with user authorization. Prefer evidence reproducible by committed scripts when that is appropriate to the task and authorized; session-only links must be identified, and private transcripts or credentials must not be copied into public evidence. The trail plus the diff should let a returning reviewer understand and assess the work.

## Phase E: Verify and hand back

Check the complete product against the Phase A predicate, not merely the harness or the sum of worker reports. Inspect the real outcome and retain exact observations. A locally successful unit does not prove an end-to-end result. If a final check fails, return to the responsible unit under the same experiment discipline and record the correction.

Read and apply `skill://principle-encode-lessons-in-structure`: turn recurring corrections into an appropriate gate, lint rule, check, or script, rather than another reminder. After proof, remove temporary scaffolding and update affected existing documentation as authorized. Apply `skill://show-me-your-work`'s evidence audit and independent trail review, including its disclosure when independent or cross-model review is unavailable.

**Reply with:**

- The playbook designed and executed, including material deviations.
- The chosen rigor level and why it fit the risk.
- The plan/notepad and canonical decision-trail paths; distinguish session-only from durable evidence.
- What is VERIFIED against the original predicate, with concrete observations and evidence links.
- What is NOT VERIFIED or INCONCLUSIVE, still open, blocked, or awaiting authorization; do not describe a partial run as complete.
- The audit review's `Attention` section required by `skill://show-me-your-work`, including review limitations and unresolved flags.
