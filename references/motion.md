# Movimiento (animación con criterio)

Una animación mal hecha se nota más que la falta de animación. Lenta, sin propósito, o
animando la propiedad equivocada, se lee como "amateur" aunque el resto esté impecable.
Esta referencia junta tres cosas: los **principios** (qué hace que el movimiento se sienta
bien), las **herramientas** (CSS nativo, GSAP, Framer Motion) y un **método** para no
entregar animación de relleno.

Regla de entrada, antes de tocar nada: **una animación por interacción tiene que poder
decirse en una frase.** "El menú entra desde el botón que lo abrió para mostrar de dónde
sale." Si no hay frase, no hay animación: hay ruido. Este es el gate de *interaction
thesis* — se declara la intención en una línea antes de escribir el código.

## Principios (los de Emil Kowalski, destilados)

Emil Kowalski (autor de *Animations on the Web*, creador de Sonner y Vaul) resume el oficio
en unas pocas reglas que casi nadie sigue:

1. **Rápido.** La mayoría de las transiciones de UI van entre **150 y 300 ms**. Hover y
   feedback pequeño, ~150 ms. Un panel grande que cruza la pantalla, hasta ~400 ms. Más que
   eso se siente lento; menos de ~100 ms no se percibe como movimiento.
2. **Easing correcto según la dirección.** Es lo que más separa lo pro de lo torpe:
   - Algo que **entra** → `ease-out` (arranca rápido, desacelera). Se siente que "llega".
   - Algo que **sale** → `ease-in` (acelera al irse). Y salir más rápido que entrar.
   - Algo que se **mueve de A a B** en pantalla → `ease-in-out`.
   - **Nunca `linear`** salvo movimiento continuo (spinners, marquesinas).
   - Curva por defecto que casi siempre queda bien (ease-out expresivo):
     `cubic-bezier(0.16, 1, 0.3, 1)`.
3. **Origen.** El movimiento sale de donde lo disparaste. Un dropdown crece desde su botón
   (`transform-origin` en la esquina correcta), no aparece flotando en el centro. Un modal
   de una fila puede nacer de esa fila.
4. **Solo `transform` y `opacity`.** Es principio de rendimiento y de calidad a la vez:
   animar `width`, `top`, `height` o `box-shadow` no solo va lento, se ve entrecortado.
   `blur` (`filter`) da profundidad al entrar pero es caro: úsalo en un elemento a la vez,
   nunca en una lista.
5. **Interrumpible.** Si el usuario vuelve a hacer hover mientras la animación de salida
   corre, tiene que poder revertir sin "esperar el turno". Las transiciones CSS y los
   springs de Framer Motion lo hacen solas; una animación por keyframes con estado manual,
   no. Nunca bloquees la interacción esperando que termine una animación.
6. **Propósito.** El movimiento **guía la atención, da feedback o muestra una relación**
   (esto salió de aquí, esto reemplaza a aquello). Si no hace ninguna de las tres, sobra.
   Decoración que se mueve sola cansa a la segunda visita.
7. **`prefers-reduced-motion` siempre.** No es opcional. Movimiento con desplazamiento
   grande, zoom, paralaje o rotación provoca mareo real. Con la preferencia activa: cortá a
   un `opacity` corto o directo sin transición.

Springs vs. curvas: para gestos, arrastre y cosas que el usuario "agarra", un **spring**
(física) se siente más natural que una duración fija, porque responde a la velocidad. Para
transiciones de estado discretas (abrir/cerrar, aparecer), una curva con duración fija es
más predecible y más barata. No uses spring para todo.

## CSS nativo primero (0 KB de librería)

Antes de instalar nada, mirá cuánto resuelve el navegador hoy:

```css
/* Entrada con curva y origen correctos */
.panel {
  transform-origin: top right;
  transition: transform var(--dur-base) var(--ease-out),
              opacity   var(--dur-base) var(--ease-out);
}
```

- **`@starting-style`**: anima la aparición de un elemento que entra al DOM (incluido
  `display:none` → visible y elementos en el *top layer* como `<dialog>` y popover), sin JS.
- **Animación al hacer scroll sin JS**: `animation-timeline: view()` /`scroll()`. Donde no
  haya soporte, `IntersectionObserver` en 10 líneas antes que cualquier librería.
- **Transiciones entre vistas/páginas**: View Transitions API (`document.startViewTransition`),
  nativa en Astro y en SPAs modernas.
- **Bloque de movimiento reducido**: ya resuelto globalmente en `assets/tokens.css`.

Regla: si el efecto se logra con CSS o Web Animations API, **no** entra una librería.

## GSAP (cuando el timeline o el scroll lo justifican)

Novedad que cambia la decisión: desde 2025 **GSAP es 100% gratis, incluidos todos los
plugins** (ScrollTrigger, SplitText, MorphSVG, DrawSVG, Flip…). Ya no hay tier de pago ni
license key. Webflow compró GreenSock y liberó todo, con licencia comercial incluida.

Cuándo vale la pena sobre CSS:
- **Secuencias coordinadas** (timeline con solapamientos y control de tiempo fino).
- **Scroll-driven complejo**: *scrubbing*, *pinning*, *snapping* (ScrollTrigger). Es lo que
  CSS todavía no cubre bien.
- **SplitText** para animar por letra/palabra/línea con accesibilidad resuelta.
- **Flip** para transiciones de layout (FLIP) sin recalcular a mano.
- **MorphSVG / DrawSVG** para SVG.

Peso: core ~**23–25 KB gzip**, compartido entre todo lo que lo use; cada plugin suma poco.
Es Nivel 1 en el catálogo de peso (ver `react-bits.md`): pagás la librería una vez y podés
usar varios efectos casi sin costo extra. Cargala **lazy** si no está en la ruta crítica.

```js
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
gsap.registerPlugin(ScrollTrigger);

// Responsive + movimiento reducido en un solo lugar: matchMedia
const mm = gsap.matchMedia();
mm.add(
  { reduce: '(prefers-reduced-motion: reduce)', ok: '(prefers-reduced-motion: no-preference)' },
  (ctx) => {
    if (ctx.conditions.reduce) return;                 // sin animación, salida limpia
    gsap.from('.reveal', {
      y: 24, opacity: 0, duration: 0.6, ease: 'expo.out', stagger: 0.06,
      scrollTrigger: { trigger: '.reveal', start: 'top 80%' },
    });
  }
);
```

En React, usá el hook oficial `useGSAP` (paquete `@gsap/react`): limpia solo los tweens y
ScrollTriggers al desmontar. Sin eso, cada re-render deja triggers colgados y el scroll se
vuelve pesado.

```tsx
import { useGSAP } from '@gsap/react';
useGSAP(() => { gsap.from('.reveal', { opacity: 0, y: 24 }); }, { scope: containerRef });
```

Reglas GSAP que evitan problemas:
- Registrá los plugins una sola vez, no por render.
- Matá tweens y triggers al desmontar (`useGSAP`/`gsap.context` lo hacen).
- No animes 200 nodos a la vez con ScrollTrigger individual: usá un trigger con `stagger`.

## Framer Motion / `motion` (React, transiciones de estado)

El default de React para animaciones declarativas de estado. Su ventaja real:
**`AnimatePresence`** para animar la **salida** de componentes que se desmontan —lo que en
CSS puro es lo más incómodo— y **layout animations** (`layout` / `layoutId`) para transiciones
de posición sin calcular FLIP a mano.

- Peso: importá desde `motion/react` y, para bajar el bundle inicial, `LazyMotion` +
  componentes `m` cargan las features bajo demanda.
- Springs por defecto en gestos; `transition={{ duration, ease }}` para curvas fijas.
- Respetá reduced-motion con el hook `useReducedMotion()` y bajá a `opacity` o nada.

```tsx
import { AnimatePresence, motion } from 'motion/react';

<AnimatePresence>
  {open && (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 8 }}
      transition={{ duration: 0.2, ease: [0.16, 1, 0.3, 1] }}
    />
  )}
</AnimatePresence>
```

Vue: `<Transition>`/`<TransitionGroup>` nativos cubren casi todo; `@vueuse/motion` o GSAP
para lo demás. Svelte: `transition:`/`animate:`/`crossfade` nativos, pagás 0 KB. Compose,
SwiftUI, Flutter: ver `stacks.md`, los principios de arriba no cambian.

## Fondos y generativo (Nivel 2–3)

Canvas/WebGL (partículas, flow fields, ruido, shaders) y 3D (`three`/R3F) son **un efecto
pesado por pantalla como máximo**, siempre lazy, pausables y con fallback estático. Todo el
detalle de montaje seguro, `IntersectionObserver`, pausa por `visibilitychange` y `dpr`
capado está en `react-bits.md §5`. Para un adorno de fondo, primero mirá si un gradient
mesh CSS (`recipes.md §4`) o un `.webm` exportado logran lo mismo por una fracción del peso.

## Método: interaction thesis + mini-audit

Inspirado en cómo trabaja *genjutsu* (`/genjutsu:cast`), sin depender de él:

1. **Tesis en una línea.** Qué comunica el movimiento y por qué. Si no hay, no se anima.
2. **Elegí el nivel** por peso (CSS → GSAP/Framer → WebGL) y el presupuesto de la pantalla.
3. **Implementá** con `transform`/`opacity`, easing por dirección, origen correcto.
4. **Mini-audit** antes de cerrar:
   - ¿Respeta `prefers-reduced-motion`?
   - ¿Es interrumpible?
   - ¿Anima solo propiedades compositables?
   - ¿La salida es más rápida que la entrada?
   - ¿Se limpia al desmontar (sin triggers/listeners colgados)?
   - ¿Aporta a atención/feedback/relación, o es decoración?

Un "sí" a todo es la puerta de peso y accesibilidad del movimiento cerrada. Reportalo en la
línea de cierre igual que el resto.
