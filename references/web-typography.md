# Tipografía web (el detalle que más se nota sin que nadie sepa nombrarlo)

`design-tokens.md` fija la escala base. Esta referencia es el nivel de detalle de
tipografía que separa una pantalla "con texto" de una pantalla tipografiada con criterio.

## Escala: razón fija, no valores sueltos

Generá la escala con una razón (1.125 conservador, 1.25 estándar, 1.333 expresivo) desde
una base de 16px, no eligiendo cada tamaño "a ojo":

```
12 → 14 → 16 → 20 → 25 → 31 → 39 → 49   (razón 1.25, redondeado)
```

Para texto **fluido** (que escala con el viewport sin saltos por breakpoint), usá `clamp()`
en vez de media queries repetidas:

```css
--text-hero: clamp(2rem, 1.2rem + 4vw, 4.5rem);
--text-body: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
```

El mínimo y el máximo son los límites reales que verificaste en pantalla; el término del
medio (`vw`) es la tasa de cambio. No pongas `clamp()` en texto de body si el proyecto ya
tiene breakpoints fijos para todo lo demás: mezclar estrategias es peor que elegir una.

## Interlineado y tracking, por tamaño

- Texto corrido (14–18px): `line-height` 1.5–1.6. Menos que eso cansa en párrafos largos.
- Subtítulos (20–28px): 1.3–1.4.
- Títulos grandes (36px+): 1.05–1.15, y `letter-spacing` negativo (−0.01 a −0.03em): a
  tamaño grande el espaciado por defecto se ve suelto.
- Texto muy chico (11–12px, badges/labels): `letter-spacing` positivo leve (+0.02–0.04em)
  y a veces mayúsculas — compensa que a ese tamaño las letras se aprietan.
- Números en tablas/dashboards: `font-variant-numeric: tabular-nums` para que no bailen al
  actualizarse, y `font-feature-settings: "ss01"` si la fuente ofrece cifras alineadas.

## Medida (largo de línea)

45–75 caracteres por línea en texto corrido; 66 es el punto dulce citado más seguido.
Controlalo con `max-width: 65ch` en el contenedor de texto, no adivinando con `px`. Un
párrafo a todo el ancho de un monitor ultrawide es el error de legibilidad más común en
dashboards con panel de detalle.

## Pareo de fuentes

- Dos familias como máximo: una para títulos (puede tener más carácter), una para texto
  (siempre alta legibilidad, ojo abierto, buen soporte de pesos). Una sola familia bien
  usada, con solo variación de peso, también resuelve el 90% de los casos.
- Contrastá **por categoría**, no por parecido: serif + sans, geométrica + humanista,
  display + neutral. Dos sans-serif parecidas entre sí (misma x-height, mismo tono) se leen
  como un error, no como una decisión.
- Fuentes variables (`font-variation-settings`) dan acceso a pesos intermedios (450, 550)
  sin cargar archivos extra por peso — un solo archivo cubre toda la escala.

## Jerarquía sin subir el tamaño

Ver `refactoring-ui.md` para el criterio completo: peso y color antes que tamaño. En
tipografía específicamente, un mismo tamaño con distinto peso (`400` vs `600`) ya separa
niveles sin romper el ritmo vertical de la página.

## Carga y rendimiento (cruce con `performance.md`)

- `font-display: swap` siempre; el usuario lee texto en fuente de sistema antes que nada.
- `preload` solo de la fuente del primer render (hero/body), nunca de todas.
- Subset: si el proyecto es en español/latino, no cargues el charset completo de la fuente
  (cirílico, griego) si no se usa.
- Variable font en un solo archivo suele pesar menos que 3–4 archivos estáticos de pesos
  distintos: verificá el peso real antes de asumir cuál conviene.

## Chequeo rápido

1. ¿La escala sale de una razón fija, o hay tamaños sueltos tipo `15px`, `17px`?
2. ¿Los títulos grandes llevan tracking negativo e interlineado ajustado?
3. ¿El texto corrido está limitado a 45–75 caracteres por línea?
4. ¿Hay más de dos familias en pantalla?
5. ¿Las fuentes cargan con `swap` y solo la crítica tiene `preload`?
