---
description: Activa/ajusta el modo breve incluido (compresión de salida estilo caveman)
argument-hint: [lite | full | ultra | off]
---

Activá el **modo breve** de la skill **ui-ultimate-reforce**. Leé `references/brief-mode.md`.

Nivel pedido: $ARGUMENTS (si viene vacío, usá `full`).

Reglas:
- Comprimí solo la **narración**: quitá artículos, relleno, cortesías y hedging. Fragmentos OK.
- **Nunca** comprimas código, comandos, rutas, nombres de componente ni mensajes de error.
- **Auto-claridad obligatoria:** los avisos de las tres puertas (seguridad, peso,
  accesibilidad), las confirmaciones de acciones irreversibles y las secuencias de varios
  pasos se escriben en español normal y completo, aunque el nivel sea `ultra`.
- Persiste hasta que se cambie de nivel o se diga "modo normal" / `off`.
- Si ya hay una skill caveman externa activa, no dupliques la compresión: solo garantizá la
  excepción de claridad de las tres puertas.

Confirmá el nivel activo en una línea y seguí trabajando en ese modo.
