---
description: Construye UI completa (diseño + peso + seguridad) de un solo prompt
argument-hint: [qué construir, ej. "landing de un SaaS de facturación"]
---

Usá la skill **ui-ultimate-reforce** en modo **Construir**: el flujo completo con las tres
puertas (se ve bien, pesa poco, no filtra nada).

Pedido: $ARGUMENTS

Pasos:
1. Detectá el stack real (leé `package.json`/`pubspec.yaml`/etc.). No asumas React. Si no
   hay proyecto, preguntá framework y si acepta dependencias nuevas.
2. Fijá el sistema visual. Si el proyecto ya tiene tokens/tema, ese manda. Si no, partí de
   `assets/tokens.css` y elegí **un** arquetipo de `references/style-systems.md`.
3. Construí con componentes y estados reales (loading, vacío, error), responsive desde 360 px.
   Iconos icono-por-icono. Un efecto pesado por pantalla como máximo, lazy y pausable.
4. Cerrá con las tres puertas y reportá en máximo tres líneas: **Diseño**, **Peso**,
   **Seguridad** (más **Movimiento**/**A11y** si aplicaron). Corré `scripts/audit.sh` si hay
   JS/TS.

Si algo no se cumplió por decisión consciente, dejalo escrito con su costo. No lo escondas.
