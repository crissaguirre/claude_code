---
name: diario-y-memoria-automatica
description: "En toda conversación registrar el diario, consolidar por temas en Claude/Temas y guardar hechos en Memoria/, minimizando tokens; buscar contexto primero en Temas/_indice.md."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2fa310d5-9378-4152-a23c-d36c866eff26
  modified: 2026-09-29T20:03:31.713Z
---

Desde el 2026-09-29, en cualquier conversación y proyecto (trabajo y personal), Claude mantiene tres capas en `~/WorkSpace/WorkSpaceObsidian/Claude`, por iniciativa propia:

1. **Diario:** `Diario/AAAA-MM-DD.md`, con las secciones Hecho, Decisiones, Pendientes y Enlaces. Añadir al terminar cada tarea relevante. Si la nota del día ya existe, agregar al final.
2. **Temas:** `Temas/<tema>.md`, una nota hub por tema (proyecto, sistema, área personal) con Estado actual, datos clave, enlaces a la memoria e Historial (una línea por diario, `[[AAAA-MM-DD]]`). Al escribir en el diario, actualizar también el tema correspondiente: el Estado actual se reescribe para que siempre esté vigente, no se acumula. Si aparece un tema nuevo, crear su nota y añadirla a `Temas/_indice.md`.
3. **Memoria:** `Memoria/`, con hechos atómicos y duraderos (reglas, preferencias, feedback) enlazados con [[...]].

**Buscar contexto:** para saber algo, primero leer `Temas/_indice.md` y luego la nota del tema. Solo si hace falta el detalle, bajar a los diarios. No explorar todo desde cero.

**Why:** Cristian quiere que el conocimiento se acumule y se agrupe solo, que cualquier información esté en un archivo concreto y que cada sesión cueste menos tokens.

**How to apply (tokens):**
- `MEMORY.md` se carga siempre, así que debe ser corto: una línea por nota. Los temas y los diarios no van ahí.
- Las notas deben ser breves. Actualizar o fusionar antes de crear una nueva, y borrar lo obsoleto. No duplicar lo que ya está en un CLAUDE.md o en el código; enlazar la ruta.
- Guardar lo que evita redescubrir cosas: rutas, IDs, comandos que funcionaron, decisiones y su porqué.
- Consolidación periódica: si pasaron más de 7 días desde la última (ver `consolidado:` en el índice), o si Cristian lo pide, repasar los diarios recientes, actualizar los temas y podar la memoria.

Relacionado: [[memoria-en-obsidian]], [[criss-prefers-free-local-options]], [[sistema-memoria-claude]].
