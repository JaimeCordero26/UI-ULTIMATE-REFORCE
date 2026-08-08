---
description: Aplica un arquetipo de estilo (bento, glass, minimal, brutalism, aurora…)
argument-hint: <arquetipo> [pantalla/componente]
---

Usá la skill **ui-ultimate-reforce** para aplicar un lenguaje visual completo. Leé
`references/style-systems.md`.

Arquetipo y alcance: $ARGUMENTS

1. Identificá el arquetipo pedido (minimalismo/editorial, bento grid, glassmorphism,
   neumorphism, claymorphism, brutalism/neo-brutalism, aurora/gradient mesh, dark developer).
   Si el usuario no nombró uno, recomendá el más adecuado al producto y confirmá.
2. Aplicalo sobre `assets/tokens.css` cambiando `--accent-h` y las pocas variables que pide
   la firma del arquetipo. No instales librerías: todos se construyen con CSS.
3. **Un arquetipo por proyecto**, consistente. Respetá su trampa documentada (p. ej. glass y
   neumorphism rompen contraste fácil: la accesibilidad manda sobre el estilo).
4. Verificá contraste 4.5:1 y estados completos antes de cerrar.
