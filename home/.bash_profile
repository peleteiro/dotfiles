#OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export OS="osx"
else
    exit
fi

# coreutils if osx
if [[ "$OS" == "osx" ]]; then
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  alias sed=gsed
fi

# Bash functions
if [ -f ~/.bash_functions ]; then
  source ~/.bash_functions
fi

# setup some basic variables
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

: ${HOME=~}
: ${LOGNAME=$(id -un)}
: ${UNAME=$(uname)}

# bash-completion
if [[ "$OS" == "osx" && -f `brew --prefix`/etc/bash_completion ]]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -d ~/.bash_completion.d ]; then
  for file in ~/.bash_completion.d/*; do
    source $file
  done
fi

# tmxu
alias tmux="TERM=xterm-256color tmux"

# bindings
stty werase undef
bind '\C-w:unix-filename-rubout'

# editor
export EDITOR=vim
export VISUAL=vim
export BAT_PAGER=never

# bash prompt
export PS1='\[\033[01;32m\]\w\[\e[m\]\[\e[1;34m\]$(__git_ps1 )\[\e[m\]\[\e[m\]\$ '

# don't put duplicate lines or lines starting with space in the history. See bash(1) for more options
export HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=1000
export HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Colors
export TERM=xterm-color
export CLICOLOR=1
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

eval "`dircolors -b ~/.dircolors`"
export LS_COLORS

# Misc
export PAGER='less'
export INPUTRC='~/.inputrc'

# Alias ###################################################################
alias cdd='cd - ' # goto last dir cd'ed from
alias ts='date +%Y%m%d%H%M%S'

## some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# aws cli
if [ `which aws_completer` ]; then
  complete -C aws_completer aws
fi

# aws-vault
export AWS_VAULT_BACKEND=file

# Docker
alias dkc=docker-compose
if [ `command -v _docker_compose` ]; then
	complete -F _docker_compose dkc
fi

# OS bash_profile
source ~/.bash_profile-${OS}

# PATH
export PATH=~/.bin:$PATH

if [ -f ~/.bash_private ]; then
  source ~/.bash_private
fi
