---
name: principle-attack-the-premise
description: "Apply when two or more fixes sharing one premise fail the same gate. Census the imbalance per actor, identify the role assignment, and question the premise before another fix."
disable-model-invocation: true
---

# Attack the Premise

When two or more fixes that share one premise have failed the same gate, suspect the premise, not the fixes.

**Why:** Each failure under a shared premise is evidence about the premise.

**Pattern:**
- **Write the premise down.** The premise is the one sentence that every failed fix assumed.
- **Take a census before the next fix.** Count the imbalance per actor. The census shows which actors hold the imbalance, not just how large it is. Read and apply [Build the Lever](skill://principle-build-the-lever) to write the census as a rerunnable script.
- **Read the skew.** If the same few actors hold most of the imbalance on every run, something assigns them that role. Find what assigns the role. That assignment is the next "why": read and apply [Fix Root Causes](skill://principle-fix-root-causes).
- **Remove the asymmetry instead of compensating for it.** Read and apply the [Laziness Protocol](skill://principle-laziness-protocol). Rotate the role between actors, randomize the assignment, or move the role so that no actor holds it on every run. A return path, a shared pool, a batched hand-off, or a periodic rebalance leaves the assignment in place and adds work on every run.

**Stop:**
- Do not start the next fix before the premise is written down and the census exists.
- If the census is even across actors, the premise is not the cause. Look for the cause elsewhere and keep the census as evidence.
- Proceed with reversible investigation within the authorized scope; explicit approval requirements, plan mode, destructive-operation authorization, and user-requested validation pauses still apply. If a census requires a prohibited action, describe the required evidence and stop at that boundary rather than fabricating a result.

This principle is distinct from [Redesign from First Principles](skill://principle-redesign-from-first-principles), which rebuilds a design around a new requirement. It questions a fact the current design assumes. Read and apply that skill when the task is a redesign rather than a premise investigation.
