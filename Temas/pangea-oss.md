---
tema: pangea-oss
actualizado: 2026-09-29
---
# Pangeaco OSS / Jira

## Estado actual
- Líder técnico OSS (provisión FTTH/GPON/XGSPON). El contexto completo de Jira (proyectos, flujos, campos, JQL y foto del trabajo) está en `~/WorkSpace/WorkSpacePangea/jira/CLAUDE.md`. No se duplica aquí.
- MOPs de pases en `~/WorkSpace/WorkSpacePangea/jira/mops/`.
- Consultas rápidas: `~/.claude/skills/jira/jira.sh` (`pendientes`, `ticket KEY`, `worklogs`…).

## Trabajo en curso (al 2026-09-29, verificar con `jira.sh pendientes`)
- **ITPR56-4** Feature · En ejecución: agregar servicios en ONTs offline u otros estados.
  - ITPR56-14 En ejecución: REFRESH_LINE excluye addVlan de la validación de estado operativo.
  - ITPR56-15 pruebas addVlan, -16 MOP/comité y -17 pase a producción, todas en Backlog.
- **ITPR98-5** (Hilos Cruzados, bottom-up): Completed. Pase ejecutado el 2026-09-28 (ITPR98-54).
- Changes cerrados recientes: MDS-1111 (trazabilidad PangIA), MDS-399 (bajas SOM), MDS-396 (Modelo de Provisión 5).
- **TB-35** Improvement · En ejecución: apoyo a Ademir en la revisión de casos de error MIF (2026-09-29, 30m).
- Backlog: ITPR56-2, -3 y -5 (alta/baja ISP y gestores, cambio de VLANs) e ITPR65-11 (XGSPON Nokia).
- MDS-209 y MDS-135 figuran en "Rollback Realizado" (siguen abiertos).

## Reglas
- [[jira-rules]]: solo lectura por defecto; comentarios formales tras aprobar el borrador.
- [[worklog-improvements-fixed]]: los worklogs de tickets de mejora no se mueven.

## Historial (diarios)
- [[2026-09-29]] TB-35 creado (errores MIF con Ademir); ITPR98-5 cerrado.
<!-- añadir: - [[AAAA-MM-DD]] resumen de una línea -->
