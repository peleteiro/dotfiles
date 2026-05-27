#!/bin/bash
# Completion for the `zj` helper: complete with existing Zellij session names

_zj() {
  COMPREPLY=()
  local session="${COMP_WORDS[COMP_CWORD]}"
  local sessions
  sessions="$(zellij list-sessions --short --no-formatting 2>/dev/null)"
  # shellcheck disable=SC2207
  COMPREPLY=( $(compgen -W "$sessions" -- "$session") )
}
complete -F _zj zj
