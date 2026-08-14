# Micro-interacciones (el detalle puntual, no la animación de pantalla completa)

`motion.md` cubre transiciones, timing y herramientas. Esta referencia es el nivel más
chico: el toggle, el botón de like, la validación en vivo de un campo — momentos de
segundos que, bien diseñados, son la diferencia entre "funciona" y "se siente cuidado".

## Las cuatro partes (marco de Dan Saffer, *Microinteractions*)

Toda micro-interacción tiene las mismas cuatro piezas; diseñarlas por separado evita que
falte una:

1. **Disparador (trigger).** Qué la inicia. Explícito (el usuario hace click/tap) o
   implícito (el sistema la dispara: llega una notificación, se agota un tiempo). Un
   disparador implícito necesita ser predecible, o se siente que la UI "hace cosas solas".
2. **Reglas.** Qué pasa y en qué orden. Definilas antes de animar nada: ¿el like se puede
   deshacer? ¿hay un límite de intentos? ¿qué pasa si el usuario dispara la acción dos
   veces rápido (doble submit)?
3. **Feedback.** Cómo se entera el usuario de que pasó algo — visual, con movimiento, con
   sonido si corresponde. Tiene que ser inmediato (< 100 ms de respuesta al input) aunque
   la acción real (guardar en servidor) tarde más: separá el feedback óptico del resultado
   real con un estado optimista.
4. **Loops y modos.** Qué pasa si se repite (¿el segundo click deshace el primero?) y si
   cambia de modo (¿queda "guardando" para siempre si falla la red?). Es la parte que más
   se olvida y la que produce estados colgados.

## Catálogo de las más comunes, con el detalle que se suele olvidar

| Micro-interacción | Detalle que la hace o la rompe |
|---|---|
| Toggle / switch | El estado se refleja igual en color y posición (no solo color, por contraste/daltonismo). Cambia en < 200 ms, `ease-out`. |
| Like / favorito | Feedback inmediato optimista (el corazón cambia al toque, no espera al servidor) + reversión silenciosa si falla la petición. |
| Validación de formulario en vivo | Nunca marques error mientras el usuario **todavía está escribiendo** el primer valor del campo; validá on-blur la primera vez, en vivo recién después de un primer error. |
| Copiar al portapapeles | Confirmación textual ("Copiado") además de visual — un ícono que cambia solo puede pasar desapercibido. Vuelve al estado original a los 2 s. |
| Pull-to-refresh / carga | El indicador de progreso aparece solo si la espera supera ~300–500 ms; antes de eso, mostrarlo se siente más lento, no más rápido. |
| Deshacer (undo) | El toast de "Elemento eliminado, Deshacer" da más confianza que un modal de confirmación previo, y es menos fricción para el caso feliz. Ventana típica: 4–6 s. |
| Drag & drop | Feedback de "dónde va a caer" antes de soltar (placeholder, línea guía), no solo al terminar el gesto. |
| Envío de formulario | El botón cambia a estado de carga y se deshabilita **inmediatamente** al primer click — previene doble envío, que es el bug más común de esta categoría. |

## Errores que rompen la confianza más rápido

- Feedback que llega tarde o no llega: el usuario hace click de nuevo (doble acción) o
  asume que no funcionó.
- Loops sin salida: un spinner que nunca resuelve si la petición falla en silencio. Todo
  estado de carga necesita un timeout con mensaje de error.
- Confirmar de más: pedir confirmación para acciones reversibles (dar like, archivar) es
  fricción innecesaria; guardala para lo irreversible o costoso (eliminar cuenta, cobrar).
- Animar la micro-interacción con más de 300 ms: a esta escala, más lento que eso se siente
  como que el sistema no respondió al toque, aunque técnicamente sí lo hizo.

## Chequeo rápido antes de dar por lista una micro-interacción

1. ¿Las cuatro partes (disparador, reglas, feedback, loop) están definidas, no solo el
   feedback visual?
2. ¿El feedback es inmediato aunque el resultado real tarde (estado optimista)?
3. ¿Qué pasa si se dispara dos veces seguidas? ¿Y si falla la petición de fondo?
4. ¿Hay una salida de cualquier loop de carga (timeout, error visible)?
