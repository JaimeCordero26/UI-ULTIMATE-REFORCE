# Canvas, SVG y WebGL (dibujar en vez de maquetar)

`react-bits.md §5` y `performance.md` cubren el montaje seguro de un efecto de fondo
(lazy, pausable, `IntersectionObserver`). Esta referencia es la decisión de **qué
tecnología de dibujo usar** y cómo trabajar con ella cuando el diseño pide algo que CSS no
resuelve: ilustración, visualización de datos custom, o un efecto generativo.

## Elegí la tecnología por lo que hace el contenido, no por preferencia

| Necesitás | Usá | Por qué |
|---|---|---|
| Ícono, logo, ilustración plana, gráfico que necesita ser nítido a cualquier zoom | **SVG** | Vectorial, escala sin perder calidad, cada nodo es estilizable/animable por CSS, accesible (`<title>`, `role="img"`) |
| Miles de elementos dibujados a la vez (partículas, visualización con muchos puntos), o pintar pixel a pixel | **Canvas 2D** | El DOM no aguanta miles de nodos; canvas dibuja en un solo elemento sin costo de layout por ítem |
| Efecto 3D real, shaders, iluminación, post-procesado | **WebGL** (`ogl`, `three`/R3F) | Es lo único de la lista con GPU programable de verdad; el más pesado de los tres |
| Gráfico de datos (barras, líneas, dispersión) | **SVG** primero (D3 + SVG, o librerías como Recharts/visx) | Cada punto es un nodo inspeccionable/accesible; solo pasás a canvas si son >~1000 puntos y el DOM se nota lento |

Regla de default: si SVG lo resuelve, no bajes a canvas; si canvas lo resuelve, no subas a
WebGL. Cada escalón pesa más y es más difícil de mantener.

## SVG: patrones que ahorran peso

- Un solo `<svg>` con `<symbol>`/`<use>` para íconos repetidos, en vez de pegar el mismo
  `<path>` completo N veces — baja el tamaño del documento sin perder nitidez.
- Gradientes y filtros (`feGaussianBlur`, `feTurbulence`) resuelven texturas orgánicas
  (grano, ruido, blobs) sin ninguna imagen ni librería — ver `recipes.md §4` para el
  gradient mesh de fondo.
- Animá con CSS (`transform`, `opacity` sobre el SVG) antes que con JS; `stroke-dasharray`
  + `stroke-dashoffset` anima trazos ("dibujarse solo") sin ninguna dependencia.

## Canvas 2D: patrones seguros

```js
const canvas = document.querySelector('canvas');
const ctx = canvas.getContext('2d');
const dpr = Math.min(window.devicePixelRatio || 1, 2); // cap: no renderices a 3x en un 4K

function resize() {
  canvas.width = canvas.clientWidth * dpr;
  canvas.height = canvas.clientHeight * dpr;
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
}
resize();
new ResizeObserver(resize).observe(canvas);

let raf;
function loop() {
  // dibujar un frame
  raf = requestAnimationFrame(loop);
}
document.addEventListener('visibilitychange', () => {
  document.hidden ? cancelAnimationFrame(raf) : (raf = requestAnimationFrame(loop));
});
```

- Cap de `devicePixelRatio` a 2: en pantallas 3x no gana nitidez perceptible y cuadriplica
  el trabajo de pintado.
- `OffscreenCanvas` + Web Worker si el dibujo es pesado y no puede compartir hilo con la
  UI — evita que la animación trabe el scroll o los inputs.
- Limpiá `requestAnimationFrame` al desmontar el componente **siempre**; un loop huérfano
  sigue consumiendo CPU/batería aunque el canvas ya no esté en pantalla.
- Pausá con `visibilitychange` (pestaña oculta) e `IntersectionObserver` (fuera del
  viewport) — el mismo patrón que `react-bits.md §5` para fondos.

## WebGL / 3D: solo cuando el efecto lo exige de verdad

Antes de instalar `three` (~600 KB) para un fondo decorativo, probá si un gradient mesh CSS
o un `.webm`/`.gif` exportado logra el mismo resultado visual por una fracción del peso —
casi siempre sí, salvo que haya interacción real con el mouse/scroll en 3D. Si el efecto lo
justifica: `ogl` (~5 KB) para casos simples, R3F solo si ya hay una escena 3D compleja con
múltiples objetos/luces que se benefician del modelo declarativo de React.

## Accesibilidad de contenido dibujado

Todo lo que se dibuja en canvas es invisible para un lector de pantalla: si transmite
información (no solo decoración), agregá un `<canvas>` con contenido de respaldo dentro de
las etiquetas, o un elemento paralelo oculto visualmente (`sr-only`) con la misma
información en texto. SVG resuelve esto mejor de fábrica con `<title>`/`<desc>` y roles ARIA
por nodo.

## Chequeo rápido

1. ¿SVG resolvería esto sin bajar a canvas? ¿Canvas sin subir a WebGL?
2. ¿El `devicePixelRatio` está capado a 2?
3. ¿El loop se pausa fuera de viewport y en pestaña oculta, y se limpia al desmontar?
4. Si transmite información real (no decorativa), ¿hay alternativa textual/accesible?
