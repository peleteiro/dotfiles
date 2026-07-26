#!/usr/bin/env bash
# Codex PostToolUse hook — mirrors .claude/hooks/lint.sh: runs shellcheck
# on the files apply_patch touched. Fast per-file feedback; the full lint
# stays in `mise run lint`.
#
# Registered in .codex/config.toml: [[hooks.PostToolUse]] matcher = "apply_patch".
# Receives the PostToolUse JSON on stdin. apply_patch exposes the patch in
# `.tool_input.command` (an envelope with `*** Update/Add/Move File: <path>` lines);
# we extract the paths from there. On a lint error, exits with 2 and writes to stderr
# (Codex returns that to the model, which fixes it in the same turn).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT" # so shellcheck finds the .shellcheckrc

input="$(cat)"
# `|| true`: malformed input (jq fails) never takes the hook down — it just doesn't lint.
command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
[ -n "$command_str" ] || exit 0

# Paths touched by the patch (Update/Add/Move File). Move uses "File: source -> destination";
# we take the destination (after " -> ") when present.
mapfile -t files < <(printf '%s\n' "$command_str" \
  | grep -oE '^\*\*\* (Update|Add|Move) File: .+$' \
  | sed -E 's/^\*\*\* (Update|Add|Move) File: //; s/^.* -> //')

command -v shellcheck >/dev/null 2>&1 || exit 0

status=0
for file in "${files[@]}"; do
  [ -f "$file" ] || continue

  # Detects shell scripts: by extension OR via `file` (many scripts in the repo
  # have no extension — `dotfiles`, mise tasks).
  is_shell=false
  case "$file" in
    *.sh | *.bash | *.zsh) is_shell=true ;;
    *)
      if file "$file" 2>/dev/null | grep -q "shell script"; then
        is_shell=true
      fi
      ;;
  esac
  [ "$is_shell" = true ] || continue

  if ! out=$(shellcheck "$file" 2>&1); then
    echo "shellcheck found problems in $file:" >&2
    echo "$out" >&2
    status=2
  fi
done

exit $status
