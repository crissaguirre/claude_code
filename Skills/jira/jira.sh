#!/usr/bin/env bash
# Consultas de SOLO LECTURA a Jira con salida compacta (ahorra tokens).
# Uso: jira.sh <comando> [args]   — ver `jira.sh help`
set -euo pipefail

: "${JIRA_BASE_URL:?falta JIRA_BASE_URL}" "${JIRA_CORREO:?falta JIRA_CORREO}" "${JIRA_API_TOKEN:?falta JIRA_API_TOKEN}"
ME="712020:4f1142aa-328d-4688-adcd-6957400d0013"
ABIERTOS='status NOT IN (Resuelto, Closed, Canceled, Completed, "En Delivery", Done, "Rollback Realizado")'

get()  { curl -sS -f -u "$JIRA_CORREO:$JIRA_API_TOKEN" -H 'Accept: application/json' "$JIRA_BASE_URL$1"; }
post() { curl -sS -f -u "$JIRA_CORREO:$JIRA_API_TOKEN" -H 'Accept: application/json' -H 'Content-Type: application/json' -X POST -d "$2" "$JIRA_BASE_URL$1"; }

# ADF -> texto plano (párrafos separados por salto de línea), recortado a N caracteres
ADF='def adf: if type=="object" then (if .type=="text" then .text elif .type=="hardBreak" then "\n" else ((.content//[])|map(adf)|join("")) + (if (.type|IN("paragraph","heading","listItem","codeBlock")) then "\n" else "" end) end) elif type=="array" then map(adf)|join("") else "" end;'

# Búsqueda JQL -> tabla: CLAVE | TIPO | ESTADO | ACTUALIZADO | RESUMEN
buscar() {
  local body
  body=$(jq -nc --arg j "$1" --argjson m "${2:-50}" '{jql:$j,maxResults:$m,fields:["summary","status","issuetype","updated"]}')
  post /rest/api/3/search/jql "$body" | jq -r '
    .issues[] | [.key, (.fields.issuetype.name|sub("\\[System\\] ";"")), .fields.status.name,
                 .fields.updated[0:10], .fields.summary] | join(" | ")'
}

cmd=${1:-help}; shift || true
case "$cmd" in
  pendientes) buscar "assignee = currentUser() AND $ABIERTOS ORDER BY updated DESC" ;;
  sprint)     buscar "assignee = currentUser() AND sprint in openSprints() ORDER BY status" ;;
  changes)    buscar "project = MDS AND issuetype = \"[System] Change\" AND assignee = currentUser() ORDER BY updated DESC" "${1:-15}" ;;
  reciente)   buscar "(assignee = currentUser() OR reporter = currentUser()) AND updated >= -${1:-7}d ORDER BY updated DESC" ;;
  jql)        buscar "$1" "${2:-50}" ;;

  ticket)  # resumen de un ticket: datos, descripción recortada, sub-tasks y últimos comentarios
    k=$1; n=${2:-3}
    get "/rest/api/3/issue/$k?fields=summary,status,issuetype,assignee,reporter,parent,subtasks,created,updated,duedate,description,comment,customfield_10125,customfield_10126" |
    jq -r --argjson n "$n" "$ADF"'
      .fields as $f |
      "\(.key) · \($f.issuetype.name) · \($f.status.name)\n\($f.summary)",
      "Asignado: \($f.assignee.displayName//"-") · Reporta: \($f.reporter.displayName//"-") · Creado: \($f.created[0:10]) · Act.: \($f.updated[0:10])" +
        (if $f.parent then " · Padre: \($f.parent.key)" else "" end) + (if $f.duedate then " · Vence: \($f.duedate)" else "" end),
      (if $f.customfield_10125 then "Ventana: \($f.customfield_10125[0:16]) → \(($f.customfield_10126//"")[0:16])" else empty end),
      (if $f.description then "\n# Descripción\n" + (($f.description|adf)[0:800]) else empty end),
      (if ($f.subtasks|length)>0 then "\n# Sub-tasks", ($f.subtasks[]|"- \(.key) · \(.fields.status.name) · \(.fields.summary)") else empty end),
      (if $f.comment.total>0 then "\n# Comentarios (\($f.comment.total), últimos \($n))",
        ($f.comment.comments[-$n:][]|"- \(.created[0:16]) \(.author.displayName): " + ((.body|adf|gsub("\n+";" "))[0:400])) else empty end)'
    ;;

  comentarios)  # todos los comentarios completos de un ticket
    get "/rest/api/3/issue/$1/comment?maxResults=100" |
    jq -r "$ADF"'.comments[] | "## \(.created[0:16]) · \(.author.displayName)\n\(.body|adf)"' ;;

  worklogs)  # mis worklogs de un día (por defecto hoy): CLAVE | INICIO | HORAS | RESUMEN
    d=${1:-$(date +%F)}
    body=$(jq -nc --arg j "worklogAuthor = currentUser() AND worklogDate = \"$d\"" '{jql:$j,maxResults:100,fields:["summary"]}')
    post /rest/api/3/search/jql "$body" | jq -r '.issues[] | "\(.key)\t\(.fields.summary)"' |
    while IFS=$'\t' read -r k s; do
      get "/rest/api/3/issue/$k/worklog?maxResults=200" |
      jq -r --arg d "$d" --arg me "$ME" --arg k "$k" --arg s "$s" '
        .worklogs[] | select(.author.accountId==$me and (.started|startswith($d))) |
        [.started[11:16], $k, ((.timeSpentSeconds/3600*100|round)/100|tostring)+"h", .id, $s] | join(" | ")'
    done | sort ;;

  get)  # GET libre + filtro jq opcional: jira.sh get /rest/api/3/myself '.displayName'
    get "$1" | jq -r "${2:-.}" ;;

  *) cat <<'EOF'
jira.sh pendientes            mis tickets realmente abiertos
jira.sh sprint                mis tickets del sprint activo
jira.sh changes [n]           mis Changes MDS (por defecto 15)
jira.sh reciente [dias]       actividad reciente (por defecto 7)
jira.sh jql "<JQL>" [max]     búsqueda libre, salida en tabla
jira.sh ticket KEY [n]        resumen + sub-tasks + últimos n comentarios
jira.sh comentarios KEY       comentarios completos
jira.sh worklogs [AAAA-MM-DD] mis worklogs del día (hora | clave | horas | id | resumen)
jira.sh get <ruta> [filtro]   GET libre con filtro jq
EOF
  ;;
esac
