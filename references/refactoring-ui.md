# Tácticas de Refactoring UI (el libro, aplicado)

`taste.md` explica **por qué** algo se ve caro. Esta referencia junta las tácticas
puntuales de *Refactoring UI* (Adam Wathan / Steve Schoger): movimientos concretos para
cuando una pantalla "está bien pero no convence" y hay que decidir qué tocar primero.

## Empezá por una función, no por el layout

Diseñar "la pantalla" entera desde un rectángulo vacío es lo que produce layouts genéricos.
Elegí **una función real** (la tarjeta de producto, el estado vacío del dashboard) y
diseñala a fondo con datos reales; el resto de la pantalla se ordena alrededor de esa pieza
resuelta. Datos de relleno (`Lorem`, "Usuario 1") esconden problemas de jerarquía que datos
reales (nombres largos, cifras con muchos dígitos, cero resultados) sí muestran.

## Menos opciones, usadas más veces

El error más común no es elegir mal un valor: es tener demasiados valores distintos dando
vueltas. Una escala corta y fija, reusada, se ve más profesional que "el valor que quedó
bien en ese momento":

- Tamaños de texto: una escala de ~7 pasos alcanza para toda la app (no defina un `14.5px`
  puntual porque "se veía mejor" en un lugar).
- Grises: una rampa de 8–10 pasos con nombre semántico; nunca un gris nuevo por pantalla.
- Espaciado: la escala de 4 px de `design-tokens.md`, sin valores sueltos como `13px`.

## Jerarquía: peso y color antes que tamaño

Aumentar el tamaño de fuente es el recurso más usado y el más tosco. Antes de subir el
tamaño, probá:

1. **Peso** (`font-weight`): un `600` sobre `400` ya diferencia sin cambiar la escala.
2. **Color**: texto secundario en gris medio, no negro; el contraste de valor jerarquiza
   sin gritar.
3. **Recién después, tamaño.** Y cuando lo uses, combinalo con interlineado más ajustado en
   los tamaños grandes: texto grande con mucho interlineado se ve desconectado del resto.

No todo elemento "importante" necesita destacarse igual. En una fila de metadatos (autor,
fecha, categoría), lo normal es que **todo** vaya en gris apagado — jerarquizar cada dato
por separado los hace competir entre sí en vez de leerse como un grupo.

## Separar sin bordes: usá contraste y espacio primero

El recurso automático para separar dos bloques es ponerles un `border`. Antes de eso,
probá, en este orden:

1. Más espacio entre los bloques (a veces alcanza solo con esto).
2. Fondos con distinto valor (una superficie ligeramente más clara/oscura que la otra).
3. Una sombra sutil si necesita sensación de elevación.
4. Recién si nada de lo anterior alcanza, un borde de 1 px con opacidad baja, no un gris
   sólido a full contraste.

Bordes por todos lados es la firma visual de una UI hecha por partes sueltas en vez de un
sistema. Cuantos menos bordes explícitos, más "diseñado" se percibe.

## Etiquetas como último recurso

Una etiqueta (`<label>` visible fuera de un input, o un texto tipo "Nombre:") es necesaria
cuando el contenido no se explica solo. Pero en tablas y listas repetitivas, formatear el
dato (tipografía, posición, ícono) suele bastar sin agregar una etiqueta al lado de cada
valor. Si hace falta etiquetar cada campo para que se entienda, el layout probablemente no
está comunicando la relación por sí solo.

## Los íconos solos casi nunca alcanzan

Un ícono sin texto es ambiguo salvo en un puñado de casos universalmente reconocidos (lupa
de búsqueda, cerrar con X, carrito). Fuera de esos, acompañá con texto o con un `title`/
`aria-label` — y si el ícono es la única pista en una acción destructiva o poco frecuente,
directamente escribí la palabra.

## No le tengas miedo al espacio en blanco

Espaciar de más para "aprovechar la pantalla" casi nunca es el problema real; el problema
casi siempre es espaciar de menos por apuro. Antes de agregar un elemento nuevo para
"llenar" un espacio vacío, preguntate si el espacio ya está cumpliendo su función: agrupar
y dar aire a lo que sí importa.

## Chequeo rápido antes de dar por lista una pantalla

1. ¿Hay una escala de tamaños/grises/espaciado fija, o valores sueltos por todos lados?
2. ¿La jerarquía se resuelve con peso/color antes que solo con tamaño?
3. ¿Los bordes están ahí porque hacen falta, o por default?
4. ¿Cada etiqueta visible es necesaria, o el layout ya comunica la relación?
5. ¿Los íconos sin texto son de los pocos universales, o necesitan acompañamiento?
