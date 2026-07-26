---
trigger: always_on
---

# Forbidden Destructive Commands

NEVER run these commands without explicit user approval:

## System

This repository installs files into the user's `$HOME` (`./dotfiles`). Be
extra careful with writes outside the repository.

- `rm -rf` (especially on `/`, `$HOME`, `/etc`, and inside `.git`)
- `chmod -R 777`
- `chown -R`
- Overwriting `~/.zshrc`, `~/.gitconfig`, etc. **outside** the `./dotfiles` flow

## Git

- `git push --force` / `git push -f` / `git push --force-with-lease` (rewrites history)
- `git reset --hard`
- `git clean -fd`
- `git commit --no-verify` (validation hooks must always run)

> Regular `git push` is allowed, but only when the user asks — see [[005-git-push]].

## Docker (used only in the Linux tests)

- `docker system prune`

If the user asks for one of these commands, ALWAYS confirm before running it.
