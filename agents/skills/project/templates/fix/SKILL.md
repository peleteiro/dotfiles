---
name: fix
description: Automatically fixes formatting and lint issues via mise run lint, and resolves the rest manually without silencing errors
allowed-tools: Bash, Read, Edit
user-invocable: true
---

# Fix Quality Issues

Global skill — if the repo has its own `fix` skill, it wins.

Apply the automatic fixes:

```bash
mise run lint
```

Typically runs the formatter and the linter with `--fix` (in TS projects:
oxfmt + oxlint; projects with Astro use Prettier, since oxfmt doesn't
support `.astro` yet).

Then:

1. Run `mise run check` to see what's left.
2. Type errors and non-autofixable lint errors require manual fixes — resolve
   them one by one, respecting the project's conventions.
3. **Never silence an error** with `any`, `// @ts-ignore`, `#noqa`, `nolint`
   or equivalent — fix the cause.
4. Report how many files were modified and what remains.
