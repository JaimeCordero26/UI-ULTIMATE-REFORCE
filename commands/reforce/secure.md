---
description: Pasada de seguridad — auditar y endurecer, sin cambiar el diseño
argument-hint: [ruta opcional; vacío = proyecto entero]
---

Usá la skill **ui-ultimate-reforce** en modo **Seguridad**. Leé `references/security.md`
(OWASP Top 10 2025).

Alcance: $ARGUMENTS

1. Corré `bash scripts/audit.sh $ARGUMENTS` y leé los hallazgos.
2. Revisá manualmente los cinco errores de front: secretos en el bundle
   (`NEXT_PUBLIC_`/`VITE_`/etc.), HTML sin sanitizar, autorización solo visual, cabeceras de
   seguridad ausentes, datos personales en logs o `localStorage`.
3. Reportá cada hallazgo con severidad y la corrección concreta. Si el usuario aprueba,
   aplicá los arreglos; si una clave se filtró, recordá que hay que **rotarla**, no solo
   borrarla.
4. **No** rediseñes ni "de paso" cambies lo visual. Un modo, un cambio acotado.

Estos avisos se escriben en español claro y completo aunque el modo breve esté activo.
