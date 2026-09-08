---
name: automate-me
description: "Create, update, or refresh a personal -mode skill from the user's observed working preferences and selected conventions, using authorized OMP history and memory."
disable-model-invocation: true
---

# Automate me

Turn the user's working conventions into one concise, personal `-mode` skill. This is a guided authoring flow, not permission to profile the user or infer preferences from unrelated private conversations.

Sequence evidence mining, user selection, authoring with `skill://create-skill`, and prose revision with `skill://unslop`. The resulting skill composes `skill://sky-mode` and the user's selected skill dependencies by reference, rather than reproducing their contents. Personalization is an explicit set of user-approved differences, not an assumption that the user shares every default.

## 0. Find the existing mode and establish scope

Use the user's chosen handle or first name; do not infer an identity from account metadata. Look for the matching `*-mode/SKILL.md` in the current project's `.omp/skills/` and already-discovered authored skills. Inspect other known user skill roots only within the user's authorization. OMP discovers one skill-directory level below a skills root: do not create nested personal categories.

If a matching mode exists, read it. Unless the request already says to update or refresh it, offer:

- **Update existing** — the default for a repeat run.
- **Start fresh** — ask what should be discarded before replacing anything.

For an update:

- Establish the last-edit cutoff from `git log -1 --format=%cI -- <path>` when tracked. Account for uncommitted edits; a commit date is not proof of the latest file edit. If no reliable cutoff exists, disclose that and agree a bounded history window rather than inventing one.
- Mine only newer evidence within the agreed scope; retain existing approved rules unless contradicted or explicitly removed.
- Ask what changed or is missing, not the full first-time questionnaire.
- Edit the existing file in place. A new section requires a genuinely new rule.

Before reading history, record a bounded source allowlist in the parent's working context: known session IDs or exact transcript/export paths, project, time range, and permitted memory scope. The current conversation is already available; other sessions must be known and authorized. Do not scan the global session store, prompt-history database, unrelated projects, or arbitrary `history://` sessions to find material. A task session registry is not an index of every user's conversation.

## 1. Mine the authorized history

Start with an inline survey of the allowlisted material. A useful default window is the last two to four weeks, narrowed to the update cutoff when applicable. Prefer actual user statements, corrections, and repeated accepted workflows over assumptions derived from assistant behavior.

### Evidence sources

- **Current conversation and supplied extracts:** use these directly and preserve their provenance.
- **Known OMP task sessions:** read `history://<known-id>` only when that session is in scope. Use `agent://<known-id>` for a task's returned findings, not as a substitute for the underlying user evidence.
- **Known persisted OMP sessions:** read the exact authorized JSONL path or user-provided export. Sessions are append-only trees: distinguish the selected branch from abandoned alternatives, use entry IDs and timestamps, and do not count a fork's copied messages as independent observations. Summaries, compactions, and truncated text are weaker evidence than the original user turn. Do not modify session files or invent session metadata to activate a mode.
- **Project memory:** when authorized and available, read `memory://root`, `memory://root/MEMORY.md`, or `memory://root/learned.md`. Treat memory as a heuristic, cite the artifact, and resolve conflicts in favor of current user instructions and current project evidence. Do not edit generated memory playbooks: consolidation can replace or prune them.
- **Recall:** read the available tool schema first. `recall` exists only for supported active backends, not `off` or `local`; its input is a natural-language `query`, not an invented project filter. Confirm the configured scope is authorized before using it. Shared/global banks may return cross-project memories even in a project-tagged configuration; do not query them without authorization for that scope. Use allowlisted transcripts instead when the available backend cannot guarantee the required boundary. A query mentioning a project does not enforce a privacy boundary. Read a clipped Mnemopi result through `memory://<id>` if the full evidence is needed and authorized.

When history is unavailable, ask for selected excerpts or a known session path. The user can use OMP's current-folder `/resume` picker to identify a session, or provide an `/export` or `/dump` artifact themselves. Do not switch, fork, or resume the active conversation just to mine history. Exports and dumps can contain system context, tool output, and secrets; request only relevant redacted material. `/dump` may also leave a sensitive temporary sidecar. Do not use `/share`: publishing history is unnecessary here.

Insufficient evidence is a reason to mark uncertainty and rely on explicit user choices, not a reason to broaden the scan.

### Parallel mining when justified

After the inline survey, if there are at least two independent, substantial slices, split the allowlist into disjoint time/session slices (often three). Use one native `task` batch with `scout` agents for evidence extraction. Do small histories inline. Never spawn children merely to satisfy a nominal count.

The parent owns the plan/todo and a scoped `local://` evidence notepad. Children receive no conversation history: provide the exact allowlisted paths, cutoff, signals, exclusions, and output contract. Batch context uses `# Goal`, `# Constraints`, and `# Contract`; each assignment uses `# Target`, `# Change`, and `# Acceptance`. Require no writes, no child todos, no recursive orchestration, and no tests, builds, linting, formatters, or other validation. Ask each child to return:

- Candidate operational preference.
- User evidence pointer: session/path, entry or line, date, and a short redacted quote.
- Independent occurrence count and whether it is explicit or inferred.
- Contradictions, context-specific exceptions, and uncertainty.

Read the returned `agent://<id>` artifacts, cross-check evidence, and follow up through `hub` using only returned/known IDs if needed. Honor actual tool availability, spawn policy, concurrency/depth limits, and plan-mode restrictions. If parallel work is unavailable, disclose the limitation and process the same bounded slices inline; do not claim independent agent corroboration.

Hunt for these signals:

- **Response preferences:** length, tone, format, requests for simpler explanations.
- **Delegation:** specialist use, parallelism, configured model diversity, recurring workflows.
- **Verification:** what counts as done, live reproduction versus unit tests, review expectations.
- **Code and prose discipline:** style, named principles, lint/format practices.
- **Process:** worktrees, commits, PRs, review and merge tooling.
- **Meta preferences:** correcting skills mid-task, proposing or maintaining reusable skills.

Cross-check across slices before elevating a pattern. Two or more genuinely independent slices support high confidence; copied fork history does not. A lone inferred signal is weak and usually omitted. A direct choice by the user can establish a rule without repeated historical evidence. Preserve contradictory signals for the user to resolve rather than averaging them into an invented preference.

## 2. Ask the user directly

Mining cannot reveal intent that has not appeared yet. Offer one or two compact choice questions, four to six options each. Allow multiple selections for categories. Use an available structured question tool if present; otherwise present numbered options in normal chat and ask for the selected numbers. Do not assume a particular question-tool schema or that silence selects the default.

Start broad, for example:

> Which areas should this mode capture? Select any: (1) response style, (2) autonomy and tool use, (3) investigation and delegation, (4) code/prose discipline, (5) review and verification, (6) delivery process and skill upkeep.

Then ask about the selected areas with concrete choices informed by the evidence. Show inferred preferences as candidates, label uncertainty, and include exceptions or contradictory examples. On refresh, focus on additions, changes, and removals. Finish with one free-form question: “What did these options miss?”

Do not dump twenty questions, turn inferred preferences into facts, or write a final profile before the user has selected the rules. Wait for the answers when they are required to proceed.

## 3. Cluster the selected rules

Read `skill://sky-mode` for granularity and the reusable baseline. Do not copy its prose or treat its author's preferences as evidence about this user. Show any material baseline mismatch before asking the user to approve composition.

Group only applicable, non-default rules into minimal sections:

- **Response style:** length, tone, formatting.
- **Autonomy:** when to proceed versus ask, authorized external-tool use.
- **Understand first:** investigation/scoping skills to load.
- **Subagents:** specialist selection, useful parallelism, configuration-backed model routing.
- **Prose / code discipline:** principles and style guides.
- **Review and verify:** reproduction, verification skills, actual-surface checks.
- **Process:** worktrees, commits, PRs, review and merge conventions.
- **Skills:** authoring habits, fix-the-skill-first, proposing skills.

Drop empty categories. “Communicate clearly” adds no useful rule. “Short paragraphs; tables for comparisons; bullets only for parallel items” does. Keep evidence and unresolved candidates in the parent's temporary working context, not in the installed skill. Avoid storing private quotes or a behavioral dossier.

## 4. Author the mode

Read and apply `skill://create-skill`. Produce a real authored skill, not merely a suggestion or a managed-memory record:

- New project path: `.omp/skills/<handle>-mode/SKILL.md`.
- Name: `<handle>-mode`, using the user's selected valid kebab-case identifier; `name` must match its directory.
- Existing authored skill: update its actual path. If it is in a non-discoverable nested category, explain the discovery issue and agree a migration instead of silently leaving an unusable skill or moving unrelated files.
- Personal rather than project installation: only on the user's explicit preference, resolve the installed native user skill root from OMP discovery/configuration and use its one-level layout. Do not guess a user root or write globally by default.
- Description: one concrete YAML scalar targeting this user's identifier, `/skill:<handle>-mode`, and requests to work in their style. Avoid broad triggers such as “write code” or “review PR.”
- Frontmatter: explicit `name`, `description`, and `disable-model-invocation: true`. This keeps explicit `skill://<handle>-mode` and, when enabled, `/skill:<handle>-mode` access; it is not an on/off state machine. Do not add mode IDs, persistence fields, icons, hooks, or reminder metadata. Always-on behavior is a separate explicit user decision; do not equate removing the hidden flag with applying every turn.

The generated body must begin with an operational composition instruction equivalent to:

> Read and apply `skill://sky-mode` as the baseline for this task. Apply the explicit user-selected preferences below where they differ, subject to higher-priority instructions and authorization boundaries. Load other referenced skills only when their stated task conditions apply.

Then include only selected personal rules. Resolve and read every selected dependency before referencing it. Use exact `skill://<name>` links, and `skill://<owner>/<asset>` for owned templates. Reference principle documents by their real, stable path rather than copying them. If a dependency is unavailable, report it and resolve it with the user; do not silently erase its workflow, replace it with an invented skill, or leave a broken link posing as complete behavior.

Use normal file `write`/`edit` tools for authored `.omp/skills/` files. `manage_skill` is only for an explicitly selected existing or new **managed** skill: it writes `<agent-dir>/managed-skills`, cannot edit authored skills, requires `autolearn.enabled`, and generates its own frontmatter from `name`, `description`, and a frontmatter-free `body`. It cannot express this authored skill's hidden frontmatter contract. Do not substitute that API for the required authored output, enable autolearn, or move between ownership types without the user's decision. Authored skills take precedence over managed names; avoid collisions.

If the generated rules discuss delegation, retain native specialist roles: `scout` for research, `reviewer` for review, `security-reviewer` only for security, `sonic` for mechanical changes, and the configured general task agent for reasoning/implementation. Select agent types rather than hardcoding model IDs. Optional configured multi-model panels must disclose when all agents actually use the same model. Personal autonomy rules never grant blanket permission for installation, deletion, publication, commits, pushes, or merging.

## 5. Revise with the user

Read and apply `skill://unslop` and the writing guidance in `skill://create-skill` to every line. Cut redundant baseline rules and generic filler. Use “the user” or “the human” in imperatives, not the author's name. No metaphors, invented terminology, or forced section symmetry.

Show the draft and ask whether it reads like the user, misses anything, or turns a situational preference into an absolute. Expect multiple iterations. Preserve approved sections during refresh and explain meaningful changes. This subjective output needs user feedback, not a generic benchmark/test loop. Optimize the description only if trigger accuracy becomes a real observed problem.

## 6. Land the approved skill

For a tracked project skill, prefer an isolated worktree and PR workflow based on the repository's actual mainline branch and conventions. Do not relocate or disturb existing user work merely to force this workflow. Commit, push, and open a PR only when authorized; never push directly to the mainline. If authorization is absent, leave the approved file ready for review and state that it is uncommitted/unpublished. Personal files outside version control do not require a fictitious PR.

Report the actual installed path, changed rule groups, exact dependencies, and how to invoke it. OMP discovers authored skills at startup; do not promise a new file is available immediately in an already-running session. It can be read directly by path now, and used via `/skill:<handle>-mode` after discovery when skill commands are enabled. Do not claim persistent activation or edit session records. Leave no unresolved placeholders in the delivered skill.

## Boundaries

- Do not overfit one conversation, codify assistant habits as user wishes, or hide uncertainty.
- Reference existing skills and principle documents; do not inline their instructions.
- Keep the mode short enough to apply, not a manual of every past interaction.
- A task-specific skill or a narrow workflow such as commit-message writing should use `skill://create-skill` alone; it does not need a personal mode or history mining.
