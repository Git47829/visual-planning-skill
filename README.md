<h1 align="center">visual-planning</h1>

<p align="center">
  A <a href="https://claude.com/claude-code">Claude Code</a> skill that makes the agent design before it codes.<br>
  Three real approaches, a diagram-heavy HTML design doc, a human decision gate — <em>then</em> the code.
</p>

<p align="center">
  <img alt="Claude Code skill" src="https://img.shields.io/badge/Claude%20Code-skill-1a73e8">
  <img alt="No dependencies" src="https://img.shields.io/badge/dependencies-none-success">
</p>

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Git47829/visual-planning-skill/main/install.sh | bash
```

Or from a checkout:

```bash
git clone https://github.com/Git47829/visual-planning-skill.git
cd visual-planning-skill && ./install.sh
```

Then restart Claude Code. The skill lands in `~/.claude/skills/visual-planning/`, and the
[`diagram-design`](https://github.com/mahip-kakan/diagram-design) skill it depends on is installed
alongside it. Claude picks both up on the next session.

<details>
<summary>Options and manual install</summary>

```bash
# Skip the diagram-design dependency (falls back to Mermaid)
./install.sh --no-diagram

# Install somewhere else (Codex, a plugin dir, a project-local .claude/skills)
SKILLS_DIR=~/.codex/skills ./install.sh

# Pin to a tag or branch
REF=v1.0.0 ./install.sh

# Use a different diagram-design source
DIAGRAM_REPO=https://github.com/you/your-fork.git ./install.sh

# Manual
mkdir -p ~/.claude/skills/visual-planning
cp -R SKILL.md references assets ~/.claude/skills/visual-planning/
```

An existing install is moved to `<name>.backup.<timestamp>` rather than deleted. An already-present
`diagram-design` is left untouched.

Uninstall: `rm -rf ~/.claude/skills/visual-planning ~/.claude/skills/diagram-design`

</details>

## What it does

Substantial changes get planned as a **design document** first, so you can steer the architecture
while changing direction is still cheap.

```
  Recon  ─►  HTML design doc  ─► ⏸ you pick  ─►  Markdown plan  ─► ⏸ you accept  ─►  Code
             3 approaches         an approach     file-by-file
             + tradeoffs                          + tests + rollback
```

**The gates are the point.** Claude stops at ⏸ and waits. Before you accept the plan, the only
files it touches are the two planning documents — no scaffolding, no "just stubbing out the
interface", nothing that quietly commits you to an approach you haven't agreed to.

## The output

**`design.html`** — self-contained, opens on a double-click, styled like Google developer
documentation. Sticky table of contents, inline SVG diagrams, no CDN links. Email it, attach it
to a ticket, read it on a plane.

| Section | What's in it |
|---|---|
| Overview, goals & non-goals | The problem, and what "done" means |
| Current state | How it works today, with a diagram |
| Approach A / B / C | Descriptive names, each argued by its strongest advocate |
| Tradeoffs | One table, same criteria, every cell filled — plus a quadrant or radar chart |
| Recommendation | The pick, the reasoning, and **what would change it** |
| Open questions | What Claude couldn't determine from the code |

**`plan.md`** — written only after you choose. Ordered phases, the exact files each one touches,
the tests that prove it works, a verification command per phase, risks with mitigations, and a
rollback plan.

Both land in `docs/plans/<YYYY-MM-DD>-<slug>/`.

## Three approaches that actually differ

Three variations on one architecture with different function names is one approach wearing three
hats. The skill generates spread along an axis that matters — locus of change, build vs. adopt vs.
extend, sync vs. queued vs. batch, schema strategy, big-bang vs. strangler vs. feature-flagged —
and aims for one **conservative**, one **idiomatic**, one **ambitious** option.

When three isn't justifiable, it presents two, or one, and says why. Padding to three with a
deliberately bad option makes the recommendation look predetermined.

## When it triggers

Automatically, when you ask for a new feature, a subsystem, a refactor, a migration, an
architecture redesign — or say things like *"how should I build X"*, *"what are my options for"*,
*"I'm thinking about restructuring Y"*. You don't have to say the word "plan".

It deliberately **skips** one-line fixes, renames, config tweaks, and anything you framed as
urgent and small. Borderline cases get one sentence and a choice: full plan, or a short inline
proposal.

## Diagrams

Diagrams are delegated to [`diagram-design`](https://github.com/mahip-kakan/diagram-design)
(MIT, by Mahip Kakan), which the installer pulls in for you. Output is requested as inline SVG so
the doc stays self-contained. Without it, the skill falls back to Mermaid rendered to inline SVG
and tells you it did.

Same shapes and same colors for the same concepts across all three approaches — so you can diff
them visually.

## Repo layout

```
SKILL.md                                 the skill itself
install.sh                               one-line installer (+ diagram-design dependency)
references/google-dev-docs-style.md      prose rules + visual spec
references/approaches-and-tradeoffs.md   how to spread approaches; criteria definitions
assets/plan-template.html                styled HTML skeleton
assets/markdown-plan-template.md         Phase 3 template
```

## License

MIT
