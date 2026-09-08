---
name: recall
description: "Reconstruct recent working context from available OMP memory, scoped session records, live repository state, and shared reports, fixes, and incidents. Use for 'recall my work on X', 'catch me up', 'what have I been working on', or 'where did I leave off' before starting or resuming work."
disable-model-invocation: true
---

# Recall

Before starting or resuming work, rebuild the user's working context and return a tight capsule of where things stand and what to do next. Read only what the in-scope threads need, then stop. This is evidence gathering, not permission to resume implementation or change session state.

Two records matter. Personal working history holds goals, decisions, corrections, and unfinished work. The shared record holds the surrounding history: recurring user symptoms, prior fixes, reversions, and errors still occurring. A feature with a long bug tail cannot be reconstructed from personal history alone.

## 1. Classify and route

- One specific prior conversation to resume: read and apply `skill://sky-mode/playbooks/session-pickup.md` instead.
- Turning repeated habits into a durable skill: read and apply `skill://automate-me` instead.
- A human-readable activity summary is a different task. Follow that requested format rather than treating the user as asking to load context before action.
- If the user supplied a full state capsule with paths, branch, and changes, use it and skip personal-history mining. Still check relevant live state and, for a named target, the shared record. Do not re-run a failure just to confirm a user-reported observation.

The skill named recall and the native tool named `recall` are different. Do not recursively read or invoke this skill to search memory.

## 2. Lock the scope and available sources

State the time window, topic, and workspace briefly before searching. Default “recent” to the last seven days and the workspace to the active project. Resolve relative dates against the current date and state the resulting range. Never read another project's conversation records without the user asking. Never quietly turn “all” into “recent N”; if the requested range exceeds available records or execution limits, report partial coverage and what remains unsearched.

Use the current conversation, its supplied Memory Guidance, known task outputs, and user-supplied record references to establish scope inline. Inspect actual tool availability rather than assuming a memory backend or MCP exists.

### Native memory search

When the native `recall` tool is available, call it with a natural-language `query` containing the workspace/project, topic, time window, and the decisions or unfinished work being sought. Its input is query-only, for example:

```json
{"query":"In the active project, during the last seven days, what did we decide about the named subsystem, what failed or was corrected, and what work remains open?"}
```

Replace the example's scope and topic with concrete names and dates. Query wording is not a hard date or project filter. The backend controls bank scope and may include global memories; filter returned evidence against the agreed scope and do not follow another project's leads. Search a second, materially different query when a narrow or empty result leaves an important uncertainty; do not treat retrieval as exhaustive history.

If the tool is exposed as a device, read `xd://recall` for its current schema and dispatch JSON to that device with `write`. A write to this read-approved tool device invokes search; it does not retain a memory. Do not invent a device when it is absent from the available inventory.

- Structured recall is available for the configured Hindsight or Mnemopi backend, not for `off` or `local`. Restrictions can also hide the tool. Report unavailable or failed retrieval separately from “no relevant memories found.” Do not enable, switch, rebuild, or configure a backend as part of recall.
- Mnemopi results can be clipped previews. Read a relevant returned ID with `read memory://<memory-id>` when the full content matters. This form requires Mnemopi and resolves only in the calling session's scoped banks. Hindsight results are not addressable by this URI; do not fabricate IDs or equivalent full-record access.
- Where available, use `read memory://root` for the compact project summary, `memory://root/MEMORY.md` for the full document, and `memory://root/learned.md` for captured lessons. A relevant generated playbook can be read through `memory://root/skills/<name>/SKILL.md` when its name is known or found with a scoped `glob` under that memory root.
- Memory is heuristic context, not authoritative repository state. Preserve its source, timestamp, and uncertainty. A backend confidence score is not proof that a change shipped. Follow a memory's cited source when accessible before relying on a decisive claim.

### Scoped session evidence and fallback

Use `agent://<known-id>` for a task's saved findings and `history://<known-id>` for its transcript, with bounded `read` selectors. Use only IDs supplied by the current task/session, user, or an authorized discovery result. These are known agent sessions, not a general search interface for all the user's historical chats. Do not enumerate unrelated peers or inspect their records to find something to recall.

For ordinary past conversations not reachable through those resources, use a user-provided transcript/export or an explicitly authorized project-specific record set. Do not sweep private OMP directories, prompt-history databases, or all-project session stores automatically. Do not guess a transcript path from a project slug or a session ID. If a crucial record is unavailable after checking accessible sources, say precisely what is missing and request that specific session or export, while returning the reachable findings.

For `off`, `local`, a hidden recall tool, or retrieval failure, continue with available project memory artifacts, supplied transcripts, known task outputs, current conversation, shared records, and live state. Label this a scoped reconstruction, not a complete search of prior chats. Missing files and permission or retention limits are coverage gaps, not evidence that no work happened.

Session records are trees. When reading an explicitly supplied raw session, preserve branch/leaf lineage and distinguish abandoned branches, compaction summaries, and reset boundaries from the active conversation. A full transcript may include material no longer in model context. Prompt history alone is not a conversation transcript. Truncated or missing content cannot establish what an agent actually did.

Do not use resume, fork, fresh, clear, or share to obtain evidence: those operations switch/reset state or publish data. If the user chooses to supply an export or dump, explain that it may include prompts, tool results, private context, and secrets; a dump may also leave a temporary JSON sidecar. Reading an available record does not require publishing it.

## 3. Mine the in-scope working history

Order candidate conversation files by real modification timestamps when files are available, never by UUID or filename order. Use `glob` for the authorized inventory and filesystem metadata for ordering; a record's modification time identifies candidates, while message timestamps establish whether events belong to the requested window. Search the topic with `grep` first, then `read` only matching chats and relevant regions. Exclude the current chat and obvious test/evaluation noise. Do not count child transcripts as separate user work threads; use a known child record when evidence about its actual actions is needed.

For one or two records, work inline. After scoping, if two or more substantial independent corpus/source searches remain, fan them out in one native `task` batch. Use `scout` for read-only search where its available tools cover the sources; the parent handles tools unavailable to a child. Keep synthesis in the parent. Do not require a new agent role or specify a model in the task payload.

The parent owns the coverage notes and, when useful, a scoped `local://recall-notepad.md`; children receive source pointers and do not inherit conversation history. Batch context must use **# Goal**, **# Constraints**, **# Contract** and state the scope, disjoint source ownership, read-only rules, and result schema. Each assignment uses **# Target**, **# Change**, **# Acceptance**. Children must not edit, maintain todos, spawn children, recursively invoke workflows, or run builds, tests, linters, or formatters. Honor tool, plan-mode, concurrency, and spawn limits; search inline where permitted and disclose actual coverage limits.

Each investigator returns one block per relevant conversation, with:

- Source session ID and exact accessible record URI/path, relevant timestamps, and topic.
- The user's goal.
- Decisions and their supporting quotations or record locations.
- Open threads.
- Struggles, failed attempts, and corrections.
- Artifacts: PRs, tickets, branches, commits, and relevant paths.
- Confidence, contradictions, and missing or truncated evidence.

Keep raw transcripts out of the parent response; return findings through `agent://<id>` with enough citations to recover decisive passages. Follow up with an existing source owner through its returned `hub` ID rather than spawning a replacement.

## 4. Sweep the shared record

Whenever the topic names a feature, file, subsystem, area, or bug, this sweep is the default. “My work on X” does not exempt it. Skip only for pure activity recall without a named target, such as “what did I do this week,” where personal history and live state answer the question.

Read and apply `skill://why` for its source investigation workflow, adapting the question to: **What is the current state, what has been tried and failed to hold, and what are users still reporting?** This is supporting investigation within recall, not a second top-level orchestrator. Retain recall's final brief format, and do not recurse between workflows.

Reuse `skill://why/references/epistemics.md`, `skill://why/references/investigator-prompt.md`, and the applicable category playbooks indexed by `skill://why/references/source-playbook.md`. Include `skill://why/references/sources/incident-postmortem.md` for defensive code or incident-driven fixes. Apply the synthesis discipline from `skill://why/references/synthesizer-prompt.md` without replacing the brief with a separate rationale report.

Cover available source control, issue tracking, long-form documents, team chat, infrastructure observability, error tracking, and product analytics evidence. Read each relevant mounted MCP's actual schema and follow its server instructions. Use only read-only search, fetch, history, list, and query operations. Do not post, mark messages read, change memberships, mutate records, or run mutating SQL. Preserve distinct sources even when they share a category.

When delegation is warranted, include independent shared-source investigators in the same batch as history mining, one source per investigator. Otherwise search inline. Null results are findings; an unavailable MCP, missing authentication, blocked tool, or restricted agent is an access gap. Record both honestly. Do not assume a child can access the parent's MCPs; perform a parent-only search when needed. Keep sources, source confidence, timestamps, and conflicts attached to findings as they enter the brief.

## 5. Check against live state

Check the surfaced PRs, branches, commits, files, and tickets using available read-only git, authenticated `gh`, `pr://`, `issue://`, known URLs, and tracker tools. Determine whether work is merged, open, reverted, still on a branch, or merely proposed. Follow reverted fixes into the recurring-problem account rather than reporting them as completed solutions. Do not checkout, fetch, reset, commit, push, merge, or modify tickets merely to reconstruct context.

A transcript saying “done” is not proof of current state or verification. When the answer hinges on tools run, files read, or errors encountered, read the relevant full transcript regions, not only a summary or trimmed copy. Recover omitted output through its known artifact where available. If decisive content remains inaccessible, mark the claim unverified. Current repository evidence and the user's current instructions take precedence over stale memory; preserve disagreements rather than silently rewriting history.

## 6. Return the brief

Read and apply `skill://unslop` to the prose, preserving citations, uncertainty, and this contract. Lead with the capsule, then thread status, then problems, then the next move. Group by thread and stay on the named topic.

- **Capsule:** at most five bullets describing the work and its overall current state.
- **Threads:** one line each, prefixed with exactly one supported status tag: `[merged #N]`, `[open PR #N]`, `[in flight <branch>]`, `[verified, uncommitted]`, `[reverted #N]`, or `[planned, not started]`. Replace identifiers with observed values. Use “verified” only with actual verification evidence. Never force an unsupported tag: if status cannot be established, explicitly report that thread's unknown status and missing evidence rather than inventing a branch, PR, completion, or verification.
- **Problems:** at most five recurring problems, including user symptoms and fixes that shipped and were reverted, so the next attempt starts where the last failed.
- **Next move:** the single most useful concrete action.

Cite conversation findings by their session ID and accessible record reference, memory findings by their artifact URI or returned source metadata, and shared findings by PR number, ticket ID, chat permalink, document, or error-tracker issue. Distinguish documented facts, reasonable inferences, and unknowns; do not strengthen source confidence while shortening prose. Add a compact coverage/limitations line when sources are missing, empty, clipped, or only partially searched.

Exclude adjacent features and tickets unless they block this work. When capsule and thread lines outgrow a screen, cut deeper detail before cutting threads. Sanitize private context before any public output; recall does not authorize publication. Reply with the brief, not a raw transcript dump, implementation, or a claim of exhaustive history coverage.
