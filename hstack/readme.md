# HStack

General-purpose development workflows for [Oh My Pi](https://github.com/can1357/oh-my-pi), packaged as `@heyskylark/hstack`.

HStack is influenced by [pstack in cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack). Its comment cleanup, verification, and architect workflows are adapted for OMP—not copied as Cursor runtime integrations. Source attribution and the upstream MIT license are in [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES).

## Install

```sh
omp plugin marketplace add heyskylark/omp-plugins
omp plugin install hstack@omp-plugins
omp plugin doctor
```

For local development, run `omp plugin link ./hstack` from the repository root. Restart OMP after installation. After skill-only edits, use `/reload-plugins`; restart when agent definitions change. See the [repository README](../README.md) for scopes, updates, and removal.

## Capabilities

| Capability | Purpose |
| --- | --- |
| `/skill:architect` | Ground the system, compare distinct designs, synthesize caller-first types and boundaries, then implement and verify. |
| `/skill:no-comments` | Audit and remove needless comments through the `comment-sicko` agent. |
| `/skill:create-verification-skill` | Create and exercise a project-native real-surface verification skill. |
| `/skill:maintain-verification-skill` | Keep an existing verification skill aligned with the application. |
| `comment-sicko` agent | Own comment cleanup, with read-only scouts for independent research areas. |
| `verifier` agent | Independently exercise completed changes; requires a configured `modelRoles.verifier` mapping. |

## Architect

```text
/skill:architect Add a project-level settings API
/skill:architect with checkpoint Redesign job ownership
/skill:architect design only Compare storage boundaries
```

The default workflow continues through implementation and behavioral verification. `with checkpoint` stops after synthesis for your approval; `design only` delivers the design without implementation. Active OMP plan-mode restrictions always apply.

Architect preserves the useful parts of [pstack's architect](https://github.com/cursor/plugins/tree/main/pstack/skills/architect): caller-first usage, at least two structurally distinct designs, interface-depth screening, explicit rationale, and redesign when repeated implementation friction exposes a wrong boundary.

The OMP adaptation is self-contained:

- **Orchestration:** native `task` batches for substantial independent work, `scout` for bounded research, and design-capable agents for candidate reasoning. Candidates return `agent://` artifacts; `hub` handles follow-up. Editing agents use isolation; tightly coupled edits stay with one owner.
- **Notepad:** a parent-owned `local://architect-notepad.md` or an existing scoped session artifact. There is no separate notepad tool, no concurrent note writers, and no Cursor workspace state. Session artifacts are not committed design documentation.
- **Progress:** the parent maintains OMP `todo`; children return results. A human approval checkpoint is distinct from OMP's context `checkpoint`/`rewind` tools.
- **Models:** existing agent configuration and `modelRoles` determine routing. No required architect role, hardcoded model IDs, external runner CLI, or unsupported per-task model argument. Distinct candidates need not use different models.
- **Restricted sessions:** honor exposed task schemas, spawn policies, recursion limits, and plan-mode restrictions. When delegation is unavailable or disproportionate, compare both designs inline and disclose that fact.
- **References:** bundled candidate instructions, rationale template, and design red flags resolve through `skill://architect/references/`. No dependency on uninstalled pstack skills.
- **Delivery:** sketches remain session artifacts, not broken production scaffolds. Implementation must exercise the actual requested behavior before claiming completion.

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

Every new skill must fit OMP's existing runtime rather than introduce a parallel Cursor configuration:

1. Put `SKILL.md` exactly one level below `skills/`; nested grouping directories are not discovered. Include explicit `name` and concrete `description` frontmatter. HStack's manual workflows use `disable-model-invocation: true`, which hides automatic model selection without disabling `/skill:<name>` invocation.
2. Keep assets inside their skill directory and reference them with `skill://<name>/<path>`. Project-generated skills follow `.omp/skills/<name>/SKILL.md`.
3. Use native orchestration and session artifacts as described above. Check the currently exposed tool schemas; never assume optional task fields or drivers are enabled.
4. Add agents only when a dedicated tool/model policy earns its maintenance cost. Use OMP agent frontmatter in `agents/<name>.md` (or `.omp/agents/` for project agents). Role aliases resolve through `modelRoles` in `.omp/config.yml` or `~/.omp/agent/config.yml`; do not overwrite the user's configuration to install a skill.
5. Inspect every imported dependency, prompt, asset path, and model assumption. Inline essential guidance or bundle it locally; do not leave references to unavailable foreign-harness skills.
6. Verify actual OMP discovery and `skill://` asset reads, package inclusion, and the changed workflow behavior. Keep the package and marketplace versions synchronized when releasing additions.

Runtime references: OMP [skills](https://github.com/can1357/oh-my-pi/blob/main/docs/skills.md), [task orchestration](https://github.com/can1357/oh-my-pi/blob/main/docs/tools/task.md), and [agent discovery/model routing](https://github.com/can1357/oh-my-pi/blob/main/docs/task-agent-discovery.md). The installed runtime exposes these as `omp://skills.md`, `omp://tools/task.md`, and `omp://task-agent-discovery.md`; prefer those when checking version-specific behavior.
