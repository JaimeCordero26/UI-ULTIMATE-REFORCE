# Heurísticas de usabilidad (por qué algo "se siente raro" de usar)

`taste.md` mide si una pantalla se ve cara. Esta referencia mide si se **usa** bien, aunque
se vea impecable. Son cosas distintas: una UI puede pasar todos los tests de gusto y seguir
siendo confusa de operar. Usalo cuando el usuario duda de un flujo, no solo de un estilo.

## Las 10 heurísticas de Nielsen, con el chequeo concreto

| # | Heurística | Preguntá esto de la pantalla |
|---|---|---|
| 1 | Visibilidad del estado del sistema | ¿El usuario sabe qué está pasando ahora (cargando, guardado, error) sin adivinar? |
| 2 | Coincidencia con el mundo real | ¿El lenguaje y el orden son los que usaría la persona, no jerga interna del sistema? |
| 3 | Control y libertad | ¿Hay salida clara (cancelar, deshacer, atrás) en cada flujo, sobre todo antes de una acción destructiva? |
| 4 | Consistencia y estándares | ¿El mismo tipo de acción se ve y se comporta igual en toda la app? Un botón "Guardar" no debería cambiar de posición entre pantallas |
| 5 | Prevención de errores | ¿Se puede evitar el error (deshabilitar, formato guiado) en vez de solo mostrarlo después? |
| 6 | Reconocer antes que recordar | ¿La opción está visible cuando se necesita, o el usuario tiene que recordar dónde estaba? |
| 7 | Flexibilidad y eficiencia | ¿Hay atajos para quien vuelve seguido (teclado, bulk actions) sin estorbar al que usa la app por primera vez? |
| 8 | Diseño estético y minimalista | ¿Cada elemento en pantalla compite por atención con algo que importa más? |
| 9 | Ayudar a reconocer y recuperarse de errores | ¿El mensaje de error dice qué pasó, por qué, y qué hacer — en lenguaje humano, sin código interno? |
| 10 | Ayuda y documentación | ¿Se puede resolver una duda sin salir del flujo (tooltip, ejemplo inline) para lo que sí necesita explicación? |

## Cuatro leyes que explican fricción concreta

- **Ley de Fitts.** El tiempo para llegar a un objetivo depende de su tamaño y distancia.
  Botones primarios grandes y cerca del punto de acción; zonas de click de 44×44 px mínimo;
  acciones destructivas lejos de las frecuentes, no una al lado de la otra.
- **Ley de Hick.** Más opciones = más tiempo de decisión, no linealmente sino cerca de
  logarítmico. Un menú de 20 ítems planos se resuelve mejor agrupando en 4–5 categorías que
  agregando un buscador como parche.
- **Ley de Miller.** La memoria de trabajo sostiene ~7±2 elementos (en la práctica, mejor
  apuntar a 4–5 en un menú o pasos de un wizard). Más que eso, agrupar o paginar.
- **Ley de Jakob.** El usuario llega con expectativas de cómo funcionan "todos los demás
  sitios". El carrito va arriba a la derecha, el logo lleva al inicio, el buscador tiene
  lupa. Innovar en la interacción base rara vez vale el costo de reaprendizaje; guardá la
  innovación para lo que de verdad diferencia al producto.

## Auditoría rápida de un flujo (no de una pantalla suelta)

1. Contá los clics/taps desde la entrada hasta completar la tarea principal. Si son más de
   lo que un competidor conocido necesita para lo mismo, hay fricción que explicar.
2. En cada paso: ¿qué pasa si el usuario no hace nada, se equivoca, o vuelve atrás? Los tres
   caminos tienen que tener una salida diseñada, no un callejón sin salida.
3. Sacá el mouse. Navegá solo con teclado (`Tab`, `Enter`, `Esc`). Si algo queda inalcanzable
   o el foco se pierde, es un fallo de heurística 1 y 3 a la vez.
4. Preguntá "¿esto necesita explicación para usarse?" Si la respuesta es sí, el problema casi
   nunca se arregla con un tooltip: se arregla rediseñando la acción para que se explique
   sola (heurística 8 + 10 juntas).

Cruce con el resto de la skill: las heurísticas 8 y 9 se resuelven en `refactoring-ui.md` y
`content-studio.md`; la 1 y 5 se apoyan en `microinteractions.md` (feedback) y
`design-html.md` (estados nativos del formulario).
