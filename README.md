# OMP Plugin Stacks

Personal Oh My Pi agents and skills, grouped into independently installable stacks. Each top-level stack directory is its own OMP plugin package, so a user or project can install only the capabilities it needs.

## Stacks

| Directory | Package | Purpose | Included capabilities |
| --- | --- | --- | --- |
| [`hstack/`](hstack/) | `@heyskylark/hstack` | General-purpose personal development workflows. | `comment-sicko` agent and the manual `/skill:no-comments` cleanup workflow. |

Future stacks should live in their own top-level directories with independent `package.json` manifests and conventional OMP `agents/` and `skills/` directories. This keeps installation, versioning, and capability discovery isolated per stack.

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

OMP links the local directory rather than copying it. Changes made in `hstack/` are therefore available to newly started OMP sessions without reinstalling the plugin.

### User level

A user-level link makes HStack available to OMP sessions in every project:

```sh
cd /Users/skylark/git/omp-plugins
omp plugin link ./hstack --scope=user
```

Verify the link:

```sh
omp plugin list
```

### Project level

A project-level link makes HStack available only when OMP runs in that project. Run the command from the target project, not from this plugin repository:

```sh
cd /path/to/target-project
omp plugin link /Users/skylark/git/omp-plugins/hstack --scope=project
```

Verify the link from the same project:

```sh
omp plugin list
```

Restart OMP after linking so it discovers the stack's agents and skills.

## Use HStack

Run the comment-cleanup workflow manually:

```text
/skill:no-comments
```

Optionally append a file, directory, range, or diff scope:

```text
/skill:no-comments src/api
```

The skill delegates its comment-only audit to the `comment-sicko` custom agent, reviews the applied changes, and owns any accepted root-cause fixes and verification.

## Remove HStack

Remove a user-level link:

```sh
omp plugin uninstall @heyskylark/hstack --scope=user
```

For a project-level link, run the corresponding command from that project:

```sh
omp plugin uninstall @heyskylark/hstack --scope=project
```
