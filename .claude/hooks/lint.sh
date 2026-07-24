#!/usr/bin/env bash
# PostToolUse hook: roda shellcheck SOMENTE no arquivo editado.
# Espelha a etapa de shellcheck do `mise run lint`, mas por-arquivo — feedback
# rápido a cada edição. O lint completo continua rodando via `mise run lint`.
#
# Recebe o JSON do PostToolUse no stdin. Em falha do shellcheck, sai com 2 para
# devolver o erro ao modelo (que corrige na mesma volta). O shellcheck não tem
# auto-fix, então aqui só apontamos os problemas.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT" # para o shellcheck achar o .shellcheckrc

file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null || true)
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

# Detecta shell script: por extensão OU pelo `file` (muitos scripts do repo,
# como `dotfiles` e as tasks do mise, não têm extensão).
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
  echo "shellcheck encontrou problemas em $file:" >&2
  echo "$out" >&2
  exit 2
fi

exit 0
