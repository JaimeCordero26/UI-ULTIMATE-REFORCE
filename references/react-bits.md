# React Bits y familia (React / Vue / Svelte)

Colección de componentes animados: animaciones de texto, efectos, componentes de UI y
fondos. Licencia MIT + Commons Clause: libre para uso personal y comercial, el código
queda en tu repo y se puede editar. No se puede revender la librería como producto.

- React: https://reactbits.dev
- Vue: https://vue-bits.dev
- Svelte: https://sveltebits.xyz

**Índice**
1. Cómo instalar
2. Regla de verificación de nombres
3. Catálogo por peso
4. Integración en Next.js / SSR
5. Cómo hacer que un efecto pesado no mate el rendimiento
6. Herramientas del sitio

---

## 1. Cómo instalar

Dos vías oficiales por CLI. El componente se copia dentro del proyecto, no se agrega como
dependencia npm, así que después se edita libremente.

```bash
# shadcn (recomendado si el proyecto ya usa shadcn/ui)
npx shadcn@latest add @react-bits/BlurText-TS-TW

# jsrepo
npx jsrepo add https://reactbits.dev/tailwind/TextAnimations/BlurText
```

Variantes disponibles en el sufijo: `TS-TW`, `TS-CSS`, `JS-TW`, `JS-CSS`. Elegí la que
coincida con el proyecto: si hay `tsconfig.json` y `tailwind.config`, va `TS-TW`.

La tercera vía siempre válida: abrir la página del componente en reactbits.dev, copiar el
código y pegarlo. Es la más confiable cuando el CLI falla o no hay red.

Existen servidores MCP no oficiales de React Bits, pero están desactualizados respecto a
la librería. Preferí el CLI o el copiado manual desde la documentación.

## 2. Regla de verificación de nombres

Los nombres de componente cambian y se agregan varios por semana. **No inventes nombres.**
Si no estás seguro de que un componente existe:

1. Probá el comando del CLI: falla de inmediato si el nombre no existe, y ese error es
   información barata.
2. O consultá la documentación del sitio antes de prometerle al usuario un componente.

Si el componente que imaginabas no existe, decilo y escribí el efecto a mano con CSS.
Nunca entregues un import a un módulo inexistente.

## 3. Catálogo por peso

La clasificación importa más que el nombre exacto: define cuántos podés usar por pantalla.

**Nivel 0 — CSS puro, sin dependencias (usá los que quieras)**
Bordes animados, texto con degradado, texto con brillo, cuadrículas y patrones de fondo,
efectos hover de tarjeta. Costo prácticamente nulo.

**Nivel 1 — animación por JS (`framer-motion` / `motion` o `gsap`), ~30–60 KB gzip la
librería, compartida entre todos los componentes que la usen**
Animaciones de texto (aparición por letra, desenfoque, conteo, tipeo, descifrado,
rotación), contenido que entra al hacer scroll, imanes de cursor, chispas de click,
carruseles y galerías, docks y menús animados, steppers, tarjetas inclinables.
Regla: si ya pagaste la librería una vez, usar tres componentes más de ese nivel casi no
suma peso. Ese es el lugar donde conviene gastar el presupuesto.

**Nivel 2 — WebGL con `ogl` (~40 KB gzip) — máximo uno por pantalla**
Fondos tipo aurora, seda, ondas, iridiscencia, rayos de luz, velos oscuros, partículas,
cromo líquido, orbes. Se ven espectaculares y son la razón principal por la que alguien
usa React Bits. Siempre lazy y siempre pausables.

**Nivel 3 — `three` / react-three-fiber, y en algunos casos física (~600 KB+) — evitar**
Visores de modelos 3D, galerías tipo domo, cordones con física, cristal fluido.
Solo si el 3D **es** el producto. Para un adorno de fondo, nunca. Si el usuario lo pide
igual, avisá el costo en KB y en batería antes de instalarlo.

## 4. Integración en Next.js / SSR

Los componentes animados tocan `window`, `document` o el canvas, así que:

```tsx
'use client';
```

va en el archivo del componente o del wrapper. Para fondos pesados, además:

```tsx
import dynamic from 'next/dynamic';

const Aurora = dynamic(() => import('@/components/Aurora'), {
  ssr: false,
  loading: () => <div className="absolute inset-0 bg-[var(--surface-2)]" />,
});
```

El `loading` con el color de fondo sólido evita el parpadeo blanco y evita CLS: el hueco
ya ocupa el espacio final antes de que cargue el efecto.

## 5. Cómo hacer que un efecto pesado no mate el rendimiento

Cuatro medidas, siempre juntas:

```tsx
// 1. Montar solo cuando el efecto está en pantalla
const [visible, setVisible] = useState(false);
const ref = useRef<HTMLDivElement>(null);

useEffect(() => {
  const el = ref.current;
  if (!el) return;
  const io = new IntersectionObserver(
    ([entry]) => setVisible(entry.isIntersecting),
    { rootMargin: '200px' }
  );
  io.observe(el);
  return () => io.disconnect();
}, []);

// 2. Respetar la preferencia de movimiento reducido
const reduced = useMemo(
  () => window.matchMedia('(prefers-reduced-motion: reduce)').matches,
  []
);

// 3. Fallback estático, no pantalla vacía
return (
  <div ref={ref} className="relative">
    {visible && !reduced ? <Aurora /> : <div className="absolute inset-0 bg-gradient-to-b from-[var(--surface-2)] to-[var(--surface-1)]" />}
  </div>
);
```

```tsx
// 4. Pausar el loop cuando la pestaña no se ve (ahorra batería y CPU)
useEffect(() => {
  const onVis = () => (document.hidden ? stopLoop() : startLoop());
  document.addEventListener('visibilitychange', onVis);
  return () => document.removeEventListener('visibilitychange', onVis);
}, []);
```

Además: bajá el `dpr` del canvas a `Math.min(window.devicePixelRatio, 1.5)`. En pantallas
retina la diferencia visual es mínima y el costo de píxeles se reduce a la mitad.

## 6. Herramientas del sitio

React Bits publica utilidades gratuitas que sirven para conseguir el efecto sin código
pesado: un estudio de fondos que exporta el resultado como imagen o video (un `.webm` de
fondo pesa mucho menos que WebGL en vivo), un generador de esquinas redondeadas internas
que exporta SVG o `clip-path`, y un laboratorio de texturas con efectos tipo ruido o
dithering aplicables a imágenes.

Cuando el efecto es puramente decorativo y no interactivo, **exportarlo como video o
imagen desde el estudio de fondos suele ser la mejor decisión de rendimiento**: se ve
igual y cuesta una fracción.

## Nota de cadena de suministro

Instalar por CLI descarga y escribe código en el proyecto. Revisá el archivo generado
antes de darlo por bueno: que no haga peticiones de red inesperadas, que no lea
`localStorage` sin motivo, que las dependencias que agregó al `package.json` sean las que
esperabas. Es un minuto y cubre el riesgo A03 de la lista de OWASP.
