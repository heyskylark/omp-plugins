---
name: create-verification-skill
description: Generate and prove a project-local OMP skill that drives the real application through its user surface and captures durable evidence. Use for /skill:create-verification-skill or when a repository lacks an executable behavioral verification workflow.
disable-model-invocation: true
---

# Create an OMP verification skill

Create a project-local verification capability at `.omp/skills/verify-<app>/`. The result is operational guidance for a future OMP agent arriving cold in the repository, not a human-oriented testing essay.

## 1. Interview the repository

Resolve facts from source, configuration, existing scripts, current documentation, and installed tools before asking the user:

- **Surface:** the real user surface: web, native mobile, desktop, CLI/TUI, HTTP service, library, or several coordinated surfaces.
- **Run:** the repository-owned launch/build command, environment, ports, seed data, authentication, device/runtime, and readiness signal.
- **Drive:** existing harnesses first. Prefer a specialized OMP tool or MCP driver over raw shell control: `browser` for web, Maestro MCP/CLI for mobile, `hub`-supervised PTYs for CLI/TUI, and direct HTTP for services.
- **Observe:** screenshots, accessibility trees, recordings, transcripts, response bodies, logs, exit codes, files, database rows, native traces, and other user-visible side effects.
- **Isolate:** whether concurrent runs can use unique ports, data roots, app identifiers, simulator/emulator instances, or profiles. If not, require exclusive use and never drive an instance the run did not launch and doctor.

For two or more independent surfaces or feature areas, perform discovery with one OMP `task` batch of read-only `scout` agents. Define shared `# Goal`, `# Constraints`, and `# Contract`; give every child an exact `# Target`, `# Change`, and `# Acceptance`. Scouts do not edit, build, start services, or run tests. Stay the integration owner and verify their evidence.

If the checkout cannot build or launch, fix the source problem first when it is in scope. Otherwise report the exact blocker. Never encode a broken assumption into the generated skill.

## 2. Generate the native OMP skill

Write `.omp/skills/verify-<app>/SKILL.md`. OMP scans skills one level below `.omp/skills`; do not add another grouping directory. Frontmatter must include explicit `name: verify-<app>` and a concrete `description` naming the app, surface, and trigger.

Ground these sections in observed repository facts. Leave no placeholders:

### Scope

Name supported surfaces, required runtimes, exclusive resources, and explicit non-goals.

### Launch

Give exact application and argument arrays. Long-lived servers, emulators, simulators, watchers, and interactive programs must use OMP `hub` process supervision:

- `start` with a stable project-scoped name;
- readiness by a real log expression and/or accepting TCP port;
- `logs` with cursors for diagnosis;
- `send` for PTY input;
- `stop` for teardown.

Never background a process with shell syntax and never kill an unverified PID or process name. A short-lived command may use `bash` directly.

### Doctor

Provide one read-only diagnostic that proves the intended build, process, device, account, test data, and driver are usable. Run it before the first drive and after any surprising failure.

### Drive

Use real stable selectors and commands from the repository. Prefer accessibility labels, identifiers, roles, prompt strings, and route paths over coordinates or tab order. When a project MCP server exposes the driver, name its tools and use them before lower-level CLI equivalents.

### Evidence

Name a repository-ignored artifact root outside cleanup state. Every proof must capture the user action and resulting state, not only a final screenshot. Pair visible proof with read-only verification of durable side effects. Use OMP `read` to inspect captured images/documents and `artifact://` or explicit paths when evidence spills from tool output. Do not claim a visual result from an exit code.

### Performance

When applicable, distinguish debug diagnosis from release/profile acceptance. Name exact native tracing tools, build modes, device identity, metrics, baseline comparison, and artifact paths. Do not treat emulator timing as physical-device performance evidence.

### Cleanup

Stop only `hub` processes started by the run. Remove scratch state, not evidence. Failed iterations receive the same cleanup. Verify that evidence survives teardown.

### Helpers

Every shipped helper must be executable, narrowly scoped, and invoked literally in the skill. Prefer repository-native scripts. Do not make a future agent reverse-engineer a helper.

## 3. Seed the feature map

Create `.omp/skills/verify-<app>/features/README.md` and one file for each of the top three to five user-facing features identified from real routes, commands, screens, menus, or documentation. Use `skill://create-verification-skill/references/feature-map-example/README.md` and `skill://create-verification-skill/references/feature-map-example/sample-feature.md` as the shape.

Each feature file contains an H1, a user-visible description, and exactly these H2 sections in order:

1. `Sub-features`
2. `How to get to it (user POV)`
3. `Driving it with <harness>`
4. `Gotchas`

Map every distinct user entry point. A convenient alternate path does not prove an unexercised entry point.

## 4. Add OMP integration only when it earns its weight

A skill is usually sufficient. If the repository repeatedly delegates verification or needs a restricted tool/model policy, add `.omp/agents/<agent>.md` with explicit `name`, `description`, `model: "@<role>"`, least-privilege `tools`, and `autoloadSkills: [verify-<app>]`. Add the concrete role mapping under `.omp/config.yml#modelRoles` without replacing existing project settings.

For a device-aware driver offering MCP, use `.omp/mcp.json` with the OMP schema, a full executable path when GUI/minimal environments may lack `PATH`, and explicit required environment such as `JAVA_HOME`. Project MCP configuration is executable trusted input; keep it minimal and reviewable.

## 5. Prove the generated skill

Execute its own instructions once end to end:

1. launch;
2. doctor;
3. drive one mapped feature through the real user surface;
4. inspect the captured evidence with the appropriate OMP reader/tool;
5. clean up;
6. confirm the evidence remains.

Fix failed instructions and repeat the affected path. Always clean residue after a failed attempt. A skill that was not exercised is a draft, not a deliverable.

## 6. Report

Report the skill path, mapped features, installed or reused harness, exact live scenario exercised, retained evidence, cleanup result, and any physical-device-only or externally blocked coverage. Point the user to `/skill:maintain-verification-skill` for upkeep.
