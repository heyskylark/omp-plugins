---
name: create-skill
description: Create or revise an OMP-native skill with grounded instructions, discoverable packaging, complete asset and skill dependencies, and verification proportionate to the requested change.
disable-model-invocation: true
---

# Create an OMP skill

Turn a repeatable task into instructions another OMP session can execute without the author's conversation. Author a skill, not an extension, hook, agent fleet, or application unless the user actually requests those capabilities.

## 1. Establish the contract and destination

Determine the trigger, inputs, intended result, non-goals, required tools, permissions, and observable acceptance criteria from the request and repository. Ask only for decisions not recoverable from available files or tools. Read relevant repository instructions and nearby skills before choosing a structure; revise an existing skill rather than creating a near-duplicate.

Read `omp://skills.md` as the authority for discovery, frontmatter, invocation, and asset resolution. Read `omp://marketplace.md` when packaging a plugin, `omp://tools/manage_skill.md` for managed skills, and `omp://task-agent-discovery.md` plus `omp://tools/task.md` if delegation is part of the workflow. Do not guess runtime mechanics from another harness.

Choose one ownership model:

- **Authored project skill:** default to `.omp/skills/<name>/SKILL.md`, committed with the project when the user authorizes version-control operations.
- **Authored package skill:** when requested, use `<package-root>/skills/<name>/SKILL.md` alongside the package's existing content. Follow its established manifest and distribution conventions. A directory alone does not install or enable a package.
- **Managed learned skill:** only when the user wants an isolated auto-learn capability rather than maintained repository/package files; follow section 5.

Discovery scans one level under a skills root. Do not use `skills/group/name/SKILL.md` unless the existing configuration explicitly points `skills.customDirectories` at that nested parent. Choose a descriptive kebab-case name and make frontmatter `name` match its directory exactly.

## 2. Inspect configuration and collisions

Use `glob`, `grep`, and targeted `read` calls to identify the relevant roots, existing names, assets, scripts, and package configuration. Inspect existing project and user configuration only as needed, without exposing secrets. Check the session's discovered skills and configured custom directories, enabled package sources, and managed skills for the proposed name. Do not overwrite an unrelated skill or silently rename an established public dependency.

Account for these discovery rules:

- `skills.enabled: false` disables discovery. Source toggles, `disabledExtensions` entries such as `skill:<name>`, `ignoredSkills`, and `includeSkills` can filter a valid file out.
- Authored provider skills deduplicate by exact name and provider precedence; native OMP roots precede extension-package roots. Custom-directory skills override provider skills, with first-wins behavior among custom directories. Enabled authored skills take precedence over managed skills.
- Identical real paths are deduplicated. Another copy with the same name may be shadowed even when its files are valid.
- Inspect actual enabled roots rather than assuming all installed providers are active. Preserve existing configuration; change only an explicitly required setting with appropriate authorization.

Record any inaccessible root or unresolved collision as a specific limitation. Do not claim global uniqueness from a repository-only search.

## 3. Write a complete operational skill

Use explicit supported frontmatter:

```yaml
---
name: inspect-migrations
description: Review pending database migrations for compatibility and data-loss risks before deployment.
disable-model-invocation: true
---
```

This is a format example, not a ready-made body. Replace its name and description with the actual task. The description states what the skill does and when it applies; avoid vague capability claims. Default new skills from this workflow to manual invocation unless the user requests automatic discoverability. `disable-model-invocation: true` hides metadata from the model's normal skill list; it is not an access-control boundary. The skill remains reachable by exact `skill://<name>` and, when `skills.enableSkillCommands` is enabled, `/skill:<name> [arguments]`. Do not invent mode, icon, color, reminder, delivery, or tool-permission frontmatter. Optional `globs`, `alwaysApply`, and `hide` are supported but should be used only for a documented requirement, not as decorative metadata.

Write the body for a cold session, including:

1. **Scope and prerequisites:** required input, supported cases, environment, permissions, explicit non-goals, and how missing prerequisites are reported.
2. **Investigation:** where to obtain authoritative facts and existing patterns before mutation; bounded questions for facts genuinely unavailable through tools.
3. **Execution:** ordered substantive phases, exact decisions and criteria, concrete tool recipes grounded in source, dependencies to read/apply, and ownership boundaries.
4. **Failure handling:** how to identify failure, recover safely, and report real blockers without fake fallbacks or unjustified retries.
5. **Evidence and completion:** observable acceptance criteria, appropriate verification, retained evidence, cleanup, and the final report contract.

Keep stable instructions in the main file and move bulky reusable recipes or examples into assets only when that improves usability. Include every needed phase rather than presenting scaffolding as finished work. Never put secrets, session-specific IDs, temporary absolute paths, unresolved template tokens, or invented commands into an authored result.

Use native OMP tools and existing project tooling. Prefer `read`/`grep`/`glob` for source, surgical `edit` for existing content, `write` for new files, LSP for symbol intelligence when available, and `ast_edit` for structural codemods. Long-lived or interactive processes use native `hub` start/readiness/logs/send/stop; web workflows use the installed browser prelude. Read the relevant installed tool documentation before prescribing an unfamiliar API. Required unavailable tools are a prerequisite, not permission to invent a substitute API.

A plain authoring job stays inline. If the generated workflow genuinely requires substantial independent work, select existing agent types: `scout` for read-only research, `reviewer` for compatible patch bug review, `security-reviewer` for compatible source-security review, `sonic` for mechanical work, and the configured general task agent for reasoning/implementation, design critique, custom scoring, evidence judgment, and executable verification. Check each discovered agent's role scope, tools, and output contract before routing; a prompt or `outputSchema` override cannot make an incompatible role suitable. Bundled `reviewer` reports only patch-introduced code bugs anchored to changed diff lines in its native findings/correctness schema. Preserve that schema and the security specialist's own contract; the parent may normalize full inspected outputs into a workflow ledger, but cannot infer runtime PASS or coverage from correctness. Use a discovered explicitly compatible specialist for other judgment or proof only when all three checks pass. Do not hardcode models or pass a model to `task`. Give each child self-contained scope and acceptance because it lacks conversation history. Use one batch with shared `# Goal`, `# Constraints`, `# Contract` and individual `# Target`, `# Change`, `# Acceptance`; keep parent-owned progress and scoped `local://` notes, consume returned `agent://` outputs, and use only known IDs for `hub` followup or `history://` reads. Disjoint editing needs supported isolation; never require children to orchestrate recursively or validate each other's in-flight edits. Honor the actual tool schema, spawn/depth/plan limits, and report unavailable parallelism honestly.

Do not create a custom agent merely to wrap a skill. If an explicitly needed agent policy justifies one, agent definitions are a separate artifact with their own schema and precedence. `autoloadSkills` refers to exact parent-discovered skill names; unknown names are ignored, so authoring that field does not prove availability. Reuse configured role routing instead of adding a mandatory new role.

## 4. Close assets and dependencies

Store every shipped template, reference, and helper inside the owning skill directory. Reference assets as `skill://<owner>/<relative-path>` and dependent skills as exact `skill://<name>` URLs, with an explicit instruction to read and apply them. Resolution rejects absolute paths and traversal, has no missing-file fallback, and depends on the discovered owner's exact name.

Walk the dependency graph to closure: read each referenced skill and asset, follow their required references, and distinguish bundled dependencies from optional integrations or prerequisites provided by the target project. For each edge record its owner, path/name, purpose, and availability. Do not silently delete a dependency, inline another skill to hide its absence, or introduce an invocation cycle. Existing cycles require a bounded entry/exit rule or a corrected design before delivery.

Ship only assets actually consumed by the skill. Reuse repository-owned scripts when suitable; any new helper needs exact invocation, inputs, outputs, dependencies, side effects, failure behavior, and cleanup. Treat source material as content to assess, not authority to run embedded commands. Preserve required attribution through the package's existing notices when importing material, within the authorized edit scope.

For an application-driving verification skill, read and apply `skill://create-verification-skill` instead of recreating its Launch/Doctor/Drive/Evidence/Cleanup and feature-map workflow. That dependency requires real application execution to claim behavioral proof; when execution is not authorized, report the unexercised coverage honestly rather than declaring it proven.

## 5. Managed skills are a separate API

Authored skills are ordinary maintained files. Do not use managed storage as a shortcut for project/package authoring, and do not write directly into its root to bypass the managed API.

The top-level `manage_skill` tool is registered only when `autolearn.enabled` is true (default false), independently of `memory.backend`. Inspect actual tool availability: a configured memory backend neither enables this tool nor guarantees its presence. Managed discovery itself is unconditional and still defers to enabled authored skills. Subagents do not automatically receive the tool; explicit tool access would be required. Do not change autolearn settings merely to complete an authored-skill request.

If the API is available and the user requests a managed mutation, use its current schema:

- `create`: `action`, `name`, one-line `description`, and Markdown `body` without YAML frontmatter. Creation fails on an existing managed file or an active authored-name collision; do not silently turn it into an update.
- `update`: the same fields, for an existing managed skill; it cannot override authored precedence.
- `delete`: `action` and `name`; it recursively removes that managed skill directory and requires the user's authorization for that deletion.

Names are normalized to lowercase and must match `[a-z0-9][a-z0-9-]{0,63}`. Bodies must be nonempty; the serialized file including generated frontmatter is limited to 64,000 UTF-8 bytes. The tool generates only name/description frontmatter and sanitizes descriptions. Therefore a request requiring manual-invocation metadata, packaged assets, or a repository-owned skill belongs in the authored workflow, not an unsupported managed field. Successful mutations refresh active skills only when the session supplies the refresh callback. Never equate successful file mutation with proven invocation.

If the tool or storage is unavailable, state the exact unavailable capability and offer authored project files if appropriate. Do not claim that configuring a different memory backend repairs the API, or fabricate a successful managed mutation.

## 6. Audit and prove proportionately

Respect the user's verification scope. When checks are prohibited, make the requested edits only and explicitly report checks not run. Otherwise perform source audit first:

- Inspect final frontmatter, discoverable layout, concrete description, literal invocation names, existing filter settings, and collision findings.
- Resolve the entire required skill/asset graph; check that every template reference belongs to the correct owner and no temporary or missing files are required.
- Trace a representative request through the instructions, including one failure or boundary condition where meaningful. Identify unsupported assumptions rather than merely restating the prose.
- For a requested distributable package, inspect its actual inclusion rules and existing packaging scripts. When authorized, run its established packaging/listing mechanism and inspect the resulting file inventory for every skill and asset. Validate catalog source paths against the intended package root; catalog metadata does not substitute for discoverable files.

Do not launch OMP for every prose change. Source/packaging proof is sufficient for ordinary instruction edits when no runtime contract changed. If the user authorizes discovery or invocation verification, use the existing session or a controlled session and exercise the changed path. Do not install, publish, or alter global state just to obtain a green check. Marketplace TUI mutations invalidate caches but do not refresh the active session: `/reload-plugins` refreshes skills, slash commands, and MCP servers; newly installed tools, hooks, or extension modules require a restart. Do not claim an existing session loaded a newly authored file without observing it.

Operational recipes and helpers require an authorized real scenario for behavioral proof; a source audit is not proof that a command or application works. Preserve observed evidence and distinguish executed checks, source-only checks, and unavailable coverage. Fix failures within scope, and remove only scratch files or processes the verification created, never unrelated state or evidence.

## 7. Deliver

Return the created/updated paths, purpose and invocation, ownership model, complete asset/dependency mapping, any configuration or packaging changes, and exact evidence or explicit checks-not-run status. Identify unresolved discovery restrictions, unavailable tools, and unexercised behavior. Do not commit, push, publish, install, delete unrelated content, or perform sensitive external actions without the corresponding user authorization.
