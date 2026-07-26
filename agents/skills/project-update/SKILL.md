---
name: project-update
description: Updates an existing project with the improvements of the personal standard — reconciles skills with the dotfiles templates, fixes config drifts (hooks, symlinks, guard-rails) and flags divergences. Run at the project root.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
user-invocable: true
disable-model-invocation: true
---

# Update Project to the Current Standard

Companion of `/project-new`: applies to an **existing** project what has
evolved in the templates
(`~/Projects/dotfiles/agents/skills/project/templates/`) and in the scaffold
standard. For a report without changes, use `/project-doctor`. Never overwrites blindly — the project may
have deliberate adaptations.

## 1. Skills inventory and diff

For each template in `~/Projects/dotfiles/agents/skills/project/templates/`:

- Does it exist in the project's `.agents/skills/<name>`? Compare
  (`diff -u`).
- **Template improvement** (new rule, fix) → apply it to the project's
  copy, adapting local names/paths.
- **Deliberate local adaptation** (domain rule, different stack) →
  preserve; note it in the final report.
- Template missing from the project and relevant to the stack → propose
  copying it.
- Project skill with no corresponding template → it is domain-specific; do
  not touch it.

## 2. Known config drifts (checklist)

- [ ] `CLAUDE.md` is a symlink → `AGENTS.md` (and `GEMINI.md`, if it
      exists).
- [ ] `.claude/skills` is a symlink → `../.agents/skills`.
- [ ] **Consistent formatter**: oxfmt + oxlint; Prettier **only** if the
      project has Astro. Check `.claude/hooks/format.sh` and
      `.codex/hooks/*` — a hook calling Prettier in an oxfmt-only repo is
      leftover baggage to fix.
- [ ] Anti-destructive guard-rails present **in all three syntaxes**
      (`.claude/settings.json` deny, `.codex/rules/default.rules`,
      `.antigravity/settings.json`).
- [ ] `.agents/rules/` with the base rules (golden-rule, no-destructive,
      language, mise-only) up to date.
- [ ] Tasks: `prepare` **idempotent** and a `doctor` task present
      (companion of the `prep` skill).
- [ ] `lefthook.yml` with pre-commit (lint staged) and commit-msg
      (conventional).
- [ ] `.tmp/` in `.gitignore`; `mise.local.toml` ignored.
- [ ] `includeCoAuthoredBy: false` (no AI attribution in commits).

## 3. Divergent conventions → make explicit, do not "fix"

Detect divergences between the project and the personal standard (e.g.
commits without gitmoji, docs in English) via history/docs:

- If it is a project choice, **record it explicitly in its AGENTS.md**
  ("commits without emoji", "docs in English") so no agent "fixes" it to
  the wrong standard later.
- Standing-legacy stacks get the same treatment: shadcn on **Radix**
  (`@radix-ui/*` in package.json — current standard is Base UI) or Inngest
  instead of Hatchet → record as standing legacy in the project's
  AGENTS.md; **never migrate on your own**.
- If it is an accident/inconsistency, align it to the personal standard and
  note it.
- When in doubt, ask the user — never rewrite an established convention on
  your own.

## 4. Security

- Run `gitleaks` (or the repo's check) and **report** any versioned
  secret — removal/rotation is the user's decision, not automatic.
- Check MCP configs: no token at rest (`mcp-setup` skill in the
  templates).

## 5. Report and commit

Finish with a summary: what was updated, what was preserved as a local
adaptation, divergences recorded and pending items (secrets, decisions).
**Do not commit** — present the diff and leave the commit for the user to
request.
