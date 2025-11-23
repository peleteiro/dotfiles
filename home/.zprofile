# Zsh profile
# Loaded for login shells

# Load shared configurations
if [ -f ~/.shared_shell_config ]; then
  source ~/.shared_shell_config
fi

# Load .zshrc if interactive shell
if [[ -o interactive ]]; then
  if [ -f ~/.zshrc ]; then
    source ~/.zshrc
  fi
fi

