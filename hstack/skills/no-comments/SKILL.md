---
name: no-comments
description: Run the comment-sicko agent, review its deletions, fix accepted root causes, and offer enforceable encodings for comment-only constraints.
disable-model-invocation: true
---

# No Comments

Use this skill when the user explicitly invokes `/skill:no-comments`. Delegate the first pass to `comment-sicko`; the current agent remains responsible for reviewing every deletion, implementing accepted fixes, verifying behavior, and reporting open constraints.

## Scope

Use files, directories, ranges, or a diff supplied by the caller. If the caller gives no fence, use the current change against the repository's base branch, defaulting to `main`, including committed branch changes, staged and unstaged work, and relevant untracked files.

Never widen the fence to clean similar comments elsewhere. Preserve unrelated and pre-existing user changes.

## Workflow

### 1. Establish the fence

Resolve the exact scoped paths and base revision before delegation. Read repository instructions first. For a broad diff, identify changed files before passing the task onward.

### 2. Delegate the comment-only pass

Call OMP's `task` tool once with `agent: "comment-sicko"`. Use an isolated worktree when the repository has a usable Git `HEAD`; successful isolated edits can then be applied without exposing the parent checkout to partial agent work. Otherwise use the shared checkout and keep the scope exact.

Give the task a complete OMP assignment:

- `context`: the cleanup goal, immutable scope, base revision, and the contract that only comment text may change.
- `Target`: exact files or diff and explicit non-goals.
- `Change`: delete comments under the agent's policy and flag code-design causes without editing application code.
- `Acceptance`: comment-only diff plus the required deletion, `MUST KILL`, and skip report. Tell the worker to skip formatters, linters, builds, and tests.

Do not duplicate or weaken the agent's policy in the task text.

### 3. Review the actual result

Inspect both the agent report and the applied diff. Accept only deletions that remain inside scope and preserve:

- legal or license notices;
- necessary tool and generated-code directives;
- public API contracts that signatures and types do not encode;
- proven immutable external constraints;
- live issue, specification, or RFC links for constraints code cannot express.

Reject application-code edits, scope escapes, unsupported claims, protected deletions, and `MUST KILL` flags that blame intentional or already-clear code. Audit scoped lint, compiler, and type suppressions the agent missed. A suppression protecting correctness or safety remains actionable, but its deletion is provisional until the full fix lands; a faulty or purely stylistic rule may justify a skip.

Never use `git checkout`, `git restore`, or a whole-file overwrite to reject part of the result: those can destroy user work. Restore only the invalid comment deletions with surgical edits. If the first report is materially invalid, rerun `comment-sicko` once with the specific failure and the same scope. If the rerun is still invalid, restore its rejected changes, report the audit as open, and fail the skill rather than guessing.

### 4. Fix accepted root causes

For every accepted `MUST KILL`, inspect the named symbol and its call sites. Before changing an exported or shared symbol, use OMP `lsp` references and definitions when a language server is available. Prefer a server-provided code action for imports or refactors when it covers the change.

Implement trivial fixes directly. When accepted fixes form substantial independent slices, define their shared contracts first and fan them out in one `task` batch with isolated worktrees; otherwise keep the work local. Do not delegate a generic plan.

Apply the smallest in-scope root-cause change that makes the deleted explanation or suppression unnecessary. Rename, extract, strengthen a type, replace the workaround with the real API, or remove the dead path as appropriate. Do not add a guard, fallback, alias, compatibility shim, or shorter explanatory comment in place of the original problem. Remove obsolete workaround code.

Before changing a shared symbol or contract, resolve every affected caller. If any required migration lies outside the mutation fence, obtain approval to expand the fence and migrate all callers; otherwise leave the shared change open and executable code unchanged. If a complete correctness, safety, compiler, lint, or type-suppression fix cannot land inside the approved fence, surgically restore the suppression and report the root cause as open. Never leave a live diagnostic exposed merely to achieve a comment-only deletion.

### 5. Encode claimed constraints

For comments such as `do not remove`, `do not change wording`, or `consult X before changing`:

1. Preserve the comment when it documents a proven external constraint that cannot be encoded.
2. Otherwise offer the cheapest in-scope enforcement: a type or API boundary first, then a runtime invariant, behavioral test, or narrowly scoped CI/lint rule.
3. Ask for approval only when the available encodings have materially different behavior, maintenance cost, or scope. In unattended execution, require caller pre-approval for that choice.
4. After approval, implement and verify the encoding, then delete the comment. Without approval, do not invent a mechanism; report the unenforced constraint and the smallest proposed change.

### 6. Verify the changed surface

Comment-only deletions require a final diff inspection proving that no executable text changed. Root-cause code changes require the narrowest command or scenario that exercises the changed behavior. Run project-wide formatting, linting, or test suites only when repository policy specifically requires them.

Do not claim a check you did not run. A worker's successful completion is not proof; verify applied changes in the parent checkout.

## Final report

Report:

- deleted comment count and touched files;
- restored comments and why they qualified;
- agent reruns and any rejected findings;
- `MUST KILL` fixes implemented;
- constraint encodings offered and applied;
- exact verification commands or scenarios and observed results;
- unenforced constraints and other open work.
