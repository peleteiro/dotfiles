#!/usr/bin/env bash
# PostToolUse hook do Codex — espelha o .claude/hooks/lint.sh: roda shellcheck
# nos arquivos que o apply_patch tocou. Feedback rápido por-arquivo; o lint
# completo continua no `mise run lint`.
#
# Registrado em .codex/config.toml: [[hooks.PostToolUse]] matcher = "apply_patch".
# Recebe o JSON do PostToolUse no stdin. O apply_patch expõe o patch em
# `.tool_input.command` (envelope com linhas `*** Update/Add/Move File: <path>`);
# extraímos os paths dali. Em erro de lint, sai com 2 e escreve no stderr (o
# Codex devolve isso ao modelo, que corrige na mesma volta).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT" # para o shellcheck achar o .shellcheckrc

input="$(cat)"
# `|| true`: input malformado (jq falha) nunca derruba o hook — apenas não linta.
command_str="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
[ -n "$command_str" ] || exit 0

# Paths tocados pelo patch (Update/Add/Move File). Move usa "File: origem -> destino";
# pegamos o destino (após " -> ") quando houver.
mapfile -t files < <(printf '%s\n' "$command_str" \
  | grep -oE '^\*\*\* (Update|Add|Move) File: .+$' \
  | sed -E 's/^\*\*\* (Update|Add|Move) File: //; s/^.* -> //')

command -v shellcheck >/dev/null 2>&1 || exit 0

status=0
for file in "${files[@]}"; do
  [ -f "$file" ] || continue

  # Detecta shell script: por extensão OU pelo `file` (muitos scripts do repo
  # não têm extensão — `dotfiles`, tasks do mise).
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
    echo "shellcheck encontrou problemas em $file:" >&2
    echo "$out" >&2
    status=2
  fi
done

exit $status
