---
name: project-doctor
description: Read-only diagnosis of a project against the personal standard — reports drifts, divergences and risks without changing anything. Run at the project root.
allowed-tools: Read, Bash, Glob, Grep
user-invocable: true
disable-model-invocation: true
---

# Project Doctor

Read-only counterpart of `/project-update`: runs the same inspection but
**changes nothing** — it only reports. Use it to assess a project before
deciding to update.

## What to check

1. **Skills vs templates** — for each template in
   `~/Projects/dotfiles/agents/skills/project/templates/`, diff the
   project's copy in `.agents/skills/`: up to date, locally adapted, or
   missing (and relevant to the stack)?
2. **Config drifts** — the `/project-update` checklist, evaluated only:
   - `CLAUDE.md` → `AGENTS.md` symlink; `.claude/skills` → `../.agents/skills`.
   - Formatter coherence (oxfmt/oxlint; Prettier only with Astro) in the
     format hooks.
   - Guard-rails present in the three syntaxes (Claude deny, Codex
     execpolicy, Antigravity permissions).
   - `.agents/rules/` base rules present and current.
   - `prepare` idempotent + `doctor` task; lefthook; `.tmp/` gitignored;
     `includeCoAuthoredBy: false`.
3. **Convention divergences** — commit style (gitmoji or not), docs
   language, standing-legacy stacks (shadcn on Radix — `@radix-ui/*` in
   package.json; Inngest instead of Hatchet): are they explicit in the
   project's AGENTS.md or implicit (risk of an agent "fixing" or
   "migrating" them wrongly)?
4. **Security** — `gitleaks` (or the repo's check) for versioned secrets;
   MCP configs with no token at rest.
5. **Environment** — `mise run doctor` (if the task exists) and whether
   `mise run check`/`test` pass.

## Output

A single report, grouped by severity:

- 🔴 **Broken/risky** — secrets in git, missing guard-rails, broken symlinks.
- 🟡 **Drift** — outdated skills vs template, wrong formatter in hook,
  missing doctor task.
- 🔵 **Implicit conventions** — divergences that should be recorded in the
  project's AGENTS.md.

End with the suggestion: run `/project-update` to apply fixes (nothing is
changed by this command).
