---
name: swarm
description: "Fan out parallel OMP workers for coverage matrices, implementation races, gauntlets, or exploration partitions, then aggregate every required cell into one evidenced report."
disable-model-invocation: true
---

# Swarm

Fan out N independent workers, drain their outcomes, and return one report. Workers may cover separate slices, race the same brief, or mix both. The parent owns framing, orchestration, acceptance, integration, and reporting. A worker finishing is not proof that its deliverable passes.

## Start

The parent tracks four phases in its existing todo facility: Frame, Fan out, Aggregate, Report. If that facility is unavailable, keep the same phase ledger in the parent's scoped `local://` notepad; do not create a replacement task database. Children receive self-contained assignments, not the parent's conversation, and never own the parent todo or recursively invoke this orchestrator.

Before dispatch, inspect the relevant scope inline with `read`, `grep`, or `glob`. Derive real independent work rather than delegating the decomposition itself. Small work without substantial independent slices stays inline; explain that limitation rather than manufacturing workers.

## Phase A: Frame

1. State the **done predicate** and the artifact or report to return. Separate required coverage from optional evidence.
2. Choose a shape: partitioned coverage, a race on identical briefs, or a mixture. For races, declare **first pass**, **rank all**, or **best-of** before launch, together with the pass criteria, comparison rubric, and tie-breaker.
3. Set **N**, using the user's count or the shape. N is the total worker assignments, not the runtime concurrency limit. Name every required cell before launch; never quietly delete one when a worker drops out.
4. Select available agents whose role, tools, and output contract fit the whole cell: `scout` for code/search research and exploration, bundled `reviewer` only for patch-introduced code bugs anchored to changed diff lines, `security-reviewer` only for compatible source-security analysis, `sonic` for mechanical edits, and the configured general task agent for reasoning, design/custom judgments, or implementation. Executable verification requires a general task agent or discovered compatible execution specialist with the required tools, not the bundled reviewer. Omit `agent` only when the advertised spawn-policy default is the appropriate general task agent. Overriding an output schema does not override an incompatible role.
5. Give each editing worker exclusive ownership and its own isolated workspace. Declare shared interfaces and one integration owner before spawning. Shared-file mutation is a dependency boundary, not parallel work; keep that mutation with its owner after independent results arrive.
6. Record the current workspace/baseline, constraints, relevant files, known findings, acceptance criteria, and authorization boundaries in the parent-owned brief. Workers start from the current supplied workspace, not an assumed remote branch. If a specific baseline is required, resolve it before fan-out without altering unrelated user work or publishing a branch merely to launch workers.

### Shape recipes

#### Coverage matrix

Enumerate axes appropriate to the request, such as subsystem × concern, feature × scenario, or platform × behavior. Expand the required cells explicitly. Each cell has a stable key, scope, done predicate, agent role, evidence requirement, and output location. A worker may own several clearly named cells when they share substantial setup, but must return one outcome per cell.

Example partition:

| Cell | Scope | Concern | Assigned role |
| --- | --- | --- | --- |
| API-Correctness | API boundary | Behavior and error contracts | General task agent; execution-capable for runtime proof |
| API-Security | API boundary | Source trust boundaries and exploitability | security-reviewer, retaining its native output |
| UI-Correctness | UI flow | State and observable behavior | General task agent with required UI execution tools |
| UI-Access | UI flow | Accessibility findings | General task agent or discovered specialist matching the full scope/output |

The axes are task-specific, not a mandatory four-worker quota. Reconcile the result against the original matrix, including cells that never launched. All required cells need usable evidence before claiming complete coverage.

For a patch-only bug-review cell, bundled `reviewer` is appropriate with its native findings and correctness verdict. Do not assign it a broader behavior, design, accessibility, or runtime gate by relabeling that gate as review. If a cell needs both source review and runtime proof, retain both obligations and provide a capable execution owner; the review alone cannot satisfy the cell.

#### Races

Give every arm the same goal, baseline, constraints, acceptance criteria, and evidence contract; name any intentionally different strategy. Use independent outputs so one contender cannot overwrite or observe another's answer before evaluation. Distinguish:

- **First pass:** accept the first candidate the parent establishes meets the full pass predicate, not simply the first worker to finish. Then cancel remaining running arms if their output is no longer needed. Record all completed and cancelled arms.
- **Rank all:** drain every arm, evaluate every usable output against the announced rubric, and report the full ranking. Failed, missing, or blocked arms remain in the table but do not receive fabricated scores.
- **Best-of:** drain the declared comparison set and select the strongest candidate meeting the pass predicate, using the announced rubric and tie-breaker. Report the choice and why alternatives lost. If no candidate passes, there is no winner.

Use available role-backed agent definitions, not per-call worker model selection. An optional user-configured multi-model panel may select existing agent types whose configuration supplies model diversity. Never create a hardcoded model list or claim diversity from different agent names alone. If all arms resolve to the same model or resolution is unknown, disclose that limitation; independent strategies are still useful but are not demonstrated cross-model agreement. Report an unavailable requested arm instead of silently substituting it.

#### Gauntlets

Map each gate to a required cell with its own pass predicate, scope, and evidence: for example correctness review, security analysis, performance assessment, and maintainability review. Fan independent gates together. Gates requiring a previous deliverable form a later wave; do not pretend a dependent sequence is parallel.

Reviewers inspect and report without editing. The parent fixes or assigns accepted findings after the wave drains, then performs the relevant final checks. Keep unresolved gates visible; passing one gate cannot compensate for an unrun or failing required gate. Avoid redundant full-suite runs in workers.

#### Exploration partitions

Partition a broad question by actual repository region, architectural boundary, data flow, competing hypothesis, or evidence source. Use `scout` for repository/search investigation; use a general reasoning agent when the assignment requires substantive synthesis rather than discovery. Each partition returns anchored findings, negative evidence with the searched scope, uncertainties, and cross-boundary leads.

Assign boundary ownership to prevent holes. Allow deliberate overlap only when independent corroboration matters, and label it. The parent reconciles terminology, connects cross-boundary findings, deduplicates claims, and distinguishes an inspected negative result from an unexplored area.

### Limits and authorization

Honor the active tools, plan mode, spawn policy, recursion limit, concurrency cap, and job limits. Keep any simultaneous batch within the session's supported maximum, never more than 32 workers. If N exceeds capacity, retain all N cells and launch bounded waves as capacity allows; disclose reduced concurrency. Do not build a scheduler, worker fleet, or persistence service to evade native limits.

Plan mode does not permit isolated editing or apply/merge controls. Use read-only proposed artifacts for a race in that mode, or report that implementation requires leaving plan mode through the normal approval flow. If spawning is unavailable, report the constraint and perform reachable work inline without claiming parallel execution. Do not silently reduce an explicitly requested comparison or coverage set.

Autonomy does not authorize commits, pushes, merges, destructive deletion, installation, credential access beyond scope, or sensitive external actions. Preserve the user's existing authorization boundary in every assignment. Isolation and integration must respect those boundaries too.

## Phase B: Fan out

### Independent ownership

Dispatch genuine independent slices in a single native `task` batch. Its shared `context` contains `# Goal`, `# Constraints`, and `# Contract`; every task contains `# Target`, `# Change`, and `# Acceptance`. Give each a unique stable name and the appropriate available agent type. Use `isolated: true` for independent editing when supported. Native isolated task work can integrate automatically, so this route is **not safe for competing edits**.

If the live task schema only supports individual tasks, use its advertised form and issue independent calls concurrently where supported; do not send unsupported batch fields. Shared background can live in a scoped `local://` brief referenced by every task. Use only the currently exposed schema.

Every worker brief must specify:

- The goal, required output, baseline, exact owned cells or race arm, and allowed paths.
- Relevant source context, shared contracts, explicit non-goals, and permission boundaries. Children have no parent conversation.
- Whether it may edit or only propose findings. No sibling paths, parent todo/notepad writes, or recursive orchestration.
- What would verify acceptance and what evidence to return. Workers skip formatters, linters, builds, tests, runtime validation, and project-wide gates during concurrent work; the parent performs necessary acceptance checks after integration or evaluates contenders sequentially without shared-state races. The parent may delegate a later bounded executable-verification assignment to a capable general task agent or discovered compatible execution specialist, with exclusive runtime ownership and explicit proof requirements. A worker's unexecuted verification plan is not evidence of a pass.
- Ordinary workers return one result per assigned cell using `PASS`, `ISSUES`, or `BLOCKED`, with anchored evidence, changed files or proposed artifact, uncertainties, and outstanding verification. `PASS` may describe a completed research assignment; it must not imply that unrun implementation checks passed.
- Specialized native code reviewers retain their own output contracts, not the ordinary worker format. Bundled `reviewer` returns native `findings`, `overall_correctness`, `explanation`, and `confidence`; `security-reviewer` retains its own discovered contract. Name the cells in the assignment and let the parent map the full native result into the cell ledger. Do not force these agents to emit custom statuses or override their schemas to disguise incompatible work.

Parent-owned services use `hub` process supervision with `start`, observed readiness, `logs`, `send`, and `stop`. Workers must not independently mutate one shared process or test environment. Use the available native browser surface for web verification and the relevant symbol/AST tools for code intelligence rather than implementing new orchestration machinery.

### Competing edits: hold every candidate out of the parent

Use eval's `agent()` isolation controls for races or mixed-shape cells whose edits compete. Launch the independent arms together in one eval cell, retain each handle, and set **`isolated: true, apply: false, merge: false`** on every editing contender. `apply: false` prevents integration of captured edits; `merge: false` selects patch mode. Never assume `task` isolation alone prevents automatic application.

A JavaScript launch has this shape, after the parent has defined complete stand-alone brief strings and chosen supported agents:

```javascript
const candidateA = await agent(briefA, {
  label: "CandidateA", isolated: true, apply: false, merge: false
});
const candidateB = await agent(briefB, {
  label: "CandidateB", isolated: true, apply: false, merge: false
});
const candidates = [candidateA, candidateB];
```

Each call returns a background handle; the second arm starts without waiting for the first arm's work. Choose explicit `agent` options when the spawn default is not the required role. Preserve the returned IDs and `agent://` handles in the parent ledger. Require candidates to describe all changes and return the actual reported patch/artifact location; do not guess artifact paths.

If non-applying isolation is unavailable, use read-only candidate proposals with separate returned artifacts. Do not let competing agents edit the shared checkout and attempt to undo losers afterward. If actual independent implementations are required, name the unavailable prerequisite rather than presenting proposals as equivalent finished implementations.

For rank-all and best-of, drain with `await wait(candidates, { raiseErrors: false })`; values remain in input order and errors remain in their own slots. For first-pass, process terminal deliveries as they arrive and inspect each candidate before selecting a winner. Use native `hub` waiting only while otherwise blocked; a wake can be a message or wait-window expiry, not completion of every candidate. No custom polling loop or scheduler is needed.

### Native lifecycle

Workers return through `agent://<id>` and terminal deliveries. Read the full artifact when the preview is truncated. Follow up through `hub` using actual known IDs; use `history://<id>` only for known task sessions. Isolated task workspaces can be cleaned up and their agents non-revivable: retain their outputs rather than relying on a later conversation to recover edits.

Use `hub` cancellation with actual owned job IDs or eval handle `.cancel()` for work no longer needed. Cancellation requests are not output acceptance; record the observed terminal outcome. Do not cancel required coverage because a different slice passed. A dropped worker does not stop independent workers, but its cell remains a gap. Parent-directed recovery may rerun the exact missing cell when justified and permitted; record the failed attempt as well as the replacement.

## Phase C: Aggregate

Drain terminal outcomes and reconcile **every original cell**. Runtime status and semantic verdict are separate:

| Execution outcome | Interpretation |
| --- | --- |
| Completed with usable output | Evaluate ordinary worker statuses or normalize the full specialized native result against each assigned cell's predicate and evidence; completion alone is not acceptance. |
| Failed | Retain the reported error and any explicitly partial output; failure is not a negative finding or a pass. |
| Cancelled | Record who cancelled and why, such as a confirmed first-pass winner; do not label cancellation as worker failure. |
| Absent output | A settled worker supplied no usable result, or output cannot be recovered; record a gap, not an empty successful report. |
| Not launched | Record spawn rejection or unmet prerequisite; retain the planned cell. |
| Still running | Not terminal. Continue useful parent work or wait; do not silently omit it from the final drain. |

Use native status/error/abort evidence to distinguish these outcomes; an exception alone does not establish cancellation. With error-preserving eval waits, inspect each error slot and associated handle/status rather than coercing errors into verdicts. Empty output is not evidence that no issues exist.

For native reviewer results, retain the original findings, verdict, confidence, and artifact attribution before deriving a ledger status. Map supported findings to `ISSUES`; use `PASS` only when the evidence satisfies that cell's stated scope and predicate. Missing or inconclusive required coverage stays `BLOCKED` with the specific gap, even if the patch verdict is `correct` or the findings list is empty. Never translate reviewer correctness into runtime `PASS`, design approval, rubric scores, or coverage of unexamined behavior. Required execution evidence must come from the parent or the capable execution owner.

For coverage and gauntlets, every required cell needs a usable result and the relevant acceptance evidence. For races, apply only the announced rule. If a contender failed or never produced output, a best-of selection can only claim to be best among evaluated candidates; disclose the missing comparison. In first-pass mode, cancelled losers are expected race outcomes, not missing required coverage unless they also owned a separate required cell.

Inspect evidence, deduplicate overlapping findings without losing source attribution to cell IDs, and resolve contradictory claims against the actual artifact. Keep one-line evidenced issues and a compact table instead of pasting worker dumps. Label inference, unverified claims, and remaining gaps explicitly.

For editing races, review and verify the selected candidate against the stated done predicate before integrating only its accepted changes. Never apply all candidates, cherry-pick all race branches, or combine incompatible alternatives implicitly. Preserve unrelated user work. Use the normal authorized editing/integration path; if native integration would create a commit or merge not authorized by the user, keep the candidate as a proposed patch or implement the accepted changes with ordinary edits. Perform the parent's relevant final validation once on the integrated result, and report precisely what ran.

## Phase D: Report

Return one consolidated in-chat report containing:

1. Goal, done predicate, shape, requested N, launched count, and any capacity or configuration limitation.
2. A compact table for every cell/arm: scope, actual worker ID, execution outcome, semantic verdict, evidence/artifact, and outstanding gap.
3. One-line actionable issues with anchors and severity where appropriate, deduplicated across workers.
4. Explicit dropouts, missing outputs, cancellations, blocked cells, unresolved contradictions, and unperformed verification.
5. For races: the predeclared selection rule, evaluated candidate set, winner or no winner, reasoning, tie-breaker if used, and what was actually integrated.
6. Final acceptance result grounded in the parent's checks. Do not claim complete coverage with missing required cells or successful implementation from a worker's assertion alone.

## Native references

When mechanics are uncertain, read the installed documentation rather than inventing tool fields:

- `omp://tools/task.md`: task batch context/items, conditional isolation, automatic integration, output artifacts, parent-owned todo, child context, and lifecycle/limits.
- `omp://tools/eval.md`: retained handles, `agent()` isolation/apply/merge controls, error-preserving `wait`, cancellation, and role-based dispatch without per-call models.
- `omp://tools/hub.md`: terminal deliveries, first-event waiting, actual job IDs, cancellation, messaging, and supervised process readiness.
- `omp://task-agent-discovery.md`: available agent discovery, configured role resolution, spawn-policy/depth enforcement, and plan-mode restrictions.
- `omp://skills.md`: exact `skill://` resolution and supported skill frontmatter.
