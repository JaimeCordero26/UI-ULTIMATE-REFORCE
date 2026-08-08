# Gusto (el criterio que separa "correcto" de "impecable")

Los tokens, las recetas y los arquetipos hacen que una UI esté **bien**. Esta referencia es
la capa de **juicio**: por qué dos pantallas que cumplen las mismas reglas se ven una barata
y otra cara. Es lo que se pide cuando el usuario dice "hacelo más pro", "que tenga onda" o
"le falta algo y no sé qué". Casi nunca falta un efecto; falta refinamiento.

## Las decisiones que dan "gusto"

1. **Menos decisiones, más repetidas.** Un acento, una familia de radios, una escala de
   espaciado, dos pesos tipográficos. La sofisticación viene de la **restricción**, no de la
   variedad. Cada excepción ("este botón sí lleva otro radio") baja la calidad percibida.
2. **Jerarquía por contraste de tamaño, no por cantidad de color.** Un título grande al lado
   de un cuerpo chico comunica más que tres colores. Si todo grita, nada se lee.
3. **El espacio en blanco es un elemento activo.** Más aire **entre** bloques que **dentro**;
   eso es lo que agrupa y lo que se lee como "producto caro". Apretar todo para que "entre"
   es el error nº1 de la UI amateur.
4. **Ajuste óptico sobre matemático.** El ojo manda: un ícono a veces necesita 1 px de
   corrección para verse centrado aunque la caja esté "perfecta"; los títulos grandes piden
   `letter-spacing` negativo (~-0.02em) porque a tamaño grande las letras se ven separadas;
   un texto sobre botón se ve mejor con 1 px menos de padding abajo que arriba.
5. **Radios anidados coherentes.** El radio de un elemento hijo = radio del padre − padding.
   Un botón de radio 12 dentro de una tarjeta de radio 16 con 8 de padding se ve mal; la
   tarjeta debería ir a 20. Es un detalle chico que el ojo registra aunque no sepa nombrarlo.
6. **Profundidad con luz, no con negro.** `inset` highlight arriba + sombra suave dirigida
   abajo. Una sombra negra al 40% se ve barata en cualquier arquetipo.
7. **Nunca negro puro ni blanco puro.** `#000` sobre blanco vibra y cansa; texto principal
   al 90% de opacidad y fondos oscuros entre `#0B0D10` y `#16181D`.
8. **Alineación a una grilla real.** Todo cae en múltiplos de 4. El desalineo de 1–3 px es
   la razón invisible por la que algo "se ve raro" sin que se sepa por qué.
9. **Detalles de estado.** Hover, focus, active, disabled, loading, vacío y error diseñados,
   no heredados del navegador. El pulido vive en los estados, no en el estado feliz.
10. **Movimiento corto y con intención** (ver `motion.md`). Una transición de 150 ms bien
    puesta hace más por la sensación de calidad que cualquier fondo animado.

## Tests rápidos de gusto

- **Squint test.** Entrecerrá los ojos hasta que todo se vuelva borroso. Lo que sigue
  legible es la jerarquía real. Si todo pesa igual, no hay jerarquía.
- **Test del −20%.** Quitá el 20% de los elementos (una línea, un ícono, un borde, un color).
  Si la pantalla sigue comunicando, quedó mejor. Casi siempre sigue.
- **Test de la esquina.** Mirá solo las esquinas redondeadas: ¿todas de la misma familia,
  bien anidadas? El desorden de radios es el delator más común.
- **Test del gris.** Ponelo en escala de grises. Si depende del color para funcionar
  (estados, jerarquía), falla accesibilidad y probablemente gusto.
- **Test del borde de dispositivo.** A 360 px de ancho, ¿respira o se amontona? El diseño
  angosto revela los problemas de espaciado antes que el ancho.

## Robá estructura, no estilo

El atajo honesto para el gusto: mirá **cómo estructuran** el problema los productos que
admirás (Linear, Stripe, Vercel, Things, Arc), no para copiar el color sino el **esqueleto**:
cuánto aire dejan, cuántos pesos tipográficos usan, cómo separan planos, qué **no** ponen.
Lo que hace a esos productos verse caros es casi siempre lo que decidieron **omitir**.

## Explorar antes de comprometer (método superdesign)

El error de agente más común es entregar la **primera** solución visual. Las herramientas
tipo *superdesign* (agente de diseño open source que vive en el IDE) parten de una idea
mejor: **generar varias variantes en paralelo, comparar y quedarse con la mejor**, en vez de
pulir la primera a ciegas.

Aplicalo sin herramienta, en HTML/artefacto desechable:

1. **Generá 3–5 variantes** del mismo componente/pantalla que cambien **una dimensión** cada
   una: el arquetipo (minimal vs. bento vs. glass), la densidad, la escala tipográfica, o el
   nivel de movimiento. Misma data real en todas.
2. **Compará lado a lado**, no de memoria. El ojo elige rápido cuando ve las opciones juntas.
3. **Bifurcá la ganadora** y refinala; descartá el resto. No promedies las variantes: un
   promedio de opciones buenas suele ser una opción mediocre.
4. Recién ahí, integrá al proyecto real con sus tokens y componentes.

Es lo que hace el comando `/reforce:variants`. Barato en tokens (HTML plano), y evita
enamorarse de la primera idea. Cada variante sigue pasando las tres puertas.

## El "no slop": el gate de gusto

Antes de dar por buena una UI, una línea de honestidad: **¿esto se ve como una plantilla
genérica de IA?** Señales de "slop" a matar:

- Degradado violeta→rosa por defecto sin relación con la marca.
- Emojis como iconos en UI seria.
- Tres sombras compitiendo, o sombra negra dura al 40%.
- Todo con el mismo peso visual (sin jerarquía).
- Bordes redondeados enormes en todo por igual.
- Texto de relleno que no dice nada ("Lorem", "Tu texto aquí", features vagas).
- Espaciado apretado y uniforme, sin ritmo.

Si aparece alguna, el trabajo no está terminado aunque "funcione". El gusto es la parte de
la puerta de diseño que ninguna herramienta automática mide; se decide mirando.
