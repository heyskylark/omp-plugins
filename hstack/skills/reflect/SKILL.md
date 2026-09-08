---
name: reflect
description: Review the current session through judgment, tooling, and divergent lenses, then propose durable lessons as targeted skill improvements for explicit approval.
disable-model-invocation: true
---

# Reflect

Mine the current conversation for repeatable lessons and route them into concrete skill improvements. Invoke when the user asks to reflect. Skip trivial, off-topic, one-off sessions or incidents already clearly covered by guidance the parent followed correctly. Do not manufacture findings to fill a quota.

This is `skill://reflect`, a review-and-edit workflow, not the native `reflect` memory tool. Native reflection is optional evidence, not a substitute for reviewing this session or an operation that edits skills.

## 1. Establish the evidence boundary

The parent scopes the session before delegating. Use the active conversation and a transcript path explicitly supplied by this session, if available. Do not search transcript directories, enumerate unrelated sessions, or infer that `history://Main` exposes the active conversation. `history://<id>` is for known task sessions involved in this work; `agent://<id>` holds their outputs.

When no active transcript is explicitly available, write a tight, faithful digest to a parent-owned scoped `local://` artifact. Include the opening request, decisions and rationale, corrections, tool outcomes, verification evidence and omissions, skills actually read/applied, visible missed-trigger candidates, and short quotes with turn labels. Mark uncertainty and omitted context. Do not include secrets or unrelated personal data. Pass the exact evidence URI and its limitations to every reviewer; children do not inherit the conversation.

Check actual tool availability before memory use:

- Native `reflect` is registered only for Hindsight or Mnemopi, never off/local. Read its available schema before use; supply a focused `query` and optional `context` only when cross-session evidence would help. Hindsight synthesizes; Mnemopi returns scoped recalled context rather than a separate synthesis. Neither persists the reflection output. Keep memory-derived claims distinct from session evidence and check current repository state before acting on them.
- `learn` requires enabled autolearn plus local, Hindsight, or Mnemopi memory. `manage_skill` requires enabled autolearn independently of backend. Neither is guaranteed in a child session.
- Unavailable memory tools do not block this skill. Continue with scoped session evidence and authored-skill proposals; do not create substitute brain files or change settings to enable memory without authorization.

## 2. Run three independent lenses

After inline scoping, read these complete prompt templates:

| Lens | Agent selection | Template |
|---|---|---|
| Judgment | Configured general task agent | `skill://reflect/references/judgment-reviewer.md` |
| Tooling | Configured general task agent | `skill://reflect/references/tooling-reviewer.md` |
| Divergent | Configured general task agent | `skill://reflect/references/divergent-reviewer.md` |

These are session-learning reviews, not patch reviews. Use a general reasoning agent with the read-only assignment below. The bundled `reviewer` requires patch-anchored code findings and a different output schema, so it cannot supply the Principle/Evidence/Routing contract merely by changing its prompt.

Submit the three substantial independent reviews in one native `task` batch. Shared context uses `# Goal`, `# Constraints`, and `# Contract`; each assignment uses `# Target`, `# Change`, and `# Acceptance`. Include each full template with its evidence marker replaced by the exact URI. Define the common Principle/Evidence/Routing result contract up front. Reviewers only inspect evidence and return proposals: no edits, child todos, recursive orchestration, tests, builds, linters, formatters, or external writes. The parent owns orchestration and the scoped notepad. Referenced-context lookups may use available read-capable tools; never assume a role has every connector. Use `scout` for any genuinely needed code/search research rather than outsourcing judgment to it.

Select only discovered permitted agents whose purpose and output contract fit session reflection. Optional already-configured general reasoning variants may diversify the panel; dispatch by agent type, not a model argument, and omit the agent field when the spawn-policy default is the intended agent. Three lenses using one model are not multi-model agreement. Disclose unavailable roles, connectors, spawn/depth limits, plan restrictions, or partial results. Do not bypass restrictions: if fan-out is unavailable, apply the three templates inline and label the loss of independent review. If batching is disabled, use the exposed flat task shape for independent calls with the same shared evidence artifact.

Collect complete `agent://<id>` outputs, not truncated previews. Use known `hub` IDs for follow-up; wait only when blocked. Failed or missing reviews are missing evidence, not consensus.

## 3. Synthesize

Read and apply `skill://reflect/references/synthesizer.md` inline after all available reviews settle, substituting each full review output. Inline synthesis avoids an otherwise single-purpose serial spawn. Preserve reviewer disagreements and check cited evidence and target skills. Use available read-capable connectors only for the referenced context. Produce the complete Accepted / Rejected / Backlog result, not just favorable findings.

## 4. Check structural enforcement

Read and apply `skill://principle-encode-lessons-in-structure`. Recheck every Accepted row: if a lint rule, script, metadata field, or runtime guard already enforces it or could enforce it cheaply and reliably, move it to Backlog rather than adding more prose. Preserve judgment that genuinely cannot be mechanized.

## 5. Obtain approval and apply exact routings

Present the full Accepted / Rejected / Backlog output before any Accepted edit or persistence. Wait for explicit approval of the subset and any routing changes. Skills influence future sessions; invocation of this review is not blanket permission to mutate skills or memory.

Prepare structural Backlog items for the team's actual devex tracker. File them when standing or explicit authorization covers that destination and action; otherwise request permission and retain the proposed items in the response. Do not invent a tracker or claim unfiled items were filed.

For approved rows, follow the Routing field:

- **Trivial existing-skill edit:** parent makes the one-line bullet, tightened sentence, or stale-fact correction directly.
- **Substantive existing-skill edit:** read and apply `skill://create-skill` for its draft / test / iterate workflow; a new section, pattern table, or more than roughly ten lines belongs here.
- **`tune description: <skill path>`:** read and apply `skill://create-skill` for description optimization. For explicitly hidden/manual-invocation skills, a better description cannot undo visibility settings; route a required metadata change through structural Backlog rather than promising automatic triggering.
- **`new skill via create-skill: <kebab-name>`:** read and apply `skill://create-skill`. New skills are rare and require no suitable existing home plus a recurring independent procedure.

Resolve each authored skill's actual owner from its invocation/discovery source and edit there, not a guessed duplicate or generated cache. An authored plugin skill must be changed in its real editable source; if that owner is unavailable, provide the precise proposed change and report the blocked application. Managed tools never update authored plugin skills, and a same-name managed copy loses discovery precedence.

For an approved managed-skill change, use available `manage_skill` with `action`, `name`, `description`, and the complete Markdown `body` without frontmatter; read the existing body before an update. It refreshes active skills when the session callback exists. Do not claim managed writes can preserve arbitrary authored frontmatter: their generated frontmatter contains name and description only.

Optionally capture one precise approved durable lesson with available `learn` (`memory`: what, when, why; optional source `context`). Add its optional `skill` object only for an approved managed procedure, not ordinary facts or an authored-skill edit, and do not perform the same mutation twice. `learn` stores/queues the lesson before the skill write, so report partial outcomes honestly and do not retry blindly; its skill write is discovered on a later refresh/session. Local lessons are capped at 2,000 characters with 400-character context. Never manually rewrite generated memory artifacts as a substitute.

If an approved correction concerns existing Mnemopi memory rather than skill prose, use `memory_edit` only when exposed: read the full `memory://<id>` before wholesale `update`; do not overwrite from a clipped preview. Prefer `invalidate` when useful history should remain, use permanent `forget` only with deletion authorization, and inspect the returned status. Facts are immutable; off/local/Hindsight do not expose this tool. A memory correction is not completion of a routed skill edit.

When applying future skill changes, use an existing SKILL.md validator if the environment provides one; skip that gate if none exists. Honor any task-specific prohibition on validation and report it. Do not install a validator or commit/push changes without authorization.

## 6. Report

Return a short list without preamble:

- Edits applied: exact owning skill path and one-line change.
- New skills created: path and purpose, if any.
- Lessons stored or queued: precise outcome, if approved and available.
- Backlog filed: real issue title, link, and tags; separate proposed/unfiled items.
- Dropped: each rejected principle and its synthesis reason.
- Blocked or unverified: exact missing prerequisite, partial persistence, reduced review coverage, or skipped gate.
