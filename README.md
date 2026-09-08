# OMP Plugin Stacks

Personal Oh My Pi capabilities grouped into independently installable stacks. Every top-level stack directory is an OMP plugin package with its own `package.json` and conventional OMP capability directories.

This repository uses OMP's native `.omp-plugin/marketplace.json` catalog. It contains no Cursor runtime manifests or Cursor-specific task syntax. Each stack's `THIRD_PARTY_NOTICES` records source attribution.

## Stacks

| Directory | Package | Purpose | Included capabilities |
| --- | --- | --- | --- |
| [`hstack/`](hstack/readme.md) | `@heyskylark/hstack` | General-purpose OMP development and verification workflows | `comment-sicko` and `verifier` agents plus `/skill:architect`, `/skill:no-comments`, `/skill:create-verification-skill`, and `/skill:maintain-verification-skill` |

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

Architect grounds the existing system, compares at least two structurally different designs, and synthesizes caller-first types and module boundaries before implementing and verifying. Add `with checkpoint` to review the design before code changes, or `design only` to stop with the design. It uses parent-owned OMP todos and `local://` notepads, native task orchestration, and bundled `skill://` references—not Cursor runners or uninstalled skills. See [HStack's README](hstack/readme.md) for the workflow and OMP authoring conventions.

HStack is influenced by [pstack](https://github.com/cursor/plugins/tree/main/pstack); adapted material is credited in [THIRD_PARTY_NOTICES](hstack/THIRD_PARTY_NOTICES).

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
