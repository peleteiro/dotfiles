---
name: project
description: The personal project standard — multi-agent layout (AGENTS.md + .agents), mise, guard-rails — and the skill templates distributed to projects. Reference for questions about the standard; for actions use /project-new, /project-update or /project-doctor.
allowed-tools: Read, Grep, Glob
---

# Project Standard

Single source of the personal project pattern. The action commands are thin
wrappers around this knowledge:

| Command | Purpose |
|---|---|
| `/project-new` | Scaffold a new project (workspace or single) |
| `/project-update` | Reconcile an existing project with the current standard |
| `/project-doctor` | Read-only diagnosis: report drifts, change nothing |

## The standard in one screen

- **Single source of truth**: `AGENTS.md` at the repo root; `CLAUDE.md` (and
  `GEMINI.md`) are symlinks to it.
- **Shared agent layer**: `.agents/rules/` (always-on rules), `.agents/skills/`
  (project skills; `.claude/skills` symlinks to it), `.agents/mcp/` (wrappers,
  zero secret at rest).
- **Mirrored configs**: `.claude/settings.json` + format hook,
  `.codex/config.toml` + execpolicy rules, `.antigravity/settings.json` —
  same permissions and guard-rails in three syntaxes.
- **Tasks**: mise, file-based, in `.config/mise/tasks/` (`check`, `lint`,
  `test`, `prepare` idempotent, `doctor`); lefthook for git hooks; `.tmp/`
  as the only scratch area.
- **Choices made at project start**: docs/commits language, stack, formatter
  (oxfmt + oxlint; Prettier only with Astro), infra (`sysadmin` folder or
  repo).

## Templates (`templates/` in this skill)

Per-project skills copied by `/project-new` (per stack) and reconciled by
`/project-update`. Each project evolves its own copy. Template files are
named `SKILL.template.md` so no tool loads them as live skills (Codex scans
skill dirs recursively) — rename to `SKILL.md` when copying into a project.

| Template | Copy when |
|---|---|
| `commit`, `check`, `fix`, `prep`, `new-task`, `new-test`, `env`, `docs`, `pre-pr`, `deps-upgrade` | Always |
| `typescript`, `bash` | By language (others may be added later) |
| `error`, `observability` | Projects with application code |
| `frontend` | Project has a UI (shadcn on Base UI, a11y, perf) |
| `hatchet` | Project has background jobs |
| `llm` | Project calls LLMs (model-agnostic wiring) |
| `db-migrate` | Project has a database |
| `debug-prod` | Project has a production environment |
| `sysadmin` | Project has infra |
| `mcp-setup` | Project uses MCP servers |

Precedence: the project's copy always wins over anything global. Domain
skills (tenant, cache, scene-id…) belong to each project and have no
template here.

## Model repos

`~/Projects/biblebox` (multi-repo workspace) and `~/Projects/protocolo`
(single monorepo) are live references of the standard.
