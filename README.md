<div align="center">

# UI Ultimate Reforce

**La skill que no te deja entregar una UI a medias.**

Bonita. Liviana. Segura. Las tres, o no está terminada.

*Cualquier lenguaje. Cualquier stack. De un prompt o por partes.*

</div>

---

## El problema que resuelve

Cuando le pedís una pantalla a un agente de IA, casi siempre conseguís una de tres cosas
rotas:

- **Se ve increíble pero pesa 3 MB.** Un fondo WebGL de `three` (~600 KB) para un adorno,
  y la página no abre en un celular de gama media con datos móviles.
- **Es liviana pero parece de 2009.** Funciona, pero sin jerarquía, sin estados, sin gusto.
- **Anda pero filtra una API key en el bundle.** Nadie miró la seguridad porque nadie la pidió.

El agente optimiza lo que le pediste y **sacrifica en silencio lo que no**. UI Ultimate
Reforce elimina ese silencio: convierte las tres cosas en **puertas obligatorias** que se
reportan siempre, aunque el pedido haya sido "una pantalla rápida".

## Las tres puertas

Toda interfaz pasa por las tres antes de darse por terminada. Si una falla, el trabajo no
está hecho.

| Puerta | Qué verifica |
|---|---|
| 🎨 **Diseño** | jerarquía clara, estados completos (carga, vacío, error), responsive desde 360 px, contraste suficiente, **gusto** (no "slop" genérico de IA) |
| ⚡ **Peso** | ≤ 170 KB gzip de JS inicial, un solo efecto pesado por pantalla, `prefers-reduced-motion` respetado, sin barriles de iconos, LCP < 2.5 s · INP < 200 ms · CLS < 0.1 |
| 🔒 **Seguridad** | sin secretos en el cliente, sin HTML sin sanitizar, autorización validada en el servidor, cabeceras puestas, errores manejados |

> La razón de juntarlas: una UI bonita que carga 3 MB en un celular de gama media es peor
> que una sobria; y una UI rápida que expone una clave en el bundle es un incidente, no un
> entregable.

---

## Por qué es distinta a otras skills de UI

La mayoría de las skills de diseño te dan **componentes bonitos**. Esta te da un **criterio
completo de ingeniería de front**. Diez diferencias concretas:

1. **Las tres puertas se exigen juntas.** No es una skill de "hacer cosas lindas": es una de
   "no entregar cosas rotas". Bonito sin liviano, o liviano sin seguro, no pasa.

2. **La seguridad es una puerta, no una nota al pie.** El error más común de un agente es
   saltarse la seguridad porque el usuario no la pidió. Acá se reporta **siempre**, basada en
   el **OWASP Top 10 2025** (octava edición, finalizada en enero de 2026) — no en la lista de
   2021 que todavía circula. Incluye las categorías nuevas: fallas de cadena de suministro y
   manejo incorrecto de condiciones excepcionales, más lo específico de trabajar con un agente
   (dependencias instaladas por CLI, inyección por contenido leído).

3. **El peso se mide en KB reales, no en vibras.** El catálogo de efectos está clasificado
   **por peso**: Nivel 0 (CSS, 0 KB) → Nivel 1 (`gsap`/Framer, ~25 KB compartidos) → Nivel 2
   (WebGL `ogl`, ~40 KB, uno por pantalla) → Nivel 3 (`three`, ~600 KB, desaconsejado). Eso
   decide *cuántos* efectos entran, con datos, antes de que el build pese 2 MB.

4. **Funciona en cualquier stack, no solo React.** Vue/Nuxt, Svelte, Astro, HTML plano, React
   Native, **Flutter**, Jetpack **Compose**, SwiftUI, JavaFX/Swing, Tauri/Electron, Python
   (Textual/Rich) y hasta **CLIs**. Una terminal también es una interfaz y pasa por las mismas
   puertas.

5. **No infla el contexto.** El problema típico de las skills grandes es que comen tokens en
   cada turno. Esta usa **carga progresiva**: la descripción vive en contexto, `SKILL.md` entra
   al activarse, y las 11 referencias se leen **solo cuando la tarea las pide** (máximo 2 por
   tarea). Un proyecto Python nunca carga la referencia de React Bits. Un cambio de color de
   botón no carga ninguna.

6. **De un prompt o por partes.** Pedís la pantalla y salen las tres puertas resueltas. Pero
   cada gate se dispara solo, acotado, con comandos `/reforce:*`: pulir más lo visual, sumar
   movimiento, endurecer seguridad, bajar peso — sin rehacer el resto.

7. **Movimiento con oficio, no relleno.** Los principios de **Emil Kowalski** (rápido, easing
   según dirección, origen, interrumpible, con propósito), **GSAP** —ahora **100% gratis** con
   todos los plugins, ScrollTrigger incluido— y Framer Motion, más el método *interaction
   thesis* de genjutsu: si una animación no se puede decir en una frase, no se anima.

8. **Arquetipos de estilo completos.** No un tema: un **lenguaje visual**. Minimalismo/editorial,
   bento grid, glassmorphism, neumorphism/claymorphism, brutalism/neo-brutalism, aurora/gradient
   mesh, dark developer. Cada uno con su firma, su coste en KB y su trampa de accesibilidad.

9. **Capa de gusto (el "no slop").** Lo que ninguna herramienta automática mide: los tests del
   squint, del −20% y de las esquinas, el gate contra la UI genérica de IA, y el método de
   **superdesign** — generar variantes en paralelo, comparar y elegir la mejor, en vez de pulir
   la primera a ciegas.

10. **Su propio modo caveman incluido.** Un modo breve de compresión de salida que ahorra
    tokens **y sabe de las tres puertas**: los avisos de seguridad nunca se comprimen. Todo en
    uno, y compatible con la skill caveman externa sin pelear.

Y encima trae **scripts que corren solos**: una auditoría combinada de seguridad y peso, un
instalador de componentes que reporta el costo, y un hook de pre-commit que hace que la puerta
de seguridad corra sola en cada commit.

---

## Qué trae

**Componentes y visual**
- React Bits, con sus puertos oficiales de Vue y Svelte: instalación por `shadcn` o `jsrepo`,
  y un catálogo clasificado **por peso real**. Fondos WebGL con `ogl` (~40 KB); los 3D
  arrastran `three` (~600 KB) y la skill los desaconseja salvo que el 3D sea el producto.
- Iconos: **`mx-icons`** (5.600+ iconos, tres variantes, tree-shakeable), Lucide, e Iconify
  para stacks que no son React. Regla de oro: icono por icono, nunca el barril.
- `assets/tokens.css`: sistema de tokens listo para copiar, tema claro/oscuro derivados de una
  sola variable de tono, escala tipográfica, espaciado, sombras y `prefers-reduced-motion` ya
  resuelto.

**Movimiento, estilo y gusto**
- Movimiento con criterio: Emil Kowalski + GSAP (gratis, todos los plugins) + Framer Motion +
  método *interaction thesis*, con mini-audit de reduced-motion y limpieza.
- Arquetipos de estilo listos: minimal, bento, glass, neumorphism, brutalism, aurora, dark
  developer — cada uno con firma, coste y trampa.
- Gusto: tests (squint, −20%, esquinas, gris), gate "no slop", y variantes en paralelo estilo
  superdesign.

**Cualquier stack**
Vue/Nuxt, Svelte, Astro, HTML plano, React Native, Flutter, Jetpack Compose, SwiftUI, JavaFX,
Swing, Tauri, Electron, Python (Textual/Rich) y CLIs.

**Seguridad**
OWASP Top 10 2025 aplicado al código que se escribe, más lo específico de trabajar con un
agente. No una auditoría teórica: los errores concretos que aparecen escribiendo rápido, con
su corrección.

---

## Un prompt, o por partes: comandos `/reforce:*`

| Comando | Qué hace |
|---|---|
| `/reforce:build`    | Construcción completa con las tres puertas |
| `/reforce:polish`   | Pule lo visual (gusto, jerarquía), sin tocar lógica |
| `/reforce:motion`   | Agrega/refina animaciones (Emil Kowalski, GSAP, Framer) |
| `/reforce:style`    | Aplica un arquetipo (bento, glass, minimal, brutalism…) |
| `/reforce:variants` | Genera variantes en paralelo para comparar y elegir |
| `/reforce:secure`   | Pasada de seguridad: auditar y endurecer |
| `/reforce:perf`     | Pasada de rendimiento: medir y bajar peso |
| `/reforce:brief`    | Activa el modo breve incluido (`lite`/`full`/`ultra`/`off`) |

Regla de los modos por partes: **un modo, un cambio acotado, un reporte claro.** Si al corregir
el peso aparece un problema de seguridad, se avisa en una línea; no se arregla sin permiso.

---

## Scripts

Corren sin instalar nada global y se degradan sin quejarse cuando falta una herramienta.

```bash
bash scripts/audit.sh [ruta]
```

Auditoría combinada. Detecta secretos literales y formatos de token (`sk-`, `ghp_`, `AKIA`,
claves privadas, JWT), variables `NEXT_PUBLIC_`/`VITE_` con pinta de secreto que terminan en el
navegador, `.env` versionado, dependencias vulnerables, `innerHTML`/`dangerouslySetInnerHTML`
sin sanitizar, SQL y shell por concatenación, TLS desactivado, `catch` vacíos, barriles de
iconos, dependencias pesadas, `transition: all` e imágenes sin optimizar. Sale con código 1 si
hay hallazgos que bloquean — sirve en pre-commit o CI. Usa `gitleaks`, `osv-scanner`,
`pip-audit` y `npm audit` si están; cae a un escaneo por patrones cuando no.

```bash
bash scripts/add-component.sh <Componente> [TS-TW|TS-CSS|JS-TW|JS-CSS]
bash scripts/pre-commit.sh --install
```

`add-component.sh` instala un componente de React Bits y reporta **qué dependencias nuevas
entraron y cuánto pesan** (con alerta si apareció `three`). `pre-commit.sh` engancha la
auditoría como hook de git para que la seguridad deje de depender de que alguien se acuerde.

---

## Instalación

```bash
git clone https://github.com/JaimeCordero26/ui-ultimate-reforce.git
cd ui-ultimate-reforce
bash install.sh          # skill + comandos /reforce:* en ~/.claude/
```

O para un solo proyecto: `bash install.sh --local` (instala en `.claude/` del repo actual).

Verificá con `/skills` y `/help` dentro de una sesión de Claude Code.

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

---

## Cómo se activa

Sola. La descripción cubre pantallas, componentes, estilos, temas, iconos, landing pages,
dashboards, formularios, animaciones y arquetipos visuales, además de frases como "que se vea
bien", "que se vea pro" o "con gusto". No hace falta invocarla por nombre.

Si el proyecto ya tiene un sistema de diseño propio, **ese manda y la skill se subordina**.

---

## Por qué importa

Un agente que escribe UI rápido y sin criterio produce deuda a la misma velocidad: pantallas que
se ven bien en la demo y se caen en producción, bundles que crecen sin que nadie mida, y claves
que se filtran porque la seguridad "no era parte del pedido". El costo no aparece el día que se
escribe; aparece después, en un usuario que no puede abrir la página, en un incidente, en un
rediseño completo.

UI Ultimate Reforce mete las tres decisiones que se saltan —**gusto, peso y seguridad**— dentro
del flujo, de forma que el caso común salga bien **sin que haya que pedirlo**, y sin inflar el
contexto para lograrlo. No es una caja de componentes bonitos: es la disciplina que hace que lo
bonito además sea liviano y seguro, en cualquier lenguaje, de un solo prompt.

---

## Estructura

```
ui-ultimate-reforce/
├── SKILL.md                    router, modos/comandos y presupuesto de recursos
├── assets/
│   └── tokens.css              sistema de tokens claro/oscuro
├── references/
│   ├── react-bits.md           instalación, catálogo por peso, integración SSR
│   ├── icons.md                mx-icons, Lucide, Iconify y reglas de peso
│   ├── design-tokens.md        cómo fijar paleta, tipografía y espaciado
│   ├── recipes.md              recetas premium (botón, card, hero, bento, navbar…)
│   ├── motion.md               Emil Kowalski + GSAP + Framer + interaction thesis
│   ├── style-systems.md        arquetipos: minimal, bento, glass, brutalism, aurora…
│   ├── taste.md                gusto: tests, gate "no slop", variantes (superdesign)
│   ├── stacks.md               UI fuera de React: Vue, Flutter, JavaFX, Python, CLI
│   ├── performance.md          presupuestos, causas reales de lentitud, medición
│   ├── security.md             OWASP Top 10 2025 aplicado al código que se escribe
│   ├── a11y.md                 accesibilidad práctica
│   └── brief-mode.md           modo de compresión propio (caveman incluido)
├── commands/reforce/
│   ├── build.md   polish.md   motion.md   style.md
│   └── variants.md  secure.md  perf.md    brief.md
└── scripts/
    ├── audit.sh                auditoría de seguridad y peso
    ├── add-component.sh        instalar React Bits reportando el costo
    └── pre-commit.sh           engancha audit.sh como hook de git
```

---

## Créditos y licencia

MIT. Construida sobre las ideas y el trabajo de mucha gente: el oficio de animación de
**Emil Kowalski**, **GSAP** (GreenSock/Webflow, hoy 100% gratis), **React Bits**, **mx-icons**,
el método de **superdesign**, la filosofía de **genjutsu** y el **OWASP Top 10 2025**. React
Bits se distribuye bajo MIT + Commons Clause y no se incluye en este repositorio; la skill solo
documenta cómo instalarlo desde su fuente oficial.
