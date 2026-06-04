# Zsh configuration file
# Loaded for interactive shells

# Load shared configurations
if [ -f ~/.shared_shell_config ]; then
  source ~/.shared_shell_config
fi

# Zsh history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_ignore_dups      # Ignore duplicates in history
setopt hist_ignore_space      # Ignore commands starting with space
setopt share_history          # Share history between sessions
setopt append_history         # Append to history instead of overwriting
setopt inc_append_history     # Add commands immediately

# Zsh options
setopt autocd                 # cd by typing directory name
setopt extended_glob          # Extended glob patterns
setopt no_beep                # Disable beep

# Directory stack — every `cd` pushes to stack, use `cd -<N>` or `cd +<N>` to jump
setopt auto_pushd             # Make cd push the old directory onto the stack
setopt pushd_ignore_dups      # Don't push duplicates onto the stack
setopt pushd_silent           # Don't print the stack after pushd/popd
alias d='dirs -v | head -20'  # Show numbered directory stack

# Key bindings (emacs mode)
bindkey -e
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Edit current command line in $EDITOR (Ctrl-X Ctrl-E)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Completions
# Add personal completions directory to fpath (must come before compinit).
# Also pin Homebrew's version-independent functions symlink so a stale inherited
# FPATH (e.g. left over from a zsh upgrade in an older session) can't hide
# compinit and break completion. Prune any fpath entries that no longer exist.
fpath=(~/.zsh/completions $fpath)
if [[ -d /opt/homebrew/share/zsh/functions ]]; then
  fpath=($fpath /opt/homebrew/share/zsh/functions)
fi
fpath=(${^fpath}(N-/))
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Bash completion compatibility (for tools that only provide bash-style completions)
autoload -Uz bashcompinit
bashcompinit

# Specific completions
# AWS CLI
if command -v aws_completer > /dev/null; then
  complete -C aws_completer aws
fi

# Docker Compose
if command -v docker-compose > /dev/null; then
  if [ `command -v _docker_compose` ]; then
    complete -F _docker_compose dkc
  fi
fi

# Mise
if command -v mise > /dev/null; then
  eval "$(mise completion zsh)"
fi

# Pipenv
if command -v pipenv > /dev/null; then
  eval "$(pipenv --completion 2> /dev/null)"
fi

# Starship prompt (if available, otherwise fallback to simple prompt)
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  # Fallback to simple prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{green}%~%f%F{blue}${vcs_info_msg_0_}%f$ '
fi

# Personal aliases (zsh-only)
if [ -f ~/.zsh/aliases.zsh ]; then
  source ~/.zsh/aliases.zsh
fi

# Zsh functions
if [ -f ~/.zsh_functions ]; then
  source ~/.zsh_functions
fi

# Load private Zsh configurations (if exists)
if [ -f ~/.zshrc_private ]; then
  source ~/.zshrc_private
fi

# === Plugins ===
# Plugin directory: brew on macOS, /usr/share on Linux
if [[ "$OS" == "macos" ]]; then
  _ZSH_PLUGIN_DIR="${HOMEBREW_PREFIX:-/opt/homebrew}/share"
else
  _ZSH_PLUGIN_DIR="/usr/share"
fi

# zsh-autosuggestions — fish-like inline suggestions (accept with → or End)
if [ -f "$_ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$_ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# zsh-syntax-highlighting — colors commands as you type (MUST be sourced last)
if [ -f "$_ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$_ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _ZSH_PLUGIN_DIR

