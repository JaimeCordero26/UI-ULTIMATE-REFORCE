# Arquitectura frontend (cómo se organiza, no solo cómo se ve)

Una UI que se ve bien y está armada en un solo componente de 800 líneas se rompe apenas
alguien la toca. Esta referencia es la capa de **estructura**: cómo dividir en capas para
que agregar una pantalla no obligue a reescribir las anteriores.

## Las cuatro capas (de abajo hacia arriba)

1. **Tokens** — color, tipografía, espaciado, radios, sombras (`design-tokens.md`,
   `assets/tokens.css`). No tienen opinión de layout ni de componente.
2. **Primitivos** — Button, Input, Card, Badge. Un solo propósito, sin lógica de negocio,
   estilizados 100% con tokens. Se testean y se documentan solos.
3. **Patrones** — combinaciones con estado propio: Formulario de login, Tabla con filtros,
   Modal de confirmación. Usan primitivos, no los reinventan.
4. **Pantallas** — componen patrones con datos reales y rutas. Casi no tienen estilo propio;
   si una pantalla necesita CSS a medida seguido, falta un patrón por nombrar.

Regla de dependencia: cada capa solo puede importar de la capa de abajo. Una pantalla que
importa directo un token hardcodeado, o un primitivo que importa un patrón, es la señal de
que la arquitectura se está mezclando.

## Composición sobre configuración

Un componente con 14 props booleanas (`isLarge`, `hasIcon`, `isOutlined`, `noBorder`…) es
más difícil de mantener que uno que se arma por composición:

```jsx
// evitar: explosión de props
<Button large outlined noShadow iconLeft="check" iconOnly={false} />

// preferir: composición, cada slot es explícito
<Button variant="outline" size="lg">
  <Icon name="check" /> Guardar
</Button>
```

Señal de alarma: un componente con más de ~6 props booleanas, o props que se contradicen
entre sí (`fullWidth` + `size="sm"` centrado, ¿qué gana?). Ahí conviene partir en variantes
con un solo prop `variant`/`size` en vez de flags sueltos.

## CSS: elegí una estrategia y no la mezcles

| Estrategia | Cuándo | Riesgo si se mezcla con otra |
|---|---|---|
| Utility-first (Tailwind) | Prototipo rápido, equipo chico, design system con tokens ya definidos | Clases interminables en JSX si no se extraen componentes |
| CSS Modules / vanilla-extract | Componentes con estilos complejos, tipado de tokens | Ninguno grave; conviven bien con utilities para layout |
| CSS-in-JS en runtime (styled-components clásico) | Casos legacy | Costo en runtime y bundle; hoy hay mejores opciones (vanilla-extract, Panda CSS) |

No mezcles tres estrategias en el mismo proyecto "porque cada una es mejor para algo": el
costo cognitivo de adivinar dónde está un estilo supera la ganancia.

## Responsive: mobile-first y container queries

- Escribí el CSS base para 360 px y agregá `min-width` hacia arriba, nunca al revés.
- Usá **container queries** (`@container`) para componentes que se reusan en columnas de
  ancho variable (una card en sidebar vs. en grid principal); un media query global no sabe
  en qué contenedor está el componente.
- Un layout no necesita más de 3 breakpoints reales (móvil, tablet, desktop). Más que eso
  suele ser síntoma de que el diseño no tiene un sistema de grilla consistente.

## Estado de servidor vs. estado de UI

No mezclés datos que vienen del servidor (lista de usuarios, perfil) con estado que es puro
de la interfaz (modal abierto, tab activa, orden de una tabla en pantalla). Herramientas de
data-fetching (React Query, SWR, TanStack Query) resuelven cache/revalidación; no las uses
para guardar si un dropdown está abierto. Mezclar ambos produce bugs de sincronización que
no tienen que ver con el diseño pero que el usuario percibe como "la UI se rompió".

## Antes de escribir el primer componente

1. ¿Existe ya un primitivo para esto en el proyecto? Buscá antes de crear.
2. ¿Esta pantalla necesita un patrón nuevo, o es composición de patrones existentes?
3. ¿El nombre describe el rol (`PriceTag`) o la implementación (`BoldRedText`)? Lo segundo
   se vuelve mentira apenas cambia el estilo.
