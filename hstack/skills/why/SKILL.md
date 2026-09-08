---
name: why
description: "Use for 'why does X work this way', 'why we picked Y', design rationale, regressions, postmortems, or data-backed thresholds. Discovers available MCPs and queries each evidence category (source control, issue tracker, long-form docs, real-time chat, infrastructure observability, error tracking, product analytics warehouse) in parallel, then returns a cited read on decisions and tradeoffs. Use how for runtime behavior."
disable-model-invocation: true
---

# Why

Investigate the motivation and intent behind code.

Companion to `skill://how`: it explains runtime mechanics; this skill explains the forces behind them. Only when the user question also requires a runtime explanation, read and apply `skill://how` to that bounded question. Reuse existing findings and track companion work in the parent: never call back into `why` for the same question, and if invoked from `how`, return the rationale findings without restarting either workflow.

## Operating Posture

Operate as a **careful, cautious, and precise investigator**. Be honest about what you know vs what you're inferring. Read `skill://why/references/epistemics.md` for the full confidence framework and phrasing guide. The synthesizer must follow it.

## Step 1. Understand the Target and the Question

Parse what the user is asking. The **target** is usually a chunk of code, a pattern, a feature, or a named design decision. The **question** is usually a design rationale, a tradeoff, a motivating edge case, an external constraint, dead code, or a broad history sweep.

If the target is vague ("why do we do it this way?" with no clear referent), make your best guess from conversation context (open files, recent edits, what was just discussed). State your interpretation briefly so the user can redirect if you're off, then proceed.

## Step 2. Establish the Code Anchor

Before spawning investigators, anchor the investigation in concrete code. You need:

- The relevant file path(s) and line range(s)
- The key symbols (function names, class names, constants)
- An initial commit list. The last few commits touching the target.
- PR numbers from merge commits (pattern `(#1234)` in the subject line)

Build this inline.

```bash
# Blame target lines for last-touch commits
git blame -L <start>,<end> <file>

# Full file history, with patches, through renames
git log --follow -p -- <file>

# Last N commits touching the file, PR numbers visible
git log --oneline -20 -- <file>

# Extract PR numbers from a commit message
git log -1 --format=%B <commit>
```

Pull PR bodies and discussion via `gh` for any substantive commits:

```bash
gh pr view <number> --json title,body,author,createdAt,mergedAt,labels,closingIssuesReferences,comments,reviews
```

Capture this as seed context (file paths, symbols, commits, PR numbers, linked ticket IDs). Pass it to the investigators.

## Step 3. Investigate Every Evidence Category

Default to full evidence coverage, not mandatory delegation. Scope inline first. Fan out only for two or more substantial independent source searches; a small or lone search stays inline.

### Discovery

Inspect the actual OMP tool inventory, mounted MCP tool map and server instructions. Read each relevant `xd://<tool>` schema before use, or use the directly exposed tool schema. Do not assume tools or authentication exist from a vendor name. Use only read-only search, fetch, list, history and query operations; never post messages, update records, mark items read, change memberships, trigger analyses that modify remote state, or run mutating SQL.

Map each available MCP to one evidence category:

1. Source control history
2. Issue / ticket tracker
3. Long-form documents
4. Real-time team chat
5. Infrastructure observability
6. Error / exception tracking
7. Product analytics warehouse

Check local git history and authenticated `gh` availability; neither a checkout nor remote PR access is guaranteed. Use available read-only `pr://`, `issue://`, known URLs or repository APIs as appropriate, and record missing history or authentication separately. For the other six, classify using the MCP name, server instructions, tool names, and resource descriptors. If an MCP could fit more than one category, choose the one matching its primary evidence. Record ambiguous cases in the coverage map.

Aim for a complete **coverage map**, not a minimal one. Document the null, don't skip the search.

When delegation is warranted, launch independent searches in one native OMP `task` batch, one source/tool per child. Keep small source searches inline without dropping their coverage.

Use `agent: scout` for read-only code research. Select only discovered agent types with the required source tools for remote evidence gathering, under explicit read-only instructions; reasoning and synthesis stay in the parent. Configured agent roles select models; the task payload has no model field. Read-only agent labels do not guarantee MCP access. Confirm the child's available tool surface; if the source tool is absent, the parent performs that search with its own available tools. If neither can access it, record an access gap, not an empty search. Do not bypass plan-mode or spawn restrictions.

Batch `context` uses **# Goal**, **# Constraints**, **# Contract**, including the original question, shared anchor, source ownership, read-only restrictions, and evidence format. Each task uses **# Target**, **# Change**, **# Acceptance**, populated from the investigator template. Children must skip builds, formatters, linters and tests; must not edit, maintain todos, spawn children or recursively invoke these workflows. The parent owns todo state and a `local://why-notepad.md` coverage/lead notepad. Findings return as `agent://<id>`; send cross-source leads and follow-up questions to the existing source owner with `hub`. While children work, the parent searches parent-only sources. With no permitted delegation, perform available searches inline and name blocked work honestly.

Each investigator gets:
1. The base prompt from `skill://why/references/investigator-prompt.md`
2. The category playbook `skill://why/references/sources/<source>.md` for the selected MCP, adapted from the examples in `skill://why/references/source-playbook.md`
3. The cross-cutting `skill://why/references/sources/incident-postmortem.md` **if the target code looks defensive** (null checks, retry logic, timeout handling, rate limiting, feature flags, egress guards, OOM handlers)
4. The code anchor from Step 2 (file paths, symbols, commit hashes, PR numbers, ticket IDs)
5. The user's original question

### Source roster. Cover every available evidence category

Assign a source owner (parent or child) for each matching tool/MCP. If multiple tools cover a category, preserve that distinction in the coverage map; do not silently discard an available source. Each child owns exactly one source.

Each entry names the category and the kind of "why" it uniquely surfaces. Use it to know what to expect back, how to name a gap when a category returns empty, and (only in the rare provably-irrelevant case) to justify a skip.

1. **Source control investigator**. Git history, `gh` for PRs, code comments, tests. Always investigate when available, inline or with a code-research scout. Best at surfacing *implementation-time rationale captured during review*.

2. **Issue / ticket tracker investigator** (e.g. Linear, Jira, GitHub Issues, Plane, Shortcut MCP). Best at surfacing *the product or business forcing function*. Strongest when the why is external to engineering.

3. **Long-form documents investigator** (e.g. Notion, Confluence, Google Docs, Coda MCP). Best at surfacing *long-form design rationale*. Where the why is written out before it becomes code.

4. **Real-time team chat investigator** (e.g. Slack, Discord, Microsoft Teams, Mattermost MCP). Best at surfacing *real-time deliberation that never reached a doc*. Especially important when the source control, ticket, and doc paper trail is thin.

5. **Infrastructure observability investigator** (e.g. Datadog, New Relic, Honeycomb, Grafana, Splunk MCP). Infra/runtime view. Best at surfacing *infrastructure and runtime reality that motivated the code*. Strongest when the target reacts to an infra signal (timeouts, retries, rate limits, circuit breakers).

6. **Error / exception tracking investigator** (e.g. Sentry, Rollbar, Bugsnag, Airbrake MCP). Best at surfacing *the specific exceptions and error trajectories that motivated defensive or corrective code*. Strongest for catch blocks, null guards, type checks, retries, and other defenses.

7. **Product analytics warehouse investigator** (e.g. Databricks, Snowflake, BigQuery, ClickHouse, dbt, Redshift MCP). Product/data view. Best at surfacing *product and data reality that shaped the code*. Strongest for flag-gated code, experiment-driven ships, data migrations, and "where did this number come from" questions.

### When to skip an investigator

Only skip with an **explicit, written justification** that goes in the final "Sources Consulted" section. Valid reasons:

- **Access or execution is blocked** by authentication, permissions, retention, tool availability or active plan-mode restrictions. State what was attempted and what remained unsearched. A child lacking a tool is not a gap if the parent can search it.
- **No MCP is available for that category** in this environment. Flag this as a gap, not a choice. Example: "Real-time team chat skipped. No matching MCP available, so the conversational record was not searchable."
- **The source is provably irrelevant**, not just "probably irrelevant." A high bar. Example: "Error / exception tracking skipped. Target is a build-time script with no runtime code path."

An inline answer still accounts for all seven categories. For a trivial single-commit target whose PR already contains the complete answer, explain explicitly why further available category searches would be redundant; do not manufacture seven empty results.

## Step 4. Synthesize Inline

The parent reads and applies `skill://why/references/synthesizer-prompt.md` and `skill://why/references/epistemics.md`. Gather all child and parent findings, null results, skipped categories with justification, code anchors, and the original question. Reconcile overlap, surface contradictions, route promising additional leads to the existing source owner using `hub` or investigate them inline, and spot-check citations with available read-only tools. Do not spawn a lone synthesizer. Unverifiable citations remain explicitly unverified; missing evidence never becomes a confident conclusion.

## Step 5. Present

Present the parent synthesis with conversation context and calibrated confidence language; do not strengthen uncertainty during final editing.

## Output Format

The output structure is the one in `skill://why/references/synthesizer-prompt.md`: The Question, The Code in Question, What We Found, What We Can Reasonably Infer, Competing Hypotheses, What We Don't Know, Sources Consulted, Confidence Summary. Adapt as needed, but keep the confidence separation intact, and keep Sources Consulted as one line per investigator, including the ones that returned nothing or were skipped, with the reason.

After the Sources Consulted block, if the user's `why` question is a precursor to actually changing this code, convert the lineage findings into a Preserve / Change / Avoid / Risk constraint set suitable for planning the change.

## Common Failure Modes to Avoid

- **Recency bias**. Assuming the most recent commit is authoritative. The current shape is often the accretion of many earlier decisions. Trace back.

## Reference Files

- `skill://why/references/epistemics.md`. Confidence tiers and phrasing guide. The synthesizer must follow it.
- `skill://why/references/investigator-prompt.md`. Base prompt template for investigator subagents.
- `skill://why/references/source-playbook.md`. Index pointing at the category playbooks below.
- `skill://why/references/sources/*.md`. One self-contained example playbook per category, plus cross-cutting `incident-postmortem.md`. Give an investigator the single file that matches its category and adapt it to the available MCP.
- `skill://why/references/synthesizer-prompt.md`. Parent synthesis template, including the output format.
