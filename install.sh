#!/usr/bin/env bash
#
# Install the agent-ready skill so Claude Code can find it.
#
# Usage:
#   ./install.sh                 # install globally to ~/.claude/skills/
#   ./install.sh /path/to/repo   # install into a project's .claude/skills/
#
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/skills/agent-ready"

if [ ! -d "$SRC" ]; then
  echo "Could not find the skill at $SRC" >&2
  exit 1
fi

if [ "$#" -ge 1 ]; then
  DEST="$1/.claude/skills"
else
  DEST="$HOME/.claude/skills"
fi

mkdir -p "$DEST"
cp -R "$SRC" "$DEST/"

echo "Installed agent-ready to $DEST/agent-ready"
echo "Restart Claude Code if it is running, then run /agent-ready in any repo."
