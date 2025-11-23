# Bash profile
# Loaded for Bash login shells

# Bash-specific bindings
stty werase undef
bind '\C-w:unix-filename-rubout'

## Turn off terminal beep
bind 'set bell-style none'

# Load shared configurations
if [ -f ~/.shared_shell_config ]; then
  source ~/.shared_shell_config
fi

# bash-completion
if [ -d ~/.bash_completion.d ]; then
  for file in ~/.bash_completion.d/*; do
    source $file
  done
fi

# Homebrew bash completion (macOS)
# Suppress nosort errors for bash < 4.1 (bash_completion still works without it)
if [[ "$OS" == "macos" ]]; then
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    # Check bash version - nosort requires bash 4.1+
    # Extract version numbers: "GNU bash, version 3.2.57" -> "3.2"
    bash_ver=$(bash --version 2>/dev/null | head -1 | sed -E 's/.*version ([0-9]+)\.([0-9]+)\.[0-9]+.*/\1.\2/')
    if [ -n "$bash_ver" ]; then
      major=$(echo "$bash_ver" | cut -d. -f1)
      minor=$(echo "$bash_ver" | cut -d. -f2)
      # Bash 4.1+ supports nosort
      if [ "$major" -gt 4 ] || ([ "$major" -eq 4 ] && [ "$minor" -ge 1 ]); then
        . `brew --prefix`/etc/bash_completion
      else
        # Bash < 4.1 - suppress nosort errors (bash_completion still works)
        . `brew --prefix`/etc/bash_completion 2>/dev/null || true
      fi
    else
      # If version detection fails, suppress errors to be safe
      . `brew --prefix`/etc/bash_completion 2>/dev/null || true
    fi
  fi
fi

# Bash functions
if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

# Starship prompt (if available, otherwise fallback to simple prompt)
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
else
  # Fallback to simple prompt
  export PS1='\[\033[01;32m\]\w\[\e[m\]\[\e[1;34m\]$(__git_ps1 )\[\e[m\]\[\e[m\]\$ '
fi

# Bash history
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# dircolors (Linux)
if [[ "$OS" == "linux" ]] && command -v dircolors > /dev/null; then
  if [ -f ~/.dircolors ]; then
    eval "`dircolors -b ~/.dircolors`"
    export LS_COLORS
  fi
fi

# INPUTRC
export INPUTRC='~/.inputrc'

# Bash-specific completions
# Docker Compose
if [ `command -v _docker_compose` ]; then
  complete -F _docker_compose dkc
fi

# Load OS-specific configurations for Bash (if exists)
if [ -f ~/.bash_profile-${OS} ]; then
  source ~/.bash_profile-${OS}
fi

# Load private Bash configurations (if exists)
if [ -f ~/.bash_private ]; then
  source ~/.bash_private
fi
