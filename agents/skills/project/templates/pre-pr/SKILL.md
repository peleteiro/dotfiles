---
name: pre-pr
description: Executable checklist before opening a PR — quality, tests, docs, instrumentation and secrets, in one pass
allowed-tools: Read, Bash, Grep, Glob
user-invocable: true
---

# Pre-PR Checklist

Run before opening (or asking to open) a pull request. Fix what fails;
re-run until clean.

## 1. Quality gates

```bash
mise run check   # format + lint + types, no changes
mise run test    # full suite
```

Both must pass — no skipped/blind-disabled tests, no lint silenced with
`any`/`@ts-ignore`/equivalent.

## 2. Diff review

```bash
git diff origin/<base>...HEAD
```

- **No secrets** in the diff (run `/security-check` when in doubt).
- No leftover debug code, `console.log`, commented-out blocks or stray
  `.only` in tests.
- New I/O code is instrumented (tracing/logging per the `observability`
  skill); new predictable errors use the Result pattern.
- DB changes: migration present + regenerated types committed together.

## 3. Docs and housekeeping

- README/docs updated **in this PR** if usage, commands or structure
  changed.
- Commits follow the project convention (language, gitmoji or not) — check
  `git log` on the branch.
- Branch named per convention (`feature/*`, `fix/*`, `hotfix/*`).

## 4. Open the PR

Only when the user asks. Describe **why** over **what**, link the
issue/spec, and call out anything reviewers must decide (divergences,
follow-ups). Never push or open the PR on your own initiative.
