---
name: maintain-verification-skill
description: Audit and repair a project-local OMP verification skill by reconciling every mapped feature with source and driving every reachable feature live. Use for /skill:maintain-verification-skill or when verification instructions, selectors, tooling, or feature maps may have drifted.
disable-model-invocation: true
---

# Maintain an OMP verification skill

Keep a project verification skill executable and honest. The unit of coverage is a mapped user feature, not every sentence.

## Outcomes

Choose exactly one:

- **clean:** every mapped feature received source and live coverage; no skill changes were needed.
- **changed:** proven corrections were made within the verification skill directory.
- **blocked:** coverage or a safe correction could not finish; name the exact prerequisite and attempted route.

Do not create a branch, commit, or pull request unless the user explicitly requests it or repository policy authorizes that Git operation.

## Mutation fence

Only edit the selected `.omp/skills/verify-*/` directory and helpers it owns. Never edit product code during maintenance. Behavior that no longer matches the map is either documentation/harness drift, which belongs inside the fence, or a product regression, which must be reported without being hidden by changed expectations.

## Pass

### 0. Locate the target

Find project-native candidates at `.omp/skills/verify-*/SKILL.md`. OMP project skills have higher precedence than plugin and user skills with the same name. Several candidates require the caller to choose; none means stop, read `skill://create-verification-skill`, and follow that skill instead of inventing one.

### 1. Check discovery and index hygiene

Require explicit `name` and `description` frontmatter and the one-level `.omp/skills/<name>/SKILL.md` layout. Read the feature-map index and glob sibling files. Fix missing, extra, duplicate, renamed, or dead entries. Resolve skill-owned references through `skill://<name>/...` where practical.

### 2. Run one source wave

Launch one read-only `scout` per feature file concurrently in a single OMP `task` batch, up to OMP's concurrent cap. If more than 32 feature files exist, process bounded waves without overlapping ownership.

The batch `context` must define:

- `# Goal`: reconcile each user feature with current product source.
- `# Constraints`: read-only; no edits, app driving, builds, formatters, linters, or tests.
- `# Contract`: every report has a feature summary, exact source entry points, likely drift or `none`, and one concise live recipe.

Every child task must contain exact `# Target`, `# Change`, and `# Acceptance` sections and use `agent: scout`. Children never drive the app, edit files, or spawn agents. Continue independent coordinator work while they run; use `hub` messaging for clarification and wait only when no other action remains.

### 3. Reconcile source evidence

Account for every feature report. Merge compatible recipes into as few deterministic application states as practical. Re-read source before accepting reported drift. Sweep recent user-facing churn for missing features and require a concrete source path before adding one.

### 4. Drive every feature live

The coordinator owns all live driving. Follow the target skill's launch model:

- long-lived servers, emulators, simulators, watchers, and interactive programs use OMP `hub` with stable names, declared readiness, cursor-based logs, and `stop` teardown;
- short-lived commands use `bash`;
- specialized drivers such as OMP `browser` or a project MCP server take precedence over ad-hoc shell automation.

Exercise every reachable feature at least once. Preserve these invariants:

1. Doctor before the first drive, on every fresh isolated session, and after surprising behavior. If a healthy process hides wedged UI state, reset or relaunch instead of guessing.
2. Inspect evidence at its named location as it is produced. Evidence survives every cleanup.
3. Nothing started by a drive outlives its usefulness. Clean failed-iteration residue without deleting evidence.

A doctor failure caused by skill drift is drift: repair it, restart what the repair invalidates, and retry once. A route is `verified-unreachable` only when the report names its concrete prerequisite, the exact route attempted, and evidence of the block.

### 5. Triage

- Wrong or missing user-POV instructions: fix documentation.
- Working behavior the harness cannot drive: fix the skill-owned harness and re-drive it.
- Actual product failure: report it; do not weaken assertions or rewrite the map to pass.
- Unstable visual comparison: pin device/OS/state and fix the evidence recipe before changing thresholds.
- Performance regression: retain the trace and baseline; do not accept debug/emulator timing as release-device proof.

Any helper added or changed must remain executable and have a literal invocation in the skill body.

### 6. Teardown and classify

After the final drive and any re-proof, stop each named `hub` process started by the run. Confirm scratch state is gone and evidence remains. Re-read every changed skill file, then classify the outcome.

For **changed**, report modified paths and the live scenario proving each correction. For **clean**, report feature/source/live coverage. For **blocked**, report completed coverage, retained evidence, the exact blocker, and what was attempted. Keep run notes in ignored scratch storage; do not commit them.
