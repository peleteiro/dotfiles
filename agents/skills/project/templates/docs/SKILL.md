---
name: docs
description: Documentation standards — language chosen per project, Mermaid (never ASCII art) readable in dark mode, README always up to date, runbooks in docs/. Use when writing or reviewing documentation.
allowed-tools: Read, Grep
---

# Documentation

Global skill — if the repo has its own `docs` skill, it wins.

## Language

The documentation language is **chosen at project start** (and also applies
to commits — skill `commit`). Follow what the repo already uses; in a new
project, the choice is recorded in AGENTS.md (skill `new-project`). Do not
force Portuguese or English.

## Diagrams: Mermaid, never ASCII art

- Every diagram in ```mermaid``` blocks — renders on GitHub and in viewers.
- **Readable in dark mode**: don't hardcode light background/text colors; if
  you need styling, test in both themes.
- One diagram per concept; prefer simple `flowchart`/`sequenceDiagram` over a
  mega-diagram.

## README

- **Update the README together** with any change that affects usage, commands, or
  project structure — in the same commit/PR, not "later".
- README is the entry point: installation, main commands, overview.
  Detail goes into `docs/`.

## Structure

| Where | What |
|---|---|
| `README.md` | Entry point: what it is, how to install, commands |
| `AGENTS.md` | Rules for agents (single source; `CLAUDE.md` is a symlink) |
| `docs/` | Architecture, decisions, operational runbooks, dev guides |

- An operational runbook describes **executable steps** (complete commands,
  real paths), not theory.
- Internal docs may assume context; public docs (README) may not.

## Style

- Short titles, small sections; tables for enumerable facts, prose for
  explanation.
- Example code that **works** (pasteable), with minimal placeholders.
- No screenshots of what can be expressed in text/code/Mermaid.
- Never paste secrets, tokens, or personal data in docs — not even as an example
  (fictional "use `sk-...`" is ok; a real value never).
