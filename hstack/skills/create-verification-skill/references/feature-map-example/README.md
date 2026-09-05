# Example verification map

This directory is the maintained source for proving user-facing behavior. Read this index before driving the app, then use the matching feature recipe.

## Baseline preconditions

- Launch a disposable instance using the parent skill's exact `hub` process specification.
- Run the parent skill's Doctor check before driving.
- Never drive an instance the verification run did not start and identify.
- Keep mutable scratch state separate from the evidence root.

## Driving conventions

- Begin each recipe from the documented baseline unless its preconditions differ.
- Prefer accessibility identifiers, roles, labels, and visible text over coordinates.
- Treat commands and selectors as literal.
- Reset mutated state before another recipe depends on the baseline.

## Proof and skip reporting

- Capture the action and its visible result.
- Pair mutations with a read-only second observation of persisted state.
- Inspect screenshots, recordings, responses, or transcripts rather than trusting exit status alone.
- Record feature ID, entry point, platform/runtime, build mode, and evidence path.
- Report an unreachable entry point with the attempted route and unmet prerequisite.
- Cleanup removes scratch state and named processes, never evidence.

## Feature entry contract

Each feature file starts with an H1 and a user-visible description, followed by exactly four H2 sections in this order:

1. `Sub-features`
2. `How to get to it (user POV)`
3. `Driving it with <harness>`
4. `Gotchas`

## Features

- [Sample feature](./sample-feature.md) demonstrates the required recipe shape.
