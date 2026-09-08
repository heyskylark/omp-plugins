---
name: principle-migrate-callers-then-delete-legacy-apis
description: "Apply when introducing a new internal API while old callers still exist. Migrate callers and delete the old API in the same wave instead of preserving compatibility layers."
disable-model-invocation: true
---

# Migrate Callers Then Delete Legacy APIs

When we decide a new API is the right design, migrate callers and remove the old API in the same refactor wave instead of preserving compatibility layers.

**Rule:**
- Do not keep legacy API paths only because internal callers still exist.
- Inventory callers, migrate them, and delete the old API immediately.
- Treat temporary adapters as exceptional and time-boxed, not default architecture.
- Update tests to assert the new contract, and delete tests that only protect pre-refactor implementation details.

**When this applies:**
- No external users depend on backward compatibility.
- The project can absorb coordinated breaking changes.
- The new API is part of a simplification or refactor initiative.

Keeping both old and new APIs creates dual-path complexity, slows cleanup, and makes the codebase feel append-only.

## Applying in OMP

Scope the API and callers inline first. Use available LSP definitions and references for symbol-aware inventory, supplemented by targeted search for dynamic references, exports, documentation, and generated inputs. Preview LSP renames with `apply: false` before applying; renames default to mutation. Use structural editing for codemods and ordinary edits for contract changes a rename cannot express. If LSP is unavailable, disclose that limitation and use targeted source search; do not call an incomplete reference list exhaustive.

For substantial independent caller groups, the parent may dispatch one native task batch with agreed API shape, exclusive file ownership, and an integration owner. Select `scout` for research, `sonic` for strictly mechanical migrations, the configured general task agent for implementation reasoning, and `reviewer` for review. Give children complete context because they do not inherit conversation history. Use isolated editing when available and allowed; native isolation may apply returned patches, so do not dispatch competing implementations as independent migrations. Keep the shared API mutation and final legacy removal with the integration owner after callers are migrated. The parent owns the todo and scoped `local://` coordination notes; children return findings and changes through `agent://` outputs and skip mid-flight validation. Honor spawn, tool, and plan restrictions rather than bypassing them.

Take initiative on reversible edits already authorized by the task. This principle does not authorize a breaking external release, unrelated deletion, commits, pushes, or destructive operations. Explicit approval requirements, plan mode, and user-requested validation pauses still govern when changes and final removal may occur.
