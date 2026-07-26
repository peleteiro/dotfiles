---
name: security-check
description: Scans the repo (or the pending diff) for committed secrets, gitignore gaps and tokens at rest in configs — report only, works in any repository
allowed-tools: Read, Bash, Grep, Glob
user-invocable: true
---

# Security Check

Read-only sweep for the most common self-inflicted leak: a secret in git.
Works in any repo — no project scaffolding required. **Report only**: never
delete, rewrite history or rotate anything on your own.

## 1. Scan for secrets

Prefer gitleaks when available (installed or via the repo's toolchain):

```bash
gitleaks detect --no-banner --redact          # working tree + history
gitleaks protect --staged --no-banner --redact  # only what is about to be committed
```

Without gitleaks, fall back to targeted patterns over tracked files —
private key blocks (`BEGIN … PRIVATE KEY`), bearer/oauth tokens, provider
prefixes (`sk-`, `ghp_`, `gho_`, `xox`, `AKIA`, `ntrys_`, `GOCSPX-`),
`_TOKEN=`/`_SECRET=`/`_KEY=` assignments with literal values, and URLs with
embedded credentials. Check `git log -p` for the file when a hit looks
historical.

## 2. Check the guards

- `.gitignore` covers the sensitive files the stack uses: `.env*`,
  `mise.local.toml`, `*.pem`/`*.key`, credential JSONs, `.tmp/`.
- Example files (`*.example.*`) contain placeholders, not real values.
- MCP/agent configs (`.mcp.json`, `.codex/config.toml`,
  `.agents/mcp_config.json`) have **no token at rest** — tokens come from
  the environment at runtime (wrapper pattern).
- Git hooks (lefthook or equivalent) run a secret scan before commit, if
  the project has that standard.

## 3. Report

Group findings by severity and be precise about exposure:

- 🔴 **Secret committed** — file, line, and whether it is in history (not
  just the working tree). State clearly: **rotation is the fix**; removing
  the line does not un-leak it. Rotation and history rewriting are the
  user's decision.
- 🟡 **Gap** — missing gitignore entry, real-looking value in an example
  file, no scan in the hooks.
- Never paste the secret value itself into the report — reference
  file:line and a redacted prefix.
