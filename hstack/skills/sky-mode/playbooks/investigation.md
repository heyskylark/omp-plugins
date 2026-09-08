### Investigation

**You own the answer. Plan, route, write.**

Investigation requests are read-only. They produce a cited explanation or recommendation, not a code change.

1. Read and apply `skill://how`. For motivation questions, also read and apply `skill://why`. Scope the question inline first. Use `scout` only when substantial independent code or search research warrants delegation. Give each child the exact question, scope, known sources, and required citation shape because children have no conversation history. Keep phase tracking with the parent and consume actual `agent://` results rather than claims of completion.
2. Keep the throughput checkpoint to one line. `throughput checkpoint: n/a, read-only investigation`.
3. Produce the how-shaped output with Overview, Key Concepts, How It Works, Where Things Live, and Gotchas. For a decision between alternatives, provide a recommendation with a tradeoffs table instead. Cite inspected files, symbols, authoritative sources, and real observed evidence. Distinguish established facts, inference, and what remains unknown. Scale investigation depth to the question rather than turning a small answer into a program of work.
4. Read and apply `skill://unslop` to the reply.

No PR, no babysit, and no `skill://architect` unless the investigation precedes a requested code change. If it does, hand the cited answer back to the user and re-route the implementation through `skill://sky-mode/playbooks/bug-fix.md` or `skill://sky-mode/playbooks/feature.md`. Do not silently expand a request for an answer into editing code.

**Reply.** The investigation output. For an “are we sure?” question, include your real judgment and reasons. Push back when the premise is wrong. An inconclusive finding is a valid answer when the available evidence does not distinguish alternatives. Explain the missing evidence without pretending uncertainty is confirmation.
