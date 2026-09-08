### Multi-phase or multi-PR plan

**You own the plan, not the code. The plan is a checklist an owner runs box by box and the operator audits from the evidence.** The plan is the deliverable. Do not implement.

1. When the change is one or two files with an obvious approach, skip the plan. Say so and stop.
2. Settle open questions by prototype before you write. Run `skill://sky-mode/playbooks/prototype.md` for each. Keep the branch, the SHA, and the screenshots for Appendix A. Ask the operator only about a product or preference call that no run can settle. Give options (the `skill://principle-never-block-on-the-human` principle skill).
3. Scope inline, then explore independent substantial areas in one bounded native `task` batch with `agent: "scout"`, shared contracts and explicit read-only assignments (the `skill://principle-guard-the-context-window` principle skill). Each returns file pointers, conventions, test commands, and entry points. No inlined dumps.
4. Copy the skeleton below into the plan file and fill every placeholder. Unless the operator names a path, write the file at `local://<program>/docs/plan.md`. Keep every heading and every sub-block in the order shown. One section per PR. One PR is one change with its own evidence (the `skill://principle-sequence-verifiable-units` principle skill). Name the execution playbook in **How to read this**. Pick between `skill://sky-mode/playbooks/autopilot-full.md` and `skill://sky-mode/playbooks/autopilot-stack.md` per the rule at the end of `skill://sky-mode/playbooks/autopilot-stack.md`. A standing program takes `skill://sky-mode/playbooks/orchestrate.md`.
5. Read and apply `skill://technical-writing` in full, then `skill://unslop`. The body is one Diátaxis mode, how-to. Appendices hold explanation and reference. Each heading states the task or the finding. No long dashes. No mid-sentence colons.
6. Run `node skill://sky-mode/scripts/check-plan.mjs <plan.md>` through the native shell tool, which resolves the skill URI to its actual helper path, and fix every diagnostic it prints (the `skill://principle-encode-lessons-in-structure` principle skill).
7. Hand back. Post the plan path and the script's output, then stop. Execution starts on the operator's explicit go, under the execution playbook the plan names.

**Native execution contract.** Read `omp://tools/task.md`, `omp://tools/eval.md`, `omp://tools/hub.md`, `omp://tools/todo.md`, `omp://task-agent-discovery.md`, and `omp://session.md` before asserting runtime mechanics. Keep all ten live coverage lanes; run them in bounded waves when actual concurrency or job limits require it, and report unavailable coverage as blocked. Use configured general task agents for independent proof judgment, design critique, runtime scenarios and custom verdicts, and scout for research. A discovered specialist must fit both the assignment and its tools/output contract. Bundled reviewer only reports patch-introduced bugs anchored to changed diff lines in its native findings/overall_correctness/explanation/confidence schema; security-reviewer only handles a compatible source-security slice in its own schema. A schema override does not override patch-only role intent. The parent inspects full outputs and receipts before normalizing native findings and scenario judgments into per-PR verdicts; patch correctness alone never establishes runtime PASS or coverage. No per-task model IDs. Optional configured model diversity is useful but same-model runs are not cross-model evidence. Native task isolation may auto-apply results. Use eval agent isolation with apply:false and merge:false for competing or unaccepted changes, or read-only proposed artifacts; never integrate every alternative. Read and apply `skill://arena` for competing designs and `skill://swarm` for coverage. Keep branch ownership, DAG eligibility and the verification ledger in parent-owned scoped local artifacts. Every commit, push, merge, external PR write, install or destructive action needs its actual authorization. Generic autonomy is not that authorization. Preserve output and patch artifacts before isolated workspace teardown. Plans do not promise an autonomous session after shutdown.

**Verification.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked (the `skill://principle-prove-it-works` principle skill). That sentence is the verification rule. Every verification block opens with it. The live block is mandatory. Ten lanes using configured general task agents or explicitly compatible specialists at the PR head drive the real surface through its control skill, per `skill://swarm`. Each lane is one box with a concrete scenario, the screenshot it saves, and its pass predicate. One lane is the **Regression lane against trunk.** It runs the same load-bearing scenario on trunk and head. If trunk does not have the feature, the lane records that fact and gates the behavior the diff adds plus the end state the user waits for instead of inventing a trunk result. The perf gate is dual-sided. Trunk and head must both produce the named metric. If trunk lacks the feature, also isolate the work the diff adds and set an absolute budget for that work plus the end-to-end state the user waits for. Do not claim a ratio between unlike scenarios. The perf block names the metric, the interleaved probe, the trunk baseline measured first, and the rule with the number that fails. A PR that changes an interaction is review-gated. The operator reviews it in chat with screenshots and a video before merge. A PR that changes no interaction writes `**Review gate.** None. <PR id> is not review-gated.` and no boxes under it.

**Control skill.** Pick it by surface. Browser, Electron, and web UIs use `skill://control-ui`. CLIs and TUIs use `skill://control-cli`. Native mobile uses whatever simulator-driving skill the repo has. A PR that touches two surfaces gets lanes on both. A surface with no control skill is a risk in Appendix C, and its live block still names how each lane drives it.

````markdown
# <Program> plan

<Under ten lines. What changes, for whom, the rule the program enforces, and the PR ids in order.>

## How to read this

One box is one unit of work. Every box names the evidence that checks it. A nested box is a sub-step of the box above it. Check a box only when its evidence exists, a file, a log line, a screenshot, a test run, or a SHA. The body is a how-to. The appendices explain and record.

The program runs `skill://sky-mode/playbooks/<execution playbook>.md`. <Who merges, and which PR ids are the operator's items that stop at merge-ready.>

Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

## Program checklist

### Arm the program

- [ ] State the protocol and this plan to the operator, then stop. Start execution only on her explicit go.
- [ ] On explicit go, initialize the parent todo and save the objective in `local://<program>/notepad.md` with this exact text. "<The plan path, the PR ids in order, the verification rule, who merges, and the done condition.>"
- [ ] Read and apply these installed skills and playbooks at program start. Re-read them at every tick. If a newer repository copy exists on trunk, inspect its known path and record the version rather than assuming the plugin lives there.
  - [ ] `skill://sky-mode/playbooks/<execution playbook>.md`
  - [ ] `skill://swarm`
  - [ ] `<exact skill://control-ui or skill://control-cli URI>`
  - [ ] `skill://sky-mode/playbooks/opening-a-pr.md`
  - [ ] `skill://<each other leaf skill the program uses>`
- [ ] Arm the 30-minute audit tick while the parent session is active. Use `hub start` with a unique name, `application: "sleep"` and `args: ["1800"]`, observe exit with `hub wait`, audit and rearm. Use real event watchers where possible. This timer does not launch agent turns after session exit. Record process names and the next check; continuing after shutdown requires an explicitly resumed user session.
- [ ] Use this tick prompt, verbatim. "Re-read the execution playbook and the saved objective. Audit the operation against both and fix drift in this tick. Probe every active lane and judge progress by side effects only. Stop a stuck lane, reconcile its artifacts and ownership, and dispatch its eligible replacement now. Then send the operator a status message, whether or not anything changed, with the queue table of PR, owner, state, and head SHA, the verdicts since the last tick, what merged, open operator gates, and blockers."
- [ ] On the operator's hold or stand-down, send every owner a zero-writes order at once.

### Spawn owners

- [ ] Assign one logical owner per PR with the lifecycle the execution playbook names. Dispatch eligible independent substantial work in bounded native task batches. The parent owns todo and shared records. Children receive exact upstream agent:// artifacts and do not recursively orchestrate or run mid-flight project-wide validation.
- [ ] Follow this dependency graph. Start dependent work only after its parent merges, or base it on the parent branch when the execution playbook stacks.
  - [ ] <PR id> and <PR id> are independent and first. Both branch from `main`.
  - [ ] <PR id> after <PR id>.
- [ ] Hold the file boundaries. <PR id or class> touches only `<glob>`.
- [ ] Hold the review gate. <PR ids> change an interaction. They wait for the operator's review in chat with screenshots and a video before merge.

### PR mechanics, for every PR

- [ ] Record authorization for commits, pushes, PR writes and merges. Operator-owned or interaction-review-gated PRs stop at merge-ready. Unapproved operations remain gates.
- [ ] Resolve the forge once. Default to `gh`; select Origin only after its installed help documents the required PR operations and it can resolve and support this repository. Use its documented interface consistently, never infer flags from its executable name. Record any fallback to `gh`. Never require `gt`.
- [ ] Open the PR ready, never draft, with `gh pr create --base <base-branch>` or the selected forge's documented installed equivalent. A stack child targets its parent branch.
- [ ] Run the repo's lint and typecheck once on the stable head before an authorized PR-facing push, not during parallel mutation. Push with hooks on.
- [ ] Read and apply `skill://deslop` before each authorized commit and `skill://no-comments` before review.
- [ ] Triage every Bugbot and security-reviewer comment per `skill://sky-mode/references/bugbot-triage.md`.
- [ ] Before babysit and again before the merge-ready report, have the single topology owner refresh the authorized branches under the selected execution/stack playbook. Rebase an independent PR or stack root onto current trunk, then restack children bottom-up onto their recorded updated parent tips, never every child onto trunk. Record old and new parent/base/head SHAs, honor rebase and published-push authorization, and refresh affected proof, current-head CI and mergeability under `skill://sky-mode/playbooks/shipping.md` before reporting.

### Verdict and merge, for every PR

- [ ] At each PR's merge-ready head SHA, run its independent swarm per `skill://swarm` with configured general task agents or explicitly compatible specialists for executable scenarios and custom proof verdicts. One gates lane. The ten live lanes from the PR's **Verify, live** block. The perf lane from its **Verify, perf** block. One audit lane that reads the diff and the receipts and distrusts the PR body.
- [ ] Clean only when every lane is `PASS`. Findings go back to the owner. Inspect full outputs and receipts, preserve any separate bounded native patch/security reviews in their own schemas, and normalize evidence into the per-PR parent ledger. Patch correctness alone is not runtime PASS or coverage. Record verifier, base SHA, head SHA, stable patch-id and receipt paths in the parent ledger. A changed patch gets a fresh swarm and verdict; unchanged patch-id retains only code proof, never stale CI or mergeability.
- [ ] <The merge or append rule from the execution playbook, with the patch-id rule from `skill://sky-mode/playbooks/shipping.md`.>

### Boot recipe, for every live lane

Each live lane runs in its own isolated workspace at the PR head, with exclusive ports, browser profile, process names and artifact directory. Drive through `control-ui` or `skill://control-cli`.

- [ ] Prepare the lane's isolated workspace at the exact fetched head SHA. Do not checkout or reset the parent's working tree.
- [ ] <Start backend and surface through hub start, with unique names and actual readiness conditions. Observe readiness and retain logs.>
- [ ] <Deliver input only through the control skill's commands. Name the read-only diagnostics.>
- [ ] Save every screenshot to `/tmp/swarm-<pr-id>/worker-<n>/<slug>.png` and return the paths with the report.

## <Task as a verb phrase> (<PR id>)

**Depends on.** <PR id, or None.>

**Files.**

- [ ] Edit `<path>`.
- [ ] Create `<path>`.
- [ ] Delete `<path>`.

**Build.**

- [ ] <One change. Name the symbol and the file.>

**You see.**

- [ ] <One observable result, with the exact log line or screen state.>

**Verify, unit.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] <Test file and the case it gains.> Run `<command>`.

**Verify, live.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked. Ten lanes using configured general task agents or explicitly compatible specialists at the PR head, per the boot recipe.

- [ ] Lane 1. Regression lane against trunk. Run <the same load-bearing scenario> at trunk and head. If trunk lacks the feature, record that and gate <the behavior the diff adds plus the end state the user waits for>. Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 2. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 3. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 4. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 5. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 6. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 7. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 8. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 9. <Scenario.> Save `<slug>.png`. Pass when <predicate>.
- [ ] Lane 10. <Scenario.> Save `<slug>.png`. Pass when <predicate>.

**Verify, perf.** Tests alone are not sufficient verification. A PR is verified only when its unit, live, and perf boxes are all checked.

- [ ] Metric. <What is measured at both trunk and head. If trunk lacks the feature, also name the diff-added work and the end-to-end state the user waits for.>
- [ ] Probe. <The command or procedure, run at trunk and at the head, interleaved. Both sides must produce the metric.>
- [ ] Baseline. Record the trunk <value> first.
- [ ] Rule. <Head against trunk, with the number that fails. If the scenarios differ, add absolute budgets for the diff-added work and the user-visible end state instead of an invalid ratio.>

**Review gate.** The operator reviews before merge.

- [ ] Copy lane <n> screenshots into `<media path>/<pr-id>-review-<slug>.png`.
- [ ] Record a 30 to 60 second video of the change in a lane workspace. Save it as `<media path>/<pr-id>-review.mp4`.
- [ ] Post the screenshots and the video in chat. Stop at merge-ready. Wait for the operator's click.

**Merge.**

- [ ] Root's clean verdict at the exact head SHA.
- [ ] Bugbot triage done.
- [ ] Rebased onto current trunk or the required parent, patch-id compared with verdict, changed patches reverified, and CI and mergeability refreshed at the current head.
- [ ] <The owner squash-merges its own PR, or the root appends it to the base-branch stack and the operator lands it bottom-up.>

## Close the program

- [ ] Every box above is checked with its evidence. Reconcile every owner, accepted patch and delivery against the DAG and current-head ledger. Leave a durable pickup note for any real blocked or paused work; never mark its boxes complete.
- [ ] Reply to the operator with the report the execution playbook names.

## Appendix A. Prototype evidence

<Each open question a prototype answered, with the branch, the SHA, and the artifact links. Each question that stays unproven.>

## Appendix B. Alternatives rejected

<Each approach weighed and why it lost.>

## Appendix C. Risks

<Each risk with the PR it lands in and what the owner watches.>

## Appendix D. Links and reading list

<Docs to read before editing. Which PRs get `skill://how` and `skill://interrogate`. The trail per `skill://show-me-your-work`.>
````

**Reply:** the plan path, the PR ids with their dependencies and the review-gated set, what the prototypes proved and what stays unproven, and the check script's output.