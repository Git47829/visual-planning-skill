# Google developer-documentation style
 
Two halves: how the prose reads, and how the page looks. The template in
`assets/plan-template.html` already implements the visual half — this file explains the rules
behind it so you can extend it correctly.
 
## Contents
 
- [Voice and tone](#voice-and-tone)
- [Headings](#headings)
- [Words to avoid](#words-to-avoid)
- [Lists, tables, and code](#lists-tables-and-code)
- [Callouts](#callouts)
- [Visual specification](#visual-specification)
- [Quick checklist](#quick-checklist)
## Voice and tone
 
**Second person.** Address the reader as "you". Refer to the team as "we" only when describing a
decision the team made together.
 
> The service retries failed writes three times. You configure the limit in `retry.yaml`.
 
**Present tense.** Describe what the system does, not what it will do.
 
> Write: The scheduler picks up the job within 30 seconds.
> Not: The scheduler will pick up the job within 30 seconds.
 
**Active voice.** Name the actor. Passive voice hides who does what, which is exactly the
information a design doc needs to convey.
 
> Write: The worker validates the payload before enqueuing it.
> Not: The payload is validated before being enqueued.
 
**Imperative for instructions.** Steps start with a verb.
 
> Write: Run `npm test` to verify the migration.
> Not: You should run `npm test`, which will verify the migration.
 
**Short paragraphs.** Three or four sentences, one idea. Long blocks of prose in a design doc go
unread, and the unread paragraph is always the one with the constraint in it.
 
**Define terms and expand acronyms on first use.** A design doc outlives the context it was
written in.
 
## Headings
 
Sentence case. Capitalize the first word and proper nouns only.
 
> Write: Set up the message queue
> Not: Set Up The Message Queue
 
Make headings descriptive rather than generic — a reader skimming the table of contents should
be able to reconstruct the argument. "Approach B: queue writes through Redis" beats "Approach B".
 
Do not skip levels: `h2` follows `h1`, `h3` follows `h2`. The generated table of contents depends
on this, and so do screen readers.
 
Never stack two headings with no text between them. Write a sentence of orientation.
 
## Words to avoid
 
**Minimizers** — "simply", "just", "easy", "obviously", "of course", "merely". They tell a
struggling reader that their difficulty is a personal failing. Delete them; the sentence is
almost always better.
 
**Vague scale words** without numbers — "fast", "scalable", "lightweight", "significant". In a
tradeoff table these are worse than useless because they look like analysis. Replace with a
measurement or a bounded estimate.
 
**Hype** — "seamless", "powerful", "cutting-edge", "robust". A design doc persuades with
reasoning, not adjectives.
 
**"Please"** in instructions. **"Note that"** — just state the thing, or make it a callout.
 
**Ableist or directional metaphors** — "sanity check" → "validation"; "click here" → descriptive
link text; "see below" → link to the section by name, since readers arrive mid-page from the
table of contents.
 
## Lists, tables, and code
 
**Numbered lists** for sequences and anything with a required order. **Bulleted lists** for
unordered sets. Keep list items grammatically parallel — all fragments or all sentences, all
starting with the same part of speech.
 
**Tables** for anything compared along shared dimensions. Every cell filled; use an em dash for
genuinely non-applicable, never leave blank. Header row uses sentence case. Left-align text,
right-align numbers.
 
**Code font** for filenames, paths, commands, function and variable names, and literal values:
`src/queue/worker.ts`, `MAX_RETRIES`, `npm run migrate`.
 
**Code blocks** get a language label. Keep them short — a design doc shows interfaces and
signatures, not implementations. If a block runs past about 25 lines it belongs in the markdown
plan, not the design doc.
 
## Callouts
 
Four kinds, used sparingly. A page with six callouts has none, because the reader stops seeing
them.
 
| Type | Use for | Accent | Background |
|---|---|---|---|
| Note | Useful context the reader can skip | `#1a73e8` | `#e8f0fe` |
| Key point | The one thing to remember from a section | `#1e8e3e` | `#e6f4ea` |
| Caution | Something that could cause rework or data loss | `#f9ab00` | `#fef7e0` |
| Warning | Something that breaks production or loses data | `#d93025` | `#fce8e6` |
 
Rendered as a 4px left border in the accent color over the tinted background, with the label in
bold as the first words.
 
## Visual specification
 
**Type.** `'Google Sans', Roboto, -apple-system, 'Segoe UI', sans-serif` for everything;
`'Roboto Mono', Menlo, Consolas, monospace` for code. Body 16px at line-height 1.75. `h1` 36px
weight 400, `h2` 24px weight 500 with a `1px solid #dadce0` rule above it and generous top
margin, `h3` 20px weight 500.
 
**Color.**
 
| Role | Value |
|---|---|
| Body text | `#202124` |
| Secondary text, captions | `#5f6368` |
| Link and accent | `#1a73e8` |
| Borders and rules | `#dadce0` |
| Page background | `#ffffff` |
| Code and subtle fills | `#f1f3f4` |
| Table header, hover | `#f8f9fa` |
 
**Layout.** Content column capped at about 1000px, prose measure around 760px — long lines are
the fastest way to make a technical document tiring. A sticky "On this page" table of contents
sits to the right on wide viewports and collapses above the content below about 1100px.
Generous vertical rhythm; whitespace is doing real work in this style.
 
**Metadata line** directly under the `h1`, in secondary text: date, status, author. Status is one
of Draft, In review, Approved, or Superseded.
 
**Figures.** Inline SVG centered in the column, with a caption below in secondary text at 14px:
"Figure 3. Write path under Approach B." Number them sequentially across the document and refer
to them by number in the prose.
 
**Approach sections** get a subtle card treatment — `1px solid #dadce0`, 8px radius, padding —
so the three read as parallel alternatives rather than as a sequence of decisions.
 
## Quick checklist
 
Run this over the draft before delivering:
 
- [ ] Every heading is sentence case and descriptive
- [ ] No "simply", "just", "easy", "obviously", "seamless", "robust"
- [ ] No vague scale words in the tradeoff table — numbers or bounded estimates only
- [ ] Passive voice only where the actor genuinely does not matter
- [ ] Every table cell filled
- [ ] Every figure numbered, captioned, and referenced in the prose
- [ ] Every acronym expanded on first use
- [ ] Fewer than five callouts total
- [ ] CSS inlined, SVG inlined, zero external requests
- [ ] Opens correctly with a double-click, offline
 
