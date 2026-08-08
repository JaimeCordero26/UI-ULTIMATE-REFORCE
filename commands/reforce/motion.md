---
description: Agrega o refina animaciones con criterio (Emil Kowalski, GSAP, Framer)
argument-hint: [qué animar, ej. "la entrada del hero y el menú"]
---

Usá la skill **ui-ultimate-reforce** en modo **Movimiento**. Leé `references/motion.md`.

Qué animar: $ARGUMENTS

1. **Interaction thesis primero:** escribí en una línea qué comunica cada animación (atención,
   feedback o relación) antes de tocar código. Si no hay tesis, no se anima.
2. Elegí el nivel por peso: CSS nativo → GSAP/Framer (Nivel 1) → WebGL (Nivel 2, uno por
   pantalla). GSAP hoy es 100% gratis con todos los plugins; cargalo lazy si no es crítico.
3. Implementá con `transform`/`opacity`, easing por dirección (entra `ease-out`, sale
   `ease-in` y más rápido), origen correcto, interrumpible.
4. **Mini-audit** antes de cerrar: reduced-motion respetado, interrumpible, solo propiedades
   compositables, salida más rápida que entrada, limpieza al desmontar (sin triggers colgados).

Reportá el costo en KB si entró una librería.
