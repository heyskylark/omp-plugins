---
name: principle-test-behavior-not-implementation
description: "Apply when writing, changing, or keeping a test. Exercise the code as its users do and assert a concrete observable result, rejecting weak assertions, mock echoes, constant pins, and fixtures that only test themselves."
disable-model-invocation: true
---

# Test Behavior, Not Implementation

A test calls the code the way its users do and asserts the result they observe against a literal expected value. A test that only asserts which internal calls the code made, or restates a constant the code contains, does neither.

Before keeping a test, ask whether it would still pass if every function it imports returned `undefined`. If yes, it observes no behavior and cannot catch that defect: rewrite its assertion or delete the test. This is a diagnostic thought experiment, not a complete test-quality proof; an assertion that fails for `undefined` can still miss the real contract.

**Why:** A test that cannot fail for a defect costs CI time and review attention and catches nothing. A constant pin also fails when someone edits the constant or prompt it restates, preventing an edit without proving useful behavior.

**Five suspect shapes to inspect:**

- **Weak or no assertion.** No assertion, or only `toBeDefined`, `toBeTruthy`, `not.toThrow`, `toBeInstanceOf`, or `toBeGreaterThan(0)`. Some reject `undefined`, but none alone establishes the concrete result the consumer needs.
- **Mock or absence only.** Only `toHaveBeenCalled`, `not.toHaveBeenCalled`, `toBeUndefined`, `toEqual([])`, `toHaveLength(0)`, or `not.toBe(wrongValue)`. Rejecting one wrong result or observing nothing does not by itself demonstrate the desired behavior.
- **Self-referential.** The expected value comes from the code under test: `expect(f(a)).toBe(f(a))`, or `expect(parsed.url).toBe(buildUrl(...))`. A shared bug can supply both actual and expected values.
- **Constant pin.** The assertion restates a hand-maintained constant, config default, table row, or prompt string: `expect(LIMITS.maxTools).toBe(8)`, or `expect(PROMPT).toContain("You are")`.
- **Fixture asserts fixture.** The assertion reads data the test built or a value computed during setup, while the subject never runs inside the test body.

**The fix:** Call the subject inside the test body with one concrete input and assert the literal output or observable effect. For example:

```ts
expect(slugify("Hello, World!")).toBe("hello-world");
```

For absence, assert the corresponding presence on the other input in the same test, showing the boundary rather than an always-empty implementation. For a constant, test the mechanism that reads it with one input instead of restating its value. For a mock, assert the meaningful payload delivered at the consumer boundary or the resulting state, not merely that an internal function was called. Do not replace a call-count assertion with a mock echo that simply repeats its setup. When no behavioral assertion exists, delete the test.

**Keep** a test of a relation across a table's rows, such as a key shared by two tables or a parent that must exist, and a compile-time contract check in a `*.test-d.ts` file. These defend invariants or type contracts rather than pinning incidental values.

Use the project's test conventions, not a second framework or a new abstraction for this principle. Keep tests that fail for plausible defects in observable behavior, boundaries, invariants, transitions, precedence, or real errors. Do not add permanent tests merely to record that implementation work occurred; a throwaway behavioral exercise can provide execution evidence without permanent suite load.
