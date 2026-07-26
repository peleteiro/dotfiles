#!/usr/bin/env bash
# PostToolUse hook: runs shellcheck ONLY on the edited file.
# Mirrors the shellcheck step of `mise run lint`, but per-file — fast feedback
# on every edit. The full lint still runs via `mise run lint`.
#
# Receives the PostToolUse JSON on stdin. On a shellcheck failure, exits with 2 to
# return the error to the model (which fixes it in the same turn). shellcheck has no
# auto-fix, so here we only point out the problems.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT" # so shellcheck finds the .shellcheckrc

file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

# Detects shell scripts: by extension OR via `file` (many scripts in the repo,
# like `dotfiles` and the mise tasks, have no extension).
is_shell=false
case "$file" in
  *.sh | *.bash | *.zsh) is_shell=true ;;
  *)
    if file "$file" 2>/dev/null | grep -q "shell script"; then
      is_shell=true
    fi
    ;;
esac
[ "$is_shell" = true ] || exit 0

command -v shellcheck >/dev/null 2>&1 || exit 0

if ! out=$(shellcheck "$file" 2>&1); then
  echo "shellcheck found problems in $file:" >&2
  echo "$out" >&2
  exit 2
fi

exit 0
