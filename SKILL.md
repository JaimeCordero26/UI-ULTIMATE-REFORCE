---
name: ui-ultimate-reforce
description: Sistema unificado para construir interfaces de alto impacto visual, bajo consumo de recursos y seguras, en cualquier lenguaje o stack (React/Next, Vue, Svelte, HTML/CSS, Astro, Flutter, Compose, JavaFX, Python TUI, CLI). Usa esta skill SIEMPRE que la tarea toque UI, pantallas, componentes, layout, estilos, temas, tipografía, iconos, landing pages, dashboards, formularios, animaciones o transiciones; cuando el usuario pida que algo "se vea bien", "se vea pro", "moderno", "increíble" o "con onda"; cuando haya que instalar componentes de React Bits / Vue Bits / Svelte Bits, elegir iconos (mx-icons, Lucide, Iconify), definir tokens de diseño, revisar peso de bundle y rendimiento del front, o auditar seguridad de la app. Aplícala también en prototipos rápidos, mockups, HTML desechable, ejemplos y refactors visuales, aunque el usuario nunca mencione diseño, rendimiento ni seguridad.
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
| El stack NO es React (Vue, Svelte, HTML, Flutter, Compose, JavaFX, Python, CLI/TUI) | `references/stacks.md` |
| Se nota lento, hay que medir, o se van a agregar 2+ efectos | `references/performance.md` |
| Hay auth, formularios, datos de usuario, pagos, API, deploy, o el usuario pide auditar | `references/security.md` |
| Formularios, navegación por teclado, contraste, dudas de accesibilidad | `references/a11y.md` |

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

## Compatibilidad con la skill caveman

Caveman comprime la prosa de salida; esta skill define **qué se construye**. No chocan,
pero para que convivan bien:

- Todo lo que sea código, comando, ruta, nombre de componente, dependencia o mensaje de
  error se escribe **exacto y completo**, nunca comprimido. Caveman ya respeta esto.
- La narración alrededor (explicaciones, justificaciones de diseño) sí se comprime.
- **Excepción de claridad:** los avisos de las tres puertas se escriben en español normal
  y completo, no en estilo caveman. Un hallazgo de seguridad, una advertencia de peso de
  bundle o un aviso de que se bajó el nivel de efecto tienen que entenderse a la primera.
- Formato de aviso corto en modo caveman, una línea por puerta:
  `[UI] hero + tokens listos. [PESO] +12 KB gzip, ogl lazy. [SEC] sin hallazgos.`

## Scripts incluidos

Corren solos y se degradan sin quejarse si falta una herramienta. No requieren instalar
nada globalmente.

- `scripts/audit.sh` — auditoría combinada: secretos en el repo, dependencias
  vulnerables, peso del build, y patrones de riesgo en el front (`dangerouslySetInnerHTML`,
  `eval`, `innerHTML`, secretos en variables de entorno públicas). Uso: `bash scripts/audit.sh [ruta]`
- `scripts/add-component.sh` — instala un componente de React Bits por CLI y reporta qué
  dependencias nuevas entraron y cuánto pesan, para decidir con datos antes de aceptarlas.
  Uso: `bash scripts/add-component.sh <Componente> [TS-TW|TS-CSS|JS-TW|JS-CSS]`

## Checklist de cierre

Antes de decir que la tarea está lista, verificá y reportá en máximo tres líneas:

1. **Diseño** — jerarquía clara, estados completos, responsive a 360 px, contraste OK.
2. **Peso** — dependencias nuevas justificadas, efectos pesados lazy y pausables,
   `prefers-reduced-motion` respetado, sin barriles de iconos.
3. **Seguridad** — sin secretos en el cliente, sin HTML sin sanitizar, autorización
   validada en el servidor, errores manejados sin filtrar detalles internos.

Si algo no se cumplió por decisión consciente (por ejemplo, el usuario quiere el fondo
WebGL igual), dejalo escrito en una línea con el costo asociado. No lo escondas.
