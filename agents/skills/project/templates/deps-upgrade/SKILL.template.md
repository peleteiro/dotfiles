---
name: deps-upgrade
description: Safe dependency upgrades — grouped, changelog-aware, verified between groups; respects minimumReleaseAge
allowed-tools: Read, Bash, Grep, Glob
user-invocable: true
---

# Dependency Upgrade

Upgrades are routine, not heroics: small groups, verify between them, read
before jumping majors.

## Flow

1. **Inventory**: `pnpm outdated -r` (and `mise outdated` for the
   toolchain). If the repo has `upgrade:*` tasks, prefer them
   (`mise run upgrade:deps`, `upgrade:tools`).
2. **Group** the updates:
   - patch/minor of direct deps → one batch;
   - each **major** → its own batch, after reading the changelog/migration
     guide (breaking changes listed in the PR/commit message);
   - toolchain (node, pnpm, go…) → separate batch via `mise.toml`.
3. **Per batch**: upgrade → `mise run check` → `mise run test` → commit
   (one commit per batch, e.g. `⬆️ chore: bump <group>`). A red batch is
   reverted or fixed before the next one starts.
4. **Lockfile**: review the lockfile diff for surprise transitive jumps;
   never hand-edit it.

## Rules

- Respect `minimumReleaseAge` (pnpm workspace setting) — do not force a
  release younger than the window.
- Never pin exact versions when adding/upgrading (project standard); let
  the range do its job.
- Never mix an upgrade batch with feature changes in the same commit.
- Security advisories (`pnpm audit`) jump the queue — handle them first
  and mention them explicitly in the report.
