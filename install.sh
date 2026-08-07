#!/usr/bin/env bash
# Instala ui-ultimate-reforce en ~/.claude/skills/ (o en el proyecto actual con --local)
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.claude/skills/ui-ultimate-reforce"
[ "${1:-}" = "--local" ] && DEST="$(pwd)/.claude/skills/ui-ultimate-reforce"

mkdir -p "$(dirname "$DEST")"
rm -rf "$DEST"
mkdir -p "$DEST"

# Solo lo que la skill necesita en tiempo de ejecución.
cp "$SRC/SKILL.md" "$DEST/"
cp -r "$SRC/references" "$SRC/scripts" "$SRC/assets" "$DEST/"
chmod +x "$DEST/scripts/"*.sh

echo "Instalada en: $DEST"
echo "Verificá con /skills dentro de una sesión de Claude Code."
