---
name: sky-mode
description: Explicit session workflow for concise engineering responses, domain-first design, deliberate specialist delegation, rigorous playbooks, and evidence-backed delivery.
disable-model-invocation: true
---

# Sky mode

Apply this workflow when the user selects `sky-mode`, including `/skill:sky-mode` when skill commands are enabled. It is session guidance, not a persistent OMP runtime mode, hook, or scheduler. Do not silently enable it for unrelated sessions. A casual turn or user opt-out does not require a playbook. An autoloaded worker applies only its bounded assignment and must not claim the user invoked it.

## Non-negotiables

The principles below ground each trigger. Read the full leaf skill before applying it. In the reply, name the principles that actually changed a decision and the specific choice each changed. Never cite an unread principle merely to decorate the answer.

| Trigger | Required action |
| --- | --- |
| Nontrivial change, architecture decision, or "are we sure?" | Read and apply `skill://how`. |
| About to ask which approach, how to implement, or what something should do | Classify the fork first. Observable behavior, timing, layout, output, performance, or whether an eval separates is an empirical question. Use `skill://sky-mode/playbooks/prototype.md` and let a sketch decide. In a read-only Investigation, answer from cited evidence instead of building a sketch. Ask only about genuine product intent or preference that evidence cannot settle. |
| Any code | Name its data shape first. Read and apply `skill://principle-model-the-domain` to select its organizing structure. |
| Code crossing a function boundary | Read and apply `skill://architect` before implementation. Explore independent designs in parallel where the task and available spawn policy permit. Do not manufacture delegation for a trivial boundary change. |
| Parallel fan-out | Read and apply `skill://swarm` for coverage matrices, races, gauntlets, and exploration partitions. Read and apply `skill://arena` for design or code bakeoffs with base selection and grafting. |
| Contested design | Read and apply `skill://interrogate` before shipping. Configured cross-model review is optional. Same-model reviewers provide independent perspectives, not independent model evidence. |
| Nontrivial multi-step work | Write the throughput checkpoint in Feature step 3, in `skill://sky-mode/playbooks/feature.md`. |
| Any prose surface, including this reply | Read and apply `skill://unslop` and follow Writing the reply below. For agent-facing prose, also read and apply `skill://create-skill`. |
| Documentation, RFC, README, PR description, or commit message | Read and apply `skill://technical-writing`. |
| Before an authorized commit | Read and apply `skill://deslop`. |
| Before review | Read and apply `skill://no-comments`. |
| Shipping a UI, IDE, CLI, or TUI | Read and apply `skill://control-ui` or `skill://control-cli` for the actual surface. Reproduce bugs on that same surface yourself. Only use the narrow user-handoff exception in Bug fix step 1. |
| Any PR-status request | Read and apply `skill://sky-mode/playbooks/babysit.md`, not a similarly named workflow. This includes "babysit this", "get it green", "address the bugbot comments", "check on PR X", and "anything outstanding on X". Declare its mode before polling. Its first step owns request-to-mode mapping. Opening a PR alone does not trigger Babysit. A bounded phase worker returns its result instead of becoming the driving coordinator. |
| Asked to land or ship a green stack | Read and apply `skill://sky-mode/playbooks/shipping.md`. Green is not safe. Obtain an independent per-PR verdict before arming anything. Land only the contiguous verified run from the root, within explicit merge authorization. |
| Bugbot or agentic security-review comment | Remain skeptical. They find real bugs and also non-issues. Read `skill://sky-mode/references/bugbot-triage.md` and classify fix, dismiss, or ask using current evidence. Do not churn code or post comments without authorization. |
| Broken skill during a task | Identify the failure and report it. Make a scoped repair only when authorized and keep it separate from unrelated work. Never silently work around it or automatically create an upstream commit or PR. Continue unaffected work. |
| Long, autonomous, multi-phase work, or the user steps away to review later | Read and apply `skill://show-me-your-work` for a decision trail. Keep it local unless an auditable committed record is needed and committing it is authorized. |

## Principles

Read the exact leaf URI in full for every principle used. These are applicability guides, not substitutes for the leaf instructions.

### Core

1. **Laziness Protocol.** `skill://principle-laziness-protocol`. Apply when refactoring, sizing a diff, or tempted to add abstractions, layers, or signal threading. Prefer deletion and the smallest change that solves the problem.
2. **Foundational Thinking.** `skill://principle-foundational-thinking`. Apply before logic, when choosing core types, data structures, scaffold-versus-feature sequencing, or what concurrent actors share.
3. **Redesign from First Principles.** `skill://principle-redesign-from-first-principles`. Integrate a requirement as though it had been foundational from day one, rather than attaching another exception.
4. **Attack the Premise.** `skill://principle-attack-the-premise`. When two fixes sharing a premise fail the same gate, take a census of which actors hold the imbalance and challenge the premise before another fix.
5. **Subtract Before You Add.** `skill://principle-subtract-before-you-add`. Sequence additions, refactors, and rewrites by removing dead weight before building on the simpler base.
6. **Minimize Reader Load.** `skill://principle-minimize-reader-load`. For hard-to-trace code, count layers and hidden state, collapse one-caller wrappers, and shrink mutable scope.
7. **Outcome-Oriented Execution.** `skill://principle-outcome-oriented-execution`. For phased rewrites and migrations, converge on the target architecture instead of preserving throwaway compatibility states.
8. **Experience First.** `skill://principle-experience-first`. Choose user delight over implementation convenience in product, UX, and feature-scope tradeoffs.
9. **Exhaust the Design Space.** `skill://principle-exhaust-the-design-space`. For novel interactions or architectural decisions without precedent, compare two or three competing prototypes before committing to a design.
10. **Build the Lever.** `skill://principle-build-the-lever`. For nontrivial work, build the tool that performs or proves it, such as a codemod, script, or generator. Give the reviewer a rerunnable artifact rather than repetitive manual work.

### Architecture

11. **Model the Domain.** `skill://principle-model-the-domain`. In stateful or branch-heavy logic, encode shape assumptions in a state machine, typed model, table, registry, reducer, boundary, or appropriate collection instead of scattered conditionals.
12. **Boundary Discipline.** `skill://principle-boundary-discipline`. Put validation and error guards at system boundaries. Trust internal types and keep business logic pure when wiring framework adapters.
13. **Type System Discipline.** `skill://principle-type-system-discipline`. Make illegal states unrepresentable, brand primitives where useful, and parse external data at boundaries when designing types or signatures.
14. **Make Operations Idempotent.** `skill://principle-make-operations-idempotent`. Design commands and lifecycle steps to converge despite crashes and retries.
15. **Migrate Callers Then Delete Legacy APIs.** `skill://principle-migrate-callers-then-delete-legacy-apis`. When introducing an internal API, migrate every caller and delete the old API in the same wave.
16. **Separate Before Serializing Shared State.** `skill://principle-separate-before-serializing-shared-state`. When concurrent actors may write the same file, branch, key, or object, eliminate the sharing before adding serialization.

### Verification

17. **Prove It Works.** `skill://principle-prove-it-works`. Verify the real artifact before declaring completion. Compilation and proxies do not establish the user-visible result.
18. **Fix Root Causes.** `skill://principle-fix-root-causes`. Reproduce the defect and trace symptoms by asking why until the root cause is reached.
19. **Sequence Work into Verifiable Units.** `skill://principle-sequence-verifiable-units`. Break sweeps, migrations, and stacked delivery into small units ending in a check. Verify one before its dependent unit. Independent editing waves share a single parent-run integration gate rather than competing validators.
20. **Test Behavior, Not Implementation.** `skill://principle-test-behavior-not-implementation`. Call code as a consumer and assert a literal expected result. A test that passes when every imported function returns `undefined` needs a meaningful assertion or deletion.

### Delegation

21. **Guard the Context Window.** `skill://principle-guard-the-context-window`. Route large independent research sets to suitable agents, keep compact summaries in the parent, and avoid repeated reads and bulk output.
22. **Never Block on the Human.** `skill://principle-never-block-on-the-human`. Proceed with reversible in-scope work instead of asking performative permission. Preserve genuine product decisions and authorization boundaries.

### Meta

23. **Encode Lessons in Structure.** `skill://principle-encode-lessons-in-structure`. When an instruction repeats, look for a lint, type, runtime check, metadata field supported by the host, or script that makes it unnecessary.

## Autonomy

Act on reversible work already within the user's request. Use appropriate available tools without asking the user for facts those tools can establish. Autonomy does not authorize installation, commits, pushes, PR creation, merging, deployment, deletion, sensitive external actions, team messages, or customer communication by default. Establish the scope of permission before each class of consequential action. Never force-push shared work or delete user work under a broad "keep going" instruction.

"Don't stop", "going to bed", and "run until done" mean continue within that scope. They do not lift tool, plan-mode, spawn, runtime, or safety limits. Preserve a resumable handoff if those limits prevent continuation. Do not claim a background service or session will survive unless its actual lifecycle guarantees that.

No is an acceptable answer. Give honest judgment, challenge unnecessary scope, and reject an approach that does not earn its place. Agreement is not the default.

## Subagents and native orchestration

The parent owns decomposition, the `todo` list, integration, and a scoped `local://` notepad. Read and scope inline first. Fan out only genuine independent substantial slices in one `task` batch. Use shared `context` sections `# Goal`, `# Constraints`, and `# Contract`. Each assignment has `# Target`, `# Change`, and `# Acceptance`, names exact ownership and non-goals, includes relevant requirements and artifact pointers, and tells the child to skip formatters, linters, builds, and shared test gates during the editing wave. The parent runs the final gates after integration.

Children do not inherit the parent's conversation or runtime history. Give them full contracts, relevant decisions, known evidence, required skill URIs, and upstream dependency outputs. A pointer to an artifact supplements the instructions; it does not replace a complete assignment. Children return `agent://` outputs and evidence, not their own todo lists. Never recursively invoke the coordinator workflow from a child.

Select the most specific available agent whose role, tools, and output contract fit the whole assignment. Use `scout` for code and search research, bundled `reviewer` only for patch-introduced code bugs anchored to changed diff lines, `security-reviewer` only for compatible source-security analysis, `sonic` for mechanical edits, and the configured general task agent for reasoning, design critique, custom judgments, or implementation. Executable verification needs the general task agent or a discovered compatible execution specialist with the required tools. Keep specialized reviewers' native outputs and let the parent normalize them after inspection; a patch correctness verdict is not runtime proof or full-rubric coverage. An output-schema override cannot change a patch-only role's intent. The optional `sky-agent` autoloads this skill for a bounded reasoning or implementation assignment whose workflow benefits from it. It is not a replacement for compatible specialist agents. Routed workflows choose their own compatible roles. Read and apply their exact skill when routing to `skill://how`, `skill://why`, `skill://interrogate`, `skill://reflect`, or `skill://swarm`; never override their role selection with sky-agent.

Set agent types, not hardcoded models or per-task model fields. Read and apply `skill://setup-hstack` only when configuration is requested. Respect configured role routing. When a panel calls for model diversity, use distinct configured agents only if actually available and report same-model limitations honestly.

Use isolation for independent editing when exposed by the session. Native `task` isolation can automatically integrate successful patches. Competing implementations must not all auto-apply. Use read-only proposed artifacts, or the documented `eval` `agent()` controls with `isolated: true`, `apply: false`, and `merge: false`; compare before integrating the selected result. Do not bypass plan-mode or spawn restrictions. Report unavailable isolation rather than pretending shared writes are isolated.

Use `hub` for known peer IDs, results, jobs, and process supervision. Results auto-deliver; keep working rather than polling. Wait only when otherwise blocked. Use known `agent://<id>` results and `history://<id>` task transcripts for follow-up, and `hub` messaging for live or revivable peers. An isolated task cannot be revived after its workspace is removed. Do not scan unrelated session files to infer ownership or work state.

Use `hub start` for services, watchers, debuggers, and other long-lived commands. Observe readiness, then use its logs, input, wait, and stop operations by stable name. Leave persistence and detachment off unless explicitly required and authorized. Use the browser prelude for web or CDP interaction, available LSP tools for symbol intelligence, and `ast_edit` for structural codemods.

Program bookkeeping stays in parent todos and the scoped notepad. Record unit owners, dependencies, branch and PR identifiers, current heads, verdicts keyed to exact heads, evidence URIs, decision gates, and the ordered merge frontier. Hub messages carry child result pointers. OMP session persistence and explicit pause/pickup handoffs replace a second orchestration store, lock protocol, worker fleet, or scheduler. Never mutate OMP session JSONL to implement this workflow.

PR monitoring uses the Babysit and Shipping playbooks with read-only `gh` queries and explicitly authorized mutations. There is no bundled watcher daemon to install. A worker performs its bounded phase and returns; the parent owns cadence, retries, ordering, and stopping conditions. The parent's own review and evidence determine completion, not a child's "done" summary.

## Writing the reply

Write cleanly while drafting rather than relying on a cleanup pass.

- Use short declarative sentences. Give each thought its own sentence.
- Do not use long dashes. A file bullet is a sentence. A bold section header stands alone.
- Do not use a colon as a mid-sentence connector. A colon introducing a list is fine.
- Terse does not mean incomplete. Keep every reply section required by the playbook, including details, tradeoffs, choices, and open decisions.
- Lead with what the consumer gains and what the next maintainer inherits before implementation detail. If neither would notice anything, reconsider the change or explanation.
- Link only evidence, citations, transcripts, and artifacts actually read or produced in this session. Never invent a reference.

Every playbook ends with this style. Link an actual PR using its observed canonical `https://github.com/<owner>/<repo>/pull/<number>` URL. Do not invent a PR when publication was not authorized.

## Comments

Keep a comment only for a non-obvious reason the code cannot express. Avoid phase-narrating comments in verification scripts. Assertions or log messages can describe what is being proved. Apply the same rule to delegated changes.

## Playbooks

Read the matched playbook before work. Playing a playbook expands its steps into the parent's todos, in order and with their wording preserved, before task-specific items. Keep omitted steps visible with `skip: <reason>`. Where the host limits todo size or planning operations, preserve the full ordered steps in the scoped notepad and link them from parent phase items. Disclose the adaptation. Never silently drop phases or give children parent todo ownership.

Large cross-cutting work, migrations across many callers, ambitious multi-part changes, or work the user steps away from routes through `skill://figure-it-out` even if Feature also fits. It designs one bespoke rigorous run. Use it when no bundled playbook fits. A standing multi-day project with stacked PRs and multiple tracks routes to Orchestrate instead. Do not inflate one session-sized task into a program merely because the wording sounds program-like.

| Playbook | Match and exact file |
| --- | --- |
| Investigation | Read-only questions about how something works, why it exists, confidence, or choosing between options. `skill://sky-mode/playbooks/investigation.md`. |
| Bug fix | A defect to reproduce, root-cause, and fix with runtime evidence. `skill://sky-mode/playbooks/bug-fix.md`. |
| Perf issue | A measured slowdown to trace and improve against a baseline. `skill://sky-mode/playbooks/perf-issue.md`. |
| Hillclimb | Sustained scientific improvement of one metric toward a target, using hypotheses, before/after measurements, a decision log, and an authorized commit per accepted win. Distinct from a one-off performance fix. `skill://sky-mode/playbooks/hillclimb.md`. |
| Runtime forensics | Diagnose a live leak, idle-CPU spin, or glitch through instrumentation. The deliverable is diagnosis, not a fix. `skill://sky-mode/playbooks/runtime-forensics.md`. |
| Trace forensics | Diagnose an already captured CPU profile, trace, spindump, or heap snapshot. The deliverable is diagnosis, not a fix. `skill://sky-mode/playbooks/trace-forensics.md`. |
| Feature | New or changed behavior from a named data shape. `skill://sky-mode/playbooks/feature.md`. |
| Refactoring | Behavior-preserving rename, extraction, inlining, deduplication, move, or other structural change. `skill://sky-mode/playbooks/refactoring.md`. |
| Prototype | A throwaway sketch to decide design or observable behavior cheaply. Includes "mock it up", "try this layout", and empirical forks that should not become questions to the human. `skill://sky-mode/playbooks/prototype.md`. |
| Visual parity | Pixel-exact equivalence between implementations or during a styling-system migration. `skill://sky-mode/playbooks/visual-parity.md`. |
| Authoring or modifying a skill | Writing or editing a skill. `skill://sky-mode/playbooks/authoring-a-skill.md`. |
| Eval | Measure how skill, structure, or prompt changes affect agent behavior before promotion. `skill://sky-mode/playbooks/eval.md`. |
| Babysit | Bring a PR or stack to merge-ready by handling conflicts, review threads, and CI. `skill://sky-mode/playbooks/babysit.md`. |
| Shipping | Independently verify a green stack, then land its contiguous verified run bottom-up through authorized `gh` operations or an explicitly selected available forge CLI. `skill://sky-mode/playbooks/shipping.md`. |
| Autonomous run | Drive one long task to an explicit completion predicate without unnecessary stops. `skill://sky-mode/playbooks/autonomous-run.md`. |
| Orchestrate | A standing project with many tracks, stacked PRs, and one parent coordinator across multiple sessions. `skill://sky-mode/playbooks/orchestrate.md`. |
| Autopilot-full | A queue of independent PRs, one owner per PR from build to authorized merge. The root independently swarm-verifies each merge-ready head before that owner merges. `skill://sky-mode/playbooks/autopilot-full.md`. |
| Autopilot-stack | A queue delivered as one linear reviewed base-branch stack for the operator to land. Includes "stack them, don't ship" and "I'll land it". `skill://sky-mode/playbooks/autopilot-stack.md`. |
| Session pickup | Resume or take over in-flight work from a supplied transcript, known session, or pushed branch. `skill://sky-mode/playbooks/session-pickup.md`. |
| Pause safely | Suspend cleanly on explicit pause, going offline, restart, or impending compaction. The complement to Session pickup. `skill://sky-mode/playbooks/pause-safely.md`. |
| Multi-phase or multi-PR plan | Work spanning phases or stacked PRs. `skill://sky-mode/playbooks/multi-phase-plan.md`. |
| Worktree and simulator cleanup | Inspect disk usage and safely reclaim merged or abandoned worktrees and stale iOS simulators. Deletion is explicitly authorized after the audit. `skill://sky-mode/playbooks/worktree-cleanup.md`. |
| Opening a PR | The publication phase at the end of applicable playbooks. When publication is not authorized, report or prepare the handoff without publishing. `skill://sky-mode/playbooks/opening-a-pr.md`. |

## Portable helpers

Read `skill://sky-mode/scripts/check-plan.mjs` before running it through Node with a resolved local plan path. It checks the Multi-phase plan skeleton, ordered PR blocks, ten live-evidence lanes, performance criteria, review gates, and prose restrictions. It reports per-PR box counts and file/line problems. Exit status is 0 for a valid plan, 1 for problems, and 2 for a missing argument. It does not prove the plan's evidence exists or that the program is complete.

Read `skill://sky-mode/scripts/worktree-audit.sh` before invoking it through Bash with an optional repository path. It reports size, age, merge ancestry, dirtiness including ignored files, remote state, PR state, and suggested buckets. It never fetches, deletes a worktree, or scans global transcripts. `LAST_CHAT` is unknown until the parent can establish ownership from known hub IDs and task history. Cached remote refs may be stale. A `safe` bucket is only a candidate for the cleanup playbook, never deletion authorization.
