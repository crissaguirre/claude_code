# Claude – memoria y skills

Bóveda de Obsidian y repo git con la memoria persistente y las skills de Claude Code.

- `Memoria/` — memoria automática de Claude (`autoMemoryDirectory`). `MEMORY.md` es el índice que se
  carga en cada sesión; cada nota es un hecho con frontmatter (`name`, `description`, `metadata.type`)
  y enlaces `[[...]]` entre notas.
- `Temas/` — notas hub por tema (estado actual + historial); empezar por `Temas/_indice.md`.
- `Diario/AAAA-MM-DD.md` — registro diario de lo trabajado con Claude.
- `Skills/<nombre>/SKILL.md` — skills personales, enlazadas en `~/.claude/skills/<nombre>`.

## Instalar en una PC nueva
```bash
git clone <url-del-repo> ~/WorkSpace/WorkSpaceObsidian/Claude
cd ~/WorkSpace/WorkSpaceObsidian/Claude && ./install.sh
```
Luego definir en `~/.zshrc` las variables que usan las skills (p.ej. `JIRA_BASE_URL`, `JIRA_CORREO`,
`JIRA_API_TOKEN`). Los secretos **nunca** se guardan en este repo.

## Uso diario
- `git pull` antes de empezar y `git add -A && git commit -m "..." && git push` al terminar
  (o el plugin *Obsidian Git* para hacerlo automático).
- Nueva skill: crear `Skills/<nombre>/SKILL.md` y volver a correr `./install.sh`.
