# Fábrica de temas (de un color semilla a un sistema completo)

`design-tokens.md` dice **qué** tokens definir. Esta referencia es el **método** para
generarlos en un solo paso, de forma consistente, cuando hay que crear un tema completo
(claro + oscuro, rampa de neutros, semánticos) desde un único color de marca.

## Por qué OKLCH y no HSL

HSL miente sobre el brillo percibido: un amarillo y un azul al mismo "lightness" HSL no se
ven igual de claros. **OKLCH** (`oklch(L C H)`) es perceptualmente uniforme: subir/bajar `L`
en el mismo paso produce el mismo cambio de brillo percibido sin importar el matiz. Es lo
que permite generar una rampa completa con una fórmula, sin retocar cada paso a mano.

```css
--accent-500: oklch(62% 0.19 258);  /* L C H */
```

Soporte: todos los navegadores modernos. Fallback automático con `color-mix()` o un valor
hex de respaldo si el proyecto necesita compatibilidad con navegadores muy viejos.

## Generar la rampa desde un color semilla

1. Fijá el **matiz (H)** y el **croma (C)** del color semilla — son los que le dan
   identidad de marca.
2. Generá 9–11 pasos de **lightness (L)** desde ~97% (paso 50, casi blanco) hasta ~15%
   (paso 950, casi negro), manteniendo H fijo y bajando C levemente en los extremos (el
   croma alto no es perceptible en colores muy claros u oscuros, y forzarlo produce colores
   "sucios").

```js
// pseudocódigo — en la práctica: culori, o generadores como oklch.com / Leonardo (Adobe)
const steps = [97, 92, 84, 74, 62, 52, 42, 32, 22, 15]; // % lightness
const ramp = steps.map((L, i) => `oklch(${L}% ${chromaFor(i)} ${H})`);
```

3. **Neutros:** no uses gris puro (`C: 0`). Tomá el mismo `H` del acento con `C` muy bajo
   (0.01–0.02) — es la diferencia entre un gris "de marca" y un gris genérico de sistema
   operativo (ver `taste.md §7`, nunca negro/blanco puro tampoco).
4. **Semánticos** (éxito, advertencia, error, info): no los derives del acento, tienen `H`
   propio y fijo por convención (verde ~145°, ámbar ~85°, rojo ~25°, azul ~250° aprox. en
   OKLCH) — así se mantienen reconocibles sin importar cuál sea el acento de marca.

## Verificar contraste, no asumirlo

Generar la rampa no garantiza accesibilidad; hay que verificar cada par texto/fondo que se
vaya a usar de verdad:

- WCAG 2.x: mínimo 4.5:1 texto normal, 3:1 texto grande/iconos (regla ya fijada en
  `SKILL.md`).
- APCA (el algoritmo más nuevo, pensado para tipografía variable y modo oscuro) da
  resultados más realistas que WCAG en fondos oscuros — usalo como referencia adicional si
  la herramienta lo soporta, no como reemplazo del mínimo legal WCAG.
- Herramientas: `culori` (JS, cálculo programático), el contraste integrado en DevTools de
  Chrome/Firefox, o generadores web tipo oklch.com que muestran el contraste en vivo mientras
  se ajusta la rampa.

## Modo oscuro: no inviertas, remapeá

No hay "un" modo oscuro correcto derivado matemáticamente del claro; hay que remapear los
roles:

- Fondo: no es el acento invertido, es un neutro oscuro propio (`#0B0D10`–`#16181D`, nunca
  negro puro — ver `design-tokens.md`).
- El mismo acento que funciona en claro suele vibrar de más en oscuro: bajá el croma (C) o
  subí levemente el lightness (L) del acento específicamente para el tema oscuro.
- Texto principal en oscuro: 90% de opacidad, no blanco puro.
- Implementación: los mismos nombres de token (`--surface-1`, `--accent`) redefinidos bajo
  `.dark`/`[data-theme="dark"]` — todo el CSS que ya usa esos nombres cambia de tema gratis.

## Salida de una corrida de la fábrica de temas

Al terminar, el sistema debería tener: 1 rampa de acento (9–11 pasos), 1 rampa de neutros
con tinte de marca, 4 semánticos con variante fondo-suave/texto, y las dos versiones (claro/
oscuro) de cada token con nombre de rol — listo para pegar en `assets/tokens.css` o mapear
en `@theme` de Tailwind v4.

## Chequeo rápido

1. ¿La rampa usa OKLCH (o al menos mantiene H fijo), no HSL con L lineal?
2. ¿Los neutros tienen una pizca del H del acento, no son gris puro?
3. ¿Se verificó contraste real de los pares que se van a usar, no solo generado la rampa?
4. ¿El oscuro remapea roles (fondo, acento, texto) en vez de invertir el claro?
