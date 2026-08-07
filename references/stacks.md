# UI por stack (cuando no es React)

Los principios de `SKILL.md` no cambian: jerarquía antes que decoración, un efecto pesado
por pantalla, movimiento reducido respetado, tokens definidos antes de decorar. Lo que
cambia es la herramienta. Los tokens de `assets/tokens.css` se traducen a cualquiera de
estos entornos.

## Vue / Nuxt

- Componentes animados: Vue Bits (https://vue-bits.dev), puerto oficial de React Bits, con
  las mismas categorías y la misma clasificación de peso.
- Base de componentes: shadcn-vue, Nuxt UI o PrimeVue. Uno solo, no mezclar.
- Iconos: Iconify con `unplugin-icons`, que en Nuxt viene integrado y compila los SVG en
  build.
- Efectos pesados: `<ClientOnly>` más `defineAsyncComponent` para que no entren en el
  bundle inicial ni rompan el SSR.

## Svelte / SvelteKit

- Componentes animados: Svelte Bits (https://sveltebits.xyz).
- Svelte trae `transition:`, `animate:` y `crossfade` nativos: buena parte de lo que en
  React necesita una librería aquí ya está incluido y pesa cero. Usalo antes de instalar nada.
- Iconos: `unplugin-icons` o `@iconify/svelte`.

## HTML / CSS / Astro / sitios estáticos

- Los tokens se importan tal cual, sin adaptación.
- Animación al hacer scroll sin JS: `animation-timeline: view()`. Donde no haya soporte,
  `IntersectionObserver` en 10 líneas antes que cualquier librería.
- Transiciones entre páginas: la View Transitions API, nativa en Astro.
- Efectos de fondo: un `.webm` exportado o un SVG animado pesan mucho menos que WebGL.
- Iconos: sprite SVG con `<symbol>` y `<use>`. Un solo archivo cacheado, cero JS.
- Astro con islas: `client:visible` para cualquier cosa animada, nunca `client:load`.

## React Native / Expo

- Animación: `react-native-reanimated` corriendo en el hilo de UI. Nada de `Animated` del
  core para gestos, se siente lento.
- Iconos: `@expo/vector-icons` o SVG con `react-native-svg`.
- Listas: `FlashList` sobre `FlatList` en listas largas.
- Respetá `AccessibilityInfo.isReduceMotionEnabled()` igual que `prefers-reduced-motion`
  en web.

## Flutter

- Material 3 con `ColorScheme.fromSeed()`: se le pasa el color de acento y genera la
  paleta completa, claro y oscuro. Equivale a `--accent-h` de los tokens.
- Los tokens van a `ThemeData` (`colorScheme`, `textTheme`, `cardTheme`), nunca sueltos en
  los widgets.
- Animación: `AnimatedContainer`, `Hero`, `flutter_animate` para secuencias. Evitá
  reconstruir árboles grandes por frame.
- Movimiento reducido: `MediaQuery.of(context).disableAnimations`.

## Android nativo (Jetpack Compose)

- Material 3 con dynamic color, tokens en `Theme.kt` (`ColorScheme`, `Typography`, `Shapes`).
- Animación: `animate*AsState`, `AnimatedVisibility`, transiciones compartidas.
- Cuidado con recomposiciones: estado lo más abajo posible en el árbol.

## Escritorio: JavaFX, Swing, WPF, Qt

- JavaFX: los tokens van a un `.css` con `-fx-` (JavaFX soporta variables con `-fx-` y
  `looked-up colors`). AtlantaFX da una base moderna sin escribir el tema desde cero.
- Swing: FlatLaf resuelve el 90% del aspecto anticuado con una línea de configuración.
- Regla común: nunca bloquear el hilo de UI. En JavaFX el trabajo pesado va en `Task` y la
  actualización en `Platform.runLater`; en Swing, `SwingWorker`.

## Escritorio web: Tauri / Electron

- Tauri antes que Electron si se puede elegir: unos pocos MB contra unos 150 MB, y menos
  memoria en reposo.
- Dentro es una web app: aplican todas las reglas de la parte web sin cambios.
- Seguridad: en Tauri, allowlist mínima de APIs; en Electron, `contextIsolation: true`,
  `nodeIntegration: false` y preload con `contextBridge`. Sin eso, un XSS en la UI se
  convierte en ejecución de código en la máquina del usuario.

## Python: interfaces de escritorio y TUI

- TUI moderna: Textual. Tiene CSS propio (archivos `.tcss`), layout, temas y widgets
  reactivos; los tokens se traducen casi uno a uno.
- Salida enriquecida en terminal: Rich (tablas, paneles, barras de progreso, syntax
  highlighting). Detecta si la salida es un TTY y degrada a texto plano solo cuando toca.
- Escritorio: PySide6/Qt con hoja de estilos QSS, o Flet si se quiere Material sin Qt.
- Nunca bloquees el hilo de UI: `asyncio` en Textual, `QThread` en Qt.

## Herramientas de línea de comandos (cualquier lenguaje)

Una CLI también es una interfaz, y las mismas puertas aplican:

- Jerarquía visual con color, pero **solo si la salida es un TTY**. Detectá `NO_COLOR`,
  `TERM=dumb` y salida redirigida a archivo o pipe.
- Barra de progreso solo en operaciones de más de un segundo, y a stderr, para que stdout
  siga siendo canalizable.
- Un modo `--json` o `--quiet` para uso en scripts. Una CLI bonita que no se puede
  automatizar es una CLI rota.
- Errores accionables: qué pasó, en qué archivo o entrada, y qué hacer. Nunca un stack
  trace crudo como salida principal.
- Librerías: Rich/Textual en Python, `clap` + `indicatif` en Rust, `commander` + `ora` en
  Node, `picocli` en Java, `cobra` + `lipgloss` en Go.

## Java, C#, PHP y backends que renderizan HTML

- Thymeleaf, Razor, Blade y JSP renderizan HTML: aplican tokens y reglas web sin cambios.
- Antes de meter React en un proyecto server-rendered, evaluá HTMX o Alpine.js: para
  formularios, tablas y paneles cubren casi todo con unos pocos KB y sin build.
- Autoescapado activado siempre en el motor de plantillas. Cada `th:utext`, `@Html.Raw`
  o `{!! !!}` es un XSS potencial y necesita justificación explícita.
