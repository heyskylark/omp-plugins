---
name: teach
description: "Explain a change or subsystem plainly by combining how it works with why it was built that way. Use for 'teach me this', 'help me really understand X', or 'explain this change to me', with progressive explanations and diagrams at the person's pace."
disable-model-invocation: true
---

# Teach

Explain what a thing is, how it works, and why it is built that way in one plain account at the person's pace. The goal is understanding, not changing anything.

Teach composes `skill://how` and `skill://why`. Read and apply those skills to the actual question, not merely their descriptions. They supply the investigation methods and evidence contracts. Blend their findings into one explanation. Reword freely for teaching except for `why`'s confidence language. Its hedges are findings, not style.

## Find the teaching target

Decide the few things the person should walk away understanding. Infer why they are asking and what they already know from the conversation. They may be about to change the code, reviewing it, debugging it, or new to it. Do not quiz them to establish this. Skip what they plainly already know and put the depth where their question is.

Get oriented inline with `glob`, `grep`, and `read`. Locate the relevant change, files, symbols, and code boundaries before deciding whether to delegate. Use available LSP symbol intelligence when it resolves ownership or call relationships more directly. Reuse findings already in the conversation rather than repeating an investigation.

## Compose how and why

Let the companion skills do the research work. Apply `skill://how` to the runtime mechanism and `skill://why` to the rationale. A subsystem normally needs both. For a small change, one may already answer the question or the other may already be established by existing evidence. Do not run extra research just to fill a format.

Keep the rationale question narrow by default. Put that scope in the ask itself, such as one decision with git history and one or two relevant sources. Apply `why`'s coverage and skipped-category rules, recording what was not searched and why. Widen the search when the reasons are the point. An unavailable source is an access gap, not evidence that no rationale exists.

The parent owns both companion workflows and synthesizes their findings. Do not spawn one agent to orchestrate `how` and another to orchestrate `why`. Neither companion may call the other back for this same question, and no child may restart `teach` or either companion workflow. Reuse their existing reference templates for concrete research slices rather than inventing a second investigation convention.

After inline scoping, when mechanism and rationale contain genuinely independent substantial research, run their source searches concurrently in one native OMP `task` batch. Keep small or already-understood questions inline. The batch `context` contains **# Goal**, **# Constraints**, and **# Contract**: the original question, audience context, code anchors, mechanism/rationale boundaries, source ownership, read-only scope, and expected evidence. Each assignment contains **# Target**, **# Change**, and **# Acceptance**, populated using the applicable companion template.

Use `scout` for code and search research. For remote evidence, select an available agent with the required source tools, as directed by `why`; if the child lacks a source tool, the parent searches that source. Keep reasoning and synthesis in the parent. Agent definitions and configured model roles choose models. Do not set a task model or claim independent model diversity without evidence of the resolved models.

Children receive a complete assignment because they do not inherit the conversation. They return findings, code/source citations, uncertainty, and gaps, without editing, running tests or other validation gates, keeping todos, or spawning agents. The parent owns any todo state and a scoped `local://teach-notepad.md` evidence record. Read full child results through their returned `agent://<id>` handles. Use `hub` with known child IDs for specific follow-up questions, and `history://<id>` only for known task sessions when needed. Honor tool, spawn, concurrency, and plan-mode limits. If a search cannot run, do permitted work inline and disclose the remaining gap.

Reconcile mechanism and rationale before explaining them. Check disagreements against the cited code and sources. Preserve the difference between observed behavior, documented intent, reasonable inference, competing hypotheses, and unknown history. Retain `why`'s source coverage and confidence accounting in the parent findings; include material uncertainty and a compact source/gap account in the explanation rather than burying them in an inaccessible research report.

## Explain in layers

Start with a plain definition. Name the thing, using its common name when it has one, and say what it is in general terms as a senior engineer would say it aloud. Then tie it to this case: "In X, we use this to ..."

Give the smallest complete answer first, usually a sentence or two rather than a dense paragraph. Then stop and let the person respond. Add how it works, deeper reasons, and edge cases as they ask. For each part, explain the problem it solves and the concrete mechanism. Walk through what happens as the person does the thing, such as opening a long chat or scrolling up, when that makes the explanation land. A list of functions and constants is reference material, not teaching.

Keep it a conversation, not a lecture or performance. Offer a concrete direction to go deeper or move on and follow their lead. No quizzes, requests to repeat the explanation, or pacing theater. Do not print "Pause", announce "the sentence to nail", or call a section important, hard, or tricky. When you would pause, stop. In a one-shot response with no live human, give the complete requested explanation cleanly, with any offer to go deeper at the end.

Do not print framing labels such as "the one idea to hold onto", "the key insight", "at its core", or "TL;DR". Do not echo these workflow headings as the answer's structure. Never deliver a wall of text.

## Build the picture progressively

Show rather than only tell. Read the relevant diff or code, or use an available debugger on an authorized target, when that teaches the mechanism faster. Do not change the implementation to explain it, and do not run a side-effectful scenario without authorization.

Draw when a picture lands faster than words. For three or more moving parts, do not introduce everything in one diagram. Use a short series where each diagram redraws the preceding picture and adds one part. For a flow from A to B to C, first draw A to B, redraw with C, then redraw with the return edge or next piece. Introduce each picture alongside the explanation it supports. A single complete diagram saved for the end is a reference, not progressive teaching.

Use plain Markdown and Mermaid for source diagrams. Mermaid fits flows and structures whose labels carry the meaning. For spatial ideas such as layout, overlap, scroll position, and before/after states, use a short sequence of spatial sketches or an available image-generation tool to make marker-on-whiteboard images with a few short labels. When image generation is available and the spatial idea needs it, generate the picture rather than merely describing a desired image. Keep long text out of generated images. Preserve the build-up rule for images too. If image generation is unavailable, say so and use an actual Markdown spatial sketch rather than claiming an image was generated. A single simple point needs no figure. Do not create Figma artifacts unless the user requests Figma.

## Write the explanation

Read and apply `skill://unslop` to every response. Use plain spoken English as if explaining to a colleague. Be tight, not terse. Cut filler and stylistic hedging without removing evidence-based uncertainty. State the concrete mechanism, not a metaphor, a framing, or a preview of what comes next.

Target this density: "Virtualization runs in two parts, one for rendering and one for loading from disk. When an item scrolls out past the buffer, both its DOM node and its in-memory data are evicted."

Use normal sentence case, not all lowercase. No em dashes. Prefer periods over commas and keep each sentence to one or two commas. Split piled-up clauses. Give each concept one name and keep it. Avoid mirror sentences such as "A without B, or B without A" and tidy closers such as "the rest follows" or "it all falls out".

Reply with the explanation itself, never a report about what you did or delivered. Lead with the main point, then the plain account of what it is, how it works, and why, at the requested depth. Keep citations close to factual claims. Preserve material confidence qualifiers and source gaps. When useful, end with a specific thread worth pursuing through `skill://how` or `skill://why`, without automatically restarting either investigation.
