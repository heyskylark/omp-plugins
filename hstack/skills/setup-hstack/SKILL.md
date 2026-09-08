---
name: setup-hstack
description: Interview the user about HStack model choices, discover available OMP models and agent routing, and apply only approved, reversible model-role configuration changes.
disable-model-invocation: true
---

# Setup HStack

Configure HStack through OMP's existing model roles and task-agent mappings. Keep current choices by default. This is a configuration interview, not permission to replace settings, install providers, create a worker runtime, or run paid comparison jobs.

Read `omp://models.md`, `omp://settings.md`, `omp://config-usage.md`, `omp://task-agent-discovery.md`, `omp://cli-reference.md`, `omp://skills.md`, and `omp://tools/task.md` before changing settings. The installed docs and live tool schema take precedence over examples below.

## 1. Discover available models and configuration scope

1. Establish the actual working directory and active profile. Run `omp config path` in the intended profile context to locate the active agent directory rather than assuming the default home path. Named profiles, `PI_CODING_AGENT_DIR`, and XDG locations can change it; named profiles have their own configuration. Do not configure a different profile accidentally.
2. Run `omp models --json` from that working directory, using the same profile, extension configuration, and explicit `--config` overlays as the intended session. This lists available models, not merely catalog entries. `omp models find <substring>` can narrow a large result. Use `omp models refresh --json` only when a stale discovery result needs refreshing and the network action is permitted.
3. Record exact `provider/modelId` selectors and any reported capabilities, context limits, pricing, discovery source, and freshness. Registry presence alone does not prove entitlement: bundled or cached metadata is weaker evidence than provider endpoint discovery, and resolvable authentication does not guarantee that a later model request will succeed. Never claim an inference or a catalog fallback is a successfully exercised model.
4. If discovery fails or yields no usable models, inspect its error and the supported configuration paths. Ask the user for confirmed accessible selectors or to complete OMP authentication when tools cannot establish availability. Treat user-provided selectors as user-confirmed, not tool-detected. Do not invent a plausible identifier, infer access from a provider's marketing list, print credentials, or make a model call just to populate the interview.

The active agent directory normally holds `models.yml`, falling back to `models.yaml`, for custom provider/model definitions. This skill ordinarily leaves both untouched. Discover models through OMP rather than scraping credential stores or introducing a separate model API. Inspect only relevant non-secret configuration if diagnosis requires it; never echo API keys, headers containing secrets, or command-resolved credentials.

## 2. Load current state

Read the effective routing with:

```sh
omp config get modelRoles --json
omp config get task.agentModelOverrides --json
omp config get task.disabledAgents --json
```

Use `omp config list --json` if schema discovery is necessary; its credential fields are redacted, unlike explicit single-key credential reads. Read the corresponding routing sections of the active global `config.yml` (or existing `config.yaml`), `<cwd>/.omp/config.yml`, and any active overlay to identify which layer owns each value. Preserve existing mappings, unrelated keys, and user edits. Do not copy a merged effective record wholesale into a persistent lower layer.

Settings precedence is defaults, global, project, environment-provided overlays, explicit CLI overlays, then runtime overrides. Objects deep-merge; arrays replace. Native project settings are scoped to the process working directory, not an ancestor search. A lower-layer edit may be masked by an overlay or runtime flag; identify that before proposing a write.

Inspect the live agent inventory and relevant discovered definitions. Prefer existing `scout`, `reviewer`, `task`, `sonic`, and `verifier` agents only where their role scope, tools, and output contract fit the assignment. Bundled `reviewer` reports patch-introduced code bugs anchored to changed diff lines in its native findings/correctness schema; it cannot supply design critique, arbitrary rubric scores, or executed proof through a prose reassignment or schema override. `verifier` is not guaranteed to be bundled: use it only if discovered, permitted, and compatible with the required proof and output. Missing or disabled agents are a visible limitation, not an invitation to silently create a substitute with the same name. Agent discovery can also select a project/user definition over a bundled definition, so do not assume its scope or routing from its name.

For task dispatch, `task.agentModelOverrides[agentName]` takes precedence over that agent's prioritized frontmatter model list, then the parent/configured fallback. Role aliases expand through `modelRoles`. Dispatch selects an agent type, never a per-task model field. Removing an override restores the agent's normal resolution; it does **not** necessarily inherit the parent model because frontmatter can still choose one.

## 3. Interview and confirm every role

Show a table containing every workflow row below, its current agent or parent execution, current effective selector, configuration source, availability evidence, and proposed change. Mark unresolved selectors and unavailable agents as needing a choice. First offer **keep current routing**; do not substitute a new set of preferred models for working user configuration.

| Workflow role | Native execution policy |
| --- | --- |
| Feature and refactoring | Parent for coupled work; configured `task` for substantial implementation slices |
| Bug fix | Parent reasoning and reproduction; configured `task` for independent implementation |
| Performance issue | Parent diagnosis; configured `task` for substantive optimization work |
| Hillclimb | Configured `task` for reasoning/implementation candidates; `sonic` only for mechanical changes |
| Judgment and prose | Parent or configured general `task`; never offload judgment to `scout` or `sonic` |
| Hardest tasks | Parent's existing reasoning role or configured general `task` |
| How explorer | `scout` for code/search research after inline scoping |
| How explainer | Parent synthesis or configured general `task` |
| Why investigators | `scout` for evidence retrieval, configured general `task` for substantive reasoning |
| Why synthesizer | Parent or configured general `task` |
| Reflect tooling | `scout` for discovery, `sonic` for mechanical edits, general `task` for implementation |
| Reflect judgment, divergent work, and synthesis | Parent or configured general `task` |
| Arena runners | Ordered list of existing implementation/reasoning-capable agents |
| Arena cross-judge pool | Configured general `task` or existing explicitly compatible reasoning specialists for rubric scoring; prefer a model family different from the parent's when known |
| Swarm workers | Configured general `task`; `sonic` only for strictly mechanical slices |
| Architect runners | Ordered list of configured general `task` or existing explicitly compatible reasoning agents for design proposals and judgment |
| Interrogate reviewers | Ordered list of configured general `task` or existing explicitly compatible reasoning agents for custom scoring |
| Verification | Existing compatible `verifier` for independent executed proof, otherwise an explicitly disclosed configured general-task or parent path |

These are interview labels, **not new OMP settings keys**. Several rows deliberately share one agent mapping. Explain the blast radius: changing `task.agentModelOverrides.task`, for example, changes every subsequent use of that agent, not just bug fixes. Do not invent a workflow-to-role resolver or pretend different prose labels select different models.

Ask whether to keep everything or change specific mappings, whether the scope should be global/profile, project, or a temporary overlay, and what quality, latency, cost, privacy, or provider restrictions matter. Use the session's question tool when available, otherwise concise numbered questions. Offer only confirmed concrete selectors, already configured resolvable aliases, and **restore existing agent defaults**. For parent-executed work, keeping the active parent model is a legitimate no-change choice. If the user specifically wants workers to match the current parent, an approved explicit concrete mapping matches that model now, not dynamically after future parent switches. Do not write unsupported sentinel strings for inheritance or automatic routing.

### Panel choices

Read the exact consuming workflow before changing a panel plan: `skill://arena`, `skill://architect`, or `skill://interrogate`. Preserve their selection, ownership, and proof rules. Record an ordered roster and intended count in the parent-owned `local://` setup note, not an invented settings field. Each selected list entry represents an independent attempt, including repeated agent entries; repetitions are same-model attempts, not model diversity. The list length is the requested count, subject to the consuming skill's minimums and actual concurrency, spawn, depth, and plan-mode limits.

OMP model-role values are scalar selectors, not panel arrays. Existing appropriate agents with distinct configured routing can supply a multi-model panel; an agent frontmatter model list is a prioritized fallback list, not fan-out. Changing one agent's override cannot assign several simultaneous models to multiple instances of that same agent. Do not mutate settings between concurrent launches or add new required panel-agent definitions here. If the requested roster cannot be expressed through existing agents, explain the limitation and agree on an available roster or leave that request unapplied.

For Arena's cross-judge pool, choose one suitable configured general task agent or explicitly compatible reasoning specialist whose resolved family differs from the parent's when possible; bundled patch-only `reviewer` is not a rubric-scoring judge. If only one model is available, preserve independent review while disclosing reduced diversity. If identity is not exposed, diversity is unverified. Worker races and comparisons obey the consuming workflow's existing-agent selection rather than a model argument. A session-local panel note is advisory context, not a persistent runtime setting; report that distinction explicitly.

## 4. Validate the proposal before writing

Every new concrete selector must appear in the discovered set or be explicitly confirmed accessible by the user. Preserve the exact provider prefix; bare identifiers may resolve to a different provider. Only append supported thinking levels when the chosen model exposes them. Expand aliases to check that they resolve to confirmed selectors; reject unresolved aliases and cycles. Keep valid existing aliases instead of introducing equivalent new roles.

Confirm that every target agent actually exists, is enabled, and is permitted by the session's spawn policy. Configuring its model does not bypass those restrictions. Show the minimal before/after diff, affected workflow rows, target file/layer, any masking overrides, backup location, and rollback steps. Obtain explicit approval for that exact change. Approval to invoke setup is not approval to overwrite global preferences, install software, change credentials, broaden tool permissions, commit, or push.

## 5. Apply a reversible native configuration change

Prefer no change when current routing satisfies the interview. Otherwise:

1. Re-read the target routing sections immediately before editing so concurrent user changes survive. Save a byte-for-byte backup at an approved private sibling path, recording whether the target file or individual keys were originally absent. Preserve permissions and protect backups that may contain unrelated secrets.
2. Surgically edit only approved entries. Reuse existing `modelRoles` selectors and reference them with quoted aliases in `task.agentModelOverrides`. For example, **only if `@smol` and `@task` already resolve to the approved choices**, this partial mapping expresses fast research/mechanical work and general implementation:

   ```yaml
   task:
     agentModelOverrides:
       scout: "@smol"
       sonic: "@smol"
       task: "@task"
   ```

   This is an illustration, not a complete file or a default to install. Preserve reviewer/verifier choices unless explicitly approved; route them through an appropriate existing role or confirmed exact selector. Change `modelRoles` only when the user approves the other consumers affected by that role. Do not create custom roles merely to mirror every interview row.
3. For project settings, edit `<cwd>/.omp/config.yml` directly. For a one-shot overlay, write the approved minimal YAML mapping to an agreed local file and use `--config <file>` only for the intended run. For global/profile settings, edit the active existing YAML file. `omp config set` writes globally and accepts whole JSON objects for record keys; if used, merge with the target-layer record first and preserve every untouched entry. It is not a project-write command and cannot be used as a dotted per-agent shorthand unless the live schema explicitly provides that key.
4. Re-runs compare with the requested effective mapping and become no-ops when already satisfied. Never overwrite the whole settings file. Do not use `omp config reset` as rollback: it persists schema defaults rather than restoring prior values or inheritance. Roll back by restoring only the changed entries or removing newly added entries after checking for later edits; restore the complete backup only when no intervening changes would be lost.

## 6. Confirm what actually changed

Read back the changed keys and, in the same working-directory/profile context, the effective routing. Check the models listing for the approved selectors; an explicit overlay must be considered through an overlay-aware surface such as `omp models --config <file> --json`, not assumed to affect ordinary config commands. Report syntax/configuration failures instead of declaring success or silently falling back.

Give the user the target path and scope, approved mappings, preserved defaults, unresolved panel limitations, backup and rollback instructions, and checks actually performed. Task/eval preflight refreshes persisted settings and agent discovery for subsequent launches; already running agents keep their own configuration snapshots. New sessions load persistent changes, while an overlay applies only when supplied. Do not claim a model request or end-to-end workflow ran unless it did; setup need not incur paid agent calls. Re-running `skill://setup-hstack` revisits these choices.

## 7. Offer project verification once

Check whether the project already has a real-app harness or an applicable verification skill. If not, offer once: “Want a project-local verification skill so agents can drive the app the way a user does and prove changes work?” On yes, read and apply `skill://create-verification-skill` within the approved project scope. On no, continue without pushing. Reuse an existing harness rather than generating a duplicate. This offer is separate from permission to install dependencies, run external actions, or modify application code.
