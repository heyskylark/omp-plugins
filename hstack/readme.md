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

| Capability | Purpose |
| --- | --- |
| `/skill:architect` | Ground the system, compare distinct designs, synthesize caller-first types and boundaries, then implement and verify. |
| `/skill:how` | Trace runtime behavior, subsystem boundaries, and ownership from source evidence. |
| `/skill:why` | Investigate design rationale across history and available evidence sources. |
| `/skill:arena` | Compare independent candidates, cross-judge, select a base, synthesize, and verify. |
| `/skill:interrogate` | Challenge a design or change with independent reviews and return a categorized verdict. |
| `/skill:show-me-your-work` | Keep and audit a decision trail with concrete evidence and independent review. |
| `/skill:unslop` | Edit workflow prose and decision logs for clear, factual language. |
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

Architect composes `how` for runtime grounding, `why` for ownership and layering rationale, and `arena` for competing designs and synthesis. Request `interrogate` for adversarial design review. Supporting principle skills supply the design, implementation, and verification disciplines; each is installed alongside the workflows and loaded through its exact `skill://principle-...` name.

The workflows share OMP's existing runtime:

- **Orchestration:** native `task` batches for substantial independent work, `scout` for bounded research, and design-capable agents for candidate reasoning. Candidates return `agent://` artifacts; `hub` handles follow-up. Editing agents use isolation; tightly coupled edits stay with one owner.
- **Notepad:** a parent-owned `local://architect-notepad.md` or an existing scoped session artifact. There is no separate notepad tool, no concurrent note writers, and no Cursor workspace state. Session artifacts are not committed design documentation.
- **Progress:** the parent maintains OMP `todo`; children return results. A human approval checkpoint is distinct from OMP's context `checkpoint`/`rewind` tools.
- **Models:** existing agent configuration and `modelRoles` determine routing. No required architect role, hardcoded model IDs, external runner CLI, or unsupported per-task model argument. Distinct candidates need not use different models.
- **Restricted sessions:** honor exposed task schemas, spawn policies, recursion limits, and plan-mode restrictions. When delegation is unavailable or disproportionate, compare both designs inline and disclose that fact.
- **Dependencies:** supporting workflows and principle skills are bundled under `skills/`; each workflow reads and applies its named `skill://` dependencies. Skill-owned templates and playbooks remain under that skill's `references/` directory.
- **Delivery:** sketches remain session artifacts, not broken production scaffolds. Implementation must exercise the actual requested behavior before claiming completion.

### Supporting principles

Architect and its supporting workflows load these 14 bundled skills when their conditions apply:

- `principle-boundary-discipline`
- `principle-encode-lessons-in-structure`
- `principle-exhaust-the-design-space`
- `principle-fix-root-causes`
- `principle-foundational-thinking`
- `principle-guard-the-context-window`
- `principle-laziness-protocol`
- `principle-make-operations-idempotent`
- `principle-minimize-reader-load`
- `principle-outcome-oriented-execution`
- `principle-prove-it-works`
- `principle-redesign-from-first-principles`
- `principle-separate-before-serializing-shared-state`
- `principle-subtract-before-you-add`

The transitive chain includes `principle-minimize-reader-load` → `principle-guard-the-context-window` and `principle-prove-it-works` → `show-me-your-work` → `unslop`. `how` and `why` are conditional companions; they reuse completed findings rather than invoking each other recursively. The audit log writer and every source playbook are included in the package.

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
5. Follow every referenced skill through its upstream source and port its supporting dependency chain as OMP skills. Preserve explicit cross-skill calls rather than replacing them with inline summaries or declaring them unnecessary. If a referenced skill cannot be found upstream, report the missing dependency for a user decision; do not invent a replacement. Inspect every asset path, tool contract, and model assumption as part of the port.
6. Verify actual OMP discovery and `skill://` asset reads, package inclusion, and the changed workflow behavior. Keep the package and marketplace versions synchronized when releasing additions.

Runtime references: OMP [skills](https://github.com/can1357/oh-my-pi/blob/main/docs/skills.md), [task orchestration](https://github.com/can1357/oh-my-pi/blob/main/docs/tools/task.md), and [agent discovery/model routing](https://github.com/can1357/oh-my-pi/blob/main/docs/task-agent-discovery.md). The installed runtime exposes these as `omp://skills.md`, `omp://tools/task.md`, and `omp://task-agent-discovery.md`; prefer those when checking version-specific behavior.
