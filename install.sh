#!/usr/bin/env bash
# Conecta este repo con Claude Code en la PC actual. Idempotente: se puede correr varias veces.
#  - Apunta autoMemoryDirectory (~/.claude/settings.json) a <repo>/Memoria
#  - Enlaza cada <repo>/Skills/<nombre> en ~/.claude/skills/<nombre>
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

command -v jq >/dev/null || { echo "Falta jq (instálalo y vuelve a correr)"; exit 1; }
mkdir -p "$CLAUDE_DIR/skills"

# 1. Memoria
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "$SETTINGS.bak"
tmp="$(mktemp)"
jq --arg dir "$REPO/Memoria" '.autoMemoryDirectory = $dir' "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"
echo "memoria  -> $REPO/Memoria (respaldo en settings.json.bak)"

# 2. Skills
for dir in "$REPO"/Skills/*/; do
  [ -f "$dir/SKILL.md" ] || continue
  name="$(basename "$dir")"
  link="$CLAUDE_DIR/skills/$name"
  if [ -L "$link" ]; then
    ln -sfn "${dir%/}" "$link"
    echo "skill    $name (enlace actualizado)"
  elif [ -e "$link" ]; then
    echo "OMITIDA  $name: ya existe $link y no es un enlace; revísalo a mano"
  else
    ln -s "${dir%/}" "$link"
    echo "skill    $name (enlazada)"
  fi
done

# 3. Enlaces rotos que apuntaban a skills borradas del repo
for link in "$CLAUDE_DIR"/skills/*; do
  if [ -L "$link" ] && [ ! -e "$link" ] && [[ "$(readlink "$link")" == "$REPO"/* ]]; then
    rm "$link" && echo "quitada  $(basename "$link") (ya no existe en el repo)"
  fi
done

echo "Listo. Abre una sesión nueva de Claude Code para que tome los cambios."
