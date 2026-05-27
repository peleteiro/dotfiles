# Personal zsh aliases
# Sourced from .zshrc — overrides the basic ls aliases set in .shared_shell_config

# Modern `ls` replacement — prefer eza (active fork), fallback to exa
if command -v eza > /dev/null 2>&1; then
  alias l='eza -la --git'
  alias ll='eza -l --git'
elif command -v exa > /dev/null 2>&1; then
  alias l='exa -la --git'
  alias ll='exa -l --git'
fi
