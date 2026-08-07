#!/usr/bin/env bash
# ui-ultimate-reforce :: instala un componente de React Bits y reporta lo que costó
# Uso: bash add-component.sh <Componente> [TS-TW|TS-CSS|JS-TW|JS-CSS]
# Si no se pasa variante, se deduce del proyecto (tsconfig + tailwind).

set -uo pipefail

COMP="${1:-}"
if [ -z "$COMP" ]; then
  cat <<'EOF'
Uso: bash add-component.sh <Componente> [variante]

  <Componente>  nombre exacto en reactbits.dev (ej: BlurText, Aurora, SpotlightCard)
  [variante]    TS-TW (por defecto si hay tsconfig + tailwind), TS-CSS, JS-TW, JS-CSS

El script instala vía shadcn, y si falla intenta jsrepo. Después reporta qué
dependencias nuevas entraron y cuánto pesan, para decidir con datos.
EOF
  exit 1
fi

[ -f package.json ] || { echo "No hay package.json aquí. React Bits necesita un proyecto React."; exit 1; }

# --- deducir variante
VAR="${2:-}"
if [ -z "$VAR" ]; then
  LANG="JS"; STYLE="CSS"
  [ -f tsconfig.json ] && LANG="TS"
  if ls tailwind.config.* >/dev/null 2>&1 || grep -qE '"tailwindcss"' package.json 2>/dev/null; then
    STYLE="TW"
  fi
  VAR="${LANG}-${STYLE}"
  echo "Variante deducida del proyecto: $VAR"
fi

# --- foto del estado previo
BEFORE_DEPS=$(mktemp)
node -e 'const p=require("./package.json");console.log(Object.keys({...p.dependencies,...p.devDependencies}).sort().join("\n"))' \
  > "$BEFORE_DEPS" 2>/dev/null || : > "$BEFORE_DEPS"

echo "Instalando ${COMP}-${VAR}..."
if npx --yes shadcn@latest add "@react-bits/${COMP}-${VAR}"; then
  echo "Instalado vía shadcn."
else
  echo "shadcn falló. Intentando jsrepo..."
  STYLE_PATH="default"; [ "${VAR#*-}" = "TW" ] && STYLE_PATH="tailwind"
  echo "Si esto también falla, el nombre del componente probablemente no existe."
  echo "Verificá en https://reactbits.dev antes de reintentar."
  npx --yes jsrepo add "https://reactbits.dev/${STYLE_PATH}/${COMP}" || {
    echo "No se pudo instalar. No inventes el import: copiá el código desde reactbits.dev o escribí el efecto a mano."
    rm -f "$BEFORE_DEPS"; exit 1
  }
fi

# --- qué entró
AFTER_DEPS=$(mktemp)
node -e 'const p=require("./package.json");console.log(Object.keys({...p.dependencies,...p.devDependencies}).sort().join("\n"))' \
  > "$AFTER_DEPS" 2>/dev/null || : > "$AFTER_DEPS"

NEW=$(comm -13 "$BEFORE_DEPS" "$AFTER_DEPS" 2>/dev/null)
rm -f "$BEFORE_DEPS" "$AFTER_DEPS"

echo ""
echo "Dependencias nuevas:"
if [ -z "$NEW" ]; then
  echo "  ninguna — el componente es autocontenido, costo cercano a cero"
else
  printf '%s\n' "$NEW" | while read -r dep; do
    [ -z "$dep" ] && continue
    SIZE=$(du -sh "node_modules/$dep" 2>/dev/null | cut -f1)
    echo "  $dep  ${SIZE:-?} (sin comprimir en disco)"
    case "$dep" in
      three|@react-three/*|@react-spring/three|three-stdlib)
        echo "     AVISO: three pesa ~600 KB gzip. Para un fondo decorativo, no compensa."
        echo "     Alternativas: exportar el efecto como .webm desde el estudio de fondos"
        echo "     de reactbits.dev, o usar un componente equivalente basado en ogl." ;;
      ogl)
        echo "     WebGL ligero (~40 KB gzip). Aceptable, pero uno solo por pantalla" 
        echo "     y siempre con carga diferida + IntersectionObserver." ;;
      gsap|framer-motion|motion)
        echo "     Librería de animación compartida: el costo se paga una vez," 
        echo "     los siguientes componentes de este nivel casi no suman." ;;
    esac
  done
fi

cat <<'EOF'

Antes de dar el componente por bueno:
  1. Abrí el archivo generado y revisá que no haga peticiones de red inesperadas.
  2. Si es un fondo WebGL: envolvelo en carga diferida, IntersectionObserver
     y comprobación de prefers-reduced-motion (ver references/react-bits.md, sección 5).
  3. Corré: bash scripts/audit.sh
EOF
