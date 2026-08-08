---
description: Pasada de rendimiento — medir primero, después optimizar el peso
argument-hint: [ruta/pantalla opcional]
---

Usá la skill **ui-ultimate-reforce** en modo **Peso**. Leé `references/performance.md`.

Alcance: $ARGUMENTS

1. **Medí antes de tocar.** `npm run build` para el peso por chunk,
   `npx vite-bundle-visualizer` o `source-map-explorer` para ver quién ocupa el bundle, y
   Lighthouse contra el sitio corriendo. La intuición sobre qué es lento falla la mitad de
   las veces.
2. Atacá las cinco causas reales: dependencias que entraron sin medirse, imports estáticos de
   lo que no se ve, animar propiedades que fuerzan layout, listas largas sin virtualizar,
   imágenes sin optimizar.
3. Verificá el presupuesto: JS inicial ≤ 170 KB gzip, LCP < 2.5 s, INP < 200 ms, CLS < 0.1.
4. **No** cambies el diseño ni la seguridad. Si ves algo de otra puerta, avisalo en una línea.

Reportá el antes/después en KB y en métricas, no en sensaciones.
