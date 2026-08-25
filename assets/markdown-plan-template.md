<!--
  Visual planning — implementation plan template (Phase 3).
  Written after the human chooses an approach. Where the HTML doc argues, this instructs.
  Target reader: a competent developer who has NOT read the design doc. Detailed enough to
  execute without guessing; not so detailed that it becomes the code itself.
  Delete this comment and every {{PLACEHOLDER}}. Delete sections that genuinely do not apply
  rather than leaving them empty.
-->
 
# Implementation plan: {{TITLE}}
 
**Approach chosen:** {{A/B/C}} — {{STRATEGY_NAME}}
**Design doc:** [`design.html`](./design.html)
**Date:** {{YYYY-MM-DD}} · **Status:** Awaiting approval
 
## Summary
 
{{Two or three sentences: what gets built and how, in the developer's terms. Anyone picking
this up cold should know what they are doing before reading further.}}
 
## Scope
 
**In scope**
 
- {{…}}
**Out of scope**
 
- {{…}}
## Prerequisites
 
{{Anything that must be true before Phase 1 starts — access, credentials, a migration window,
a decision from someone else, a dependency version bump. Delete if none.}}
 
- [ ] {{…}}
## Phases
 
Phases are ordered and independently verifiable. Each one leaves the repository in a working
state — if the work stops after any phase, nothing is broken.
 
<!-- Repeat this block per phase. Aim for 3–6 phases; more than that usually means the phases
     are really tasks and should be grouped. -->
 
### Phase 1 — {{NAME}}
 
**Goal:** {{One sentence. What is true at the end of this phase that was not true before.}}
 
**Changes**
 
| File | Action | What changes |
|---|---|---|
| `{{path/to/file.ts}}` | Create | {{…}} |
| `{{path/to/other.ts}}` | Modify | {{…}} |
| `{{path/to/dead.ts}}` | Delete | {{…}} |
 
**Details**
 
{{Interfaces, signatures, and the non-obvious decisions. Show the shape of new types and the
contracts between pieces. Do not write the implementation — that is Phase 4's job. Flag
anything where a reasonable developer would otherwise guess wrong.}}
 
```{{lang}}
{{signatures / interfaces / schema — keep it short}}
```
 
**Tests**
 
- {{What proves this phase works, and at what level — unit, integration, manual.}}
**Verify**
 
```bash
{{command that must pass before moving on}}
```
 
---
 
### Phase 2 — {{NAME}}
 
{{…}}
 
---
 
## Data model changes
 
{{Schema changes, migrations, and the backfill strategy. State explicitly whether the migration
is reversible and whether old and new code can run against the same schema during deploy.
Delete this section if there are none.}}
 
## Interface and contract changes
 
{{Public APIs, exported functions, events, and config that other code or other teams depend on.
Note anything breaking and who is affected. Delete if none.}}
 
## Testing strategy
 
| Level | What it covers | Where |
|---|---|---|
| Unit | {{…}} | `{{…}}` |
| Integration | {{…}} | `{{…}}` |
| Manual | {{…}} | — |
 
{{Note anything deliberately not tested and why — that is a decision worth recording, not a gap
worth hiding.}}
 
## Risks
 
| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| {{…}} | Low / Medium / High | {{…}} | {{…}} |
 
## Rollout and rollback
 
**Rollout:** {{Feature flag, staged deploy, big-bang, migration ordering. Include the order of
operations if deploy sequencing matters.}}
 
**Rollback:** {{The actual procedure. Note the point of no return — the first step after which
rollback stops being clean — because knowing where it is changes how carefully you approach it.}}
 
## Open questions
 
{{Anything still unresolved. Mark whether each one blocks a phase or can be answered during
implementation.}}
 
1. **{{Question}}** — {{blocks Phase N / non-blocking}}
## Progress
 
Updated during Phase 4. Tick items as they complete; if reality contradicts the plan, stop and
raise it here rather than improvising silently.
 
- [ ] Phase 1 — {{NAME}}
- [ ] Phase 2 — {{NAME}}
- [ ] Phase 3 — {{NAME}}
 
