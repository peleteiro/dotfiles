#OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OS="ubuntu"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OS="osx"
else
    exit
fi

# Bash functions
if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

# setup some basic variables
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export HOMEBREW_LLVM=true

: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# Compilation
export ARCHFLAGS="-arch x86_64"

# bash-completion
if [[ "$OS" == "osx" && -f `brew --prefix`/etc/bash_completion ]]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -d ~/.bash_completion.d ]; then
  for file in ~/.bash_completion.d/*; do
    source $file
  done
fi

# rvm
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

# Git
alias __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"

# tmxu
alias tmux="TERM=xterm-256color tmux"

# editor
export EDITOR='vim'
export VISUAL='vim'

# bash prompt
export HISTCONTROL=ignoredups
export CLICOLOR=true
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\033[01;32m\]\w\[\e[m\]\[\e[1;34m\]$(__bundler_ps1 " [%s]")$(__git_ps1 )\[\e[m\]\[\e[m\]\$ '

# Misc
export PAGER='less'
export CLICOLOR='yes'
export INPUTRC='~/.inputrc'

# Alias ###################################################################
alias cdd='cd - ' # goto last dir cd'ed from
alias ts='date +%Y%m%d%H%M%S'

# OS bash_profile
source ~/.bash_profile-${OS}

# PATH
export PATH=~/.bin:$PATH

if [ -f ~/.bash_private ]; then
  source ~/.bash_private
fi
