#!/usr/bin/env bash
# ui-ultimate-reforce :: auditoría combinada de seguridad y peso
# Uso: bash audit.sh [ruta-del-proyecto]
# Se degrada sin fallar cuando falta una herramienta. Nunca instala nada global.

set -uo pipefail
ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "No existe la ruta: $ROOT"; exit 1; }

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  B=$'\033[1m'; R=$'\033[31m'; Y=$'\033[33m'; G=$'\033[32m'; D=$'\033[2m'; N=$'\033[0m'
else
  B=""; R=""; Y=""; G=""; D=""; N=""
fi

FINDINGS=0
WARNINGS=0
note()  { printf '%s\n' "  ${D}$1${N}"; }
ok()    { printf '%s\n' "  ${G}ok${N}  $1"; }
warn()  { printf '%s\n' "  ${Y}!!${N}  $1"; WARNINGS=$((WARNINGS+1)); }
bad()   { printf '%s\n' "  ${R}XX${N}  $1"; FINDINGS=$((FINDINGS+1)); }
head2() { printf '\n%s\n' "${B}$1${N}"; }

has() { command -v "$1" >/dev/null 2>&1; }

# Busca solo en código fuente; ignora dependencias y artefactos de build.
srcgrep() {
  grep -rIn --binary-files=without-match \
    --exclude-dir={node_modules,.git,dist,build,.next,out,vendor,target,.venv,venv,coverage,.cache,__pycache__} \
    --exclude={package-lock.json,yarn.lock,pnpm-lock.yaml,*.min.js,*.map} \
    -E "$1" . 2>/dev/null
}

srcgrepi() {
  grep -rIni --binary-files=without-match \
    --exclude-dir={node_modules,.git,dist,build,.next,out,vendor,target,.venv,venv,coverage,.cache,__pycache__} \
    --exclude={package-lock.json,yarn.lock,pnpm-lock.yaml,*.min.js,*.map} \
    -E "$1" . 2>/dev/null
}

# Filtra ejemplos, placeholders y lecturas legítimas de variables de entorno.
not_example() {
  grep -viE '(example|sample|dummy|fake|placeholder|your[_-]?|xxx|<|\$\{|process\.env|import\.meta\.env|os\.environ|getenv|System\.getenv)'
}

printf '%s\n' "${B}ui-ultimate-reforce :: auditoría de $(pwd)${N}"

# ---------------------------------------------------------------- 1. secretos
head2 "1. Secretos y credenciales"

if has gitleaks; then
  if gitleaks detect --no-banner --redact -v >/tmp/uur_gitleaks 2>&1; then
    ok "gitleaks: sin secretos en el historial"
  else
    bad "gitleaks encontró posibles secretos (revisá /tmp/uur_gitleaks)"
    grep -E '^\s*(Description|File|Line):' /tmp/uur_gitleaks 2>/dev/null | head -20 | sed 's/^/      /'
  fi
else
  note "gitleaks no instalado — se usa el escaneo básico de patrones"
fi

# a) nombre con pinta de credencial asignado a un literal largo
PAT='(api[_-]?key|secret|passwd|password|token|private[_-]?key|client[_-]?secret|auth|credential)[a-z0-9_]*["'"'"'`]?\s*[:=]\s*["'"'"'`][A-Za-z0-9_\-\.\/+]{16,}'
# b) formatos conocidos de proveedores: más preciso que adivinar por el nombre
PAT2='(sk-[A-Za-z0-9_\-]{16,}|ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_\-]{30,}|xox[baprs]-[0-9A-Za-z\-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|eyJ[A-Za-z0-9_\-]{20,}\.[A-Za-z0-9_\-]{20,}\.)'
HITS=$( { srcgrepi "$PAT"; srcgrep "$PAT2"; } | not_example | sort -u | head -12)
if [ -n "$HITS" ]; then
  bad "credenciales en texto plano dentro del código:"
  printf '%s\n' "$HITS" | cut -c1-160 | sed 's/^/      /'
  note "si alguna es real, no alcanza con borrarla: hay que rotarla"
else
  ok "sin credenciales literales evidentes en el código"
fi

# Secretos expuestos al cliente por prefijo público de bundler.
PUB=$(srcgrep '(NEXT_PUBLIC|VITE|REACT_APP|EXPO_PUBLIC|PUBLIC)_[A-Z0-9_]*(KEY|SECRET|TOKEN|PASSWORD|PRIVATE|CREDENTIAL)' | head -10)
if [ -n "$PUB" ]; then
  bad "variables públicas con pinta de secreto (terminan en el navegador del usuario):"
  printf '%s\n' "$PUB" | cut -c1-160 | sed 's/^/      /'
else
  ok "sin secretos detectados en variables de entorno públicas"
fi

# .env versionado.
if [ -d .git ]; then
  TRACKED=$(git ls-files 2>/dev/null | grep -E '(^|/)\.env(\.|$)' | grep -v '\.example$' | head -5)
  [ -n "$TRACKED" ] && bad ".env versionado en git: $(echo "$TRACKED" | tr '\n' ' ')" || ok ".env fuera del control de versiones"
fi

# ------------------------------------------------------------- 2. dependencias
head2 "2. Dependencias (OWASP A03 — cadena de suministro)"

if [ -f package.json ]; then
  if has npm; then
    AUD=$(npm audit --omit=dev --json 2>/dev/null)
    CRIT=$(printf '%s' "$AUD" | grep -o '"critical":[0-9]*' | head -1 | cut -d: -f2)
    HIGH=$(printf '%s' "$AUD" | grep -o '"high":[0-9]*'     | head -1 | cut -d: -f2)
    if [ -z "$CRIT$HIGH" ]; then
      note "npm audit no devolvió datos (probablemente falta 'npm install')"
    elif [ "${CRIT:-0}" -gt 0 ] || [ "${HIGH:-0}" -gt 0 ]; then
      bad "npm audit: $CRIT críticas, $HIGH altas en dependencias de producción"
      note "detalle: npm audit --omit=dev"
    else
      ok "npm audit: sin vulnerabilidades altas ni críticas en producción"
    fi
  fi
  if [ -f package-lock.json ] || [ -f yarn.lock ] || [ -f pnpm-lock.yaml ] || [ -f bun.lockb ]; then
    ok "lockfile presente"
  else
    warn "sin lockfile: las versiones pueden cambiar entre instalaciones"
  fi
fi

if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
  if has pip-audit; then
    if pip-audit -q >/dev/null 2>&1; then ok "pip-audit: sin hallazgos"; else warn "pip-audit reportó hallazgos (corré: pip-audit)"; fi
  else
    note "pip-audit no instalado (proyecto Python detectado)"
  fi
fi

if has osv-scanner; then
  if osv-scanner -r . >/tmp/uur_osv 2>&1; then ok "osv-scanner: sin hallazgos"; else warn "osv-scanner reportó hallazgos (revisá /tmp/uur_osv)"; fi
else
  note "osv-scanner no instalado (cubre npm, pip, go, maven, cargo)"
fi

# ------------------------------------------------------- 3. patrones de riesgo
head2 "3. Patrones de riesgo en el código (A05 — inyección)"

check_pattern() {
  local pat="$1" msg="$2" level="$3"
  local hits; hits=$(srcgrep "$pat" | head -6)
  if [ -n "$hits" ]; then
    [ "$level" = "bad" ] && bad "$msg" || warn "$msg"
    printf '%s\n' "$hits" | cut -c1-140 | sed 's/^/      /'
  fi
}

RISK=0
BEFORE=$((FINDINGS+WARNINGS))
check_pattern 'dangerouslySetInnerHTML' "dangerouslySetInnerHTML — verificá que pase por DOMPurify" warn
check_pattern '\.innerHTML\s*=' "asignación directa a innerHTML — usá textContent o sanitizá" warn
check_pattern 'v-html|\{@html' "HTML sin escapar en plantilla (v-html / {@html})" warn
check_pattern '(^|[^a-zA-Z_])eval\(|new Function\(' "eval o new Function con entrada dinámica" bad
check_pattern 'document\.write\(' "document.write bloquea el parser y es vector de inyección" warn
check_pattern 'execSync\(|child_process.*\+|os\.system\(|subprocess.*shell\s*=\s*True' "comando de shell construido por concatenación" bad
check_pattern '(SELECT|INSERT|UPDATE|DELETE)[^;]{0,80}(\+ *(req|params|input|user)|\$\{|% *\()' "SQL construido por concatenación — usá consultas parametrizadas" bad
check_pattern 'localStorage\.setItem\(["'"'"'`](token|jwt|auth|access_token|refresh)' "token en localStorage — preferí cookie HttpOnly" warn
check_pattern 'verify\s*=\s*False|rejectUnauthorized:\s*false|InsecureSkipVerify:\s*true' "verificación de certificado TLS desactivada" bad
check_pattern 'Access-Control-Allow-Origin["'"'"'`:,\s]+\*' "CORS abierto a cualquier origen" warn
check_pattern 'catch\s*\([a-zA-Z_]*\)\s*\{\s*\}' "catch vacío — A10, condiciones excepcionales sin manejar" warn
[ $((FINDINGS+WARNINGS)) -eq $BEFORE ] && ok "sin patrones de riesgo conocidos"

# --------------------------------------------------------------- 4. peso / UI
head2 "4. Peso y rendimiento"

if [ -f package.json ]; then
  for heavy in three moment lodash jquery @tensorflow/tfjs chart.js; do
    grep -qE "\"$heavy\"\s*:" package.json 2>/dev/null && warn "dependencia pesada declarada: $heavy — revisá si entra en el bundle inicial"
  done

  BARREL=$(srcgrep "import \* as .* from ['\"](lucide-react|react-icons|mx-icons|@heroicons)" | head -5)
  [ -n "$BARREL" ] && { bad "import de barril de iconos (rompe el tree-shaking):"; printf '%s\n' "$BARREL" | cut -c1-140 | sed 's/^/      /'; } || ok "iconos importados de forma individual"

  RM=$(srcgrep 'prefers-reduced-motion' | head -1)
  ANIM=$(srcgrep "from ['\"](framer-motion|motion|gsap|three|ogl)" | head -1)
  if [ -n "$ANIM" ] && [ -z "$RM" ]; then
    warn "hay librería de animación pero ningún prefers-reduced-motion en el proyecto"
  elif [ -n "$RM" ]; then
    ok "prefers-reduced-motion presente"
  fi

  ALLPROP=$(srcgrep "transition:\s*[\"'\`]?all" | head -3)
  [ -n "$ALLPROP" ] && warn "transition: all — declará las propiedades para no animar layout sin querer"
fi

for d in dist build .next/static out; do
  if [ -d "$d" ]; then
    SIZE=$(du -sh "$d" 2>/dev/null | cut -f1)
    JSB=$(find "$d" -name '*.js' -not -name '*.map' -exec du -ch {} + 2>/dev/null | tail -1 | cut -f1)
    note "build en $d: total $SIZE, JS $JSB (objetivo: ≤ 170 KB gzip en la ruta crítica)"
    break
  fi
done

IMGS=$(find . -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' \) \
  -not -path './node_modules/*' -not -path './.git/*' -size +500k 2>/dev/null | head -5)
[ -n "$IMGS" ] && { warn "imágenes de más de 500 KB (convertí a webp/avif):"; printf '%s\n' "$IMGS" | sed 's/^/      /'; }

# ----------------------------------------------------------------- resultado
head2 "Resultado"
printf '  %s hallazgo(s) que bloquean, %s advertencia(s)\n' "$FINDINGS" "$WARNINGS"
if [ "$FINDINGS" -gt 0 ]; then
  printf '  %sNo cierres la tarea sin resolver los hallazgos marcados con XX.%s\n' "$R" "$N"
  exit 1
fi
printf '  %sPuertas de peso y seguridad superadas.%s\n' "$G" "$N"
exit 0
