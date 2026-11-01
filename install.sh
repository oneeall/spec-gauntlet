#!/usr/bin/env bash
# Install the spec-gauntlet skill for ZCode.
# Symlinks this repo's skill into ~/.zcode/skills/ (falls back to a copy)
# so it is discovered in every project. Re-running is safe.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$REPO_DIR/.agents/skills/spec-gauntlet"
SKILL_DST_DIR="${ZCODE_SKILLS_DIR:-$HOME/.zcode/skills}"
SKILL_DST="$SKILL_DST_DIR/spec-gauntlet"

if [[ ! -f "$SKILL_SRC/SKILL.md" ]]; then
  echo "error: $SKILL_SRC/SKILL.md not found" >&2
  exit 1
fi

mkdir -p "$SKILL_DST_DIR"

if [[ -L "$SKILL_DST" ]]; then
  echo "replacing existing symlink at $SKILL_DST"
  rm "$SKILL_DST"
elif [[ -e "$SKILL_DST" ]]; then
  echo "error: $SKILL_DST already exists and is not a symlink; remove it first" >&2
  exit 1
fi

if ln -s "$SKILL_SRC" "$SKILL_DST" 2>/dev/null; then
  echo "installed: $SKILL_DST -> $SKILL_SRC (symlink)"
else
  cp -R "$SKILL_SRC" "$SKILL_DST"
  echo "installed: $SKILL_DST (copy; symlink unavailable)"
fi

echo "done. Trigger it by asking for a feature, or explicitly with /spec-gauntlet."
echo "uninstall: rm $SKILL_DST"
