if [ -d $HOME/.asdf ]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
fi

[ -n "$PS1" ] && source ~/.bash_profile
