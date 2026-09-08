---
name: typescript-best-practices
description: Apply TypeScript type modeling, boundary validation, narrowing, and schema-derived types when reading or editing .ts and .tsx files.
globs: ["**/*.ts", "**/*.tsx"]
disable-model-invocation: true
---

# TypeScript best practices

First read and apply [type-system discipline](skill://principle-type-system-discipline). For data crossing a trust boundary, also read and apply [boundary discipline](skill://principle-boundary-discipline).

| Rule | Summary |
|------|---------|
| Discriminated unions | Model variants with a `kind` literal discriminant so impossible states can't be represented. No optional-field bags. |
| Branded types | Brand primitives with `& { readonly __brand: "X" }` so they can't be mixed up. Validate once at the boundary. |
| Constructive modeling | Build the shape so the illegal value can't be constructed. `[T, ...T[]]` for non-empty, `[T, T][]` for even length, `start` plus `duration` for a range. Not repeated runtime guards, not a wish for refinement types. |
| Simplest total type | Keep `T[]` while every operation on it stays total. Strengthen to `NonEmpty<T>` only where the loose type forces `!`, a cast, or a "should never happen" throw. |
| `unknown` over `any` | External data is `unknown`. |
| Schemas before guards | Before hand-writing a property-by-property type guard, use the repository's runtime schema library and infer the type from the schema, such as `z.infer`. |
| No `as` casts | An unchecked `as` can hide a runtime crash. Cast only after validation establishes the claim. |
| Narrowing hierarchy | Discriminant switch > `in` operator > `typeof`/`instanceof` > user-defined type guard > `as`. |
| Type guards | Must verify the claim. A lying guard is worse than `as` because the bug hides behind a name that says it's safe. Name them `isX` or `hasX`. |
| Exhaustiveness | Inline `const _exhaustive: never = x;` in default arms so the compiler errors when a new variant is added. |
| `satisfies` over `as` | Checks assignability without replacing the expression's inferred type with the target type; preserve literal precision where contextual typing supports it. |
| Boundary validation | Parse where data crosses in, into a named domain type. `Record<string, unknown>` (however spelled) stops at that parse. Trust types inside. Apply [boundary discipline](skill://principle-boundary-discipline). |
| Schema-derived types | Reach for `Pick`/`Omit`/`Parameters`/`ReturnType`/`Awaited`/`typeof` before declaring a new interface. |
| Object args | Pass objects, not positional, so argument order is self-documenting. Skip on hot paths (per-frame render, tokenizers, parsers). |
| Real tests | Don't mock what you can run. Prefer the framework's real test primitives with leak/disposable checks, and verify UI in a running build. Mock only what you can't run locally. |
| Structured telemetry | Prefer structured logger diagnostics with enough context to debug from an id. No `console.log` in shipped code. |

Read [syntax examples](skill://typescript-best-practices/references/patterns.md) for the relevant rules before editing.

## Working in OMP

Scope the relevant files and existing conventions with `grep` and `read`. Use OMP LSP `definition`, `type_definition`, `hover`, and `references` for symbol and type intelligence rather than guessing from text matches. Supply the actual file, 1-indexed line, and symbol for position-based lookups; `definition` and `references` require a symbol when a line is supplied on project-aware servers.

Before changing a type, inspect its definition and consumers. Prefer the existing schema, brand, and discriminant conventions. Use LSP `code_actions` to list supported fixes before selecting one with `query` and `apply: true`. Preview a symbol rename with `apply: false` first: LSP rename otherwise applies by default. Keep every resulting edit within the authorized scope; use syntax-aware `ast_edit` for structural codemods and `edit` for surgical changes.

If LSP or the relevant server is unavailable, disclose that limitation and use grounded `grep`/`read` investigation; do not invent definitions, references, or successful actions. This skill does not require installing packages or changing framework setup. Its testing guidance applies to the actual implementation task and its verification policy, not to an automatic package-command gate on every TypeScript read.
