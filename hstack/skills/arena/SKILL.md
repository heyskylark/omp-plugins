---
name: arena
description: "Spawn independent candidates at the same task, pick a base, graft the strongest parts of the others, and verify. Use for arena, competing designs, or a non-trivial artifact where one attempt could lock in the wrong shape."
disable-model-invocation: true
---

# Arena

Fan out N independent attempts at the same task. Read every candidate end to end. Pick the strongest base, graft the best ideas from the others, and verify the synthesized result. The caller owns orchestration and synthesis; candidate and judge children never invoke arena, architect, or another orchestrator recursively.

## Start

The parent tracks Frame, Fan out, Cross-judge, Pick, Graft, and Verify in its own todo mechanism when available and a `local://` notepad. Children do not create todos or modify that notepad. Scope inline first; fan out only for genuinely substantial independent candidate work, not trivial variations. Respect the live tool schema, permitted agents, concurrency, recursion, and plan-mode limits. If those prevent independent candidates or review, disclose the limit; do not pretend a phase ran.

## Phase A: Frame

The common runner prompt is the contract.

1. State the artifact each candidate must produce, the user goal, constraints, invariants, and non-goals. Put the shared grounding in a parent-owned `local://` artifact. Ground facts inline first; substantial independent codebase research uses `scout`, not a reasoning/design assignment disguised as research.
2. Derive 3–6 concrete, gradeable criteria from success for this task. Keep this picker rubric separate from candidate prompts; candidates receive the task and its acceptance conditions, not the scoring sheet.
3. Select N available, appropriate agents from the live agent inventory. Models are selected by existing agent definitions and configured role mappings, never a per-task model field. Prefer genuinely different configured model families for judgment-sensitive alternatives. Repeated runs of one model are useful for generation-bound work, but are not equivalent to model diversity. Record known resolved models and fallbacks; if identity is unavailable, say diversity is unverified. Do not create new agents or require new role names to run this skill. Unavailable configurations are dropouts or explicitly disclosed replacements using available agents, not a reason to silently claim the requested model ran.
4. Read and apply `skill://principle-separate-before-serializing-shared-state`. Give each candidate exclusive ownership of a separate artifact destination. No candidate writes the final destination, another candidate's files, shared grounding, or the parent's synthesis note.

### Caller package, including architect designs

Accept a caller package containing the runner prompt URI, shared grounding URI(s), candidate count and labels, required distinct assignments/directions, artifact/output contract, constraints, and caller-owned synthesis destination. Read the runner prompt and grounding before dispatch. Preserve every required direction as a distinct candidate assignment; do not replace different design directions with identical prompts. Each candidate receives the same common contract plus its own direction and exclusive destination. An architect design package produces design artifacts, not competing repository edits. Return the candidates, judge verdict, scores, and synthesis record to the architect caller; the caller remains the owner of the final design and downstream work.

### Competing executable alternatives

Never launch competing implementations using ordinary `task` isolation with implicit auto-apply: successful isolated tasks can apply every candidate into the parent checkout. Read `omp://tools/eval.md` before using the available eval `agent()` controls. When supported outside plan mode, launch each candidate with explicit `isolated: true, apply: false, merge: false`. For example, in JavaScript, `await agent(prompt, { agent: selectedAgent, label: candidateLabel, isolated: true, apply: false, merge: false })`, using real selected agent names and complete prompts. Start all independent handles before awaiting any; do not reset the kernel while they run. Each child must return the full patch/artifact, changed-file manifest, rationale, and baseline information in durable output before its isolated workspace is cleaned up. Use the returned actual patch/output metadata; never invent a worktree path or assume it survives completion.

If those controls are unavailable, use non-executing candidate patches or full proposed file contents in separately owned scratch artifacts/`agent://` outputs, without editing the checkout. If a safe executable environment is required but unavailable, report that prerequisite rather than running competing edits against shared state. In plan mode, omit isolation/apply/merge and respect read-only tools: candidates return design/proposed changes as output only. Only the caller may apply the selected, synthesized result, when edits are authorized. Do not apply all candidate patches and then attempt to undo the losers.

## Phase B: Fan out

Launch all independent candidates in one `task` batch for artifact-only work, or one eval launch wave using the safe controls above for executable alternatives. Native task `context` uses `# Goal`, `# Constraints`, and `# Contract`; each `task` uses `# Target`, `# Change`, and `# Acceptance`. For eval prompts include the same shared context and assignment headings. Supply the runner prompt URI, grounding URI(s), own assignment, output destination/contract, and a requirement to produce both the complete artifact and a short rationale naming alternatives considered and rejected.

Tell every child to skip formatters, linters, builds, and tests while candidates are in flight; the parent verifies the selected synthesis later. Children neither read competitors' outputs nor coordinate toward convergence. They return through `agent://` output, with actual artifact/patch locations when applicable. Retrieve full outputs, not just preview summaries. Use `hub` for follow-up with revivable children; isolated children are not revivable, so use their durable output/history and do not depend on a later conversation with them.

If a candidate fails or produces no usable artifact, proceed with N−1 and record the dropout. With one survivor, disclose that there was no comparative competition. With none, stop selection and report/recover the failed prerequisite; never fabricate a base.

## Phase C: Cross-judge

Wait until every candidate has completed, failed, or been cancelled, and freeze the usable artifacts before judging. Only then launch an independent configured general task agent, or a discovered judge whose role, tools, and output contract explicitly support the full comparison, preferably a configured model family different from the parent's. Give it the rubric and candidates by neutral path/label, not the parent's preference. Require read-only work, criterion-by-criterion scores, evidence, a recommended base, and rationale. No edits or recursive orchestration. Bundled `reviewer` is patch-bug-only and cannot supply design judgments, criterion scores, or base selection; changing its output schema does not make it a compatible judge.

The judge runs in parallel with the parent's reading and independent scoring in Phase D, never with candidates still writing. Select an existing appropriate agent through its configured roles, not a hardcoded model or new required role. If only the same model is available, disclose reduced independence. If no judge can run, record the missing cross-judge and make a clearly labeled parent-only judgment; do not claim cross-judge agreement.

## Phase D: Pick a base

Read every usable candidate end to end and score each rubric criterion independently before incorporating the cross-judge verdict. Compare your scores and reasoning with the judge. Agreement supports the pick; disagreement requires reading both rationales and checking whether bias or an ambiguous rubric explains it. Decide on evidence, not a vote.

Read and apply `skill://principle-laziness-protocol`. Pick the candidate a future maintainer can extend most easily without breaking invariants. Prefer the cleaner boundary or smaller API in a tie. Record the pick, criterion scores, reasons, cross-judge verdict, disagreement resolution, and model-diversity limitations in the parent-owned synthesis note.

## Phase E: Graft

Walk each losing candidate once more. Usually one or two ideas per candidate are worth porting, not most of the artifact. Read and apply `skill://principle-redesign-from-first-principles`: fold grafts in by hand rather than mechanically pasting them. Keep one coherent mental model. Record each graft and its source, and rejections with reasons.

When candidates converge on the same shape, record the strong agreement and ship that shape; no graft is necessary. Wild divergence means the frame was under-specified: reframe and rerun instead of averaging incompatible designs. For implementation candidates, integrate only the chosen base and consciously selected grafts into the authorized destination, preserving unrelated user work. For caller-owned design synthesis, return the evidence and selected/grafted design to that caller without taking over its other phases.

## Phase F: Verify

Read and apply `skill://principle-prove-it-works`. Verify the synthesized artifact against the original goal, invariants, and rubric, not merely against candidate self-reports. Run the actual relevant behavior for executable output; for a design, inspect concrete interfaces, dependency direction, failure paths, migration coverage, and feasibility against grounded code. The parent owns final runtime checks and any necessary project-wide validation after all candidate writes have stopped. Respect authorization and plan-mode restrictions and label checks not run.

A newly found problem means either the frame was wrong (return to A) or a candidate's useful idea was missed (return to E). Do not paper over it. If the caller retains verification ownership, hand back the explicit verification obligations and evidence; do not claim its unrun checks passed.

## Outputs

One synthesized artifact and one short parent-owned synthesis note (use `local://` unless a repository document was requested), naming the base, criterion scores, cross-judge verdict, grafts with sources, rejections, convergence/divergence, dropouts, model identities or uncertainty, and actual verification results. Preserve candidate output URIs for the caller's inspection. A failed or limited phase is visible in the record, not reported as completed.
