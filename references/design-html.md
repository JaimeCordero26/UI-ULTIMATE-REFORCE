# HTML como base del diseño (no como detalle técnico aparte)

El HTML correcto no es un tema de "los devs de backend": es la base sobre la que el CSS, la
accesibilidad y hasta el rendimiento se construyen gratis. Un `<div>` genérico con
`onClick` hace todo el trabajo que un elemento nativo ya resuelve, pero peor y con más
código. Esta referencia es para cuando hay que estructurar markup, no solo estilizarlo.

## Usá el elemento nativo antes de reconstruirlo

| Necesitás | Usá | Lo que te regala gratis |
|---|---|---|
| Modal / diálogo | `<dialog>` | Foco atrapado, `Esc` para cerrar, capa superior (`::backdrop`) sin z-index manual |
| Contenido expandible/acordeón | `<details>` + `<summary>` | Toggle sin JS, estado accesible, `open` por CSS |
| Popover / menú flotante | Popover API (`popover`, `popovertarget`) | Se cierra solo al hacer click afuera o `Esc`, capa superior sin gestionar z-index |
| Botón que ejecuta acción | `<button>` (nunca `<div onClick>`) | Foco por teclado, `Enter`/`Espacio` funcionan, rol accesible correcto |
| Enlace que navega | `<a href>` | Abrir en pestaña nueva, copiar enlace, historial — todo gratis |
| Campo con opciones fijas | `<select>` (o combobox ARIA si el diseño lo exige) | Teclado, buscar por letra, funciona en móvil sin librería |
| Fecha | `<input type="date">` | Selector nativo por plataforma, sin librería de calendario |
| Progreso / medidor | `<progress>` / `<meter>` | Semántica correcta para lectores de pantalla sin ARIA manual |

Reconstruir cualquiera de estos con `<div>` + JS solo se justifica cuando el diseño exige
algo que el elemento nativo no puede lograr (ni con CSS moderno) — y ahí hay que reponer a
mano todo lo que la tabla de arriba da gratis: foco, teclado, rol ARIA, `Esc`.

## Landmarks: que un lector de pantalla pueda saltar de bloque en bloque

```html
<header>…</header>
<nav aria-label="Principal">…</nav>
<main>
  <h1>Único por página</h1>
  <section aria-labelledby="ventas-heading">
    <h2 id="ventas-heading">Ventas</h2>
  </section>
</main>
<footer>…</footer>
```

Un solo `<h1>` por página; el resto de los títulos bajan en orden (`h2` → `h3`) sin saltar
niveles solo por tamaño visual — el tamaño se controla con CSS, no eligiendo un heading más
chico.

## Formularios: la estructura es la accesibilidad

```html
<div class="field">
  <label for="email">Correo</label>
  <input id="email" name="email" type="email" autocomplete="email" required
         aria-describedby="email-error" aria-invalid="true" />
  <p id="email-error" role="alert">Ingresá un correo válido.</p>
</div>

<fieldset>
  <legend>Método de envío</legend>
  <label><input type="radio" name="envio" value="standard" /> Estándar</label>
  <label><input type="radio" name="envio" value="express" /> Express</label>
</fieldset>
```

- `label` asociado con `for`/`id` siempre — un placeholder no reemplaza un label (ver
  `content-studio.md`, nunca se puede ver el valor y la instrucción al mismo tiempo).
- `fieldset` + `legend` para grupos de radios/checkboxes relacionados: sin esto, un lector
  de pantalla no anuncia qué pregunta agrupa esas opciones.
- `type` correcto (`email`, `tel`, `number`, `url`) activa el teclado correcto en móvil sin
  JS y habilita validación básica del navegador.
- `autocomplete` correcto (`name`, `email`, `street-address`, `cc-number`) — es lo que
  permite el autocompletado del navegador/gestor de contraseñas, y es accesibilidad además
  de conveniencia.

## Por qué esto importa incluso si "nadie usa lector de pantalla en este proyecto"

- SEO: los motores de búsqueda leen la jerarquía semántica, no el CSS.
- Menos JS: cada elemento nativo de la tabla de arriba es una dependencia menos, o cientos
  de líneas menos de manejo de foco y teclado escritas a mano (y con bugs).
- Estilizable igual: cualquier elemento nativo se puede rediseñar por completo con CSS
  moderno (`::backdrop`, `appearance: none`, `::picker`); usar el elemento correcto no
  limita el diseño visual.

## Chequeo rápido

1. ¿Hay algún `<div onClick>` que debería ser `<button>` o `<a>`?
2. ¿Cada input tiene `label` asociado, y cada grupo de opciones tiene `fieldset`/`legend`?
3. ¿El modal/menú flotante usa `<dialog>`/Popover API antes de reconstruir foco y `Esc` a
   mano?
4. ¿Hay un solo `<h1>` y los niveles de heading bajan en orden?
