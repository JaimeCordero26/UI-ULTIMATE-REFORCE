# UI Ultimate Reforce

Skill de [Claude Code](https://claude.com/claude-code) que hace que cualquier proyecto salga
con una interfaz de alto nivel, liviana y segura, sin importar el lenguaje ni el framework.

La idea es simple: cuando le pedís una pantalla a un agente, normalmente conseguís una de
tres cosas: se ve bien pero pesa 3 MB, es liviana pero parece un formulario de 2009, o
funciona pero filtra una API key en el bundle. Esta skill obliga a que las tres cosas se
resuelvan juntas.

## Las tres puertas

Toda interfaz tiene que pasar por las tres antes de darse por terminada:

| Puerta | Qué verifica |
|---|---|
| **Diseño** | jerarquía clara, estados completos (carga, vacío, error), responsive desde 360 px, contraste suficiente |
| **Peso** | ≤ 170 KB gzip de JS inicial, un solo efecto pesado por pantalla, `prefers-reduced-motion` respetado, sin barriles de iconos |
| **Seguridad** | sin secretos en el cliente, sin HTML sin sanitizar, autorización validada en el servidor, errores manejados |

## Por qué no infla el contexto

Es el problema típico de las skills grandes: mientras más completas, más tokens comen en
cada turno. Esta usa carga progresiva en tres niveles.

```
descripción (~150 palabras)   siempre en contexto
SKILL.md (124 líneas)          entra solo cuando la skill se activa
references/ (7 archivos)       se leen solo si la tarea los pide, máximo 2 por tarea
```

Un proyecto Python nunca carga la referencia de React Bits. Un cambio de color de botón no
carga ninguna referencia. El `SKILL.md` trae una tabla de ruteo que decide qué abrir y qué
no, y el presupuesto de rendimiento está escrito ahí adentro para que el caso común se
resuelva sin leer nada más.

## Qué trae

**Componentes y visual**
- React Bits, con sus puertos oficiales de Vue y Svelte: instalación por `shadcn` o
  `jsrepo`, y un catálogo clasificado **por peso real**, que es lo que decide cuántos
  efectos entran por pantalla. Los fondos WebGL usan `ogl` (~40 KB); los componentes 3D
  arrastran `three` (~600 KB) y la skill los desaconseja salvo que el 3D sea el producto.
- Iconos: `mx-icons` (5.600+ iconos, tres variantes, tree-shakeable), Lucide, e Iconify
  para stacks que no son React. Con la regla de importar icono por icono, nunca el barril.
- `assets/tokens.css`: sistema de tokens listo para copiar, con tema claro y oscuro
  derivados de una sola variable de tono, escala tipográfica, espaciado, sombras y el
  bloque de `prefers-reduced-motion` ya resuelto.

**Cualquier stack, no solo React**
Vue/Nuxt, Svelte, Astro y HTML plano, React Native, Flutter, Jetpack Compose, JavaFX y
Swing, Tauri y Electron, Python con Textual y Rich, y herramientas de línea de comandos.
Una CLI también es una interfaz y pasa por las mismas puertas.

**Seguridad**
Basada en el **OWASP Top 10 2025**, la octava edición finalizada en enero de 2026, no en
la lista de 2021 que todavía circula en la mayoría del material. Incluye las dos
categorías nuevas: fallas de cadena de suministro (A03) y manejo incorrecto de condiciones
excepcionales (A10). Además cubre lo específico de trabajar con un agente: dependencias
instaladas por CLI, e instrucciones que aparecen dentro del contenido que el agente lee.

## Scripts

Corren sin instalar nada global y se degradan sin quejarse cuando falta una herramienta.

```bash
bash scripts/audit.sh [ruta]
```

Auditoría combinada. Detecta secretos literales y formatos conocidos de token (`sk-`,
`ghp_`, `AKIA`, claves privadas, JWT), variables `NEXT_PUBLIC_`/`VITE_` con pinta de
secreto que terminan en el navegador, `.env` versionado, dependencias vulnerables,
`innerHTML` y `dangerouslySetInnerHTML` sin sanitizar, SQL y comandos de shell por
concatenación, TLS desactivado, `catch` vacíos, barriles de iconos, dependencias pesadas,
`transition: all` e imágenes sin optimizar. Sale con código 1 si hay hallazgos que
bloquean, así que sirve en un hook de pre-commit o en CI.

Usa `gitleaks`, `osv-scanner`, `pip-audit` y `npm audit` si están disponibles, y cae a un
escaneo propio por patrones cuando no.

```bash
bash scripts/add-component.sh <Componente> [TS-TW|TS-CSS|JS-TW|JS-CSS]
```

Instala un componente de React Bits deduciendo la variante del proyecto, y después reporta
**qué dependencias nuevas entraron y cuánto pesan**, con una advertencia específica si
apareció `three`. La idea es decidir con datos antes de aceptar el costo, no descubrirlo
cuando el build ya pesa 2 MB.

## Instalación

```bash
git clone https://github.com/<usuario>/ui-ultimate-reforce.git
cp -r ui-ultimate-reforce ~/.claude/skills/
chmod +x ~/.claude/skills/ui-ultimate-reforce/scripts/*.sh
```

O para un solo proyecto, copiala en `.claude/skills/` del repo.

Verificá con `/skills` dentro de una sesión de Claude Code.

### NixOS

Para que sobreviva a un rebuild, enlazala desde tu configuración en vez de copiarla:

```nix
home.file.".claude/skills/ui-ultimate-reforce" = {
  source = ./skills/ui-ultimate-reforce;
  recursive = true;
};

environment.systemPackages = with pkgs; [ gitleaks osv-scanner ];
```

Los dos paquetes son opcionales; el script funciona sin ellos con menos precisión.

## Cómo se activa

Sola. La descripción cubre pantallas, componentes, estilos, temas, iconos, landing pages,
dashboards, formularios y animaciones, además de frases como "que se vea bien" o "que se
vea pro". No hace falta invocarla por nombre ni mencionar diseño o seguridad.

Si el proyecto ya tiene un sistema de diseño propio, ese manda y la skill se subordina.

## Convivencia con caveman

Funciona junto a [caveman](https://github.com/JuliusBrussee/caveman) sin conflicto: caveman
comprime la prosa de salida, esta skill define qué se construye. Todo lo que sea código,
comando o nombre de dependencia se escribe exacto, y los avisos de las tres puertas quedan
exentos de la compresión, porque una advertencia de seguridad tiene que entenderse a la
primera. En modo comprimido el reporte de cierre es una línea:

```
[UI] hero + tokens listos. [PESO] +12 KB gzip, ogl lazy. [SEC] sin hallazgos.
```

## Estructura

```
ui-ultimate-reforce/
├── SKILL.md                    router y presupuesto de recursos
├── assets/
│   └── tokens.css              sistema de tokens claro/oscuro
├── references/
│   ├── react-bits.md           instalación, catálogo por peso, integración SSR
│   ├── icons.md                mx-icons, Lucide, Iconify y reglas de peso
│   ├── design-tokens.md        cómo fijar paleta, tipografía y espaciado
│   ├── stacks.md               UI fuera de React: Vue, Flutter, JavaFX, Python, CLI
│   ├── performance.md          presupuestos, causas reales de lentitud, medición
│   ├── security.md             OWASP Top 10 2025 aplicado al código que se escribe
│   └── a11y.md                 accesibilidad práctica
└── scripts/
    ├── audit.sh                auditoría de seguridad y peso
    └── add-component.sh        instalar React Bits reportando el costo
```

## Licencia

MIT. React Bits se distribuye bajo MIT + Commons Clause y no se incluye en este
repositorio; la skill solo documenta cómo instalarlo desde su fuente oficial.
