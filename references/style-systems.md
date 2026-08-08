# Sistemas de estilo (arquetipos visuales)

Los tokens fijan el sistema y `recipes.md` da las composiciones; esta referencia elige el
**lenguaje visual** completo. Un arquetipo es una decisión de conjunto: qué hacen la luz, la
profundidad, el borde, el fondo y la tipografía juntos. Elegí **uno** por proyecto y sé
consistente; mezclar dos se lee como plantilla sin terminar.

Regla transversal: cualquiera de estos se construye sobre `assets/tokens.css` cambiando
`--accent-h` y unas pocas variables. Ninguno justifica una librería de componentes nueva.
Cada uno declara su **coste** y su **trampa** (lo que lo arruina).

Cómo elegir rápido:

| Querés que se sienta… | Arquetipo |
|---|---|
| Serio, caro, atemporal, mucho contenido | Minimalismo / editorial |
| Producto moderno, features, dashboard con ritmo | Bento grid |
| Vidrio, capas, sobre foto o fondo con color | Glassmorphism |
| Suave, físico, táctil (con cuidado de contraste) | Neumorphism / claymorphism |
| Crudo, con carácter, "anti-corporativo" | Brutalism / neo-brutalism |
| Landing con "wow", tech, IA, degradados | Aurora / gradient mesh |
| Herramienta técnica, dev tool, terminal | Dark developer |

---

## Minimalismo / editorial (el default seguro)

Lo que eligen los productos que quieren durar. No es "poco diseño": es jerarquía pura.

- **Firma:** mucho blanco (o superficie), tipografía como protagonista, escala tipográfica
  amplia (títulos grandes, `letter-spacing` negativo ~-0.02em), un acento discreto, bordes
  de 1 px en vez de sombras fuertes, grilla estricta.
- **Tokens:** neutros con una pizca del acento; `--accent` casi solo en foco y links; radios
  chicos o nulos; sombras mínimas.
- **Coste:** 0 KB. Es el más barato y el más difícil de hacer mal.
- **Trampa:** contraste insuficiente (gris claro sobre blanco) y falta de ritmo. Sin
  jerarquía tipográfica clara, se ve "sin diseñar" en vez de "limpio".

## Bento grid

Celdas de distinto tamaño en una grilla regular. El layout de moda para features, "cómo
funciona" y dashboards. La receta CSS está en `recipes.md §5`; acá va la dirección visual.

- **Firma:** tarjetas con el mismo radio y borde, jerarquía dada por **tamaño de celda**, no
  por color. Una celda "héroe" (2×2) ancla la grilla; el resto la rodea. Un dato/ilustración
  por celda, nunca párrafos.
- **Coste:** 0 KB (CSS grid).
- **Trampa:** celdas con densidad desigual (una vacía al lado de una saturada) y usar color
  distinto por celda para "diferenciar". La diferencia la da el tamaño y el contenido.

## Glassmorphism

Superficies translúcidas con desenfoque de fondo. La receta `.glass` está en `recipes.md §2`.

- **Firma:** `backdrop-filter: blur()` + fondo semitransparente + borde de 1 px con blanco a
  baja opacidad (simula el canto del vidrio). **Solo funciona sobre un fondo con color,
  degradado o imagen**; sobre blanco plano no hay nada que desenfocar y se ve sucio.
- **Coste:** `backdrop-filter` es caro en GPU. **Uno o dos por pantalla**, nunca en una lista
  o en algo que scrollea: mata los FPS.
- **Trampa:** texto sobre vidrio con poco contraste. Poné una capa de color sólida detrás del
  texto o subí la opacidad del fondo del panel. Accesibilidad primero.

## Neumorphism (soft UI) y claymorphism

Elementos que parecen extruidos de la superficie (neumorphism) o inflados y blandos
(claymorphism).

- **Firma neumorphism:** misma superficie que el fondo + doble sombra (una clara arriba-izq,
  una oscura abajo-der) para simular relieve.
- **Firma claymorphism:** radios grandes, sombra interior clara + sombra exterior difusa,
  colores pastel. Más amigable y con mejor contraste que el neumorphism.

```css
.neu {
  background: var(--surface-1);
  border-radius: var(--radius-lg);
  box-shadow: -6px -6px 12px hsl(0 0% 100% / 0.7),
               6px  6px 12px hsl(var(--accent-h) 20% 60% / 0.25);
}
.clay {
  background: var(--surface-1);
  border-radius: var(--radius-xl, 24px);
  box-shadow: inset 0 2px 6px hsl(0 0% 100% / 0.6),
              0 12px 24px -8px hsl(var(--accent-h) 40% 40% / 0.35);
}
```

- **Coste:** 0 KB.
- **Trampa grande:** el neumorphism casi siempre **falla contraste** (el borde entre control
  y fondo es pura sombra suave, invisible para baja visión). No lo uses en controles críticos
  (botones primarios, campos) sin un borde real. Claymorphism sufre menos.

## Brutalism / neo-brutalism

Crudo y con carácter: bordes negros gruesos, sombras duras sin difuminar, colores planos y
saturados, tipografía grande, cero degradados.

```css
.brutal {
  background: var(--surface-0);
  border: 2px solid #000;
  border-radius: 0;                 /* o muy poco */
  box-shadow: 4px 4px 0 0 #000;     /* sombra dura, sin blur */
  transition: transform var(--dur-fast) var(--ease-out),
              box-shadow var(--dur-fast) var(--ease-out);
}
.brutal:hover { transform: translate(-2px, -2px); box-shadow: 6px 6px 0 0 #000; }
.brutal:active { transform: translate(2px, 2px); box-shadow: 2px 2px 0 0 #000; }
```

- **Coste:** 0 KB, y de hecho el más liviano visualmente (sin blur, sin gradientes).
- **Trampa:** en modo oscuro la sombra negra desaparece; usá un color de sombra visible.
  Y el contraste altísimo cansa en pantallas de mucho texto: va mejor en landings y portfolios
  que en apps de uso prolongado.

## Aurora / gradient mesh

El fondo "caro" de landing tech/IA: degradados radiales suaves apilados, a veces animados.
La receta 0 KB (sin WebGL) está en `recipes.md §4`.

- **Firma:** 2–4 radiales del mismo `--accent-h` (más un par de tonos vecinos), grano sutil
  encima para matar el *banding*, y contenido con mucho aire encima.
- **Coste:** 0 KB en CSS. Si es WebGL en vivo (aurora de React Bits), Nivel 2: lazy y
  pausable, uno por pantalla. Para algo puramente decorativo, exportá `.webm`/imagen.
- **Trampa:** meter un segundo tono no relacionado (arcoíris) y poner texto de bajo contraste
  encima del degradado. Un acento por pantalla; el texto va sobre zona sólida o con capa.

## Dark developer / terminal

Para dev tools, dashboards técnicos, docs de API.

- **Firma:** fondo entre `#0B0D10` y `#16181D` (nunca negro puro), texto al 90% de opacidad,
  acento saturado usado con moderación, tipografía mono para datos/código, bordes de 1 px con
  blanco a baja opacidad en vez de sombras (que casi no funcionan en oscuro).
- **Coste:** 0 KB. El tema oscuro de los tokens ya trae esta base.
- **Trampa:** negro puro (`#000`) produce halos alrededor del texto, y blanco puro vibra.
  Ambos ya resueltos en `design-tokens.md §Modo oscuro`.

---

## Cierre

- **Un arquetipo por proyecto.** El sistema visual se elige una vez; los tokens lo hacen
  barato de cambiar si te equivocaste.
- **La accesibilidad manda sobre el estilo.** Glass y neumorphism son los que más fácil
  rompen contraste: si el arquetipo pelea con 4.5:1, gana el contraste.
- **Ninguno necesita una librería.** Todos salen de `tokens.css` + las recetas. Si un
  arquetipo "pide" un paquete pesado, casi siempre es que se puede con CSS.
