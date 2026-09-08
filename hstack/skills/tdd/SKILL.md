---
name: tdd
description: "Fix bugs with a failing-before, passing-after behavioral regression check when explicitly requested or when an obvious cheap local test target exists; use honest fallback evidence when a permanent test is impractical."
disable-model-invocation: true
---

# TDD Bug Fix

When fixing a bug with a clear, cheap test path, make the broken behavior executable before changing production code. The goal is a focused behavioral regression test that fails before the fix and passes after it, followed by any warranted refactoring while keeping the check green.

Use this workflow when the user explicitly requests TDD, a failing test, or a regression test, or the bug has an obvious cheap local test target. Do not force a test when its path is unclear, expensive, integration-heavy, or requires broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state, vague reproduction steps, or large unrelated fixture churn. Prefer the closest useful evidence instead.

Existing repository test conventions and the user's explicit verification restrictions win. A request to skip execution means no tests, builds, lint, debugger runs, browser checks, or substitute scripts unless explicitly permitted. Do the allowed work and report the missing evidence; never call an unexecuted test red or green. Treat user-reported failures as established observations rather than rerunning solely to confirm them; distinguish supplied evidence from a newly observed regression-test failure.

## Workflow

1. **Understand the bug.** Identify intended behavior, current behavior, affected path, and the smallest observable reproduction. Read relevant implementation and neighboring tests using `read`, `grep`, and `glob`; reuse their runner, fixtures, and conventions.
2. **Choose the narrowest executable check.** Prefer the closest unit, component, integration, or regression test already used for that code path. Select the exact test command from repository scripts, documented runner usage, or existing commands; do not invent runner flags. If no practical test path is obvious, do not build a new harness merely to satisfy this workflow.
3. **Red: write the failing test first.** Add the smallest focused test that would have caught the bug. Assert the consumer-visible contract, boundary, invariant, transition, precedence, or real error—not current implementation details. Keep it deterministic, isolated, and safe within the existing suite.
4. **Observe red before fixing.** When execution is permitted, run only the focused check and record its actual failure. Confirm it fails because of the intended bug rather than setup, syntax, imports, or an unrelated error. If it passes or fails for another reason, correct the reproduction or test before changing production code. If production code was already changed, do not erase user work to manufacture red evidence; explain the missing baseline and use a safe isolated reproduction only when practical and authorized.
5. **Green: fix the bug.** Make the smallest production change that restores intended behavior while preserving neighboring contracts. Fix the cause, not the symptom; do not change tests to accommodate incorrect behavior or hardcode the test input.
6. **Observe green.** Rerun the same focused regression check and record the result. If it still fails, investigate the failure rather than weaken the assertion.
7. **Refactor only where warranted.** Once green, simplify the affected implementation or test without broadening scope or changing the contract. Rerun the focused check after any such change. A refactoring phase is not a mandate for unrelated cleanup.
8. **Validate nearby risk.** When allowed and warranted by the changed contract, run relevant adjacent tests, type checks, lint, or scenario checks. Start narrow; do not reflexively launch project-wide gates. During parallel implementation, children skip validation and the integrating parent runs the selected checks once after edits settle.

## If a Failing Test Is Impractical

Before fixing, explicitly explain why a permanent failing test is impossible or not worth the cost, then choose the closest useful executable regression check permitted by the user. Options include a targeted throwaway script, a manual reproduction command, browser automation, a meaningful snapshot comparison, a log assertion, or a focused integration check. Exercise the actual affected behavior before and after when possible; if either side cannot be demonstrated, state exactly why.

Prefer no new test over a bad test. Do not keep tests that primarily exercise mocks, repeat field copies or wiring, assert source text or incidental defaults, depend on timing or unrelated global state, require expensive infrastructure for a small fix, or merely assert that something did not throw. A test must fail for a plausible behavioral regression, not just prove the implementation was called. Use temporary proof when that is all the check earns, and remove only your own throwaway files after preserving the evidence.

### Native execution and diagnostic tools

- Use `bash` for a finite existing test or reproduction command, with the actual `cwd` supplied separately and environment values in `env`. Read the completed result, including exit status and relevant failure output; a background job's start is not a passing result. Respect effective timeouts and tool availability. Use `eval` for inline scripting rather than complex shell control flow.
- Use the available native `debug` tool or its exposed `xd://debug` device when breakpoints, stack frames, variables, or stepping can clarify an ambiguous reproduction. Read the active tool schema before use. `launch` takes a program path, not a shell command; use only an available configured adapter. One root debug session is supported, so do not displace an unrelated active session. Inspect `sessions`, then use the appropriate launch or authorized attach, breakpoint, continue/step, and inspection actions; terminate only the session you own when finished. A timeout that leaves the target running is not successful verification. Debugger observations supplement the behavioral regression check rather than turn internal state into the public test contract.
- Keep persistent services and interactive terminals under native `hub` process management, observing readiness before reproduction and stopping only owned processes. Use the browser prelude for an actual web surface when it is the useful fallback. Read the relevant tool documentation before unfamiliar actions; do not infer availability or install missing tools without authorization.
- This narrow red/green loop normally runs inline. Do not spawn an agent merely to run one test or create a custom testing worker system. If the parent already delegated implementation, return evidence through the assigned agent output and let the parent own integration validation.

## Guardrails

- Do not change tests merely to match a wrong implementation.
- Do not weaken existing assertions unless the expected behavior genuinely changed and the reason is clear.
- Keep regression coverage focused on this bug. Avoid unrelated fixtures, coverage expansion, and new testing abstractions.
- Do not add tests when the practical signal is weak. Use permitted manual or scripted verification and explain why.
- For flaky bugs, make the reproduction deterministic where possible and describe the behavioral signal being locked down; do not hide the flake with arbitrary waits or retries.
- If the bug reveals a broader class of failures, establish the focused regression path first. Add sibling coverage only when it protects distinct plausible failures and remains in scope.
- Verification and autonomy do not authorize installations, sensitive external actions, deletion of unrelated work, commits, pushes, or merges.

## Final Response

Report evidence, not just an outcome:

- The intended behavior and focused fix.
- The failing-before test or executable check, exact command where applicable, and the relevant failure observed; label user-supplied evidence separately.
- The passing-after run and any relevant adjacent validation actually performed.
- Refactoring performed, if any, and whether the focused check was rerun afterward.
- If failing-before or passing-after evidence is unavailable, the concrete reason, any explicit execution restriction, and the closest permitted regression evidence used instead. State unexecuted checks honestly; never imply that a test file's presence proves the fix.
