---
name: deslop
description: Remove unnecessary comments, needless defenses, type-bypassing casts, nesting, and style drift introduced in the scoped branch diff without changing behavior.
disable-model-invocation: true
---

# Remove AI code slop

Clean up slop introduced by the current change, not the entire repository. Prefer small, focused edits that look native to the surrounding code. Do not infer that unfamiliar code is generated or unnecessary.

## 1. Establish the change fence

Read repository instructions and scope the change inline before delegating. Honor any caller-supplied paths, ranges, base revision, or exclusions.

Resolve the actual target branch from the caller or existing pull-request metadata; otherwise inspect repository branch/upstream configuration and local history. A tracking upstream may be the feature branch, not its integration target. Do not assume a branch named `main`. If the target remains genuinely ambiguous after inspection, ask for the base rather than cleaning against an invented one.

Use the merge base with the resolved target to identify changes introduced on the branch. Account separately for staged and unstaged edits and relevant untracked files when they belong to the requested scope. Preserve unrelated uncommitted work. If the caller requests only uncommitted changes, do not include committed branch changes. Record the resolved base revision, exact mutation fence, and included working-tree layers; an empty fence is a valid no-op.

Read the changed constructs and enough adjacent code to understand local conventions and invariants. Inspection of callers outside the fence is allowed to establish correctness; edits outside it require approval. Do not reformat a whole file or repair pre-existing issues merely because they are nearby.

## 2. Find targeted cleanup

- **Comments:** remove explanations of obvious code and commentary inconsistent with local style. Preserve legal notices, required directives, public contracts, and durable external constraints. For the comment pass, read and apply `skill://no-comments` with this exact base revision, paths/ranges, and working-tree scope explicitly supplied. Use its existing orchestration and deletion-review policy; do not build a second comment-agent workflow or allow its default scope to widen this fence. Keep that pass separate from concurrent executable-code edits to the same files.
- **Needless defenses:** remove abnormal defensive checks or try/catch blocks only when caller contracts, types, and control flow prove the path is trusted and the fallback adds no required behavior. Preserve validation at trust boundaries, authentication and authorization checks, parsing checks, cleanup, error translation, retries required by an existing contract, and observable failure semantics. Uncertainty is a reason to retain the check, not delete it.
- **Type-bypassing casts:** remove casts to `any` whose only purpose is hiding a type issue. Fix the actual type or narrowing at its source using existing patterns; do not substitute another unsafe assertion or suppression. Resolve affected callers before touching a shared contract. If the complete fix requires out-of-scope edits, report it and obtain approval rather than leaving a partial migration.
- **Nesting:** use early returns or simpler control flow where they make the code clearer. Preserve evaluation order, side effects, cleanup, resource lifetime, and error propagation. Do not trade nesting for opaque expressions or gratuitous helper functions.
- **Style drift:** match the file and codebase's established naming, idioms, and structure. Remove needless scaffolding and inconsistency introduced by the change; avoid broad rewrites, new abstractions, or a second convention.

Keep behavior unchanged unless fixing a clear, evidenced bug within the authorized scope. Separate any such bug fix from stylistic cleanup in the report and verify the corrected behavior. Do not use cleanup as authorization for feature work.

## 3. Apply focused changes

Work inline for small or tightly coupled scopes. If two or more substantial independent slices justify delegation, define the ownership boundaries first and launch one native `task` batch. Use `reviewer` for code-quality and correctness findings and `scout` for factual searches of conventions, callers, or invariants. They report locations, evidence, proposed changes, and risks; the parent decides and edits. Do not assign implementation reasoning to a scout.

Provide shared `# Goal`, `# Constraints`, and `# Contract` context, and give every child a self-contained `# Target`, `# Change`, and `# Acceptance` assignment. Include the exact fence, base, relevant diff/context, behavior constraints, output expectations, and an instruction to skip builds, tests, linting, and formatting. Children do not inherit the conversation. Keep planning and any scoped `local://` notes with the parent; no child task lists or recursive orchestration.

When actual edits are substantial and independently owned, use the configured general implementation agent in isolated workspaces if the exposed tool and plan policy permit it. Native isolated edits may auto-apply: use isolation for disjoint implementation slices, not competing alternatives. Never have overlapping editors. If isolation or spawning is unavailable, keep edits in the parent and disclose the limitation without narrowing the audit. Agent types select configured behavior; do not hardcode models.

Read full returned findings through `agent://<id>` when the inline result is incomplete. Follow up through `hub` using returned agent IDs; use `history://<id>` only for known task sessions. Reject unsupported findings and retain necessary checks even when a worker recommends removing them. Do not reset files to reject a change; use surgical edits that preserve user work.

## 4. Verify and finish

After all edits are integrated, the parent checks that the resulting change stays inside the fence and that retained code still satisfies the original contracts. For executable changes, run the narrowest existing command or real scenario that exercises the affected behavior, including relevant failure paths. Follow the comment skill's verification requirements for its pass; do not run duplicate gates. Run project-wide checks only when repository policy requires them, once at the end, not in workers mid-flight. Honor an explicit caller instruction to skip checks and state that verification was not run.

Do not commit, push, merge, delete unrelated files, or install tooling without user authorization. Finish with **1–3 concise sentences** describing the cleanup, exact verification performed or skipped, and any retained uncertain candidates or scope blockers. If nothing warranted removal, say so rather than manufacturing a diff.
