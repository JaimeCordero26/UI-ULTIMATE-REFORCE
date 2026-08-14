---
name: ui-ultimate-reforce
description: Sistema unificado para construir interfaces de alto impacto visual, bajo consumo de recursos y seguras, en cualquier lenguaje o stack (React/Next, Vue, Svelte, HTML/CSS, Astro, Flutter, Compose, JavaFX, Python TUI, CLI). Usa esta skill SIEMPRE que la tarea toque UI, pantallas, componentes, layout, estilos, temas, arquetipos visuales (minimalismo, bento grid, glassmorphism, neumorphism, brutalism, aurora), tipografía, iconos, landing pages, dashboards, formularios, animaciones, movimiento o transiciones; cuando el usuario pida que algo "se vea bien", "se vea pro", "moderno", "increíble", "con onda" o "con buen gusto"; cuando haya que instalar componentes de React Bits / Vue Bits / Svelte Bits, elegir iconos (mx-icons, Lucide, Iconify), definir tokens de diseño, animar con GSAP / Framer Motion / CSS, aplicar principios de motion (Emil Kowalski) o de micro-interacciones (Dan Saffer), explorar variantes de diseño, aplicar heurísticas de usabilidad (Nielsen) o tácticas de Refactoring UI, definir arquitectura de componentes, tipografía web, dibujar con canvas/SVG/WebGL, generar un tema completo desde un color de marca, escribir copy de interfaz o mensajes memorables (SUCCESS de Made to Stick), aplicar/definir guía de marca, revisar peso de bundle y rendimiento del front, o auditar seguridad de la app. También trae un modo de compresión de salida propio (estilo caveman) y comandos `/reforce:*` para intervenir por partes (build, polish, motion, secure, perf, style, variants, brief, copy, brand). Aplícala en construcción completa de un prompt y en prototipos, mockups, HTML desechable, ejemplos y refactors visuales, aunque el usuario nunca mencione diseño, rendimiento ni seguridad.
---

# UI Ultimate Reforce

Toda interfaz que salga de este proyecto debe pasar tres puertas antes de darse por
terminada: **se ve bien**, **pesa poco** y **no se rompe ni filtra nada**. Si una falla,
el trabajo no está hecho, aunque el usuario solo haya pedido "una pantalla rápida".

La razón de las tres puertas juntas: una UI bonita que carga 3 MB de WebGL en un celular
de gama media es peor que una UI sobria, y una UI rápida que expone una API key en el
bundle es un incidente, no un entregable.

## Regla de carga: leé poco, leé tarde

Este archivo es lo único que entra en contexto al activarse la skill. Las referencias son
archivos separados que se leen **solo cuando la tarea lo pide**. No leas más de dos por
tarea. Si la tarea es "cambiá el color de un botón", no leas ninguna.

| Situación | Leé |
|---|---|
| Proyecto React/Next y toca animación, fondo, hero, efecto visual | `references/react-bits.md` |
| Hay que poner iconos en cualquier stack | `references/icons.md` |
| Proyecto nuevo, rediseño, o no hay sistema visual definido | `references/design-tokens.md` |
| Hay que construir UI real (hero, tarjetas, dashboard, formulario, navbar) y que se vea premium | `references/recipes.md` |
| Hay que animar, hacer scroll-driven, usar GSAP/Framer, o el movimiento se siente torpe | `references/motion.md` |
| Hay que elegir/aplicar un lenguaje visual completo (bento, glass, minimal, brutalism, aurora…) | `references/style-systems.md` |
| "Se ve correcto pero le falta algo", "hacelo más pro/con gusto", o hay que explorar variantes | `references/taste.md` |
| El stack NO es React (Vue, Svelte, HTML, Flutter, Compose, JavaFX, Python, CLI/TUI) | `references/stacks.md` |
| Se nota lento, hay que medir, o se van a agregar 2+ efectos | `references/performance.md` |
| Hay auth, formularios, datos de usuario, pagos, API, deploy, o el usuario pide auditar | `references/security.md` |
| Formularios, navegación por teclado, contraste, dudas de accesibilidad | `references/a11y.md` |
| El usuario pide "modo caveman", "menos tokens" o "sé breve" | `references/brief-mode.md` |
| Hay que decidir arquitectura de componentes, capas del design system o cómo organizar CSS/props | `references/frontend-design.md` |
| El pedido es "que quede pro/nivel producción", o hay que hacer el pase final antes de cerrar una pantalla importante | `references/ui-ux-pro-max.md` |
| Hay que resolver jerarquía/contraste/espaciado con tácticas puntuales (Refactoring UI) | `references/refactoring-ui.md` |
| Hay que definir escala tipográfica, largo de línea, pareo de fuentes o texto fluido | `references/web-typography.md` |
| Hay que diseñar un toggle, like, validación en vivo, undo u otra micro-interacción puntual | `references/microinteractions.md` |
| Dudas de usabilidad, flujo confuso, carga cognitiva o patrones que el usuario espera | `references/ux-heuristics.md` |
| Hay que estructurar HTML: formularios, landmarks, o modal/acordeón/menú (dialog, details, popover nativos) | `references/design-html.md` |
| Hay que dibujar con canvas/SVG/WebGL más allá de un efecto de fondo, o visualizar datos custom | `references/canvas-design.md` |
| Hay que generar una paleta/tema completo (claro+oscuro) desde un color semilla | `references/theme-factory.md` |
| Hay que escribir copy de UI: botones, mensajes de error, estados vacíos, confirmaciones | `references/content-studio.md` |
| El proyecto tiene o necesita guía de marca (logo, tono, uso de color) | `references/brand-guidelines.md` |
| Hay que escribir un headline, propuesta de valor u onboarding memorable | `references/made-to-stick.md` |

## Flujo de trabajo

1. **Detectá el stack antes de escribir código.** Leé `package.json`, `pubspec.yaml`,
   `requirements.txt`, `pom.xml` o lo que exista. Nunca asumas React. Si no hay proyecto,
   preguntá una sola cosa: framework y si acepta dependencias nuevas.
2. **Fijá el sistema visual.** Si el proyecto ya tiene tokens, paleta o design system
   propio (por ejemplo un `tailwind.config`, un `theme.dart`, o una skill de diseño
   específica del proyecto), **esa manda y esta skill se subordina**. Si no hay nada,
   copiá `assets/tokens.css` y trabajá sobre esos tokens.
3. **Elegí el nivel de efecto según el presupuesto** (tabla de abajo). Un efecto pesado
   por pantalla, como máximo. El resto se resuelve con tipografía, espaciado, jerarquía y
   micro-interacciones CSS, que cuestan 0 KB.
4. **Construí.** Componentes reales, estados reales (loading, vacío, error), responsive
   desde 360 px.
5. **Cerrá con las tres puertas.** Corré `scripts/audit.sh` si el proyecto tiene JS/TS,
   y repasá el checklist de cierre al final de este archivo.

## Modos de uso: todo junto o por partes

El caso principal es la **construcción completa** (el flujo de arriba, las tres puertas). Pero
la skill también sirve para intervenir en una sola cosa sin rehacer el resto. Detectá el modo
por lo que pide el usuario y ejecutá solo esa parte:

| El usuario pide… | Modo / comando | Qué hacés (y qué NO tocás) |
|---|---|---|
| "hacé la pantalla / la landing / el dashboard" | **Construir** · `/reforce:build` | Flujo completo + tres puertas. |
| "esto se ve feo / mejoralo / hacelo pro / con gusto" | **Rediseño visual** · `/reforce:polish` | Puerta de diseño: `taste.md`, tokens, jerarquía, `recipes.md`. No reescribas lógica. |
| "animá / hacelo con movimiento / scroll-driven" | **Movimiento** · `/reforce:motion` | Solo `motion.md`. Interaction thesis + mini-audit. |
| "quiero estilo bento / glass / minimal / brutalism…" | **Estilo** · `/reforce:style` | Solo `style-systems.md`. Un arquetipo, consistente. |
| "mostrame opciones / explorá variantes" | **Variantes** · `/reforce:variants` | HTML desechable, 3–5 variantes, comparar y elegir. |
| "está lento / pesa mucho / optimizá" | **Peso** · `/reforce:perf` | Solo `performance.md` + `audit.sh`. Medí antes de tocar. |
| "revisá seguridad / auditá / ¿es seguro?" | **Seguridad** · `/reforce:secure` | Solo `security.md` + `audit.sh`. Reportá hallazgos, no cambies diseño. |
| "arreglá el foco / el teclado / el contraste" | **Accesibilidad** | Solo `a11y.md`. |
| "agregá el efecto / componente X" | **Componente** | `add-component.sh` + reportá el costo antes de aceptar. |
| "escribí el copy / los mensajes de error / el texto de los botones / el headline" | **Copy** · `/reforce:copy` | `content-studio.md` (+ `made-to-stick.md` si es headline/propuesta de valor). No toques layout ni componentes. |
| "necesito guía de marca / esto respeta la marca / no tenemos marca definida" | **Marca** · `/reforce:brand` | `brand-guidelines.md` (+ `theme-factory.md` si hay que generar paleta). No inventes marca si ya existe una. |
| "modo caveman / menos tokens / sé breve" | **Breve** · `/reforce:brief` | `brief-mode.md`. Comprime prosa, nunca código ni avisos de puertas. |

Los comandos `/reforce:*` son la misma cosa que los modos, invocables por nombre. Se instalan
en `.claude/commands/reforce/` (ver `install.sh`). Sirven cuando el usuario quiere disparar
una parte sin describir todo el flujo: pulir más, endurecer seguridad, sumar movimiento.

Regla: en modo por partes, **no expandas el alcance**. Si al corregir el peso ves un problema
de seguridad, avisalo en una línea; no lo arregles sin permiso. Un modo, un cambio acotado,
un reporte claro. Así el usuario puede corregir cosas de a una sin sorpresas.

## Presupuesto de recursos (aplica siempre, sin leer nada más)

Estos números evitan el problema clásico de que la UI quede "increíble" y el proyecto
quede inservible en un celular de CR con datos móviles:

- JS inicial: **≤ 170 KB gzip** en la ruta crítica. Todo lo demás va lazy.
- Un solo efecto WebGL/canvas por pantalla, y siempre por debajo del fold o detrás de
  `IntersectionObserver`. Si la pestaña se oculta, se pausa el loop.
- Nada de `three` (~600 KB) para un fondo decorativo. Si el efecto solo existe con
  `three`, proponé la alternativa CSS/`ogl` y explicá el costo.
- Animá solo `transform` y `opacity`. Animar `width`, `top`, `box-shadow` o `filter`
  fuerza layout/paint en cada frame y es lo que hace que se sienta lento.
- Respetá `prefers-reduced-motion` en toda animación no esencial. No es opcional: es
  accesibilidad y además es el interruptor de emergencia para equipos lentos.
- Fuentes: máximo 2 familias, `font-display: swap`, subset latino, `preload` de la que
  se usa en el primer render.
- Imágenes: formato moderno, `width`/`height` explícitos para no generar CLS,
  `loading="lazy"` fuera del fold.
- Objetivos medibles: LCP < 2.5 s, INP < 200 ms, CLS < 0.1.

**Regla de degradación:** si el equipo objetivo es gama baja, hay `prefers-reduced-motion`
activo, o la pantalla es crítica (login, checkout, formularios largos), bajá un nivel de
efecto automáticamente y decilo en una línea.

## Reglas rápidas que aplican siempre

- Jerarquía antes que decoración: una escala tipográfica clara y espaciado consistente
  hacen más por el resultado que cualquier fondo animado.
- Contraste mínimo 4.5:1 en texto normal, 3:1 en texto grande e iconos accionables.
- Área táctil mínima 44×44 px.
- Estados obligatorios en cualquier vista con datos: cargando, vacío, error, éxito.
- Nada de placeholders como etiqueta de campo: el label va visible siempre.
- Un acento de color por pantalla. Dos acentos compitiendo se lee como plantilla.
- Iconos: import individual, nunca barril completo (`import * as Icons` mata el
  tree-shaking y suma cientos de KB).
- Antes de agregar una dependencia nueva, mirá peso, última publicación y mantenedores.
  Una librería de 40 KB para un componente que se resuelve en 20 líneas de CSS no entra.

## Modo breve propio (caveman incluido) y compatibilidad

La skill trae su **propio** modo de compresión de salida (`references/brief-mode.md`,
`/reforce:brief [lite|full|ultra|off]`): recorta la prosa como caveman pero sabe de las tres
puertas, así que es todo-en-uno y no depende de nada externo. Reglas base:

- Todo lo que sea código, comando, ruta, nombre de componente, dependencia o mensaje de
  error se escribe **exacto y completo**, nunca comprimido.
- La narración alrededor (explicaciones, justificaciones de diseño) sí se comprime.
- **Excepción de claridad:** los avisos de las tres puertas se escriben en español normal
  y completo, aunque el nivel sea `ultra`. Un hallazgo de seguridad, una advertencia de peso
  o un aviso de que se bajó el nivel de efecto tienen que entenderse a la primera.
- Formato de aviso corto, una línea por puerta:
  `[UI] hero + tokens listos. [MOV] entrada ease-out 200ms. [PESO] +24 KB gzip, gsap lazy. [SEC] sin hallazgos.`
- **Compatibilidad:** si el usuario ya usa la skill/plugin caveman externa, no dupliques la
  compresión; solo garantizá la excepción de claridad de las puertas. El último modo invocado
  fija el nivel.

## Scripts incluidos

Corren solos y se degradan sin quejarse si falta una herramienta. No requieren instalar
nada globalmente.

- `scripts/audit.sh` — auditoría combinada: secretos en el repo, dependencias
  vulnerables, peso del build, y patrones de riesgo en el front (`dangerouslySetInnerHTML`,
  `eval`, `innerHTML`, secretos en variables de entorno públicas). Uso: `bash scripts/audit.sh [ruta]`
- `scripts/add-component.sh` — instala un componente de React Bits por CLI y reporta qué
  dependencias nuevas entraron y cuánto pesan, para decidir con datos antes de aceptarlas.
  Uso: `bash scripts/add-component.sh <Componente> [TS-TW|TS-CSS|JS-TW|JS-CSS]`
- `scripts/pre-commit.sh` — engancha `audit.sh` como hook de git para que la puerta de
  seguridad corra **sola** en cada commit y bloquee si hay hallazgos. Es el antídoto al
  problema de que la seguridad se "olvide": deja de depender de que alguien se acuerde.
  Instalar una vez por repo: `bash scripts/pre-commit.sh --install`

## La puerta de seguridad no es opcional

El error más común de un agente construyendo UI es entregar algo lindo y rápido y **saltarse
la seguridad** porque el usuario no la pidió. En esta skill no se salta: es una de las tres
puertas y se reporta siempre, aunque el pedido haya sido solo "una pantalla rápida". Si no
hubo tiempo de auditar a fondo, se dice explícitamente qué quedó sin revisar. No se entrega
en silencio.

## Checklist de cierre

Antes de decir que la tarea está lista, verificá y reportá en máximo tres líneas:

1. **Diseño** — jerarquía clara, estados completos, responsive a 360 px, contraste OK.
2. **Peso** — dependencias nuevas justificadas, efectos pesados lazy y pausables,
   `prefers-reduced-motion` respetado, sin barriles de iconos.
3. **Seguridad** — sin secretos en el cliente, sin HTML sin sanitizar, autorización
   validada en el servidor, errores manejados sin filtrar detalles internos.

Si algo no se cumplió por decisión consciente (por ejemplo, el usuario quiere el fondo
WebGL igual), dejalo escrito en una línea con el costo asociado. No lo escondas.
