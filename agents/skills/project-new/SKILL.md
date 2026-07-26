---
name: project-new
description: Scaffolds a new project with the full personal standard — multi-agent layout (AGENTS.md + .agents), mise, lefthook, guard-rails — in both formats, multi-repo workspace or single project
argument-hint: [name] [workspace|single]
allowed-tools: Read, Write, Bash, Glob, Grep
user-invocable: true
disable-model-invocation: true
---

# New Project — personal standard scaffold

The project's convention skills come from the **`project` skill templates**:
`~/Projects/dotfiles/agents/skills/project/templates/` (commit, check,
fix, prep, new-task, new-test, env, typescript, bash, error, observability,
docs, frontend, hatchet, sysadmin, mcp-setup — see the `project` skill for
the copy-when table). Model repos to consult for structure:
`~/Projects/biblebox` (multi-repo workspace) and `~/Projects/protocolo`
(single monorepo). For an **existing** project use `/project-update`
(applies the standard) or `/project-doctor` (read-only diagnosis).

## Step 0 — Decisions (ask if not in the request)

1. **Type**: `workspace` (directory with several sibling git repos,
   biblebox style) or `single` (one repo — simple or pnpm monorepo).
2. **Docs and commits language** (pt-BR or en) — applies to the whole
   project and is recorded in the AGENTS.md.
3. **Stack**: default TypeScript (pnpm); everyday alternatives: Dart/
   Flutter, Go, Rust, Python (uv/ruff).
4. **Formatter**: oxfmt + oxlint; **if there is Astro, Prettier** instead of
   oxfmt (no `.astro` support yet).
5. **Infra?** If yes: `sysadmin` as a folder (single) or sibling repo
   (workspace) — `sysadmin` skill.
6. **UI/frontend?** If yes: copy the `frontend` template and scaffold
   components with the shadcn CLI on **Base UI** (its default since
   Jul 2026 — never pass `-b radix` in new projects). Then ask two
   sub-questions:
   - **Shared ui-kit?** If more than one app will share components, create
     a `packages/ui` kit (tokens + shadcn components live there once; apps
     only consume — no per-app component forks).
   - **Admin app?** Admin UI follows a different standard than the public
     product UI (density and productivity over wow factor — see the
     `frontend` template). Scaffold it as its own app (`apps/admin`)
     consuming the ui-kit.

## Step 1 — Repo base

```
git init (branch main; working branches: feature/* fix/* hotfix/*)
mise.toml            # toolchain (node, pnpm, go…) — versions, not tasks
.config/mise/tasks/  # check, lint, test, prepare, doctor (file-based!)
lefthook.yml         # pre-commit: lint staged; commit-msg: conventional
.gitignore           # includes .tmp/ and mise.local.toml
.tmp/                # the only place for agent scratch
```

- Tasks follow the `new-task` skill; `prepare` **idempotent**; `doctor`
  validates the environment (companion of the `prep` skill).
- Node projects: `pnpm-workspace.yaml` if monorepo; **never** `scripts` in
  `package.json`.

## Step 2 — Agents layer (single source + mirrors)

```
AGENTS.md                      # single source of truth
CLAUDE.md -> AGENTS.md         # symlink (same for GEMINI.md if used)
.agents/
├── rules/                     # 001-golden-rule, 002-no-destructive,
│                              # 003-language, 004-mise-only (trigger: always_on)
├── skills/                    # copied from the templates per stack —
│                              # rename each SKILL.template.md → SKILL.md
│                              # when copying (templates are inert on purpose)
│                              # (commit/check/fix/prep/new-task always;
│                              # typescript/bash by language; hatchet only
│                              # if there are jobs; sysadmin only if there is infra)
│                              # + domain skills created later
└── mcp/                       # MCP wrappers (mcp-setup template)
.claude/
├── settings.json              # permissions + PostToolUse hook format.sh
├── hooks/format.sh            # formats+lints only the edited file; exit 2 returns the error to the model
└── skills -> ../.agents/skills   # symlink
.codex/
├── config.toml                # sandbox workspace-write + MCP + hooks
└── rules/default.rules        # execpolicy (brute-force deny)
.antigravity/settings.json     # equivalent permissions
```

- Copy the rules/configs from a model repo and adjust names — the
  guard-rails (deny of `rm -rf`, force-push, `--no-verify`,
  `docker system prune`, `tofu apply`) must exist **in all three syntaxes**.
- `003-language`: record here the Step 0 choice (docs+commits).
- `format.sh`: oxfmt+oxlint on the edited file (Prettier if Astro).
- `includeCoAuthoredBy: false` and no AI attribution in commits.

## Step 3 — Minimal AGENTS.md

Sections: what the project is · golden rules (linking `.agents/rules/`) ·
stack and territory map · how to run (`mise run …`, `tilt up`) · tests
(Bug = Test, `new-test` skill) · code conventions (`typescript`, `error`,
`observability` skills) · docs/commits language.

## Step 4 — Type-specific

**workspace**: create the parent directory with the sibling repos; replicate
Steps 1–3 in each repo; in the `.claude/settings.json` files, use
`additionalDirectories` pointing to the relevant siblings; prod deploy
centralized in the `sysadmin` repo.

**single**: everything at the root; if monorepo, per-module tasks in
`<module>/.config/mise/tasks/` (`mise run //module:task`); `sysadmin/` as a
folder when there is infra.

## Step 5 — Dev environment

- `Tiltfile` + docker-compose for local dependencies (Postgres, Mailpit,
  Hatchet…): `mise run dev` → `tilt up`.
- Env: `mise.toml` (defaults) + `mise.local.toml` (personal, gitignored) —
  never `.env` (`env` skill).
- Asynchronous jobs, if any: self-hosted Hatchet (`hatchet` skill).

## Step 6 — Final verification

- [ ] `mise run check`, `test` and `doctor` pass in the freshly created repo.
- [ ] `prepare` run twice without error (idempotency).
- [ ] Claude/Codex/Antigravity see the AGENTS.md and the skills
      (`CLAUDE.md` symlink ok, `.claude/skills` symlink ok).
- [ ] No secret in a versioned file (`gitleaks` via lefthook).
- [ ] README with installation and commands.
