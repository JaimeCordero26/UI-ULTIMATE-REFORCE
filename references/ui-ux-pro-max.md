# UI/UX pro-max (el pase final antes de decir "listo")

Todas las demás referencias son especializadas: gusto (`taste.md`), tácticas concretas
(`refactoring-ui.md`), usabilidad (`ux-heuristics.md`), tipografía, copy, marca. Esta es la
que las junta en **un solo pase de auditoría**, para cuando el usuario pide "que quede
pro", "nivel producción" o simplemente para autoevaluar antes de cerrar una pantalla
importante. No reemplaza el checklist de cierre de `SKILL.md` (diseño/peso/seguridad); lo
precede, enfocado solo en la calidad de la interfaz.

## Los tres niveles

Sirve para calibrar qué tan lejos está una pantalla, no solo si "está bien":

| Nivel | Se ve así | Síntoma típico |
|---|---|---|
| **Funcional** | Cumple el objetivo, nada roto | Jerarquía plana, espaciado inconsistente, un solo estado (el feliz) diseñado |
| **Pro** | Sistema visible, se siente a propósito | Escala tipográfica y de espaciado consistente, estados completos, sin bordes por default |
| **Elite** | No se nota el esfuerzo, se siente obvio en retrospectiva | Ajuste óptico, micro-interacciones con intención, copy que dice exactamente lo necesario, nada sobra ni falta |

La mayoría del trabajo va de Funcional a Pro con disciplina (seguir las reglas ya escritas
en esta skill). De Pro a Elite es criterio, no reglas — es lo que cubre `taste.md`.

## El pase de siete preguntas

Una por cada área que esta skill trata por separado. Si alguna falla, esa referencia
específica tiene el detalle para resolverla — esto es el radar, no el manual.

1. **Jerarquía** — ¿el squint test (`taste.md`) muestra una jerarquía clara, resuelta con
   peso/color antes que tamaño (`refactoring-ui.md`)?
2. **Tipografía** — ¿la escala es fija, el interlineado es correcto por tamaño, la medida
   de línea está entre 45–75 caracteres (`web-typography.md`)?
3. **Usabilidad** — ¿pasa las 10 heurísticas de Nielsen sin fricción evidente, sobre todo
   la 1 (estado visible), 5 (prevención de errores) y 9 (recuperación de errores)
   (`ux-heuristics.md`)?
4. **Micro-interacciones** — ¿cada acción interactiva tiene disparador, reglas, feedback
   inmediato y una salida de loop definidos (`microinteractions.md`)?
5. **Copy** — ¿cada botón describe su propia acción, cada error dice qué pasó/por qué/qué
   hacer, no hay placeholders haciendo de label (`content-studio.md`)?
6. **Estructura** — ¿el HTML usa elementos nativos donde corresponde, no `<div>` reconstruyendo
   lo que el navegador ya resuelve (`design-html.md`)?
7. **Marca y consistencia** — ¿respeta la guía de marca si existe, o al menos un acento y
   un tono consistentes si no existe (`brand-guidelines.md`)?

## Cómo usarlo sin inflar el trabajo

No es una lista para aplicar entera a cada botón. Usalo completo en: pantallas de alto
tráfico (landing, checkout, onboarding), o cuando el usuario pide explícitamente nivel
"pro"/"producción". Para un cambio chico ("cambiá el color de este botón"), no lo corras —
la regla de `SKILL.md` de leer poco y leer tarde aplica acá también.

## Diferencia con las otras referencias de calidad

- `taste.md` responde **por qué** algo se ve caro o barato (juicio estético).
- `refactoring-ui.md` da **tácticas puntuales** para resolver un problema visual concreto.
- `ux-heuristics.md` responde si la interfaz **se usa** bien, más allá de cómo se ve.
- Esta referencia es el **checklist de siete puntos** que cruza las tres, para no olvidar
  ninguna dimensión al hacer el pase final.

## Chequeo rápido (versión de una línea por punto)

1. Jerarquía clara sin gritar.
2. Tipografía con escala fija y medida controlada.
3. Sin fricción de usabilidad evidente (Nielsen).
4. Micro-interacciones completas, no solo el feedback visual.
5. Copy que no necesita explicación aparte.
6. HTML semántico, no `<div>` reinventando lo nativo.
7. Marca y tono consistentes de punta a punta.
