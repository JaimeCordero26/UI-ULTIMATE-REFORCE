# Sistema visual y tokens

Lo que separa una UI que se ve profesional de una que se ve armada por partes casi nunca
es el efecto animado: es que las decisiones se repiten. Un espaciado, una escala
tipográfica, un radio, una sombra. Por eso lo primero es fijar los tokens, y recién
después decorar.

Si el proyecto ya tiene tokens, `tailwind.config`, un tema, o una skill de diseño propia,
**esa manda**. Esta referencia es para cuando no hay nada.

## Punto de partida

Copiá `assets/tokens.css` al proyecto e importalo antes que cualquier otro CSS. Trae
paleta clara y oscura, escala tipográfica, espaciado, radios, sombras y el bloque de
`prefers-reduced-motion` ya resuelto.

Con Tailwind v4, los tokens se exponen directamente:

```css
@import "tailwindcss";
@import "./tokens.css";

@theme inline {
  --color-surface: var(--surface-1);
  --color-accent: var(--accent);
  --radius-card: var(--radius-lg);
}
```

Con Tailwind v3, mapealos en `theme.extend.colors` como `var(--surface-1)`.

## Cómo elegir la paleta en dos minutos

1. **Un color de acento.** Uno. Es el que usan los botones primarios, los enlaces y el
   foco. Todo lo demás es neutro.
2. **Una rampa de neutros de 9 a 11 pasos**, no gris puro: metele una pizca del tono del
   acento (por ejemplo, neutros levemente azulados si el acento es azul). Un gris
   perfectamente neutro se ve barato en pantalla.
3. **Semánticos:** éxito, advertencia, error, información. Cada uno necesita variante de
   fondo suave y variante de texto, o los estados se ven como carteles.
4. Verificá contraste contra el fondo donde se van a usar de verdad, no en abstracto.

Nombrá por rol, no por color: `--accent`, `--surface-2`, `--text-muted`. Si mañana el
acento pasa de violeta a verde, no hay que renombrar nada.

## Tipografía

- Dos familias como máximo: una para títulos, una para texto. Con una sola bien usada
  también alcanza.
- Escala con razón fija (1.25 o 1.333) para que los tamaños se sientan relacionados.
- Interlineado: 1.5 en texto corrido, 1.1–1.2 en títulos grandes.
- Ancho de línea entre 45 y 75 caracteres. Un párrafo a todo el ancho de un monitor es
  incómodo de leer y es lo que hace que un dashboard se sienta "sin diseñar".
- Números en tablas y dashboards: `font-variant-numeric: tabular-nums`, si no las cifras
  bailan al actualizarse.

## Espaciado y forma

- Escala base de 4 px. Todo espaciado es múltiplo: 4, 8, 12, 16, 24, 32, 48, 64.
- Más aire alrededor de los bloques que dentro de ellos: es lo que agrupa visualmente.
- Un radio de borde por familia de elementos. Botones y campos comparten radio, tarjetas
  y modales comparten otro mayor. Tres radios distintos en una pantalla se ve accidental.
- Sombras: suaves, de baja opacidad, con desplazamiento vertical. Nada de sombras negras
  al 40%. En tema oscuro las sombras casi no funcionan: usá bordes de 1 px con blanco a
  baja opacidad para separar planos.

## Modo oscuro

- No inviertas colores. El fondo oscuro va entre `#0B0D10` y `#16181D`, nunca negro puro,
  que produce halos alrededor del texto.
- Bajá la saturación del acento en oscuro; el mismo tono que funciona en claro suele
  vibrar sobre fondo oscuro.
- El texto principal en oscuro no va blanco puro: usá 90% de opacidad.
- Implementación: `color-scheme` en `:root` y una clase `.dark` que redefine los mismos
  tokens. Así todo el CSS ya escrito funciona en ambos temas sin cambios.

## Micro-interacciones que cuestan 0 KB

Es donde se consigue la mayor parte de la sensación de "producto pulido":

- Transición de 150–200 ms en hover y foco, con `ease-out`. Más largo se siente lento.
- Escala de 0.98 al presionar un botón: da respuesta táctil inmediata.
- Anillo de foco visible y consistente en toda la app, con `:focus-visible` para que no
  aparezca en clicks de mouse.
- `transition-property` explícito, nunca `transition: all`, que también anima propiedades
  costosas sin querer.
- Skeletons en vez de spinners cuando el contenido tiene forma previsible: reduce la
  sensación de espera y evita el salto de layout.
