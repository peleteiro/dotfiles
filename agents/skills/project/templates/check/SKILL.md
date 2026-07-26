---
name: check
description: Runs the project's quality checks (format, lint, types) without changing anything, via mise run check
allowed-tools: Bash, Read
user-invocable: true
---

# Check Code Quality

Global skill — if the repo has its own `check` skill, it wins.

Run the full check **without making changes**:

```bash
mise run check
```

What runs depends on the project (typically: formatter in check mode, linter,
type checking; some repos add their own checks). If the task doesn't exist,
run `mise tasks` and use the equivalent one — never invent a direct lint
command if the repo has a task for it.

After running:

1. If there are errors, list them organized by type (formatting / lint /
   types).
2. Suggest `/fix` to automatically fix whatever is possible.
3. For errors that require manual fixes, explain how to resolve them.
