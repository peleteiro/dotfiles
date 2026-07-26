---
name: commit
description: Creates a git commit using Conventional Commits (+ gitmoji when the history uses it), message in the project's documentation language, selective staging. Use when the user asks to commit.
allowed-tools: Bash, Read, Glob, Grep
user-invocable: true
---

# Create Commit

Global skill — if the repo has its own `commit` skill or commit rules in
AGENTS.md, **those win**.

## Steps

### 1. Gather information (in parallel)

```bash
git status                  # Modified/untracked files
git diff --staged --stat    # Summary of staged changes
git diff --stat             # Summary of unstaged changes
git log --oneline -10       # Style reference (language, gitmoji, scopes)
```

If there are no changes (staged or unstaged), report that and stop.

### 2. Staging

- If there are **staged** changes, use them as the basis for the commit.
- If there are **unstaged** changes, stage the relevant files with
  `git add <file>` — NEVER `git add -A` or `git add .`.
- **NEVER stage** files containing secrets (`.env`, `credentials.json`,
  tokens, keys).

### 3. Analyze

```bash
git diff --staged
```

Understand the nature of the change (and the *why*) before writing the
message.

### 4. Message

**Language**: the language of the **project's documentation** (docs in
Portuguese → commit in Portuguese; docs in English → commit in English).
Confirm against the history.

**Format**: Conventional Commits. Use **gitmoji if the repo's history uses
it** (personal default: it does); otherwise, plain type.

| Type | Emoji | Use |
|------|-------|-----|
| `feat` | ✨ | New feature |
| `fix` | 🔧 | Bug fix |
| `refactor` | ♻️ | Refactoring without behavior change |
| `chore` | ⬆️ | Dependencies, maintenance |
| `docs` | 📝 | Documentation |
| `test` | 🧪 | Tests |
| `perf` | ⚡ | Performance |
| `ci` | 🔄 | CI/CD |
| `security` | 🔐 | Security |
| `deprecation` | 🗑️ | Removal of obsolete code |

`{emoji} {type}({scope}): {description}`

- **Scope**: optional; the affected module (e.g. `api`, `engine`, `web`).
- **Description**: concise, focused on the *why*, no trailing period.

Examples (from Portuguese-language projects):
- `✨ feat(api): exigir tenant do contexto, nunca do body`
- `🔧 fix(api): exigir tenant do contexto, nunca do body`
- `⬆️ chore: atualizar dependências do monorepo`

Example (English-language project):
- `🔧 fix(api): require tenant from context, never from body`

### 5. Create the commit

```bash
git commit -m "$(cat <<'EOF'
{emoji} {type}({scope}): {description}
EOF
)"
```

### 6. Verify

If a pre-commit hook fails: fix the problem, stage it, and create a **NEW**
commit (not `--amend`). After success, report the hash and message.

## Rules

- **NEVER** `--no-verify` or `--no-gpg-sign` (hooks and signing always run).
- `--amend` only on a commit not yet published and with an explicit request.
- **NEVER** push without the user asking.
- **NEVER** create an empty commit.
- **NEVER** commit without the user asking.
