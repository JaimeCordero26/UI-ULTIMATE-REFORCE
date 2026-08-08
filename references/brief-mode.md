# Modo breve (compresión de salida incluida)

Esta skill trae su **propio** modo de compresión de prosa, estilo *caveman*: recorta la
narración para gastar menos tokens sin perder nada técnico. No depende de ninguna skill
externa. Si ya usás caveman, conviven (ver §Compatibilidad); si no, esta lo reemplaza y
además resuelve el punto que caveman no conoce: **la excepción de claridad de las tres
puertas**.

Se activa con `/reforce:brief [nivel]` o cuando el usuario pide "menos tokens", "sé breve",
"modo caveman". Persiste hasta que se cambie de nivel o se diga "modo normal".

## Qué es mejor que un caveman genérico

1. **Sabe de las tres puertas.** Los avisos de seguridad, peso y accesibilidad **nunca** se
   comprimen, aunque el modo esté en `ultra`. Un caveman genérico comprime todo por igual;
   este garantiza que una advertencia de seguridad se entienda a la primera.
2. **Glosario de dominio UI.** Sabe qué términos son código exacto (nombres de componente,
   tokens, props, comandos) y nunca los toca, incluso en `ultra`.
3. **Formato de cierre de una línea** ya integrado con el reporte de las tres puertas.
4. **Todo en uno.** Vive dentro de la skill; no hay que instalar ni coordinar dos cosas.

## Niveles

| Nivel | Qué hace |
|---|---|
| `off` | Español normal y completo. Default fuera de este modo. |
| `lite` | Quita relleno y muletillas, mantiene frases completas. Legible para cualquiera. |
| `full` | **Default del modo.** Elimina artículos, relleno, cortesías y hedging. Fragmentos OK. |
| `ultra` | Máxima compresión: telegráfico. Solo para usuarios que ya conocen el contexto. |

## Reglas de compresión

Se eliminan: artículos (el/la/los), relleno (solo/realmente/básicamente/en realidad),
cortesías (claro/por supuesto/con gusto), hedging (quizás/tal vez/podría ser). Fragmentos
permitidos. Sinónimos cortos (grande, no "de gran extensión"; arreglá, no "implementá una
solución para"). Patrón: `[cosa] [acción] [motivo]. [siguiente paso].`

**Nunca se comprime (se escribe exacto y completo):**
- Código, comandos, rutas, nombres de componente, dependencias, mensajes de error.
- **Avisos de las tres puertas** (seguridad, peso, accesibilidad). Español claro, completo.
- Confirmaciones de acciones irreversibles y secuencias de varios pasos donde el orden
  importa: se escriben normal para que no se malinterpreten.

## Auto-claridad (obligatoria)

Se **sale** del modo breve, automáticamente, para:
- Advertencias de seguridad y hallazgos de auditoría.
- Confirmaciones de algo difícil de revertir.
- Cuando el usuario pide una aclaración o repite la pregunta.

Se vuelve al modo breve apenas termina la parte que exigía claridad.

## Formato de cierre en modo breve

Una línea por puerta, términos técnicos exactos:

```
[UI] hero + tokens listos. [MOV] entrada ease-out 200ms, reduced-motion ok.
[PESO] +24 KB gzip, gsap lazy. [SEC] sin hallazgos. [A11Y] foco + contraste ok.
```

## Compatibilidad con caveman externo

Si el usuario ya tiene la skill/plugin caveman activa:
- **No dupliques la compresión.** Detectá que caveman ya está comprimiendo la prosa y no
  apliques encima; solo aportá la excepción de claridad de las tres puertas si caveman no la
  respeta.
- Los niveles son compatibles en espíritu (`lite`/`full`/`ultra`), así que `/reforce:brief`
  y `/caveman` no pelean: el último que se invoca fija el nivel.
- Todo lo que esta skill define como "código exacto" ya coincide con lo que caveman preserva,
  así que no hay conflicto sobre qué se comprime y qué no.
