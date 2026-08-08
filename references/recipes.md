# Recetas premium (el look "UI pro" de una)

Los tokens fijan el sistema; estas recetas son las **composiciones** que separan una UI
"correcta" de una que se lee como producto pagado. Todas se apoyan en `assets/tokens.css`,
son framework-neutras (CSS puro sobre variables), pesan casi 0 KB y respetan las tres
puertas. Copiá el patrón, no la marca: cambiá `--accent-h` y todo se reajusta.

La regla que hace la diferencia visual: **luz, profundidad y ritmo**. Una superficie plana
con un borde de 1 px y una sombra suave dirigida se ve cara; un `box-shadow` negro al 40%
se ve barato. Un acento por pantalla. Espaciado generoso. Movimiento corto y con
`ease-out`.

**Índice**
1. Botón premium (primario, secundario, ghost)
2. Tarjeta con borde de luz y glass sutil
3. Borde con degradado (gradient border) sin pintar el fondo
4. Hero con malla de degradado (gradient mesh) — 0 KB, sin WebGL
5. Bento grid
6. Stat / KPI tile para dashboards
7. Input y campo de formulario impecable
8. Navbar con blur pegajoso
9. Badge y pill de estado
10. Skeleton de carga
11. Spotlight que sigue el cursor (progresivo, 15 líneas)

Todo asume que `tokens.css` ya está importado. En Tailwind, mapeá los tokens (ver
`design-tokens.md`) y traducí; el diseño es idéntico.

---

## 1. Botón premium

El detalle caro: brillo interior arriba (`inset` highlight), sombra dirigida abajo, y un
hundimiento de 1 px al presionar. Nunca `transition: all`.

```css
.btn {
  --btn-bg: var(--accent);
  display: inline-flex; align-items: center; gap: var(--space-2);
  min-height: 44px; padding: 0 var(--space-5, 1.25rem);
  border: 0; border-radius: var(--radius-md);
  font: 600 var(--text-sm)/1 var(--font-sans);
  color: var(--text-on-accent);
  background: var(--btn-bg);
  box-shadow:
    inset 0 1px 0 hsl(0 0% 100% / 0.25),           /* highlight superior */
    0 1px 2px hsl(var(--accent-h) 40% 20% / 0.30),
    0 4px 12px -2px hsl(var(--accent-h) 60% 40% / 0.35);
  cursor: pointer;
  transition: transform var(--dur-fast) var(--ease-out),
              box-shadow var(--dur-fast) var(--ease-out),
              background var(--dur-fast) var(--ease-out);
}
.btn:hover { background: var(--accent-hover); transform: translateY(-1px); }
.btn:active { transform: translateY(0) scale(0.985); }
.btn:disabled { opacity: 0.5; cursor: not-allowed; box-shadow: none; }

.btn--secondary {
  background: var(--surface-1); color: var(--text);
  box-shadow: inset 0 0 0 1px var(--border-strong), 0 1px 2px hsl(0 0% 0% / 0.04);
}
.btn--secondary:hover { background: var(--surface-2); }

.btn--ghost { background: transparent; color: var(--text); box-shadow: none; }
.btn--ghost:hover { background: var(--surface-2); }
```

## 2. Tarjeta con borde de luz

El borde de 1 px con blanco a baja opacidad simula una fuente de luz superior. En oscuro es
lo que reemplaza a la sombra (que casi no funciona sobre fondo oscuro).

```css
.card {
  background: var(--surface-1);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
  box-shadow:
    inset 0 1px 0 hsl(0 0% 100% / 0.06),
    0 1px 2px hsl(0 0% 0% / 0.04),
    var(--shadow-md);
  border: 1px solid var(--border);
  transition: transform var(--dur-base) var(--ease-out),
              box-shadow var(--dur-base) var(--ease-out);
}
.card--interactive:hover {
  transform: translateY(-2px);
  box-shadow: inset 0 1px 0 hsl(0 0% 100% / 0.08), var(--shadow-lg);
}
```

Glass sutil (solo sobre un fondo con color o imagen, nunca sobre blanco plano):

```css
.glass {
  background: hsl(var(--accent-h) 20% 98% / 0.6);
  backdrop-filter: blur(12px) saturate(1.4);
  border: 1px solid hsl(0 0% 100% / 0.35);
  border-radius: var(--radius-lg);
}
.dark .glass { background: hsl(var(--accent-h) 18% 12% / 0.5); border-color: hsl(0 0% 100% / 0.08); }
```

`backdrop-filter` es costoso: uno o dos por pantalla, nunca en una lista.

## 3. Borde con degradado

El truco: dos capas con `background-clip`, el fondo real no se pinta con el degradado.

```css
.gradient-border {
  border-radius: var(--radius-lg);
  background:
    linear-gradient(var(--surface-1), var(--surface-1)) padding-box,
    linear-gradient(135deg, var(--accent), hsl(calc(var(--accent-h) + 60) 82% 62%)) border-box;
  border: 1px solid transparent;
}
```

## 4. Hero con malla de degradado (0 KB, sin WebGL)

El fondo "caro" de una landing sin pagar `ogl` ni `three`. Son radiales apiladas. Para el
90% de los casos reemplaza al fondo WebGL — y es lo que recomienda `react-bits.md` cuando
el efecto es decorativo y no interactivo.

```css
.hero {
  position: relative; isolation: isolate;
  padding: var(--space-24) var(--space-6);
  background:
    radial-gradient(60% 50% at 20% 10%, hsl(var(--accent-h) 82% 60% / 0.22), transparent 70%),
    radial-gradient(50% 45% at 85% 20%, hsl(calc(var(--accent-h) + 50) 80% 60% / 0.18), transparent 70%),
    radial-gradient(55% 50% at 50% 100%, hsl(calc(var(--accent-h) - 40) 80% 60% / 0.15), transparent 70%),
    var(--surface-0);
}
/* Grano opcional: mata el banding de los degradados grandes */
.hero::after {
  content: ""; position: absolute; inset: 0; z-index: -1; pointer-events: none;
  opacity: 0.4; mix-blend-mode: overlay;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='2'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.5'/%3E%3C/svg%3E");
}
```

Opcional animado (respeta movimiento reducido por el bloque global de tokens): animá
`background-position`, nunca el degradado entero.

## 5. Bento grid

El layout de moda para features y dashboards. Celdas de distinto tamaño en una grilla
regular. Colapsa a una columna en móvil solo.

```css
.bento {
  display: grid; gap: var(--space-4);
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: minmax(160px, auto);
}
.bento > .span-2 { grid-column: span 2; }
.bento > .row-2  { grid-row: span 2; }
@media (max-width: 720px) {
  .bento { grid-template-columns: 1fr; }
  .bento > * { grid-column: auto !important; grid-row: auto !important; }
}
```

Cada celda usa `.card`. La jerarquía la da el tamaño de celda, no colores distintos.

## 6. Stat / KPI tile

Para dashboards. Números con `tabular-nums` (ya global en tokens) para que no bailen al
actualizarse. Delta con color semántico, nunca solo color: llevá flecha o signo.

```html
<div class="stat card">
  <span class="stat__label">Ingresos</span>
  <strong class="stat__value">$48,271</strong>
  <span class="stat__delta stat__delta--up">▲ 12.4%</span>
</div>
```
```css
.stat { display: grid; gap: var(--space-1); }
.stat__label { font-size: var(--text-sm); color: var(--text-muted); }
.stat__value { font-size: var(--text-3xl); font-weight: 700; letter-spacing: -0.02em; }
.stat__delta { font-size: var(--text-sm); font-weight: 600; }
.stat__delta--up   { color: var(--success); }
.stat__delta--down { color: var(--danger); }
```

## 7. Input impecable

Label visible siempre (nunca placeholder como etiqueta), foco con anillo del acento, error
con texto + `aria`.

```html
<div class="field">
  <label class="field__label" for="email">Correo</label>
  <input class="field__input" id="email" type="email" autocomplete="email"
         aria-describedby="email-err" />
  <p class="field__error" id="email-err" role="alert" hidden>Correo inválido.</p>
</div>
```
```css
.field { display: grid; gap: var(--space-2); }
.field__label { font-size: var(--text-sm); font-weight: 500; color: var(--text); }
.field__input {
  min-height: 44px; padding: 0 var(--space-3);
  background: var(--surface-0); color: var(--text);
  border: 1px solid var(--border-strong); border-radius: var(--radius-md);
  font-size: var(--text-base);
  transition: border-color var(--dur-fast) var(--ease-out),
              box-shadow var(--dur-fast) var(--ease-out);
}
.field__input:focus {
  outline: none; border-color: var(--accent);
  box-shadow: 0 0 0 3px var(--accent-ring);
}
.field__input[aria-invalid="true"] { border-color: var(--danger); }
.field__error { color: var(--danger); font-size: var(--text-sm); }
```

## 8. Navbar con blur pegajoso

```css
.nav {
  position: sticky; top: 0; z-index: var(--z-sticky);
  display: flex; align-items: center; gap: var(--space-6);
  padding: var(--space-3) var(--space-6);
  background: hsl(var(--accent-h) 20% 99% / 0.72);
  backdrop-filter: blur(12px) saturate(1.4);
  border-bottom: 1px solid var(--border);
}
.dark .nav { background: hsl(var(--accent-h) 18% 8% / 0.72); }
```

## 9. Badge / pill de estado

Fondo suave + texto del semántico. Legible y discreto, no un cartel.

```css
.badge {
  display: inline-flex; align-items: center; gap: var(--space-1);
  padding: 2px var(--space-2); border-radius: var(--radius-full);
  font-size: var(--text-xs); font-weight: 600; line-height: 1.6;
}
.badge--success { background: var(--success-soft); color: var(--success); }
.badge--warning { background: var(--warning-soft); color: var(--warning); }
.badge--danger  { background: var(--danger-soft);  color: var(--danger); }
.badge--info    { background: var(--info-soft);    color: var(--info); }
```

## 10. Skeleton de carga

Mejor que un spinner cuando el contenido tiene forma previsible: reduce la sensación de
espera y evita el salto de layout. La animación se apaga sola con movimiento reducido.

```css
.skeleton {
  background: linear-gradient(90deg, var(--surface-2) 25%, var(--surface-3) 37%, var(--surface-2) 63%);
  background-size: 400% 100%;
  border-radius: var(--radius-sm);
  animation: skeleton 1.4s ease infinite;
}
@keyframes skeleton { 0% { background-position: 100% 0; } 100% { background-position: -100% 0; } }
```

## 11. Spotlight que sigue el cursor

Realce progresivo (mejora, no requisito). ~15 líneas de JS, sin librería. Un radial que
sigue el mouse sobre una tarjeta.

```css
.spotlight { position: relative; overflow: hidden; }
.spotlight::before {
  content: ""; position: absolute; inset: 0; pointer-events: none;
  opacity: 0; transition: opacity var(--dur-base) var(--ease-out);
  background: radial-gradient(300px circle at var(--mx, 50%) var(--my, 50%),
              hsl(var(--accent-h) 82% 60% / 0.15), transparent 70%);
}
.spotlight:hover::before { opacity: 1; }
```
```js
document.querySelectorAll('.spotlight').forEach((el) => {
  el.addEventListener('pointermove', (e) => {
    const r = el.getBoundingClientRect();
    el.style.setProperty('--mx', `${e.clientX - r.left}px`);
    el.style.setProperty('--my', `${e.clientY - r.top}px`);
  });
});
```

---

## Cierre de composición

- **Un acento por pantalla.** Los degradados de arriba nacen del mismo `--accent-h`; no
  metas un segundo tono no relacionado.
- **Profundidad con luz, no con negro.** `inset` highlight arriba + sombra suave dirigida.
  En oscuro, borde de 1 px con blanco a baja opacidad.
- **Ritmo.** Espaciado generoso entre bloques, apretado dentro de ellos. El aire es lo que
  se lee como "pro".
- **Movimiento corto.** 130–190 ms, `ease-out`, solo `transform`/`opacity`. Todo lo de
  aquí se apaga solo con `prefers-reduced-motion` por el bloque global de los tokens.
- **`backdrop-filter` con moderación:** uno o dos por pantalla; en listas mata el scroll.
