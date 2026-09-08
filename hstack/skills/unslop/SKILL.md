---
name: unslop
description: Remove formulaic AI writing patterns while preserving meaning, evidence, and the intended tone. Use /skill:unslop on prose or apply it when another workflow requests a plain-language edit.
disable-model-invocation: true
---

# Unslop

Edit the requested text to remove AI writing patterns. Preserve facts, citations, uncertainty, code, identifiers, and intentional quotations. This skill does not grant permission to edit unrelated files or override the user's requested tone and format.

## Process

1. Scan for the patterns below.
2. Rewrite while preserving meaning and matching the intended tone.
3. Self-audit for remaining formulaic phrases, unsupported claims, and unnecessary words.

Use OMP `read` for the supplied artifact and `edit` for requested existing-file changes. Return revised prose in the current output when the caller has not asked for a file edit. Supporting use, such as decision-log wording, stays with the parent workflow and does not spawn another agent.

## Patterns to detect and fix

Rule numbers are stable identifiers for other skills. Removed rules leave gaps.

### Content

3. **Superficial -ing phrases.** Delete empty phrases such as "highlighting", "ensuring", "reflecting", "showcasing", or "fostering", or replace them with a sourced statement.
5. **Vague attributions.** Replace "experts believe" and "industry reports suggest" with a named source, or remove the claim.

### Language

7. **AI vocabulary.** Prefer plain words over additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, abstract landscape, pivotal, showcase, abstract tapestry, testament, underscore, and vibrant.
8. **Fancy ways to say "is".** Replace "serves as", "stands as", "boasts", or "features" with "is" or "has" when that is the meaning.
9. **"Not just X, but Y."** State the point directly.
10. **Rule of three.** Do not force ideas into groups of three. Use the natural number.
11. **Synonym cycling.** Use one name for one concept instead of cycling through ornamental synonyms.
12. **False ranges.** Avoid "from X to Y" when the endpoints do not belong to a meaningful scale. List the topics.

### Style

13. **Em dash overuse.** Use sentences or commas rather than em dashes or substitute dash punctuation in edited prose.
14. **Colon overuse.** Keep colons before lists or examples; replace mid-sentence framing that adds no information.
15. **Boldface overuse.** Do not bold every proper noun or acronym.
16. **Inline-header lists.** Remove labels that repeat the sentence after them. A lead-in that names an item and is followed by new information is useful.
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove them from headings and bullets unless the user requested them.
19. **Curly quotes.** Prefer straight quotes in edited prose.

### Communication artifacts

20. **Chatbot phrases.** Remove "I hope this helps", "let me know if", "of course", "certainly", and theatrical announcements.
22. **Sycophantic tone.** Answer directly instead of praising the question or declaring the user right.

### Filler

23. **Filler phrases.** "In order to" becomes "to". "Due to the fact that" becomes "because". Delete "it is important to note that".
24. **Excessive hedging.** Replace stacked qualifiers with one accurate qualifier. Do not erase genuine uncertainty.
25. **Generic conclusions.** Replace optimistic boilerplate with specific facts or plans, or omit it.

### Jargon

26. **Abstract metaphor nouns.** Replace ornamental substrate, wedge, vector, locus, vantage, nexus, bedrock, modality, paradigm, north star, flywheel, and similar phrases with the concrete mechanism. Keep a technical term when it has an exact domain meaning that a plain substitute would lose.

### Plain speech

27. **Say what it does, not how it feels.** Replace impressions with a mechanism, instruction, or measured result. If a sentence could appear unchanged in an unrelated project's documentation, check whether it says anything useful.
28. **Shorten or split dense sentences.** Remove clauses or split a sentence when the reader must backtrack to parse it.
29. **Active voice.** Name the actor where known. Passive voice is useful when the actor is unknown or irrelevant.
30. **Cut adverbs, or use a stronger verb.** Replace "significantly improves" with the measured change. Never invent a measurement to strengthen prose.
31. **Prefer the plain word.** "Utilize" and "leverage" become "use"; "facilitate" becomes "help"; "numerous" becomes "many"; "in the event that" becomes "if".
32. **Mannered prose.** Replace aphorisms, personified code, rhetorical fragments, and figurative verbs with literal descriptions.
33. **Over-compression.** Restore articles, verbs, and clear sentences where fragments, arrows, or abbreviations force the reader to decode the text.
