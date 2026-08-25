# Generating approaches and comparing them
 
Read this when the three approaches are not falling out naturally, when they feel like the same
idea three times, or when you are tempted to invent a third one to hit the number.
 
## Contents
 
- [Why three](#why-three)
- [Axes that produce real difference](#axes-that-produce-real-difference)
- [The conservative / idiomatic / ambitious spread](#the-conservative--idiomatic--ambitious-spread)
- [Worked examples](#worked-examples)
- [When three is not justifiable](#when-three-is-not-justifiable)
- [Criteria definitions](#criteria-definitions)
- [Writing the recommendation](#writing-the-recommendation)
## Why three
 
One approach is a decision presented as a document. Two approaches invite a false binary, and the
reader tends to pick the one described second. Three forces the reader to hold a design *space*
in mind rather than a yes/no, which is what surfaces the constraint you did not know about.
 
The value comes entirely from the approaches being genuinely different. Three flavors of the
same architecture is one approach with extra steps, and it is worse than honestly presenting one,
because it manufactures the appearance of a considered choice.
 
## Axes that produce real difference
 
Vary one of these, not the naming or the file layout:
 
**Locus of change.** Patch the existing code in place / extract a new module and route through
it / replace the subsystem entirely.
 
**Build, adopt, or extend.** Hand-roll it / pull in a library / extend something the codebase
already has that almost does the job.
 
**Coupling and timing.** Do it synchronously in the request path / enqueue it and process
asynchronously / batch it on a schedule.
 
**Data model.** Extend the existing schema / add a new table or collection / derive the value at
read time and store nothing.
 
**Migration shape.** Big-bang cutover / strangler pattern running old and new in parallel /
feature-flagged progressive rollout.
 
**Generality.** Solve exactly this case / build the mechanism that solves this case and the two
adjacent ones you can see coming.
 
**Boundary placement.** Do it client-side / server-side / at the edge or in the gateway.
 
## The conservative / idiomatic / ambitious spread
 
When no axis jumps out, this spread almost always yields three defensible options:
 
**Conservative.** Smallest blast radius, fastest to ship, accepts some debt. Optimizes for
reversibility. Often the right call under deadline or when the requirements are still moving.
 
**Idiomatic.** What a thoughtful maintainer of *this specific codebase* would do — follows the
existing layering and conventions, moderate cost, no heroics. This is the default winner and
should be presented as a real option, not a compromise between the other two.
 
**Ambitious.** Pays down existing debt, generalizes the mechanism, or removes a constraint that
has been causing recurring pain. Costs more now and is harder to reverse. Worth presenting even
when you will not recommend it, because the human may know about upcoming work that changes the
math.
 
Name them for their strategy, not their position: "Approach B: route writes through a job queue"
tells the reader something; "Approach B" does not.
 
## Worked examples
 
**Task: add full-text search to an existing Postgres-backed app.**
 
- A — Postgres `tsvector` columns with a GIN index. No new infrastructure, good enough to a few
  million rows, ranking is crude.
- B — Managed search service (Typesense, Algolia, or similar) fed by an outbox. Better relevance
  and faceting, adds a service to run and a sync path that can drift.
- C — Query-time `ILIKE` with a materialized keyword table. Trivial to build, degrades badly, but
  ships this week and buys time to learn what users actually search for.
These differ in infrastructure, in failure mode, and in what they cost to abandon. That is a real
design space.
 
**Task: the checkout flow has grown to a 1,200-line component.**
 
- A — Extract hooks and presentational components in place, keep the same state model.
- B — Move the flow to a state machine (XState or hand-rolled reducer), making the legal
  transitions explicit.
- C — Split checkout into routed steps with URL-driven state, so browser back and deep links work.
Note that C changes product behavior. Say so explicitly — approaches with user-visible
consequences must flag them, since that decision may not be yours to make.
 
**A bad set, for contrast:**
 
- A — Extract the logic into `CheckoutService`
- B — Extract the logic into a `useCheckout` hook
- C — Extract the logic into a `checkout/` directory
Same approach, three file layouts. Present this as one approach and spend the space on something
that matters.
 
## When three is not justifiable
 
Present fewer, and say why, when:
 
- The framework or platform dictates one idiomatic path and deviating from it is the whole cost.
- It is a bug with a single root cause. Alternatives would only be different-quality fixes.
- The human already constrained the design in Phase 1 ("we're using the existing queue").
- The alternatives are all clearly dominated — worse on every criterion, not just on net.
In these cases write a short "Approaches considered and rejected" subsection giving each rejected
option a sentence and a reason. This is more useful than a padded third option because it shows
your search was real without pretending the outcome was open.
 
## Criteria definitions
 
Use consistent meanings across the tradeoff table, and quantify wherever you can.
 
| Criterion | What it means | How to express it |
|---|---|---|
| Implementation effort | Work to first working version | Lines and files, plus a rough time band |
| Blast radius | How much existing code is touched | Named modules and file count |
| Risk and reversibility | Cost of being wrong | What breaks; how hard to undo after a week in production |
| Performance | Latency, throughput, resource use | Numbers or a bounded estimate with the assumption stated |
| Testability | How provable the change is | What can be unit tested vs. needs integration or manual checks |
| Operational complexity | What ops inherits | New services, migrations, dashboards, on-call surface |
| New dependencies | What you take on | Package names, maintenance status, license |
| Convention fit | Alignment with the codebase | Which existing patterns it follows or breaks |
| Maintenance burden | Ongoing cost | Who has to understand it; how it ages |
 
Drop criteria that do not discriminate. A row where all three cells say the same thing adds
length and subtracts signal.
 
## Writing the recommendation
 
Three parts, in order:
 
**The pick and the two or three reasons that decided it.** Not a recap of the table — the
specific factors that dominated. "B, because the sync-drift failure mode is silent and this team
has no on-call rotation to catch it."
 
**The strongest argument against your pick,** stated fairly, and why it does not win here.
Skipping this is the fastest way to lose a reader who already holds that objection.
 
**What would change your mind,** as a concrete, checkable condition: "if the catalog grows past
roughly 500k documents, or if faceted filtering becomes a requirement, A stops being sufficient
and B is the right call."
 
That last part is what makes the recommendation auditable. The human usually knows one fact you
do not, and a stated trigger condition lets them apply it in seconds instead of re-deriving your
whole analysis.
 
