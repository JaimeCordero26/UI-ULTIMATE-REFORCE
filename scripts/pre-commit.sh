#!/usr/bin/env bash
# ui-ultimate-reforce :: hook de pre-commit que corre la puerta de seguridad sola
# Instalar una vez por repo:  bash scripts/pre-commit.sh --install
# Ejecutar manualmente:       bash scripts/pre-commit.sh
#
# Es el antídoto a "la seguridad se olvidó": una vez instalado, audit.sh corre en cada
# commit y lo bloquea si hay hallazgos que bloquean (código de salida 1).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT="$DIR/audit.sh"

if [ "${1:-}" = "--install" ]; then
  GITDIR=$(git rev-parse --git-dir 2>/dev/null) || { echo "No es un repo git. Corré 'git init' primero."; exit 1; }
  HOOK="$GITDIR/hooks/pre-commit"
  mkdir -p "$(dirname "$HOOK")"
  if [ -f "$HOOK" ] && ! grep -q "ui-ultimate-reforce" "$HOOK" 2>/dev/null; then
    echo "Ya existe un pre-commit distinto en $HOOK."
    echo "Agregá esta línea a mano para no pisar el tuyo:"
    echo "    bash \"$AUDIT\" || exit 1"
    exit 1
  fi
  cat > "$HOOK" <<EOF
#!/usr/bin/env bash
# ui-ultimate-reforce :: puerta de seguridad automática
bash "$AUDIT" || {
  echo ""
  echo "Commit bloqueado por la puerta de seguridad. Resolvé los hallazgos XX o corré:"
  echo "    git commit --no-verify   (solo si sabés lo que hacés)"
  exit 1
}
EOF
  chmod +x "$HOOK"
  echo "Hook instalado en $HOOK"
  echo "Desde ahora audit.sh corre solo en cada 'git commit'."
  exit 0
fi

# Sin --install: corre la auditoría directamente.
[ -x "$AUDIT" ] || chmod +x "$AUDIT" 2>/dev/null
exec bash "$AUDIT"
