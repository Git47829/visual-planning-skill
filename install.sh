#!/usr/bin/env bash
# Install the visual-planning skill for Claude Code (or Codex/agent dirs via SKILLS_DIR).
#
#   curl -fsSL https://raw.githubusercontent.com/Git47829/visual-planning-skill/main/install.sh | bash
#
# Also installs the `diagram-design` skill it depends on for inline-SVG diagrams
# (https://github.com/mahip-kakan/diagram-design, MIT). Skip with --no-diagram.
#
# Env:
#   SKILLS_DIR   target skills directory (default: ~/.claude/skills)
#   REPO_URL     source repo (default: this repo on GitHub)
#   REF          branch or tag to install (default: main)
#   DIAGRAM_REPO override the diagram-design source repo

set -euo pipefail

SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
REPO_URL="${REPO_URL:-https://github.com/Git47829/visual-planning-skill.git}"
REF="${REF:-main}"
DIAGRAM_REPO="${DIAGRAM_REPO:-https://github.com/mahip-kakan/diagram-design.git}"
WITH_DIAGRAM=1

for arg in "$@"; do
  case "$arg" in
    --no-diagram) WITH_DIAGRAM=0 ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWarning:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || die "git is required but not installed."
mkdir -p "$SKILLS_DIR"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# clone_repo <url> <ref> <dest>
clone_repo() {
  git clone --depth 1 --branch "$3" "$1" "$2" >/dev/null 2>&1 \
    || die "clone failed: $1 ($3)"
}

# stage_into <skill_name> <source_dir_containing_SKILL.md>
stage_into() {
  local name="$1" src="$2" target="$SKILLS_DIR/$1"
  [ -f "$src/SKILL.md" ] || die "no SKILL.md in $src"
  if [ -e "$target" ]; then
    local backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    say "Previous $name kept at $backup"
  fi
  mkdir -p "$target"
  cp "$src/SKILL.md" "$target/"
  for d in references assets scripts examples; do
    [ -d "$src/$d" ] && cp -R "$src/$d" "$target/"
  done
  say "Installed $name to $target"
}

# --- visual-planning -------------------------------------------------------
SELF="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$SELF" ] && [ -f "$SELF/SKILL.md" ]; then
  stage_into visual-planning "$SELF"
else
  say "Cloning $REPO_URL ($REF)"
  clone_repo "$REPO_URL" "$TMP/vp" "$REF"
  stage_into visual-planning "$TMP/vp"
fi

# --- diagram-design (dependency) -------------------------------------------
if [ "$WITH_DIAGRAM" -eq 1 ]; then
  if [ -f "$SKILLS_DIR/diagram-design/SKILL.md" ]; then
    say "diagram-design already installed — skipping"
  else
    say "Installing dependency: diagram-design"
    if git clone --depth 1 "$DIAGRAM_REPO" "$TMP/dd" >/dev/null 2>&1; then
      if [ -f "$TMP/dd/skills/diagram-design/SKILL.md" ]; then
        stage_into diagram-design "$TMP/dd/skills/diagram-design"
      elif [ -f "$TMP/dd/SKILL.md" ]; then
        stage_into diagram-design "$TMP/dd"
      else
        warn "diagram-design layout not recognised — install it manually from $DIAGRAM_REPO"
      fi
    else
      warn "could not clone $DIAGRAM_REPO — visual-planning falls back to Mermaid diagrams"
    fi
  fi
fi

cat <<MSG

Next:
  1. Restart Claude Code (or start a new session) so it picks up the skills.
  2. Ask for a plan: "plan out how to add X" — or invoke it directly.

Uninstall:
  rm -rf "$SKILLS_DIR/visual-planning" "$SKILLS_DIR/diagram-design"
MSG
