---
name: show-me-your-work
description: Keep an evidence-backed decision trail for long-running, unattended, or multi-phase work. Use /skill:show-me-your-work to record choices, reasons, proof, and outcomes in a reviewable TSV log.
disable-model-invocation: true
---

# Show me your work

Keep one canonical decision log. Other skills call this workflow rather than inventing a competing audit format. Read and apply `skill://unslop` to log prose and `skill://principle-encode-lessons-in-structure` when a repeated lesson should become an enforceable check rather than another note.

## Format and location

Use `skill://show-me-your-work/references/decision-log-template.tsv` as the header. Each row has six single-line cells:

- `ts`: ISO8601 UTC timestamp.
- `phase`: phase or workstream.
- `decision`: the concrete choice or action.
- `why`: the reason in plain language.
- `evidence`: a resolvable commit, PR URL, source location, transcript, screenshot, or artifact pointer, not a paragraph.
- `result`: the observed outcome or honest state, such as `open`, `reverted`, or `INCONCLUSIVE`. Never record a passing check before it ran.

Default to a task-specific session artifact such as `local://decision-trail.tsv`. Reuse an existing log for the same work. The parent is the sole writer; children return proposed rows and evidence through their `agent://` outputs. The shared `local://` root is not a concurrent append service.

Keep the log outside repository files by default. If the user requests a committed trail or repository policy requires one, use the repository's existing audit location and make sure its evidence survives outside this session. Do not copy private transcripts or credentials into a public PR.

## Record decisions

Invoke the bundled helper with OMP `bash`, which resolves the skill and local URIs to paths:

```text
bash skill://show-me-your-work/scripts/log.sh local://decision-trail.tsv <phase> <decision> <why> <evidence> <result>
```

Pass exactly six arguments after the helper name, quoting each value as one shell argument. Use a task-specific filename when several workflows share the session. The helper creates the parent directory and header, timestamps the row, replaces tabs/newlines/carriage returns with spaces, and prefixes cells starting with `=`, `+`, `-`, or `@` with a quote so spreadsheet readers do not execute formulas. It takes a filesystem path, not a URI when run outside OMP's path-resolving tools.

Log a chosen fork, completed unit with proof, pivot or revert with its cause, surfaced blocker, or repaired gate. For iterative work, log each consequential iteration. Skip routine actions and padding. Keep rows append-only: correct an inaccurate entry by appending a superseding row that identifies it. Never rewrite history to hide a mistake.

Respect plan-mode write restrictions. If the active mode forbids the helper or artifact write, retain proposed rows in the permitted parent planning artifact and report that the TSV has not been written; do not bypass the guard through shell execution.

## Audit the evidence

Before delivery, compare the log to actual actions and tool results in this session. Use known `agent://` outputs and `history://<returned-agent-id>` transcripts for delegated work. If the parent transcript is exposed by the active runtime, use only that exact session reference. Never search other sessions or unrelated private chats to reconstruct a trail.

Check that every row describes an action that happened, each evidence pointer resolves and supports the claim, and meaningful forks or abandoned approaches are recorded. Append corrections for inaccurate rows and add missing decisions. Distinguish absent evidence from proof of failure. Session-only evidence must be identified as such if the log is delivered outside OMP.

## Independent review

Have an independent reviewer check the trail and the available session evidence while the parent performs its own evidence audit. Use an available OMP reviewer agent with the complete scope, exact log/transcript URIs, and a read-only contract. Skip formatters, linters, builds, and tests. The task must identify weak evidence, skipped or unproven verification, risky decisions, and omissions rather than repeat the implementation.

Prefer an already configured reviewer on a different model family. Select it through OMP's agent configuration and `modelRoles`, not a per-task model field or hardcoded provider ID. Record actual model provenance only when known. If only a same-model reviewer is available, or delegation is blocked, disclose that independent cross-model review is incomplete; do not describe self-review as equivalent. Do not change the user's configuration to manufacture a reviewer.

Use `hub` with returned IDs for follow-up, and `agent://` to read the full review. The parent validates flags against the evidence and remains responsible for the result.

## Deliver

Link the log and summarize meaningful decisions. End a delivery that includes a trail with an `Attention` section. State `reviewed by <actual model>` when known, otherwise state the reviewer identity and that its model is unknown, or explicitly say review was unavailable. List each flag with its row or evidence pointer; `No flags` is valid only after a completed review. Identify any unresolved evidence gaps.
