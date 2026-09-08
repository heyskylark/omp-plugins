---
name: interrogate
description: "Use for interrogate, adversarial review, multi-model review, challenge this, stress test this code, find blind spots, or tear this apart. Independent reviewers challenge changes and the lead synthesizes an evidence-based verdict."
disable-model-invocation: true
---

# Interrogate

Independent reviewers adversarially review the same change with the same prompt and rubric. The intended adversarial signal comes from genuine model diversity, not assigned personas. The parent is the lead reviewer and delivers a synthesized verdict. **Do not auto-apply changes.** The code-quality lens requests ambitious recommendations, not permission to edit, refactor, or run mutating commands.

## Step 1: Determine scope

Scope inline before delegating. Identify what to review from context:

- If the user points at specific files or a diff, use that scope.
- On a feature branch, inspect its full changeset against the actual appropriate base, for example `git diff main...HEAD` only when `main` is that base. Include relevant working-tree changes when those are the requested subject; do not silently omit recent uncommitted work.
- If the user references recent work, gather the relevant files and surrounding callers, callees, types, and constraints.

Package the diff or file contents and surrounding context in parent-owned `local://` artifacts. Capture the scope/baseline so every reviewer sees the same change. Avoid passing huge blobs inline. Read-only codebase discovery that genuinely needs substantial independent research uses `scout`; do not assign the reasoning or adversarial judgment itself to a scout.

## Step 2: State the intent

Derive intent from the user's message, commit messages, PR description when available, and the code. State one clear paragraph before review. If materially ambiguous intent remains after examining available context, ask the user rather than guessing what outcome the code is meant to achieve. Reviewers challenge execution of that intent, not the user's goal.

## Step 3: Spawn independent reviewers

Choose available review-capable agents from the live inventory and existing configured role/model mappings. Use one independent reviewer per distinct configured model when available; extend or shrink labels A/B/C/D to the actual roster. OMP task dispatch selects `agent`, not a model field. Do not hardcode model IDs, require newly invented role names, change runtime settings, or open configuration PRs as part of this review.

Prefer true model diversity where configured. Multiple differently labeled agents may resolve to the same model; labels, personas, or repeated runs do not establish diversity. Record actual resolved identities and fallbacks when exposed. If only same-model reviewers are available, explicitly label this a same-model independent review with reduced diversity. If identities are unavailable, say model diversity is unverified. If an agent is unavailable, select a suitable available replacement only with disclosure, or record a dropout; never claim the rejected selection ran.

Read all four assets before preparing review or synthesis:

- `skill://interrogate/references/reviewer-prompt.md`
- `skill://interrogate/references/rubric.md`
- `skill://interrogate/references/code-quality-review.md`
- `skill://interrogate/references/lead-judgment.md`

Fill the reviewer template with the stated intent, diff/files, complete rubric, and complete code-quality lens. Every reviewer receives the same filled template and shared grounding, with no assigned personas and no other reviewer's findings. Supply full assets, not abbreviated substitutes; shared `local://` prompt/artifact URIs are suitable when the complete material is large.

Launch the reviewers together in one native `task` batch for genuinely substantial independent review. Shared `context` has `# Goal`, `# Constraints`, and `# Contract`; each `task` has `# Target`, `# Change`, and `# Acceptance`. The contract requires read-only review, evidence-based findings from the full template, no child todos, no edits, no formatters/linters/builds/tests, and no recursive interrogate/arena/architect or other orchestrator calls. The parent owns its todo and `local://` notepad. Reviewer output comes through `agent://<id>`, not a shared mutable report. A valid outcome is an explicit empty findings list.

Respect the actual available tool schema, spawn policy, plan mode, concurrency, and depth limits. Do not spawn trivial duplicate reviews simply to fill a roster. If parallel review is unavailable, disclose the restriction and perform an explicitly limited lead-only review, or report the missing prerequisite when the requested independent review cannot be satisfied. Do not pretend blocked reviewers completed.

## Step 4: Synthesize evidence

Read every full reviewer output through its actual `agent://` URI; do not judge from truncated previews. Distinguish failed, incomplete, and empty reviews. Use `hub` to clarify a specific finding with an existing revivable reviewer rather than spawning a duplicate. Do not treat a failed reviewer as finding no problems.

1. Parse every finding with its location, severity, evidence, and suggestion.
2. Identify independent consensus. Findings raised by two or more distinct models are a high-signal prompt for scrutiny, not proof. Same-model repetition is not cross-model consensus.
3. Inspect lone-model findings too, especially concrete security or correctness paths; a minority can be right.
4. Deduplicate differently worded reports of the same issue and retain reviewer/model attribution.
5. Record explicit disagreements. A reviewer not mentioning an issue is not the same as explicitly rejecting it.
6. Trace decisive claims against the actual code, callers, types, and user constraints. Separate observable evidence from speculation. Agreement cannot rescue an unreachable failure path; a concrete failure does not need a majority vote.

## Step 5: Lead judgment

Read and apply `skill://interrogate/references/lead-judgment.md`. You are a pragmatic senior engineer, not a neutral aggregator. Use conversation context, previous rejected approaches, dependency/migration constraints, and the actual goals. Be demanding about structural quality without treating every preferred refactor as a blocker.

Categorize every deduplicated finding:

- **Act on**: Real correctness, security, or maintainability issues given the actual goals; these would block a real PR.
- **Consider**: Legitimate points whose benefit may not yet outweigh their cost.
- **Noted**: Technically valid but not actionable now, context-dependent, premature, or low-impact.
- **Dismissed**: Wrong, nitpicky, unreachable, or missing context; explain why.

For each, identify the reviewer(s) and known model(s), category, and a one-line evidence-based rationale. Preserve dissent rather than hiding it. The upstream warning that more than five Act On findings may reflect poor filtering is a calibration cue, not a cap: do not suppress demonstrated serious issues to fit a number. Do not dismiss a real bug merely because only one model caught it. Suggestions remain recommendations; any implementation requires a separate authorized task.

## Output format

### Intent

> The intent paragraph from Step 2.

### Reviewers

One bullet per attempted reviewer: label, selected agent, known resolved model (or unknown), finding count, and completed/incomplete/failed status. Include actual scope, any substitutions/dropouts, same-model or unverified diversity, and other review limitations. A lead-only review is labeled as such, not multi-model review.

### Act On

For each finding: concrete description and location, evidence/impact, who raised it, and why it blocks.

### Consider

For each finding: description, attribution, rationale, and the tradeoff.

### Noted

Valid but low-priority findings with attribution and brief rationale.

### Dismissed

Rejected findings with attribution and brief evidence-based explanation.

### Agreement Map

Where reviewers agreed or explicitly diverged; distinguish cross-model consensus from same-model repetition. Explain what that pattern supports and what still depends on the lead's code-based judgment. State unverified claims and missing coverage. A review verdict is not a claim that unrun runtime checks passed. No automatic edits accompany the verdict.
