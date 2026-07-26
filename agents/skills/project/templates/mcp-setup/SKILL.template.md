---
name: mcp-setup
description: Configures MCP servers in a project with zero secrets at rest — wrappers that read the token from env at runtime, mirrored in the Claude Code, Codex and Antigravity formats
allowed-tools: Read, Write, Bash, Grep
user-invocable: true
disable-model-invocation: true
---

# Configure MCP Servers

**Principle: zero secrets at rest.** A token never goes into a committed file
— always read from the environment at runtime.

## The three formats (same base, different syntax)

| Tool | File |
|---|---|
| Claude Code | `.mcp.json` (or `mcpServers` in `.claude/settings.local.json`) |
| Codex CLI | `[mcp_servers.*]` in `.codex/config.toml` |
| Antigravity | `.agents/mcp_config.json` |

When adding a server, mirror it in all three — the project must work the same
across the three tools.

## Server without secrets (direct)

Public servers (docs, tailwind, shadcn…) can be declared inline in the three
files: `pnpm dlx <package>` as the command.

## Server with secrets (wrapper)

Claude and Codex forward the local env var; Antigravity does **not** — its
`env` would write the value into the file. Solution: a wrapper in
`.agents/mcp/<server>.sh` that reads from the environment and execs:

```bash
#!/usr/bin/env bash
# GitHub MCP wrapper: reads the token from the ENVIRONMENT at runtime — never
# written to the repo. Without a token, the server starts without auth (low
# rate limit) — it doesn't break.
set -euo pipefail

export GITHUB_PERSONAL_ACCESS_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-${GITHUB_TOKEN:-}}"

exec pnpm dlx @modelcontextprotocol/server-github
```

Reference the wrapper in the three configs
(`{command: "bash", args: [".agents/mcp/github.sh"]}`) and make sure the token
is in the env of whoever starts the tool (mise already exports it, e.g.:
`GITHUB_TOKEN`).

## Rules

- `chmod +x` on the wrapper; clean shellcheck (skill `bash`).
- Graceful degradation: without the token, the wrapper starts the server without
  auth or exits with a clear message — it never breaks the rest of the session.
- A database server points to the **local dev database**, never production.
- Review the diff before committing MCP config: no token value may
  appear, not even as an "example" with a real value.
