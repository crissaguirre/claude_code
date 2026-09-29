---
name: no-destructive-actions-without-asking
description: "Criss prohibits deleting files, committing/pushing, and installing anything without his explicit request."
metadata:
  node_type: memory
  type: feedback
  originSessionId: a2a3feb3-dde3-40b4-9142-83c294a85b11
  modified: 2026-09-29T17:02:33.597Z
---

Criss set explicit limits on 2026-09-29: never delete files, never make git commits or
pushes, never install or uninstall anything (packages, plugins, skills, dependencies),
and never make strong changes (config outside the workspace, schedulers, services)
without confirming first — even when reversible.

**Why:** He is running OpenClaw with real access to his machine — terminal, files,
browser — and wants to keep the decision of what changes state. He is still learning
what the system can reach, so an agent acting on its own initiative erodes the trust
he is building. The rule is about authority, not about risk level: reversible changes
count too.

**How to apply:** Propose, explain the cost, and wait for a yes. Preparing changes is
fine; executing them is not. Reading is always fine — `git status`, `git diff`,
`git log`, file reads, exploration. When unsure whether something qualifies as a
"strong change", treat it as one. When he does ask for a deletion, use `trash`,
never `rm`. These rules live in the Red Lines section of the workspace `AGENTS.md`;
a contradicting line in its automations section was corrected. See also
[[criss-prefers-free-local-options]].
