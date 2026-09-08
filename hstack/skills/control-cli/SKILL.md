---
name: control-cli
description: Drive interactive CLIs and TUIs through managed local PTYs, reproduce keyboard and prompt flows, compare startup and memory behavior, investigate hangs, and retain terminal recordings and profiling evidence.
disable-model-invocation: true
---

# Control CLI

Exercise the real interactive program through a repeatable local session. Reuse the repository's existing test/demo harness when it supplies app-specific setup, terminal emulation, or recording; run that harness under `hub`. Otherwise use a `hub`-managed PTY directly. Do not build a separate daemon or worker fleet.

## When to use

- Reproduce CLI/TUI failures with deterministic input.
- Verify keyboard flows, prompts, interrupts, and, when supported by an existing harness, resize behavior and terminal layout.
- Capture before/after evidence for fixes.
- Profile startup regressions, slow operations, memory growth, and hangs.
- Record a short terminal demo when the user asks and output is clearer than prose.

## Scope and ownership

1. Identify the executable, arguments, working directory, smallest reproducible fixture, expected outcome, and safe exit action. Inspect package scripts, e2e tests, demo recorders, Expect scripts, and PTY helpers with `read`, `grep`, and `glob` before inventing setup.
2. Record runtime version, relevant non-secret environment, fixture, and command. Use a disposable workspace for operations that change data. Set deterministic locale, timezone, seed, and application configuration only where the app supports them; keep baseline and treatment identical.
3. Inspect `hub` with `op: "ps"` and, for any name you might reuse, `op: "describe"`. Pick a unique project-scoped name of at most 48 characters. Never restart, send input to, or stop someone else's process without authorization. Project clients share names and one input stream: designate exactly one driver.
4. Keep temporary fixture/harness files in a scoped temporary directory. Retain evidence separately from disposable setup. Do not hard-code paths from a different repository. Do not install dependencies or enable privileged profiling without authorization.
5. Read `omp://tools/hub.md`, `omp://tools/bash.md`, and `omp://tools/debug.md` when capabilities or syntax are uncertain. Use finite `bash` calls for a runtime version or standalone measurement, not for a service, watcher, REPL, or interactive process requiring later input. Those belong to `hub`.

## Managed PTY loop

Use `application` and `args` rather than a quoted shell command. The following calls illustrate the sequence; replace the executable, arguments, directory, process name, and expected patterns with values established from the repository. They are tool arguments, not shell commands.

### Start and observe readiness

```json
{"op":"start","name":"cli-check","application":"node","args":["./bin/cli.js"],"cwd":"/absolute/path/to/fixture","env":{"TZ":"UTC"},"pty":true,"ready":{"log":"Command> ","timeout":30},"restart":"no"}
```

`pty` defaults to true. Leave `persist` and `detached` unset: the default session should be owned and cleaned up here. Detached mode forces a non-PTY process and disables stdin. Do not use it for interactive driving.

Readiness must be observed, not inferred from successful process creation. A readiness log is a JavaScript regular expression, not a PCRE expression; use `[Rr]eady`, not inline flags. A port condition is useful for a CLI's local service, but it alone does not prove a prompt is ready. When log and port conditions are both supplied, both must pass. A readiness timeout leaves the process running: inspect logs and state, collect evidence, then stop your process if the scenario cannot continue.

```json
{"op":"logs","name":"cli-check","lines":100}
```

Capture the initial output before interacting. Treat it as a transcript, not automatically as the current rendered terminal screen; see the limitations below.

### Act once, then wait for an observable transition

```json
{"op":"send","name":"cli-check","text":"help"}
{"op":"wait","name":"cli-check","pattern":"Available commands:","timeout":10}
{"op":"logs","name":"cli-check","lines":100}
```

Text sends append Enter by default. Use `enter: false` when testing partial entry, editing, or completion. Send arrows, Escape, Tab, and interrupts as keys:

```json
{"op":"send","name":"cli-check","text":"hel","enter":false}
{"op":"send","name":"cli-check","keys":["TAB"]}
```

Supported keys are `ENTER`, `TAB`, `ESCAPE`, `CTRL_C`, `CTRL_D`, `UP`, `DOWN`, `LEFT`, and `RIGHT`. Do not invent key names or a resize operation. Capture evidence after each meaningful action before sending the next one.

Use bounded pattern waits for prompts and bounded lifecycle waits for exit. Choose a pattern unique to the expected transition. If the same prompt existed earlier, do not accept an old match as proof of a new transition: save the cursor returned by `logs` before the action, then call `logs` with `follow: true` and that actual cursor, examine the newly returned output, and advance the cursor until the expected new output or the scenario deadline. A follow timeout or exit without the expected output is not success. Preserve the deadline across repeated waits; do not reset it indefinitely.

```json
{"op":"wait","name":"cli-check","for":"exit","timeout":10}
```

Prefer observable conditions over sleeps. If a timing-only animation requires a delay, state why no stronger signal exists and use a bounded delay in the existing harness; do not use timing alone to assert completion.

### Exit and clean up

Use the application's normal safe exit action first. For an interrupt scenario, capture the state before sending `CTRL_C`, then verify the expected prompt recovery or exit. Collect final logs and process state.

```json
{"op":"send","name":"cli-check","keys":["CTRL_C"]}
{"op":"wait","name":"cli-check","for":"exit","timeout":10}
{"op":"logs","name":"cli-check","lines":100}
{"op":"describe","name":"cli-check"}
```

If the owned process is still running, call `hub` with `op: "stop"` and its verified name. `stop` performs process-tree cleanup, with graceful termination before escalation. Do not kill an unverified PID through the shell. Capture evidence before cleanup; a forced shutdown can destroy a hang's most useful state or prevent a profiler/recorder from flushing.

## Terminal rendering and resize limits

The managed PTY provides terminal input, captured output, and process state. The public `hub` schema does **not** expose terminal geometry settings, resize, an ANSI screen emulator, screenshots, or a timed recording exporter. Log rows and raw escape sequences are not visual proof of cursor placement, alternate-screen behavior, clipping, wrapping, colors, or resize handling. Setting `COLUMNS`/`LINES` environment variables is not equivalent to changing PTY geometry and delivering a resize event.

For a layout/resize assertion, first reuse the repository's existing PTY or demo harness, supervised by `hub`. Inspect its documented interface before use. It must provide the actual missing capability: real geometry changes, screen emulation or rendering, bounded pattern waits, and capture of the asserted state. Use its control channel rather than sending a guessed control protocol into application stdin. Ensure the harness owns and terminates its child process and closes PTY descriptors on both success and failure. Keep input replay deterministic and preserve raw output alongside rendered evidence.

A repository's Python/Node/Expect PTY helper can supply richer controlling-terminal behavior when needed. Prefer it over creating another generic harness. A raw PTY reader without an ANSI emulator still cannot prove layout. If no suitable harness or rendering capability exists, report the precise unsupported checks; verify the reachable prompt/keyboard/output behavior through `hub`, but do not claim resize or visual verification. Do not substitute a hand-built terminal multiplexer daemon as the primary mechanism.

## Profiling recipes

Keep a baseline and treatment under the same command, fixture, environment, machine, runtime, and terminal conditions. Record the trigger, duration, run count, and relevant measurement boundaries. Save raw measurements, not just conclusions. Separate profiler overhead from uninstrumented measurements.

### Startup regression

Measure from process launch to the same application-ready marker, not merely shell return or successful spawn. Use the repository's startup benchmark if available; otherwise record a bounded monotonic launch-to-readiness interval from the driving code and disclose tool/transport overhead. A `hub` start result is not itself a precise startup benchmark. Repeat comparable runs, distinguish cold from warm state, and compare the distribution rather than a single anecdotal result. A finite timing command may measure total runtime for a non-interactive startup-and-exit path, but label that boundary accurately.

### Slow operation

1. Launch the owned CLI with its runtime's supported local profiling flags or existing profiler integration. For Node, `--inspect=127.0.0.1:0` can be supplied through `NODE_OPTIONS` at launch, preserving any required existing options. Read the actual inspector endpoint from output; do not guess a port or expose it on a public interface.
2. Use installed, runtime-compatible local inspector tooling. A Bun inspector is not assumed to implement Node's Chrome protocol. Discover the application's/runtime's supported mechanism first.
3. Start a CPU profile, perform exactly the slow operation, wait for its completion marker, stop and save the profile, then compare top self-time functions and call paths with the baseline.
4. If profiler automation is unavailable, state that limitation rather than fabricating a profile. Do not invoke nonexistent `debug` profiling actions: OMP's performance/heap UI menu routes are not model-callable DAP actions and profile OMP itself, not automatically the target CLI.

### Memory leak

Take a baseline heap snapshot after forced GC if the target exposes a supported GC operation. Perform the operation a recorded number of times, wait for quiescence, force GC again when available, and take a second snapshot. Compare retained objects and retaining paths, not just allocation counts or peak RSS. Record when GC is unavailable; heap retention and process RSS are different measurements. Repeat enough to distinguish one-time caches from growth. Heap snapshots can contain secrets: keep them local and never upload without authorization.

### Hang

Before interrupting, save the current output and, if supported, the rendered screen, active handles/resources, and stack or CPU sample. Prefer the `debug` tool for program state, breakpoints, stepping, threads, and stacks; use the discovered `xd://debug` route when that is how the tool is exposed. Attach only to the owned process verified from launch state, using an installed compatible adapter. `debug` supports one active root session; do not replace an unrelated debug session. Read capabilities before requesting adapter-specific state. An adapter pause changes timing, so label the sample accordingly. Preserve output, terminate the debug session you created, and stop the owned managed process as appropriate.

## Recordings and retained evidence

When asked for a demo, prefer a repo-local recorder or an installed asciinema-compatible tool. Launch the recorder and its target under `hub`, drive one action at a time with deterministic waits, and exit normally so the recording flushes. Inspect the recorder's installed interface first; do not assume flags or install it silently. Keep the sequence short and focused. Review the recording using an available local viewer/rendering harness before claiming it demonstrates layout. If only a transcript was captured, label it a transcript, not a video or timed recording.

Retain a compact evidence bundle in the task's scoped artifact location:

- Command/argv, fixture, runtime, relevant non-secret environment, process name, and measurement boundaries.
- Ordered actions and the new prompt/output or exit state observed for each, including timeouts and failures.
- Initial/final transcripts and before/after evidence; rendered captures only where actually available.
- Raw startup measurements, CPU profiles, heap snapshots, hang samples, and requested recordings, with paths and a short finding for each.
- Cleanup result and any deliberately retained process or evidence, including ownership and reason.

Persist relevant output with `write` before rotation or relaunch. `hub` keeps a 25 MiB current log and one rotated log; restarting a completed name rotates prior output. A short `logs` window is not a complete transcript. Follow and retain output during a noisy run, or use the existing harness/recorder's full capture. Use actual returned `artifact://` or task-scoped `local://` locations rather than inventing artifact IDs. Keep original profiler/recording files byte-for-byte; do not use a text-only report conversion for binary evidence.

Never type credentials or destructive commands into a controlled session. Avoid capturing secrets in environment dumps, command histories, logs, and recordings. Keep evidence local and disclose redactions. Remove only temporary fixtures/harness files you created after preserving the evidence needed for the result; keep user-requested demo artifacts. Report exactly what passed, failed, or could not be exercised, with retained evidence paths. A started process or clean exit alone does not prove the intended interaction worked.
