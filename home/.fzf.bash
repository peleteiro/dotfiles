# Setup fzf function
# ------------------
unalias fzf 2> /dev/null
fzf() {
  /usr/bin/ruby --disable-gems /usr/local/Cellar/fzf/0.8.1/fzf "$@"
}
export -f fzf > /dev/null

# Auto-completion
# ---------------
source /usr/local/Cellar/fzf/0.8.1/fzf-completion.bash

# Key bindings
# ------------
if [[ $- =~ i ]]; then

__fsel() {
  find * -path '*/\.*' -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | fzf -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

if [ -z "$(set -o | grep '^vi.*on')" ]; then
  # Required to refresh the prompt after fzf
  bind '"\er": redraw-current-line'

  # CTRL-T - Paste the selected file path into the command line
  bind '"\C-t": " \C-u \C-a\C-k$(__fsel)\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": " \C-e\C-u$(HISTTIMEFORMAT= history | fzf +s | sed \"s/ *[0-9]* *//\")\e\C-e\er"'
else
  bind '"\C-x\C-e": shell-expand-line'
  bind '"\C-x\C-r": redraw-current-line'

  # CTRL-T - Paste the selected file path into the command line
  # - FIXME: Selected items are attached to the end regardless of cursor position
  bind '"\C-t": "\eddi$(__fsel)\C-x\C-e\e0P$a \C-x\C-r"'

  # CTRL-R - Paste the selected command from history into the command line
  bind '"\C-r": "\eddi$(HISTTIMEFORMAT= history | fzf +s | sed \"s/ *[0-9]* *//\")\C-x\C-e\e$a\C-x\C-r"'
fi

fi
