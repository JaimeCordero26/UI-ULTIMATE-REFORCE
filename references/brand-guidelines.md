# Guía de marca (cuándo mandan las reglas de otro, cuándo definirlas vos)

Regla ya fijada en `SKILL.md`: si el proyecto tiene tokens, paleta o design system propio,
**esa manda y esta skill se subordina**. Esta referencia detalla qué significa eso cuando
lo que existe es específicamente una guía de **marca** (logo, tono, uso de color con reglas
legales/corporativas), y qué hacer cuando no existe nada todavía.

## Si el proyecto ya tiene guía de marca

Buscá antes de asumir: `brand/`, `docs/brand*`, un PDF de guidelines, un archivo de Figma
enlazado, o simplemente el color/logo ya usados en el código existente. Si aparece:

- El color de marca **no se reinterpreta** para que "quede mejor" en dark mode sin criterio
  — se ajusta con `theme-factory.md` (bajar croma, no cambiar el matiz) manteniendo la
  identidad, y si la guía define un color específico para oscuro, ese gana.
- El logo tiene reglas que casi nunca son opcionales: **zona de resguardo** (espacio mínimo
  alrededor, típicamente igual a la altura de un elemento del propio isotipo), tamaño
  mínimo legible, y versiones fijas para fondo claro/oscuro/color — no se recolorea el logo
  para que combine con un tema si la guía no lo permite explícitamente.
- El tono de voz de la guía es el que aplica en `content-studio.md`, por encima del default
  de esta skill.
- Si algo en la guía choca con accesibilidad (contraste insuficiente del color de marca
  sobre el fondo que pide usar), avisalo en una línea — no lo cambies en silencio ni lo
  ignores en silencio. Es el mismo principio de la puerta de seguridad: se reporta, no se
  esconde.

## Si no existe ninguna guía todavía

No hace falta un documento de marca completo para tener consistencia. Lo mínimo viable:

1. **Un color primario** (el acento de `design-tokens.md`) y su justificación en una línea
   (qué transmite, por qué ese y no otro — sirve para no cambiarlo la próxima sesión sin
   querer).
2. **Reglas de logo básicas**, aunque el logo sea solo texto/wordmark: zona de resguardo
   mínima, y una sola combinación de color aprobada por fondo (claro/oscuro/foto).
3. **Tres adjetivos de tono** (por ejemplo: "directo, técnico, sin solemnidad") que
   funcionen como filtro rápido para `content-studio.md` — si un texto no encaja con los
   tres adjetivos, se reescribe.
4. Dejalo escrito en un archivo del proyecto (`brand.md` o dentro de `design-tokens.md`) la
   primera vez que se define, para que la próxima tarea no lo reinvente distinto.

## Errores comunes al aplicar marca a UI

- Usar el color de marca para **todo** (fondos, textos, iconos, bordes) en vez de como
  acento puntual — diluye la identidad en vez de reforzarla (ver regla de "un acento por
  pantalla" en `SKILL.md`).
- Poner el logo a color sobre un fondo del mismo color o de bajo contraste "porque combina"
  — si no se lee/distingue, no cumple su función.
- Tratar la tipografía de marca (si la guía define una) como negociable en la UI del
  producto cuando la guía la especifica para todo material, no solo para marketing.

## Chequeo rápido

1. ¿Existe una guía de marca en el proyecto? Si sí, ¿se está respetando color, logo y tono?
2. Si no existe, ¿quedó definido y escrito el mínimo (color, logo, tono) para la próxima vez?
3. ¿El logo respeta zona de resguardo y contraste, no solo "se ve" a simple vista?
4. ¿El color de marca funciona como acento, no como base de todo?
