#!/usr/bin/env bash
# Instala ui-ultimate-reforce en ~/.claude/skills/ (o en el proyecto actual con --local)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$HOME/.claude"
[ "${1:-}" = "--local" ] && ROOT="$(pwd)/.claude"
DEST="$ROOT/skills/ui-ultimate-reforce"
CMD_DEST="$ROOT/commands/reforce"

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
mkdir -p "$DEST"

# Solo lo que la skill necesita en tiempo de ejecución.
cp "$SRC/SKILL.md" "$DEST/"
cp -r "$SRC/references" "$SRC/scripts" "$SRC/assets" "$DEST/"
chmod +x "$DEST/scripts/"*.sh

# Comandos /reforce:* (build, polish, motion, secure, perf, style, variants, brief, copy, brand).
rm -rf "$CMD_DEST"
mkdir -p "$CMD_DEST"
cp "$SRC/commands/reforce/"*.md "$CMD_DEST/"

echo "Skill instalada en:    $DEST"
echo "Comandos instalados en: $CMD_DEST  (usá /reforce:build, /reforce:polish, …)"
echo "Verificá con /skills y /help dentro de una sesión de Claude Code."
