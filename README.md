# OMP Plugin Stacks

Personal Oh My Pi capabilities grouped into independently installable stacks. Every top-level stack directory is an OMP plugin package with its own `package.json` and conventional OMP capability directories.

This repository uses OMP's native `.omp-plugin/marketplace.json` catalog. It contains no Cursor runtime manifests or Cursor-specific task syntax. Each stack's `THIRD_PARTY_NOTICES` records source attribution.

## Stacks

| Directory | Package | Purpose | Included capabilities |
| --- | --- | --- | --- |
| [`hstack/`](hstack/readme.md) | `@heyskylark/hstack` | General-purpose OMP development and verification workflows | 52 skills: 29 workflows and 23 principles, including explicitly selected `sky-mode` with 23 playbooks; native task agents for cleanup and verification |

Future stacks should use the same layout:

```text
<stack>/
├── package.json
├── agents/
│   └── <agent>.md
└── skills/
    └── <skill>/
        └── SKILL.md
```

## Install HStack

### OMP marketplace

Add this repository as an OMP marketplace, then install HStack:

```sh
omp plugin marketplace add heyskylark/omp-plugins
omp plugin install hstack@omp-plugins
```

The default user scope makes HStack available in every project. To install only for the current project:

```sh
omp plugin install --scope project hstack@omp-plugins
```

Verify the installation:

```sh
omp plugin list
omp plugin doctor
```

Restart OMP after installation so it discovers the stack's agents and skills.

### Local development

Clone the repository and link the package:

```sh
git clone https://github.com/heyskylark/omp-plugins.git ~/git/omp-plugins
cd ~/git/omp-plugins
omp plugin link ./hstack
```

The link points at the checkout rather than copying it. Pulling or editing `hstack/` therefore updates the files used by newly started OMP sessions.

For a project-scoped development link, run from the target project:

```sh
cd /path/to/target-project
omp plugin link --scope project ~/git/omp-plugins/hstack
```


## Use HStack

HStack 0.5.0 includes the following workflow groups. Invoke an exact skill name with `/skill:<name> [request]` when skill commands are enabled; the [full catalog](hstack/readme.md#capabilities) describes each workflow and all 23 principles.

| Group | Skills | Example |
| --- | --- | --- |
| Understand and design | `architect`, `how`, `why`, `arena`, `interrogate`, `blast-radius`, `figure-it-out` | `/skill:blast-radius Change the session ownership contract` |
| Implement and coordinate | `sky-mode`, `swarm`, `tdd`, `typescript-best-practices` | `/skill:sky-mode Implement the agreed settings API` |
| Explain and clean up | `bro`, `teach`, `technical-writing`, `unslop`, `deslop`, `no-comments`, `show-me-your-work` | `/skill:technical-writing Rewrite the API migration guide` |
| Verify and control | `control-cli`, `control-ui`, `verify-this`, `create-verification-skill`, `maintain-verification-skill` | `/skill:verify-this Confirm that cancellation stops the running job` |
| Remember, author, and integrate | `recall`, `reflect`, `automate-me`, `setup-hstack`, `make-bot-ui`, `create-skill` | `/skill:create-skill Capture this repository's release workflow` |

The [23 supporting principles](hstack/readme.md#supporting-principles) include nine additional disciplines: `principle-attack-the-premise`, `principle-build-the-lever`, `principle-experience-first`, `principle-migrate-callers-then-delete-legacy-apis`, `principle-model-the-domain`, `principle-type-system-discipline`, `principle-never-block-on-the-human`, `principle-sequence-verifiable-units`, and `principle-test-behavior-not-implementation`. Use them directly for focused work, for example `/skill:principle-model-the-domain Review the job state model`, or through the workflows that load them.

`sky-mode` is an explicitly requested workflow, not an always-on runtime mode. Its 23 playbooks cover investigation, planning, implementation, review, and delivery; it uses native OMP orchestration rather than installing a separate runner. The bundled `sky-agent` is an optional bounded worker that autoloads this skill, does not spawn children, and leaves orchestration and todos with its parent.

### Runtime and configuration boundaries

- Skills provide instructions, not new tool APIs. `task`, `hub`, parent-owned `todo`, session artifacts, and available native/MCP drivers carry out the work. Tool access, agent policies, recursion limits, credentials, and plan-mode restrictions still apply.
- Agent models route through existing configuration (`task.agentModelOverrides`, agent frontmatter, and `modelRoles`), not hardcoded model lists or a custom per-task model field. Preserve user settings; `setup-hstack` inspects and guides configuration rather than replacing it.
- `recall` and `reflect` use structured memory only when the configured backend exposes the corresponding tools. Memory defaults to `off`; `local` supports summary/lesson artifacts but not structured recall/reflect. Available session or repository evidence is an explicit fallback, not equivalent memory coverage.
- Authored skills belong in `.omp/skills/<name>/SKILL.md` or a package's `skills/<name>/SKILL.md`. Optional `manage_skill` requires `autolearn.enabled` and writes only the managed store; it does not edit authored skills.
- `make-bot-ui` builds an application integration around `omp --mode rpc` (JSONL over stdio). A user-built local server adapter must bridge a browser to that process; OMP does not supply a native HTTP webhook or hosted bot service.
- Verification claims require observed evidence. If you explicitly defer runtime checks, the workflow must report what remains unverified instead of treating source review as a runtime pass.

### Comment cleanup

Run the workflow manually:

```text
/skill:no-comments
```

Optionally append a file, directory, range, or diff scope:

```text
/skill:no-comments src/api
```

The skill uses OMP's `task` tool to spawn `comment-sicko`. For broad scopes, that agent partitions independent search areas and dispatches one parallel batch of read-only `scout` agents. Scouts report evidence only; `comment-sicko` validates their findings and performs comment deletions centrally.

OMP's default `task.maxRecursionDepth` of `2` supports this topology:

```text
main OMP agent
└── comment-sicko
    └── scout agents
```

If an installation lowers the recursion limit or restricts the `task` tool, `comment-sicko` searches directly rather than shrinking the audit.

## Design before implementation

```text
/skill:architect Add a project-level settings API
/skill:architect with checkpoint Redesign job ownership
```

Architect runs `how` for runtime grounding, `why` for ownership rationale, and `arena` to compare and synthesize structurally distinct designs before implementing and verifying. Add `with checkpoint` to review the design before code changes, or `design only` to stop with the design; request `interrogate` for adversarial review. These supporting workflows and their principle skills are bundled with HStack and use parent-owned OMP todos, `local://` notepads, and native orchestration. See [HStack's README](hstack/readme.md) for usage and authoring conventions.

## Use verification workflows

Generate and execute a project-native verification skill:

```text
/skill:create-verification-skill
```

Audit its feature map and live-driving instructions after product changes:

```text
/skill:maintain-verification-skill
```

Generated skills live at `.omp/skills/verify-<app>/`. HStack uses OMP `task` batches for read-only source waves, `hub` for supervised process lifecycles, `skill://` references for skill-owned assets, and native/MCP drivers for real-surface evidence.

## Use the verifier agent

HStack installs `verifier`, a read-only task agent for independently exercising completed changes. It resolves its model through the `@verifier` role, so define that role under `modelRoles` in OMP configuration before delegating work to it. The companion [`omp-configs`](https://github.com/heyskylark/omp-configs) repository includes this role.

## Update plugin stacks

Refresh the marketplace catalog and upgrade the installed plugin:

```sh
omp plugin marketplace update omp-plugins
omp plugin upgrade hstack@omp-plugins
```

`marketplace update` refreshes metadata; `plugin upgrade` installs the newer declared version. For a local link, update the checkout instead:

```sh
git -C ~/git/omp-plugins pull --ff-only
```

After an update, run `/reload-plugins` for skills and commands. Restart OMP when agent definitions, tools, hooks, or extension modules change.

## Remove plugin stacks

Remove user-scoped installs:

```sh
omp plugin uninstall hstack@omp-plugins
```

For a project-scoped install:

```sh
omp plugin uninstall --scope project hstack@omp-plugins
```
