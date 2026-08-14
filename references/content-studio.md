# Content studio (UX writing: el texto es interfaz)

Un formulario perfecto con un mensaje de error que dice "Error 400" no está terminado. El
texto de la UI (botones, errores, estados vacíos, confirmaciones) es tan parte del diseño
como el layout — y es la parte que más rápido delata una UI armada sin criterio.

## Botones: verbo + objeto, nunca genérico

```
mal:  "Enviar" / "OK" / "Aceptar" / "Sí"
bien: "Guardar cambios" / "Eliminar cuenta" / "Enviar mensaje"
```

El usuario que ve dos botones ("Cancelar" / "OK") en un modal de confirmación no sabe qué
hace "OK" sin leer el título completo. Cada botón describe **su propia acción**, así se
puede leer el par de botones solo, sin el contexto de arriba.

## Errores: qué pasó, por qué, qué hacer

Fórmula de tres partes, en lenguaje humano:

```
mal:  "Error 422: Unprocessable Entity"
bien: "No pudimos guardar el correo. El formato no es válido — probá con nombre@dominio.com"
```

- **Qué pasó**, sin código interno ni stack trace (eso va al log, no a la UI — ver
  `security.md` A09/A10).
- **Por qué**, si se sabe (formato inválido, ya existe, falta de permiso).
- **Qué hacer**, siempre que sea accionable. Si no hay acción posible del lado del usuario
  ("el servidor no responde"), decilo así y ofrecé reintentar, no lo disfraces de instrucción
  vacía ("intente más tarde" sin botón de reintentar).

## Placeholders no son labels

Un placeholder desaparece apenas el usuario escribe — en ese momento pierde la única pista
de qué campo es. El label va **siempre visible** (regla ya fijada en `SKILL.md`); el
placeholder, si se usa, es un ejemplo de formato (`ejemplo@dominio.com`), no la instrucción.

## Estados vacíos: no son un error

Una lista sin resultados todavía no es un fallo — es la primera impresión del usuario nuevo
o el resultado normal de un filtro estricto. Tres elementos mínimos:

1. Qué significa que esté vacío (¿todavía no hay datos? ¿el filtro no encontró nada?).
2. Una acción para salir del estado (crear el primero, limpiar filtros) cuando aplica.
3. Tono acorde: un "0 resultados" en un buscador es informativo; un "¡Todavía no tenés
   proyectos! Creá el primero 🚀" es para onboarding. No uses el tono de bienvenida para un
   filtro sin coincidencias.

## Confirmaciones: proporcional al costo de la acción

- Reversible y barata (archivar, dar like): sin confirmación, o con `undo` (ver
  `microinteractions.md`) — pedir confirmación acá es fricción, no cuidado.
- Irreversible o costosa (eliminar cuenta, cobrar, enviar a producción): confirmación
  explícita, y si es grave, que el usuario **escriba** el nombre del recurso o "eliminar"
  para confirmar, en vez de un solo click en un modal genérico.
- El texto de confirmación repite la consecuencia concreta ("Se eliminarán 34 archivos y no
  se pueden recuperar"), no una frase genérica ("¿Estás seguro?").

## Voz y tono: consistente, no uniforme

Voz = quién es el producto (formal/cercano, técnico/simple) y no cambia entre pantallas.
Tono = cómo se ajusta esa voz a la situación (un error de pago es serio aunque el producto
sea informal en el resto de la app). Definí la voz una vez; ajustá el tono por contexto de
riesgo, no por pantalla.

- Sentence case en botones y títulos de UI (más fácil de leer rápido que Title Case), salvo
  que el proyecto ya tenga otra convención — ahí manda la convención existente.
- Sin jerga interna ("payload", "entidad") en texto de cara al usuario final; sí puede
  quedar en logs y en UI de administración técnica.
- Segunda persona consistente ("tu cuenta", no mezclar con "su cuenta" en la misma app).

## Chequeo rápido

1. ¿Cada botón describe su propia acción sin necesitar el título de arriba?
2. ¿Los errores dicen qué pasó, por qué y qué hacer, sin código interno?
3. ¿Todo campo tiene label visible, no solo placeholder?
4. ¿La confirmación es proporcional al costo real de la acción?
