<!--
TEMPLATE: a path-scoped rule. Place at .claude/rules/<name>.md
The `paths:` frontmatter scopes this rule so it only loads when the agent works
on matching files. This keeps each agent focused: backend rules never pollute
frontend work, and vice versa.

Replace the globs and the body with rules for one specific area of your repo
(for example: the web UI, the data layer, a particular package, generated code).

Cursor equivalent: a .cursor/rules/<name>.mdc file with `globs:` instead of
`paths:` and a `description:` line for agent-requested activation.
-->

---
paths:
  - "src/<area>/**/*.<ext>"
---

# <Area> Rules

- <A convention that applies only to files under this path>
- <A library or pattern to prefer here>
- <A pattern to avoid here, and what to use instead>
