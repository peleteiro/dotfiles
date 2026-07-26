# Global Rules — Jose Peleteiro

Global instructions for AI agents (Claude Code, Codex, Antigravity and any
tool that follows the agents.md standard). They apply in **all** projects;
project rules (the repo's AGENTS.md) **take precedence** when they
conflict.

## 1. Golden rule

Always read the `AGENTS.md` at the repository root (and follow its links)
before working. If a local skill or rule exists with the same purpose as a
global one, the local one wins.

## 2. Language

- Reply to the user in **Brazilian Portuguese**, unless they write in
  another language.
- Documentation and commits follow **the language chosen by the project**
  (defined at its start and visible in the docs/history) — do not force
  Portuguese.

## 3. Destructive commands — NEVER without explicit approval

- `rm -rf` (especially `/`, `$HOME`, `/etc`, inside `.git`),
  `chmod -R 777`, `chown -R`.
- `git push --force` (any variant), `git reset --hard`,
  `git clean -fd`, `git commit --no-verify`.
- `tofu`/`terraform` `apply`/`destroy`; `aws ... delete`.
- SQL: `DROP`, `TRUNCATE`, `DELETE`/`UPDATE` without `WHERE`.
- `docker system prune`.

If the user asks for one of these, confirm before executing.

## 4. Git

- **Commit and push only when the user asks.** Never on your own
  initiative.
- Conventional Commits; gitmoji when the repo history uses it.
- Selective staging (`git add <file>`), never `git add -A`/`.`.
- Hooks and signing always run (no `--no-verify`/`--no-gpg-sign`).

## 5. Tasks and packages

- The task runner is **mise**, with **file-based** tasks in
  `.config/mise/tasks/` — never define tasks in `mise.toml` or in
  `package.json` `scripts`.
- Node projects use **pnpm** exclusively (never npm/npx/yarn; use
  `pnpm dlx`/`pnpm exec`). Do not pin versions when adding a dependency.
- Prefer the modern CLIs when available: `fd` (not `find`), `rg` (not
  `grep`), `sd` (not `sed`), `bat` (not `cat`), `jq`, `yq`, `xh`.

## 6. Cross-cutting technical preferences

- **Formatting/lint**: oxfmt + oxlint (never ESLint); Prettier only in
  projects with Astro (oxfmt does not support `.astro` yet).
- **UI components**: shadcn/ui with Base UI (`@base-ui/react`) as the
  headless layer (the shadcn default since Jul 2026; Radix only in legacy
  installs), styled with Tailwind + CVA.
- **Everyday languages**: TypeScript, Dart/Flutter, Go, Rust, Python —
  TypeScript and bash are the defaults for new code.
- **TypeScript**: strict; never `any` (use `unknown` + Zod); prefer
  `undefined` over `null`; `es-toolkit`, never lodash.
- **Errors**: Result pattern (`{ok, data, error}`) for the predictable;
  `throw` only for the unexpected; Zod validation at the edge.
- **Asynchronous jobs**: self-hosted Hatchet (Inngest is legacy).
- **Infra**: OpenTofu for cloud, Ansible for bare metal/VPS; `sysadmin`
  standard (repo in a workspace, folder in a monorepo).
- **Observability**: zero `console.log`; structured logger always.
- **Docs**: Mermaid (never ASCII art), readable in dark mode.
- **Scratch**: temporary scripts/files only in `.tmp/` at the repo root
  (gitignored), never scattered across the project.
- **Radical simplicity**: files between 50 and 350 lines; code a junior
  understands; avoid over-engineering.
