---
name: sysadmin
description: Personal infrastructure standard — OpenTofu for cloud, Ansible for bare metal/VPS, both together when it makes sense; sysadmin layout as a repo (workspace) or folder (monorepo). Use when creating, planning or reviewing infra.
allowed-tools: Bash, Read, Grep
---

# Sysadmin — OpenTofu + Ansible

Global skill — if the repo has its own skills (`tofu-plan`, `deploy`,
`infra-plan`), they win.

## Tool choice

| Target | Tool |
|---|---|
| Cloud (AWS, Cloudflare, GCP…) | **OpenTofu** (never Terraform) |
| Bare metal, VMs on simple VPS, local machines | **Ansible** |
| Cloud + machines that need internal configuration | **Tofu + Ansible** (tofu provisions, ansible configures) |

It is normal for the two to coexist in the same `sysadmin` (e.g. tofu creates
the VM/network, ansible installs and configures what runs on it).

## Where it lives

- **Workspace/large project**: its own `sysadmin/` repo alongside the
  siblings (multi-repo workspace pattern), with AGENTS.md and full agent
  scaffolding.
- **Monorepo**: `sysadmin/` folder at the root, with the
  tasks in `sysadmin/.config/mise/tasks/` (`mise run //sysadmin:tofu:plan`).

Typical layout:

```
sysadmin/
├── tofu/          # cloud IaC (workspaces: dev and prod — only those two)
├── ansible/       # playbooks/roles for bare metal and VMs
├── docs/          # runbooks, decisions
└── .config/mise/tasks/   # tofu:plan, tofu:apply, deploy:*, etc.
```

## Tofu rules

- Environments: **only `dev` and `prod`** (tofu workspaces). No staging, no
  per-branch environment.
- ⚠️ **NEVER** `tofu apply`/`destroy` (not even via task) without explicit
  human approval. `tofu plan` is always safe and is the default.
- ⚠️ **NEVER** use a pipe (`| head`, `| grep`) on tofu commands — it hangs
  the state lock. Let the `plan` finish and read the whole diff before
  proposing an apply.
- Secrets **never hardcoded in the IaC**: reference the secret manager.
  Where the secret lives in the cloud, mark the origin in the description:
  `[Tofu]` (managed — do not edit in the console) vs `[Manual]` (created by
  hand).

## Ansible rules

- **Idempotent** playbooks: running again converges, it does not duplicate
  the effect (same principle as `mise run prepare`).
- Inventory and sensitive variables out of git (vault or `mise.local.toml`);
  the versioned playbook only contains what is public.
- Prefer native modules over `shell:`/`command:`; when unavoidable, use
  `creates:`/`changed_when:` to keep idempotency.

## Deploy and credentials

- A production deploy is an **explicit** user action — never run `deploy:*`
  or equivalent on your own initiative.
- Per-environment credentials in the sysadmin's `mise.local.toml`
  (gitignored); no credentials shared between dev and prod.
- Every operation becomes a mise task (`tofu:plan`, `deploy:<svc>`), never a
  loose command documented only in chat.
