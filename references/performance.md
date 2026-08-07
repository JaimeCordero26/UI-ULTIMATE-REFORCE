# Rendimiento

Objetivo concreto: que la interfaz se sienta instantánea en un celular de gama media con
red móvil, no en la máquina de quien la programó. Ese es el escenario real de la mayoría
de usuarios.

## Presupuesto

| Métrica | Objetivo | Se rompe cuando |
|---|---|---|
| JS inicial (gzip) | ≤ 170 KB | entra `three`, `moment`, `lodash` completo o un barril de iconos |
| CSS inicial | ≤ 60 KB | se importa una librería de componentes completa por un botón |
| LCP | < 2.5 s | la imagen del hero no tiene prioridad o la fuente bloquea el render |
| INP | < 200 ms | hay trabajo pesado en el manejador de eventos o re-renders en cascada |
| CLS | < 0.1 | imágenes sin dimensiones, fuentes sin `size-adjust`, contenido inyectado arriba |
| Peticiones en el primer render | ≤ 25 | iconos individuales por red, fuentes de varios orígenes |

## Las cinco causas reales de lentitud

En orden de frecuencia, por lo que se ve en proyectos reales:

1. **Dependencias que entraron sin medirse.** Una fecha formateada con una librería de
   300 KB cuando `Intl.DateTimeFormat` es nativo y pesa cero.
2. **Todo importado de forma estática.** Modales, editores, gráficos y mapas que el
   usuario tal vez nunca abra, cargados en el primer byte.
3. **Animar propiedades que provocan layout.** `width`, `height`, `top`, `left`,
   `margin`, `box-shadow` y `filter` recalculan en cada frame. `transform` y `opacity`
   los maneja el compositor.
4. **Listas largas sin virtualización.** 500 filas en el DOM son 500 filas que el
   navegador mide en cada cambio.
5. **Imágenes sin optimizar.** Un PNG de 2 MB para un avatar de 40 px es más costoso que
   todo el JavaScript de la página junto.

## Patrones que resuelven cada causa

```js
// 2. Carga diferida de lo que no se ve en el primer render
const Chart = lazy(() => import('./Chart'));            // React
const Chart = defineAsyncComponent(() => import('./Chart.vue'));  // Vue
const { default: Chart } = await import('./Chart.js');  // vanilla, al hacer click
```

```css
/* 3. Solo transform y opacity, y solo las propiedades declaradas */
.card {
  transition: transform var(--dur-base) var(--ease-out),
              opacity var(--dur-base) var(--ease-out);
}
.card:hover { transform: translateY(-2px); }
```

```css
/* 4. Alternativa barata a la virtualización en listas medianas:
      el navegador se salta el render de lo que está fuera de pantalla */
.row {
  content-visibility: auto;
  contain-intrinsic-size: auto 64px;
}
```

Para listas grandes de verdad (más de ~200 filas), virtualización real: TanStack Virtual,
`FlashList` en React Native, `LazyColumn` en Compose.

```html
<!-- 5. Imágenes: dimensiones explícitas evitan CLS, y solo la del hero es prioritaria -->
<img src="hero.avif" width="1200" height="630" alt="" fetchpriority="high" decoding="async">
<img src="card.avif" width="400" height="300" alt="" loading="lazy" decoding="async">
```

## Fuentes

```html
<link rel="preload" as="font" type="font/woff2" href="/fonts/inter-var.woff2" crossorigin>
```

```css
@font-face {
  font-family: "Inter";
  src: url("/fonts/inter-var.woff2") format("woff2");
  font-display: swap;
  unicode-range: U+0000-00FF, U+0131, U+2000-206F; /* latino + puntuación */
  size-adjust: 107%;  /* iguala métricas con la fuente de fallback y elimina el salto */
}
```

Variable font cuando se necesiten 3 o más pesos: una sola descarga en vez de tres.

## Cómo medir (no adivinar)

```bash
# Peso real del build
npm run build              # Vite y Next imprimen el tamaño por chunk

# Quién ocupa el bundle
npx vite-bundle-visualizer
npx source-map-explorer 'dist/assets/*.js'

# Auditoría completa contra el sitio corriendo
npx lighthouse http://localhost:3000 --preset=desktop --view

# Peso de un paquete antes de instalarlo
npx package-size lucide-react
```

Antes de optimizar, medí. La intuición sobre qué es lento acierta menos de la mitad de las
veces, y se pierde tiempo optimizando lo que no importaba.

## Regla de decisión para agregar una dependencia

Aceptala solo si se cumplen las cuatro:

1. Resuelve un problema que llevaría más de ~100 líneas propias.
2. Pesa menos de 30 KB gzip, o entra por carga diferida y solo en la ruta que la usa.
3. Tuvo una publicación en los últimos 12 meses.
4. No duplica algo que el navegador o el lenguaje ya traen (`Intl`, `fetch`,
   `structuredClone`, `URLSearchParams`, `crypto.randomUUID`, `Temporal` donde exista).

Si no, escribí las líneas. Suele ser menos trabajo que mantener la dependencia.
