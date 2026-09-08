---
name: verify-this
description: "Verify a falsifiable claim with fresh local baseline and treatment evidence, compare measurements and confounds, and return VERIFIED, NOT VERIFIED, or INCONCLUSIVE."
disable-model-invocation: true
---

# Verify This

Verification is not a recap. Prove or disprove a specific claim with repeatable evidence, not implementation confidence or an agent's success summary.

## When to use

- The user asks “verify this”, “prove it works”, “did this fix it”, or “show me the evidence”.
- A bug fix needs a before/after reproduction.
- A UI, CLI, API, performance, or memory claim needs measurement.
- A test passes but user-visible behavior still needs confirmation.

Do not pretend vague claims such as “the code is cleaner” are measurable. Derive a concrete claim from the request and available context; if the intended criterion remains ambiguous, ask for it before measuring.

## Workflow

1. **State the claim falsifiably.** Specify the condition, observable metric, and threshold. Write down what outcome would disprove it before collecting treatment evidence.
2. **Choose the smallest local surface that can disprove it.** Inspect the relevant entry point and existing measurement recipes first. Avoid project-wide gates when a focused reproduction answers the question. Respect explicit pauses or prohibitions on validation: do not run paused checks, launch an alternate measurement to evade them, or delegate them. Return `INCONCLUSIVE`, explicitly saying the claim remains unverified because measurement was not authorized.
3. **Capture a baseline from the old state.** Use the merge base, parent commit, failing branch, or current broken reproduction. Record exactly which revision and local changes the baseline represents. Preserve the user's work; do not reset, stash, switch, or overwrite their working tree to obtain a baseline. Use a separately scoped baseline workspace when authorized, or existing evidence whose provenance and comparability can be established. Accept a user-reported failure as ground truth rather than rerunning it merely to confirm the report; distinguish that observation from a measured baseline. If the claim needs a quantitative baseline the report does not supply, say so rather than inventing one.
4. **Capture treatment from the changed state.** Use the same command or interaction, inputs, data, warmup, measurement method, and environment. Record the actual changed state, not merely its branch label. Keep unrelated changes out of the comparison.
5. **Compare raw artifacts.** Compare numbers, screenshots, terminal transcripts, HTTP responses, profiles, heap snapshots, or focused test output. Report baseline, treatment, delta, and claimed threshold. Identify confounds: environment or dependency changes, caches and warmup, input drift, differing revisions beyond the treatment, background load, noisy samples, or instrumentation that changes behavior. Repeat only where authorized and necessary to resolve noise; do not keep trying until one sample passes.
6. **Return exactly one verdict:** `VERIFIED`, `NOT VERIFIED`, or `INCONCLUSIVE`, using the rules below. Limit the conclusion to the conditions actually exercised.

## Local surfaces

| Claim | Measurement |
| --- | --- |
| Code behavior | Existing focused unit/integration test or a minimal reproduction script. |
| CLI/TUI behavior | Read and apply `skill://control-cli`; capture the actual terminal interaction, transcript, or demo recording. |
| UI behavior | Read and apply `skill://control-ui`; collect screenshots, accessibility snapshots, or browser traces of the actual surface. |
| API behavior | Local HTTP/RPC requests with matching inputs and a response diff. |
| Performance | Same-machine baseline/treatment timings or CPU profiles with matching warmup and sampling. |
| Memory | Heap snapshots before and after the suspected operation, under comparable lifecycle and collection conditions. |

Controllers execute bounded measurement recipes and return observations and artifact references to this workflow. They do not invoke `verify-this` again, launch a replacement verifier, or continue an orchestration loop. If a controller originally called this skill, use its supplied measurements or request a bounded missing measurement from that existing caller; do not re-enter its outer workflow. A successful controller/tool exit is not proof of the claim.

## OMP execution and ownership

Work inline by default. If there are multiple substantial, genuinely independent measurements, the parent may dispatch one native `task` batch with a shared claim, baseline/treatment recipe, authorization limits, disjoint artifact paths, and ownership contract. Use the configured general task agent for executing measurements and reviewing experimental design, or a discovered configured specialist whose role scope, tools, and output contract explicitly support the assignment. Use `scout` only for read-only code/search investigation. Bundled `reviewer` is patch-bug-only, not an experimental-design judge or executable verifier; a prompt or schema override cannot change that scope. Do not select worker models directly. Respect the available spawn policy and limits; never claim parallel or independent-model evidence that was not obtained.

The parent owns the experiment record and any todo; children receive complete instructions because they do not inherit conversation history. Children return raw observations, commands, environment differences, errors, and artifact references through their `agent://` results. Read those results before concluding. Use only known `hub` peer IDs for follow-up and known task sessions through `history://`; completion status is not evidence of correctness.

Use native `hub` for long-running services and interactive terminal processes: inspect existing process state, start an experiment-owned named process with `application`, `args`, `cwd`, and an appropriate readiness condition, observe readiness, then use `logs` and `send` to measure it. A readiness timeout is not success and can leave a process running. Record who owns each process and whether it was started or borrowed. Stop only processes owned by this experiment, unless their owner or user authorizes otherwise. Do not enable persistence or detached lifetime merely for convenience. Preserve user-owned browser sessions and external state; controller skills govern their native surface interactions. User authorization is still required for sensitive external actions, installation, destructive changes, and publishing.

## Artifact layout

When disk storage is safe, keep the experiment in a claim-scoped native local artifact directory:

```text
local://verify-this/<claim-slug>/
├── claim.md
├── timeline.md
├── baseline/
├── treatment/
├── diff/
└── verdict.md
```

`claim.md` records the condition, metric, threshold, disproof criterion, and recipe. `timeline.md` records source states, environment, commands/interactions, warmup, timestamps, and process ownership. Keep raw captures in `baseline/` and `treatment/`, comparisons in `diff/`, and the final verdict with evidence references in `verdict.md`. Parent and children share the native local artifact root, so assign disjoint child paths and have the parent integrate their results. These records are task artifacts, not repository documentation. Use the artifact's resolved filesystem path only when an external program requires a real path; do not pass an internal URI to a program that cannot resolve it.

If captures may contain sensitive code, prompts, screenshots, HTTP bodies, or heap data, keep only minimal redacted inline evidence unless the user agrees to disk storage. Native tool/session outputs may themselves be recorded: avoid collecting sensitive raw payloads without authorization, not just writing a second copy. Do not fabricate an artifact link when no artifact was captured. Remove only experiment-owned throwaway scripts or resources when no longer needed; preserve the agreed evidence for inspection.

## Verdict rules

- `VERIFIED`: baseline and treatment differ in the predicted direction, by the claimed threshold, with no obvious confound.
- `NOT VERIFIED`: a valid comparison shows unchanged behavior, the wrong direction, or a missed threshold.
- `INCONCLUSIVE`: no valid baseline, noisy signal, failed measurement, missing capability or authorization, or an environment difference invalidates the comparison. Paused validation means unverified, not a passing result and not a measured failure.

Do not soften a negative result. A clear `NOT VERIFIED` is useful. Do not turn missing evidence into proof against the claim.

## Output

Choose one verdict for the first line; do not output the alternatives as the verdict.

```text
<VERIFIED or NOT VERIFIED or INCONCLUSIVE>
Claim: <falsifiable claim>

Evidence:
<metric/artifact>: baseline=<observed value>, treatment=<observed value>, delta=<computed difference>, threshold=<claimed threshold>

Reasoning:
<one tight paragraph naming the evidence and any confounds>
```

Use “not measured” for missing values, explain the specific limitation, and name any paused or unexecuted checks. Report what was actually observed rather than substituting source inspection, passing unrelated checks, or a proposed experiment for executed proof.
