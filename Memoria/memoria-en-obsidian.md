---
name: memoria-en-obsidian
description: La memoria es una bóveda Obsidian global compartida por todos los proyectos; enlazar notas con [[...]] para formar el grafo.
metadata:
  type: feedback
---

Desde el 2026-09-29 toda la memoria vive en una sola bóveda Obsidian (~/WorkSpace/WorkSpaceObsidian/Claude/Memoria, vía `autoMemoryDirectory` en ~/.claude/settings.json), no por proyecto.

**Why:** Cristian quiere que todo el conocimiento (Pangea, WFM, OpenClaw, personal) esté en un solo lugar, relacionado entre sí y visible en Obsidian.

**How to apply:** Indicar en cada nota a qué proyecto o contexto pertenece, porque se carga en todos los proyectos. Enlazar siempre con [[nombre]] las notas relacionadas: tickets, flujos, microservicios, personas y reglas. Las skills viven en Claude/Skills (enlazadas a ~/.claude/skills por install.sh) y todo el repo se sincroniza con GitHub. Ver [[jira-rules]] y [[no-destructive-actions-without-asking]].
