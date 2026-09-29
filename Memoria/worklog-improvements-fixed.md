---
name: worklog-improvements-fixed
description: "When adjusting/shifting worklog times, never move worklogs on Improvement (mejora) tickets; only move other activities"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 83a0fca5-f69b-4bf1-81e6-df98c67c2021
  modified: 2026-09-25T00:34:29.979Z
---

When reorganizing or shifting worklogs (time tracking) to fix overlaps or change the end of the day, Improvement-type tickets (TB "mejora", e.g. support/apoyo tasks) keep their original times; only move sub-tasks/features and other activities around them.

**Why:** Cristian corrected this on 2026-09-24 after I shifted TB-28/TB-29 worklogs; the improvement times reflect when the support actually happened.

**How to apply:** Treat improvement worklogs as fixed anchors; fit the other blocks around them. Always show a preview table and wait for confirmation before changing worklogs. See [[jira-rules]].
