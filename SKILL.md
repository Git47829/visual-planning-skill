---
name: visual-planning
description: Plan a non-trivial coding task before writing any code. Produces a human-readable HTML design doc in Google developer-documentation style with diagrams, presenting three distinct approaches followed by a tradeoff analysis, then — after the human picks one — a detailed markdown implementation plan, and only then the code. Use this whenever the user asks to build a new feature, add a subsystem, do a refactor or migration, redesign an architecture, or says things like "how should I build X", "plan this out", "design doc", "what are my options for X", or "I'm thinking about restructuring Y". Use it even when the user has not said the word "plan" — if the request is a substantial change rather than a small fix, plan it first.
---
 
# Visual planning
 
Plan substantial coding work as a design document first, so the human can steer the
architecture before any code exists and while changing direction is still cheap.
 
The output is two documents, produced in order, with a human decision gate after each:
 
1. **An HTML design doc** — readable, diagram-heavy, written in Google developer-documentation
   style. Presents three genuinely distinct approaches, then compares them.
2. **A markdown implementation plan** — the detailed, file-by-file build instructions for the
   one approach the human chose.
Code comes third, after the markdown plan is accepted.
 
## The gates matter more than the documents
 
The whole point of this skill is that a human reviews the design before it becomes code. That
only works if you actually stop. Two hard stops:
 
- **Gate 1** — after delivering the HTML doc, stop. Do not write the markdown plan until the
  human has chosen an approach. They may also reject all three, or ask for a fourth.
- **Gate 2** — after delivering the markdown plan, stop. Do not touch source files until the
  human accepts it.
Before Gate 2 clears, the only files you create or modify are the two planning documents
themselves. No scaffolding, no "just stubbing out the interface", no `git checkout -b`. A
half-built scaffold quietly commits the human to an approach they have not agreed to yet, which
defeats the purpose.
 
Ending your turn *is* the stop. Ask which approach they want and then stop talking — do not
answer your own question and continue.
 
## Phase 0 — Is this the right skill?
 
This skill is for non-trivial work. Applying it to a one-line fix wastes everyone's time and
trains the user to skip the gates.
 
Plan it if the change touches multiple files or modules, adds or changes a dependency, changes a
data model or public interface, has more than one defensible design, or is hard to reverse.
 
Skip it for a localized bug fix with one root cause, a rename, a config tweak, a test added to an
existing suite, or anything the user framed as urgent and small. If you skip, just do the work.
 
If it is borderline, say so in one sentence and offer: full plan, or a short inline proposal
before you start. Let the user pick.
 
## Phase 1 — Recon before proposing
 
Proposing approaches before reading the code produces three variations of a guess. Spend real
effort here.
 
Read the parts of the codebase the change touches. Establish how this project actually does
things — its layering, naming, error handling, test style, dependency management — because
"fits existing conventions" is a real tradeoff axis later and you cannot assess it from memory.
Find the constraints: runtime versions, deployment target, existing dependencies you should
prefer over new ones, performance or compliance requirements, anything load-bearing that the
change must not break.
 
Then ask the human what the code cannot tell you. Good questions here are about intent and
constraint, not preference: expected scale, who the users are, whether backward compatibility
matters, whether there is a deadline shaping how much refactoring is affordable, whether any
approach is already ruled out politically or contractually. Ask the few that would actually
change the design; do not run a questionnaire.
 
Note what you could not determine. Unknowns belong in the doc as open questions, not as silent
assumptions.
 
## Phase 2 — The HTML design doc
 
### Structure
 
Use this section order. It matters: every approach is presented on its own merits *before* any
comparison happens, so the human forms their own view before reading yours.
 
```
1. Overview            — the problem, in a paragraph. What "done" means.
2. Goals and non-goals — bulleted. Non-goals prevent scope creep later.
3. Current state       — how it works today, with a diagram.
4. Approach A: <name>  — descriptive name, not "Option A"
5. Approach B: <name>
6. Approach C: <name>
7. Tradeoffs           — comparison table + quadrant or radar diagram
8. Recommendation      — your pick, the reasoning, and what would change your mind
9. Open questions      — what you need from the human
```
 
Each approach section covers: the idea in two or three sentences, a diagram, what changes
(components, files, data model, interfaces), what it costs, and what it rules out later.
 
Write each approach as its strongest advocate would. Do not hedge inside approach sections or
seed them with objections — comparison is Section 7's job. An approach you undercut while
describing it is a strawman, and a strawman turns the whole document into theater.
 
### Three approaches, when justifiable
 
Three is the target because two invites a false binary and one is a decision already made. But
the three must differ in *strategy*, not in cosmetics. Three variations on the same architecture
with different function names is one approach wearing three hats.
 
Generate them by varying an axis that actually matters. Useful axes: where the change lands
(patch in place / extract a new module / replace the subsystem); build versus adopt a library
versus extend something internal; synchronous versus queued versus batch; extend the existing
schema versus add a table versus derive the value; big-bang versus strangler-pattern versus
feature-flagged rollout; solve exactly this case versus build the general mechanism.
 
A reliable spread is one conservative approach (smallest blast radius, fastest to ship, accrues
some debt), one idiomatic approach (what a thoughtful maintainer of *this* codebase would do),
and one ambitious approach (pays down existing debt or generalizes, costs more now).
 
Sometimes three is not justifiable — the framework dictates one idiomatic path, the bug has one
root cause, or the human already constrained the design. When that happens, present two, or one.
Say plainly why the others are not viable and note what you considered and rejected. Padding to
three with a deliberately bad option is worse than presenting two honest ones, because it makes
the recommendation look predetermined.
 
### The tradeoff section
 
Compare all approaches against the same criteria in one table — same rows, same order, every
cell filled. Draw the criteria from what this project actually cares about; a reasonable default
set is implementation effort, blast radius, risk and reversibility, performance, testability,
operational complexity, new dependencies, fit with existing conventions, and long-term
maintenance burden.
 
Be concrete. "Medium effort" says nothing; "~400 lines across 6 files, 2 new tests" does.
 
Then add a visual comparison — a quadrant diagram (effort against value, or risk against reward)
or a radar chart across the criteria. See the diagram section below.
 
The recommendation that follows states your pick, the two or three reasons that decided it, and
explicitly what would flip it ("if the event volume is above ~10k/day, B becomes the right call").
That last part lets the human check your reasoning against facts you may not have.
 
### Style
 
The doc must read like Google developer documentation: second person, present tense, active
voice, sentence-case headings, short paragraphs, no "simply" or "just", tables for comparison,
tinted callouts for notes and warnings. The visual design follows too — Google Sans / Roboto,
a narrow measure, a sticky "On this page" table of contents, `#1a73e8` accents.
 
Read `references/google-dev-docs-style.md` before writing, and build from
`assets/plan-template.html`, which already implements the visual side.
 
### Where it goes
 
Write to `docs/plans/<YYYY-MM-DD>-<slug>/design.html`, unless the repo already has a home for
design docs — follow the existing convention if there is one. The file must be self-contained
and openable with a double-click: inline the CSS and inline every diagram as SVG. No CDN links,
no external assets. These documents get emailed, attached to tickets, and read offline.
 
Tell the human the path when you deliver it, then stop.
 
## Phase 3 — The markdown implementation plan
 
Only after the human picks an approach.
 
This document is for whoever implements the work, which is usually you in Phase 4. Where the
HTML doc argues, this one instructs. It is detailed enough that a competent developer who did
not read the HTML doc could execute it.
 
Build it from `assets/markdown-plan-template.md`. It breaks the work into ordered phases, each
with the specific files to create or modify, what changes in each, the tests that prove the
phase works, and a verification command. It also carries the risks with mitigations, the rollback
plan, and the open questions that remain.
 
Write to `docs/plans/<YYYY-MM-DD>-<slug>/plan.md`, next to the design doc. Then stop again.
 
## Phase 4 — Implementation
 
Once accepted, work the phases in order. Keep the markdown plan open as the source of truth and
tick off tasks as you complete them.
 
When reality contradicts the plan — and it will — stop and flag it rather than silently
improvising. A plan that turns out to be wrong is useful information; a plan that gets quietly
abandoned mid-implementation is how the human loses the thread. Say what you hit, what it means
for the plan, and what you propose instead.
 
## Diagrams
 
Diagrams are not decoration here. A design doc without them forces the reader to hold an
architecture in their head while evaluating three versions of it.
 
**Delegate to the `diagram-design` skill.** Do not hand-roll SVG. Locate it at runtime the same
way you would any other available skill — check the skills available to this session, then look
in the usual install locations (`~/.claude/skills/`, plugin skill directories, and any
Codex/agent skill directory the environment exposes). Read its `SKILL.md` and follow its
instructions. Ask `diagram-design` for **inline SVG** output so the HTML stays self-contained,
and if the project has brand tokens, use its brand-onboarding support so the diagrams match.
 
Pick the type from what the section is doing:
 
| Section | Diagram type |
|---|---|
| Current state | architecture, IT current-state, or dependency graph |
| Approach — structure | architecture, layer stack, or deployment |
| Approach — runtime behavior | sequence, data flow, or flowchart |
| Approach — stateful logic | state machine |
| Approach — schema change | ER / data model |
| Approach — cross-team process | swimlane |
| Tradeoffs | quadrant (effort vs. value) or radar/spider (multi-criteria) |
| Phasing in the markdown plan | Gantt or timeline |
 
Aim for one diagram per approach plus the current-state and tradeoff diagrams. Reuse the same
visual vocabulary — same shapes, same colors for the same concepts — across all three approaches,
so the reader can diff them visually. Diagrams that each invent their own notation are harder to
compare than no diagrams at all.
 
If `diagram-design` genuinely is not available in the environment, fall back to Mermaid rendered
to inline SVG, tell the human you did so, and keep going rather than shipping a doc with no
visuals.
 
## Reference files
 
- `references/google-dev-docs-style.md` — writing rules and the visual specification. Read
  before writing the HTML doc.
- `references/approaches-and-tradeoffs.md` — worked examples of well-spread approach sets,
  criteria definitions, and how to write a recommendation that survives scrutiny. Read when the
  three approaches are not falling out naturally, or when you are tempted to pad to three.
- `assets/plan-template.html` — the HTML skeleton, styled and ready to fill.
- `assets/markdown-plan-template.md` — the Phase 3 template.
 
