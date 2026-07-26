# AI Agent Collection

Personal collection of agent skills and global instructions, shared by
Claude Code, Codex CLI, Antigravity and any tool following the
[agents.md](https://agents.md/) standard. Lives in [`agents/`](../agents)
and is installed by `./dotfiles apply:agents`.

## Layout

```
agents/
├── AGENTS.md                  # global instructions (all projects)
└── skills/                    # GLOBAL skills — meta only
    ├── project/               # the project standard (knowledge hub)
    │   ├── SKILL.md
    │   └── templates/         # 21 per-project skill templates
    │       ├── commit/ check/ fix/ prep/ …
    │       └── frontend/ hatchet/ llm/ sysadmin/ …
    ├── project-new/           # /project-new  — scaffold a new project
    ├── project-update/        # /project-update — reconcile an existing one
    ├── project-doctor/        # /project-doctor — read-only diagnosis
    ├── new-skill/             # /new-skill — create a skill anywhere
    └── security-check/        # /security-check — secret sweep, any repo
```

## The three scopes

| Scope | Lives in | Reaches projects by |
|---|---|---|
| **Global** | `agents/skills/` | Symlinked everywhere; meta-skills only |
| **Template** | `agents/skills/project/templates/` | Copied by `/project-new`, reconciled by `/project-update` |
| **Project** | each repo's `.agents/skills/` | Committed in the project; evolves there |

Precedence: **project beats template beats global**. Conventions (commit
style, TypeScript rules, infra…) are templates — each project owns its
copy. Only skills that operate *on* projects stay global.

Template files are named `SKILL.template.md` on purpose: Codex discovers
skills recursively, so a real `SKILL.md` inside `templates/` would load as
a live global skill. The scaffold commands rename the file to `SKILL.md`
when copying it into a project.

## Installation targets

`./dotfiles apply:agents` (also part of `./dotfiles apply`) symlinks each
global skill and the instructions file:

| What | Destinations |
|---|---|
| Each `agents/skills/<name>/` | `~/.claude/skills/`, `~/.codex/skills/`, `~/.agents/skills/`, `~/.gemini/config/skills/` |
| `agents/AGENTS.md` | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.gemini/AGENTS.md` |

Notes:

- `~/.gemini/config/skills/` is the only global location read by all three
  Antigravity products (IDE, CLI, AGY).
- The installer never overwrites a real file — anything that exists and is
  not a symlink is skipped with a warning.
- Stale links (skill removed/renamed here) are pruned on the next apply.
- Because these are symlinks, edits in the repo are live immediately — no
  re-apply needed except when adding/removing/renaming a skill.

## Iterating

- Edit a skill → it is live everywhere at once.
- `mise run skills:check` validates the collection (frontmatter, folder
  names, broken references); it also runs standalone in `mise run lint`
  reviews.
- New skill? Use `/new-skill` — it knows the three scopes and where each
  belongs.
- Template improved? Projects pick it up on their next `/project-update`;
  `/project-doctor` reports the drift without touching anything.

## Language policy

Everything in this collection (and this repo) is written in **English** —
it is agent-facing content. Chat replies to the user stay in pt-BR, and
each project chooses its own docs/commits language at creation time
(recorded in that project's AGENTS.md).
