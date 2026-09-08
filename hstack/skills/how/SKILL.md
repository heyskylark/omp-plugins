---
name: how
description: "Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering questions (\"where should this live\", \"which package owns this\", \"is this the right layer\"). Explains subsystem architecture, runtime flow, onboarding mental models. Use why for motivation."
disable-model-invocation: true
---

# How

Explore the codebase to answer "how does X work?" questions. Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem, enough to build a working mental model, not so much that it reads like annotated source code.

## Step 1. Assess Complexity

State your interpretation if the scope is ambiguous, then use inline `glob`, `grep`, and `read` to locate the relevant code before deciding whether to delegate.

- **Simple** (one module, utility, or narrow function question): explore and explain inline in one pass, applying `skill://how/references/explainer-prompt.md` without the explorer-findings section.
- **Complex** (multiple services, a cross-cutting feature, or architecture overview): identify 2–4 substantial independent exploration angles. Only fan out when each merits independent research; otherwise stay inline. When in doubt, take the simple path.

## Step 2. Explore

For complex questions, read `skill://how/references/explorer-prompt.md` and build one native OMP `task` batch with `agent: scout` for each code-research slice. The batch `context` contains **# Goal**, **# Constraints**, and **# Contract**: original question, shared code anchors, slice boundaries, read-only scope, and expected findings. Each task contains **# Target**, **# Change**, and **# Acceptance**, filling the reference template with its question and angle.

Select only available agent types; their configured roles choose models. Do not pass a model field. Children gather facts, do not edit files, run validation, create todos, spawn agents, or invoke an orchestrator. The parent owns any todo state and a `local://how-notepad.md` notepad. Child findings return through `agent://<id>`; follow up with the same child using `hub` for specific unresolved connections. Respect tool, spawn, and plan-mode limits: do the permitted work inline and report what could not be traced rather than claiming a blocked exploration ran.

## Step 3. Explain Inline

Read and apply `skill://how/references/explainer-prompt.md` in the parent. Combine every explorer's findings (or your inline findings), reconcile overlaps, check contradictions in the actual code, and fill narrow gaps. Do not spawn a lone explainer or synthesizer. Favor a working mental model over annotated source.

## Step 4. Present

Use the applicable sections: **Overview**, **Key Concepts**, **How It Works**, **Where Things Live**, **Gotchas**. Cite concrete files, symbols, and line ranges. Preserve explicit gaps and distinguish observed mechanics from inferred intent.

For a question that also requires historical motivation, read and apply `skill://why` to that bounded rationale question. Do not invoke it merely to decorate an explanation with history. Track that companion work in the parent and reuse existing findings; a companion invocation must not invoke `how` back for the same question. If already called from `why`, return the requested runtime explanation to its parent workflow without restarting either skill.
