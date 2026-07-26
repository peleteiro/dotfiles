---
name: new-skill
description: Creates a new agent skill in the SKILL.md format (open standard — Claude Code, Codex, Antigravity, agents.md), in the project or in the dotfiles global collection
argument-hint: [skill-name]
allowed-tools: Read, Write, Bash, Glob
user-invocable: true
disable-model-invocation: true
---

# Create New Skill

A skill is a folder with a `SKILL.md` (+ optional assets), in the open
format supported by Claude Code, Codex, Antigravity and the agents.md
standard.

## Where to create it

| Scope | Location |
|---|---|
| Project | `.agents/skills/<name>/SKILL.md` (with `.claude/skills` symlink → `../.agents/skills`) |
| Personal template | `~/Projects/dotfiles/agents/skills/project/templates/<name>/SKILL.template.md` — inert until `/project-new`//`/project-update` copy it into a project as `SKILL.md` |
| Global (personal) | `~/Projects/dotfiles/agents/skills/<name>/`, then `./dotfiles apply:agents` |

Global is only for meta-skills that operate **on** projects (project,
project-new, project-update, project-doctor, new-skill). Code/stack
conventions become a **template**; domain rules become a **project** skill.
Precedence: a project skill wins over a global one of the same name.

## Template

```markdown
---
name: kebab-case-name
description: What it does and WHEN to use it ("Use when...") — this is how the model decides to activate it
allowed-tools: Read, Grep        # only the tools the skill needs
---

# Title

Direct instructions, in the imperative, with paste-ready examples.
```

Optional frontmatter:

- `argument-hint: [arg]` — argument hint for manual invocation.
- `user-invocable: true` — becomes a `/name` command.
- `disable-model-invocation: true` — only the user invokes it (for action
  skills: commit, scaffold, deploy…).

## Best practices

1. **The description decides everything**: say what it does **and when to
   use it**; if it over-activates, add "Do not use for…".
2. **Short and dense**: the whole SKILL.md enters the context — 50–350
   lines. Long material goes to `references/*.md` (linked, loaded on
   demand) and scripts to `scripts/`.
3. **Real examples**: code that compiles/runs, extracted from real use,
   not pseudocode.
4. **One responsibility** per skill; a family of skills > an encyclopedia
   skill.
5. **Language**: personal collection skills (dotfiles) in English; project
   skills follow the project's language.
6. Third-party vendored skill: keep the `LICENSE.*` and an `UPSTREAM.md`
   with the source repo/commit and how to update.

## Final checklist

- [ ] `name` = folder name, kebab-case.
- [ ] The description answers "when should the model activate this?".
- [ ] Tested the invocation (`/name` or a natural request that matches the
      description).
- [ ] Global? Ran `./dotfiles apply:agents` and checked the symlink in the
      four destinations.
