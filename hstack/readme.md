# HStack

General-purpose development workflows for [Oh My Pi](https://github.com/can1357/oh-my-pi), packaged as `@heyskylark/hstack`.

Source attribution and third-party license terms are in [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).

## Install

```sh
omp plugin marketplace add heyskylark/omp-plugins
omp plugin install hstack@omp-plugins
omp plugin doctor
```

For local development, run `omp plugin link ./hstack` from the repository root. Restart OMP after installation. After skill-only edits, use `/reload-plugins`; restart when agent definitions change. See the [repository README](../README.md) for scopes, updates, and removal.

## Capabilities

HStack 0.5.0 bundles **52 skills: 29 workflows and 23 principles**. `sky-mode` includes **23 playbooks**, a Bugbot triage reference, and portable plan/worktree helpers. These are instruction and reference assets, not additional executable OMP tools.

Invoke a workflow as `/skill:<name> [request]` when `skills.enableSkillCommands` is enabled. The exact names below also resolve through `skill://<name>`.

### Understand and design

| Skill | Purpose | Example |
| --- | --- | --- |
| `architect` | Ground the system, compare designs, then implement and verify the selected structure. | `/skill:architect Add a project-level settings API` |
| `how` | Trace runtime behavior, subsystem boundaries, and ownership from source evidence. | `/skill:how Trace cancellation from UI to worker` |
| `why` | Investigate design rationale across history and available evidence. | `/skill:why Why do jobs own their retry policy?` |
| `arena` | Compare independent candidates, cross-judge, and synthesize a design. | `/skill:arena Compare storage boundaries` |
| `interrogate` | Challenge a design or change with independent reviews and a categorized verdict. | `/skill:interrogate Review the proposed cache design` |
| `blast-radius` | Map affected callers, contracts, and behavior before changing a boundary. | `/skill:blast-radius Replace the session identifier type` |
| `figure-it-out` | Resolve an underspecified problem through investigation and evidence. | `/skill:figure-it-out Why does this import intermittently fail?` |

### Implement and coordinate

| Skill | Purpose | Example |
| --- | --- | --- |
| `sky-mode` | Select a task-appropriate playbook for sustained, evidence-backed execution. | `/skill:sky-mode Implement the agreed settings API` |
| `swarm` | Partition substantial independent work with explicit ownership and native task orchestration. | `/skill:swarm Migrate these independent adapters` |
| `tdd` | Drive a behavior change through a failing test, implementation, and refactoring. | `/skill:tdd Fix duplicate job delivery` |
| `typescript-best-practices` | Apply TypeScript domain modeling, type safety, and maintainable code conventions. | `/skill:typescript-best-practices Review src/session` |

### Explain and clean up

| Skill | Purpose | Example |
| --- | --- | --- |
| `bro` | Restate the last response in concise, plain language without jargon. | `/skill:bro` |
| `teach` | Explain a system or concept from concrete evidence at the requested depth. | `/skill:teach Explain how our queue handles retries` |
| `technical-writing` | Produce clear, structured technical documentation for its audience. | `/skill:technical-writing Write the migration guide` |
| `unslop` | Edit workflow prose and decision logs for clear, factual language. | `/skill:unslop Tighten this design note` |
| `deslop` | Remove unnecessary generated-code clutter while preserving behavior and local conventions. | `/skill:deslop Review the current diff` |
| `no-comments` | Audit and remove needless comments through `comment-sicko`. | `/skill:no-comments src/api` |
| `show-me-your-work` | Keep and audit a decision trail with concrete evidence and independent review. | `/skill:show-me-your-work Audit this implementation's decisions` |

### Verify and control

| Skill | Purpose | Example |
| --- | --- | --- |
| `control-cli` | Establish and use a real terminal/CLI control path for interactive evidence. | `/skill:control-cli Exercise the setup wizard` |
| `control-ui` | Establish and use available UI drivers to inspect and exercise the actual surface. | `/skill:control-ui Check the settings dialog` |
| `verify-this` | Turn a claim into a focused observable check and report its evidence. | `/skill:verify-this Confirm cancellation stops the running job` |
| `create-verification-skill` | Create and exercise a project-native real-surface verification skill. | `/skill:create-verification-skill` |
| `maintain-verification-skill` | Keep an existing verification skill aligned with the application. | `/skill:maintain-verification-skill` |

### Remember, author, and integrate

| Skill | Purpose | Example |
| --- | --- | --- |
| `recall` | Recover relevant prior context using available memory and evidence sources. | `/skill:recall Find the earlier storage decision` |
| `reflect` | Synthesize lessons and patterns from available history and evidence. | `/skill:reflect What did we learn from this migration?` |
| `automate-me` | Identify recurring work worth turning into a reusable workflow. | `/skill:automate-me Review my repeated release steps` |
| `setup-hstack` | Inspect installation and guide compatible OMP setup without replacing user configuration. | `/skill:setup-hstack Check this project's setup` |
| `make-bot-ui` | Build a local bot UI backed by a server adapter to OMP's stdio RPC. | `/skill:make-bot-ui Build a local task dashboard` |
| `create-skill` | Author a reusable OMP-native skill with its dependency and asset closure. | `/skill:create-skill Capture this repository's release workflow` |

### Task agents

- **`comment-sicko`** owns comment cleanup, with read-only scouts for independent research areas.
- **`verifier`** independently exercises completed changes; its `@verifier` selector requires `modelRoles.verifier` to be configured.
- **`sky-agent`** is an optional bounded worker that autoloads `sky-mode`, does not spawn children, and leaves orchestration and todos with the parent. It has no hardcoded model selector and is not a replacement for the configured general worker or native specialists.

The plugin supplies these agent definitions; their availability still depends on discovery, tool access, disabled-agent settings, and parent spawn policy.

## Sky-mode playbooks

Select `sky-mode` explicitly for the requested work. It is not a sticky or always-on OMP runtime mode, and it does not install an external orchestrator, bootstrap daemon, or PR-watching service.

| Area | Bundled playbooks |
| --- | --- |
| Program execution and planning | `autonomous-run`, `autopilot-full`, `autopilot-stack`, `orchestrate`, `multi-phase-plan` |
| Session and delivery | `babysit`, `opening-a-pr`, `shipping`, `pause-safely`, `session-pickup`, `worktree-cleanup` |
| Build and improve | `authoring-a-skill`, `feature`, `refactoring`, `prototype`, `bug-fix`, `eval`, `hillclimb` |
| Investigate and compare | `investigation`, `perf-issue`, `runtime-forensics`, `trace-forensics`, `visual-parity` |

For example, request `/skill:sky-mode Use the bug-fix playbook for the failed import` or `/skill:sky-mode Use session-pickup to resume the saved work`. The skill routes to its reference assets through `skill://sky-mode/...`; `check-plan.mjs` and `worktree-audit.sh` are portable helpers, not a custom runtime.

PR workflows use available `gh`/GitHub access and native OMP process/session coordination. Authentication, repository permissions, configured tools, and human approval gates remain prerequisites; installing HStack does not grant them.

## Architect

```text
/skill:architect Add a project-level settings API
/skill:architect with checkpoint Redesign job ownership
/skill:architect design only Compare storage boundaries
```

The default workflow continues through implementation and behavioral verification. `with checkpoint` stops after synthesis for your approval; `design only` delivers the design without implementation. Active OMP plan-mode restrictions always apply.

Architect composes `how` for runtime grounding, `why` for ownership and layering rationale, and `arena` for competing designs and synthesis. Request `interrogate` for adversarial design review. Supporting principle skills supply the design, implementation, and verification disciplines; each is installed alongside the workflows and loaded through its exact name, such as `skill://principle-foundational-thinking`.

The workflows share OMP's existing runtime:

- **Orchestration:** native `task` batches for substantial independent work, `scout` for bounded research, and design-capable agents for candidate reasoning. Candidates return `agent://` artifacts; `hub` handles follow-up. Editing agents use isolation; tightly coupled edits stay with one owner.
- **Notepad:** a parent-owned `local://architect-notepad.md` or an existing scoped session artifact. There is no separate notepad tool, no concurrent note writers, and no Cursor workspace state. Session artifacts are not committed design documentation.
- **Progress:** the parent maintains OMP `todo`; children return results. A human approval checkpoint is distinct from OMP's context `checkpoint`/`rewind` tools.
- **Models:** existing agent configuration and `modelRoles` determine routing. No required architect role, hardcoded model IDs, external runner CLI, or unsupported per-task model argument. Distinct candidates need not use different models.
- **Restricted sessions:** honor exposed task schemas, spawn policies, recursion limits, and plan-mode restrictions. When delegation is unavailable or disproportionate, compare both designs inline and disclose that fact.
- **Dependencies:** supporting workflows and principle skills are bundled under `skills/`; each workflow reads and applies its named `skill://` dependencies. Skill-owned templates and playbooks remain under that skill's `references/` directory.
- **Delivery:** sketches remain session artifacts, not broken production scaffolds. Exercise the requested behavior before claiming it verified. If the user explicitly defers runtime checks, preserve that boundary and report outstanding proof rather than asserting a pass.

### Supporting principles

The 23 bundled principles are available individually and loaded by workflows when their conditions apply:

| Skill | Purpose |
| --- | --- |
| `principle-attack-the-premise` | Challenge the underlying assumption before optimizing a proposed solution. |
| `principle-boundary-discipline` | Put contracts and responsibilities at explicit system boundaries. |
| `principle-build-the-lever` | Build reusable leverage when it reduces repeated work. |
| `principle-encode-lessons-in-structure` | Turn durable lessons into constraints and code structure. |
| `principle-exhaust-the-design-space` | Compare meaningfully different designs before choosing. |
| `principle-experience-first` | Start from the actual user experience and work backward. |
| `principle-fix-root-causes` | Repair the source of a failure instead of masking its symptom. |
| `principle-foundational-thinking` | Ground decisions in facts and fundamental constraints. |
| `principle-guard-the-context-window` | Preserve useful context and avoid redundant information. |
| `principle-laziness-protocol` | Question work that does not advance the requested outcome. |
| `principle-make-operations-idempotent` | Make repeated operations safe and predictable. |
| `principle-migrate-callers-then-delete-legacy-apis` | Complete caller migration and remove obsolete interfaces. |
| `principle-minimize-reader-load` | Reduce the information a reader must hold to understand the code. |
| `principle-model-the-domain` | Express domain concepts and invariants directly. |
| `principle-never-block-on-the-human` | Continue safe independent work while respecting genuine approval gates. |
| `principle-outcome-oriented-execution` | Organize work around observable outcomes rather than activity. |
| `principle-prove-it-works` | Support completion claims with evidence from the requested behavior. |
| `principle-redesign-from-first-principles` | Reconsider structure from requirements rather than inherited shapes. |
| `principle-separate-before-serializing-shared-state` | Split independent ownership before adding shared-state coordination. |
| `principle-sequence-verifiable-units` | Order work into units whose behavior can be checked. |
| `principle-subtract-before-you-add` | Remove unnecessary structure before introducing more. |
| `principle-test-behavior-not-implementation` | Test consumer-visible contracts rather than internal wiring. |
| `principle-type-system-discipline` | Use types to make valid states and operations explicit. |

For a focused review, use `/skill:principle-model-the-domain Review the job state model`. The transitive chain includes `principle-minimize-reader-load` → `principle-guard-the-context-window` and `principle-prove-it-works` → `show-me-your-work` → `unslop`. `how` and `why` reuse completed findings rather than invoking each other recursively.

## Configuration and integration boundaries

### Model routing and orchestration

HStack does not install provider credentials or replace configuration. Task model selection uses `task.agentModelOverrides[agentName]`, then the agent's frontmatter selectors, then the parent's active/default model fallback. Role aliases resolve through `modelRoles`; configure `verifier` there before using its agent. The companion [omp-configs](https://github.com/heyskylark/omp-configs) repository includes that role.

Select discovered agents by name rather than passing a nonexistent task-level model field. Native `scout`, `reviewer`, `security-reviewer`, `sonic`, and the configured general worker remain available according to the running session's policy. `sky-agent` is optional. Parents coordinate task batches, `hub`, todos, and session artifacts; skills do not supply a parallel Cursor runtime. Use the current exposed schemas rather than assuming optional fields or tools exist.

### Memory and reusable skills

Memory defaults to `off`. `recall` and `reflect` are workflow names, not promises that identically named tools are installed. A configured structured backend must expose the needed operation; Hindsight exposes `recall`, `retain`, and `reflect`, while other backend capabilities must be checked in the running session. With `local`, summary/lesson artifacts can provide context, but structured `recall`, `retain`, `reflect`, and `memory_edit` are unavailable. With `off`, do not claim persistent memory coverage. Available session/history and repository evidence are explicit fallbacks, and remembered claims must be checked against current state.

Write authored project skills to `.omp/skills/<name>/SKILL.md`, or package skills to `skills/<name>/SKILL.md`. `create-skill` does not require the managed store. Optional `manage_skill` is enabled by `autolearn.enabled` independently of the memory backend; it only creates, updates, or deletes managed skills under the agent's managed-skills directory. It cannot edit authored skills, and authored names take precedence. Subagents require explicit access to that optional tool.

### Real surfaces and bot integrations

`control-cli`, `control-ui`, and verification workflows require a real driver for the target surface. Browser, terminal, native, and MCP capabilities vary by installation; a skill cannot conjure an unavailable driver. Report inaccessible surfaces and deferred checks separately from exercised behavior.

`make-bot-ui` builds a local server adapter that launches `omp --mode rpc` and bridges a browser to JSONL over stdio. OMP RPC is not an HTTP webhook, browser endpoint, hosted bot service, or permission bypass. The adapter owns transport, process lifecycle, request correlation, and access control; it must distinguish prompt acceptance from completion events. Keep credentials and the child process on the server side.

## OMP layout and authoring rules

```text
hstack/
├── package.json
├── readme.md
├── THIRD_PARTY_NOTICES
├── agents/
│   └── <agent>.md
└── skills/
    └── <skill>/
        ├── SKILL.md
        └── references/
```

Every new skill must fit OMP's existing runtime:

1. Put `SKILL.md` exactly one level below `skills/`; nested grouping directories are not discovered. Include explicit `name` and concrete `description` frontmatter. HStack's manual workflows use `disable-model-invocation: true`, which hides automatic model selection without disabling `/skill:<name>` invocation.
2. Keep assets inside their skill directory and reference them with `skill://<name>/<path>`. Project-generated skills follow `.omp/skills/<name>/SKILL.md`.
3. Use native orchestration and session artifacts as described above. Check the currently exposed tool schemas; never assume optional task fields or drivers are enabled.
4. Add agents only when a dedicated tool/model policy earns its maintenance cost. Use OMP agent frontmatter in `agents/<name>.md` (or `.omp/agents/` for project agents). Role aliases resolve through `modelRoles` in `.omp/config.yml` or `~/.omp/agent/config.yml`; do not overwrite the user's configuration to install a skill.
5. Follow every referenced skill through its upstream source and port its supporting dependency chain as OMP skills. Preserve explicit cross-skill calls rather than replacing them with inline summaries or declaring them unnecessary. If a referenced skill cannot be found upstream, report the missing dependency for a user decision; do not invent a replacement. Inspect every asset path, tool contract, and model assumption as part of the port.
6. Check package inclusion, dependency closure, and compatibility with the current OMP schemas. Exercise discovery, `skill://` asset reads, and changed workflow behavior when runtime validation is authorized. If the user explicitly defers it, record the unperformed checks in the task or release handoff; do not run them anyway or claim runtime proof. Keep package and marketplace versions synchronized when releasing additions.

Runtime references: OMP [skills](https://github.com/can1357/oh-my-pi/blob/main/docs/skills.md), [memory](https://github.com/can1357/oh-my-pi/blob/main/docs/memory.md), [managed skills](https://github.com/can1357/oh-my-pi/blob/main/docs/tools/manage_skill.md), [RPC](https://github.com/can1357/oh-my-pi/blob/main/docs/rpc.md), and [agent discovery/model routing](https://github.com/can1357/oh-my-pi/blob/main/docs/task-agent-discovery.md). The installed runtime exposes these as `omp://skills.md`, `omp://memory.md`, `omp://tools/manage_skill.md`, `omp://rpc.md`, and `omp://task-agent-discovery.md`; prefer those for version-specific behavior.
