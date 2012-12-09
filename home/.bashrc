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

# RCov fdp
ulimit -n 1000

# Compilation
export ARCHFLAGS="-arch x86_64"

# PATH
export PATH=~/.bin:/usr/local/bin:/usr/local/sbin:$PATH

# bash-completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -d ~/.bash_completion.d ]; then
  for file in ~/.bash_completion.d/*; do
    source $file
  done
fi

# virtualenv
export WORKON_HOME=$HOME/.virtualenv
source /usr/local/bin/virtualenvwrapper.sh

# rvm
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

# npm setup
export NODE_PATH=/usr/local/lib/node
export PATH=$PATH:./node_modules/.bin:~/node_modules/.bin

# go setup
export PATH=$PATH:`brew --prefix go`/bin

# Java
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home/"

# Hadoop
export HADOOP_INSTALL=`brew --prefix hadoop`/libexec
export HBASE_INSTALL=`brew --prefix hbase`
export PIG_INSTALL=`brew --prefix pig`
export ZOOKEEPER_INSTALL=`brew --prefix zookeeper`/libexec

# Android
export ANDROID_SDK_ROOT=`brew --prefix android-sdk`

# AWS
export EC2_HOME=`brew --prefix ec2-api-tools`/jars
export AWS_AUTO_SCALING_HOME=`brew --prefix as-api-tools`/
export AWS_CLOUDWATCH_HOME=`brew --prefix cloud-watch`/jars
export EC2_AMITOOL_HOME=`brew --prefix ec2-ami-tools`/jars
export AWS_ELB_HOME=`brew --prefix elb-tools`/jars

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
alias vim='mvim -v'
alias cdd='cd - ' # goto last dir cd'ed from
alias ts='date +%Y%m%d%H%M%S'
alias screen='screen -R'
alias http-server='python -m SimpleHTTPServer'

# Mongodb
alias mongo-start='mongod run --config /usr/local/etc/mongod.conf'

# Virtuoso
alias virtuoso-start='cd `brew --prefix virtuoso`/var/lib/virtuoso/db; virtuoso-t -f'

# ElasticSearch
alias elasticsearch.start='elasticsearch -f -D es.config=`brew --prefix elasticsearch`/config/elasticsearch.yml'

# Postgresql
alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg-stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Emacs
alias em='/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -q -n'
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
