---
name: jira
description: Consultar y gestionar el Jira de Pangeaco (pangeaco-group.atlassian.net) de Cristian Aguirre - tickets MDS/ITPR/TB, sprints, Changes, worklogs, comentarios. Usar siempre que pregunte por sus tickets, pendientes, sprint, pases a producción o quiera comentar/registrar trabajo en Jira, desde cualquier carpeta.
aliases: [skill-jira]
---

# Jira – Cristian Aguirre (Pangeaco)

## Reglas (obligatorias)
1. **Solo lectura por defecto.** No crear, editar, comentar, transicionar, asignar, registrar trabajo
   ni borrar nada en Jira a menos que Cristian lo pida explícitamente en ese momento. Consultar
   (GET/búsquedas JQL) sí está permitido sin preguntar. Una autorización aplica solo a lo que se
   pidió; no se extiende a otros tickets ni a acciones posteriores. Ante la duda, preguntar primero.
2. **Comentarios formales y detallados.** Todo comentario que se publique en Jira debe:
   - Estar en español, con redacción formal y profesional (sin coloquialismos ni emojis).
   - Ser detallado y autocontenido: contexto/objetivo, acciones realizadas, resultados o hallazgos,
     y próximos pasos o pendientes (con responsables y fechas si se conocen). Incluir componentes,
     flujos, microservicios, APIs o tickets relacionados cuando aplique.
   - Estructurarse con encabezados o viñetas en formato ADF para facilitar la lectura.
   - Mostrarse primero a Cristian como borrador y publicarse solo tras su aprobación.
3. **Worklogs:** al reajustar horarios, los tickets de mejora (Improvement TB) quedan fijos; mostrar
   tabla de vista previa y esperar confirmación antes de cambiar worklogs.

## Script de consultas (usar primero)
`~/.claude/skills/jira/jira.sh` es de solo lectura y da salida compacta. Usarlo antes que curl a mano:
`pendientes` · `sprint` · `changes [n]` · `reciente [dias]` · `jql "<JQL>" [max]` · `ticket KEY [n]` ·
`comentarios KEY` · `worklogs [AAAA-MM-DD]` · `get <ruta> [filtro-jq]`. Requiere las variables de `~/.zshrc`.
Para escrituras (comentar, worklogs, transiciones) usar curl, siempre con autorización explícita.
Estado del trabajo en curso: `Temas/pangea-oss.md` de la bóveda Claude.

## Conexión
- Instancia: `$JIRA_BASE_URL` = https://pangeaco-group.atlassian.net (Jira Cloud)
- Auth básica: `curl -u "$JIRA_CORREO:$JIRA_API_TOKEN"` (el correo está en `JIRA_CORREO`, no en JIRA_EMAIL).
  Las variables se definen en `~/.zshrc` de cada PC; nunca van en este repo.
- Nunca imprimir ni guardar el valor de `JIRA_API_TOKEN`.
- Búsqueda: `POST /rest/api/3/search/jql` con body `{"jql": "...", "maxResults": 100, "fields": [...]}`
  (el antiguo `/rest/api/3/search` está deprecado).
- Tableros/sprints: `/rest/agile/1.0/board/{id}/sprint?state=active`
- Descripciones y comentarios en API v3 usan formato ADF (JSON), no texto plano.

## Usuario
- CRISTIAN WILSON AGUIRRE CALANCHO — cristian.aguirre@pangeaco.pe
- accountId: `712020:4f1142aa-328d-4688-adcd-6957400d0013`
- Grupos: Desarrollo, Torre - Desarrollo, Líder de torre, Operador Release, Proyecto OSS,
  Agentes_Pangeaco_ITSM, Proyectos_Pangeaco_ITSM
- Rol: desarrollador / líder técnico OSS (provisión FTTH/GPON/XGSPON). Trabaja con flujos Camunda
  (BPMN + DMN), microservicios D&A (Design & Assign), SOM, UX Nokia/ZTE, APIs TMF (621, 622, 645),
  PangIA, Operax/WFM.

## Proyectos donde trabaja
| Clave | Nombre | Tipo | Board | Líder |
|---|---|---|---|---|
| MDS | Mesa de servicio | Service desk (ITSM) | – | Nicolas Fuentes |
| ITPR98 | Integración Mi Fibra | Scrum | 440 | Hugo Fuentes |
| ITPR56 | Automatización mediante PangIA | Scrum | 361 | Hugo Fuentes |
| ITPR65 | FTTH: XGSPON | Scrum | 375 | Hugo Fuentes |
| ITPR66 | Modelo de Provisión 3 - ZaaZ | Scrum | 376 | Hugo Fuentes |
| ITPR74 | Modelo de Provisión 4 (MIFIBRA) | – | – | – |
| TB | Torre - Desarrollo | Scrum | 317 | Ulises Hernandez |

Hay 46 proyectos visibles en total (squads SDD, SMC, SNP, SZG, SZT, SZTR; INI; ITPR46–ITPR107; plantillas PK/PLSQ/PLT/PS).
Los proyectos ITPRxx son iniciativas; `ITPR` (board 168 "Proyectos ITPR") es el proyecto padre: las Features de ITPR98 tienen como padre `ITPR-98`.

## Flujos de estado
**Proyectos ITPRxx / TB (software):**
- Feature: Backlog → Levantamiento → En ejecución → En Pruebas → En Delivery (done) / Completed / Canceled
- Improvement (TB): Backlog → En ejecución → En Pruebas → En Delivery / Completed / Canceled
- Sub-task: Backlog → En ejecución → Completed / Canceled
- Issue: Backlog → En ejecución → En validación → Completed / Rechazado / Canceled

**MDS (Service desk):**
- [System] Change: ACK → Approval pending → In Progress → Resuelto → Closed
  (también Held, Reprogramación, En Rollback, Rollback Realizado/Finalizado, Canceled)
- [System] Incident: ACK → In Progress → Resuelto → Closed (Held, Canceled)
- Ojo: "Resuelto" está en la categoría *indeterminate*, NO done. `statusCategory != Done` incluye
  los Resuelto; para ver solo lo realmente abierto usar `status NOT IN (Resuelto, Closed, Canceled, "Rollback Realizado")`.
- "Rollback Realizado" es un estado FINAL en los Changes: no listarlo como pendiente.

## Convenciones observadas
- Cada Feature se divide en sub-tasks: levantamiento → cambios en flujos/microservicios → pruebas →
  "Elaboración de MOP, sustentación en comité de pases y programación del pase a producción" →
  "Ejecución del pase a producción, pruebas de validación y rollback en caso de falla".
- Cada pase a producción genera un `[System] Change` en MDS. Campos usados (MDS-1111 como ejemplo):
  - Nivel de Riesgo `customfield_10510` (p.ej. Riesgo Moderado)
  - Tipo Cambio `customfield_10504` (Programado) · Categoria `customfield_10505` (Proyecto)
  - Inicio/Fin de implementación `customfield_10125` / `customfield_10126` (ventana nocturna, -05:00)
  - Grupo resolutor `customfield_10353` (Proyecto OSS) · Severidad `customfield_10207` (Media)
  - ISP `customfield_10436` (PANGEACO) · Área/Gerencia Solicitante `customfield_10437` (O&M Red)
  - Con Afectación `customfield_10515` (Sin corte) · Monitoreo post ventana `customfield_10514`
  - Parada de transacciones `customfield_10516` · Componentes `customfield_10517` (OSS)
  - Operador release asignado `customfield_10857` · Líder(es) Técnico(s) `customfield_10933`
  - Approvers `customfield_10003`
- Sprints con nombre `Sprint N - Qx - YY - <Squad>` (Des, Data, Mejora), de dos semanas.
  El sprint activo se consulta en vivo (board 317 u otro) con el endpoint de sprints.
- Zona horaria: America/Lima (-05:00).

## JQL útiles
- Mis pendientes reales: `assignee = currentUser() AND status NOT IN (Resuelto, Closed, Canceled, Completed, "En Delivery", Done, "Rollback Realizado")`
- Mis Changes en MDS: `project = MDS AND issuetype = "[System] Change" AND assignee = currentUser() ORDER BY updated DESC`
- Mi sprint actual: `assignee = currentUser() AND sprint in openSprints()`
- Actividad reciente: `(assignee = currentUser() OR reporter = currentUser()) AND updated >= -7d ORDER BY updated DESC`
