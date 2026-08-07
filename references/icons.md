# Iconos

Un icono mal importado es la forma más fácil de sumar 300 KB sin darse cuenta. La regla
central es una sola: **importá icono por icono, nunca el barril completo.**

## Qué usar según el caso

| Caso | Elección | Por qué |
|---|---|---|
| React / Next, se quiere variantes outline / solid / mini | `mx-icons` | +5.600 iconos, tree-shakeable, solo React como peer dependency |
| React / Next, set genérico y muy estable | `lucide-react` | consistente, muy mantenido, es el default de shadcn/ui |
| Vue, Svelte, Astro, HTML plano, o se necesitan sets mezclados | Iconify | 200k+ iconos de cientos de sets, sin atarse a un framework |
| Build con Vite/Nuxt y se quiere costo cero en runtime | `unplugin-icons` sobre Iconify | los iconos se compilan como componentes SVG en build |
| Sitio estático o vanilla | sprite SVG propio | un solo archivo cacheado, cero JS |

Si el proyecto **ya** tiene una librería de iconos, se usa esa. Mezclar dos sets se nota
de inmediato: cambian los grosores de trazo y las esquinas, y la UI se ve armada a pedazos.

## mx-icons

```bash
npm install mx-icons
```

```tsx
import { CalendarLinear, ActivityBold } from 'mx-icons';

<CalendarLinear size={24} color="currentColor" />
<ActivityBold size={16} className="text-[var(--accent)]" />
```

Convención de nombres: PascalCase con sufijo de variante (`Linear`, `Bold`, y versiones
mini de 16 px). Props estándar: `size`, `color`, `className` y el resto de atributos SVG.
Los SVG usan `currentColor`, así que el color se hereda del texto: en la práctica conviene
no pasar `color` y dejar que lo controle la clase del contenedor.

Tamaños: 24 px para acciones e items de navegación, 16 px dentro de texto, tablas densas y
badges. No escales un icono de 24 a 12: se ve pesado. Usá la variante mini.

## Lucide

```bash
npm install lucide-react
```

```tsx
import { Search, Settings } from 'lucide-react';

<Search size={20} strokeWidth={1.75} aria-hidden="true" />
```

`strokeWidth` entre 1.5 y 2 según el peso tipográfico de la interfaz. Con tipografías
finas, 1.5. Con interfaces densas o tipografía bold, 2.

## Iconify (cualquier stack)

```html
<!-- Web component, un solo script, carga bajo demanda -->
<script src="https://code.iconify.design/iconify-icon/2.1.0/iconify-icon.min.js"></script>
<iconify-icon icon="lucide:search" width="20"></iconify-icon>
```

En producción con build propio, preferí `unplugin-icons` para que no haya petición de red
ni dependencia de un CDN externo.

## Reglas que evitan el peso muerto

```tsx
// mal: arrastra el índice completo del paquete
import * as Icons from 'lucide-react';
import Icons from 'react-icons/all';

// bien: solo entra lo que se usa
import { Search } from 'lucide-react';
```

- Nada de `react-icons` con imports desde la raíz. Si ya está en el proyecto, importá
  desde el subcamino del set (`react-icons/fi`), no desde `react-icons`.
- Si el mismo icono aparece más de 20 veces (una tabla, una lista larga), definilo una vez
  como `<symbol>` en un sprite SVG y referencialo con `<use>`. Evita 20 árboles de nodos.
- Nunca uses fuentes de iconos (Font Awesome clásico, Material Icons por webfont): bloquean
  el render, generan CLS y descargan miles de glifos para usar seis.

## Accesibilidad de iconos

```tsx
// Decorativo, hay texto al lado
<Search size={18} aria-hidden="true" />

// Es el único contenido del botón: necesita nombre accesible
<button aria-label="Buscar"><Search size={18} aria-hidden="true" /></button>
```

Un botón solo con icono y sin `aria-label` es invisible para un lector de pantalla. Es el
error de accesibilidad más común en interfaces bonitas.
