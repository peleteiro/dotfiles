#!/bin/bash

function __bundler_ps1 {
  if [ -n "${BUNDLE_GEMFILE-}" ]; then
    project_path="${BUNDLE_GEMFILE%/Gemfile}"
    project_name="${project_path##**/}"

    if [ -n "${1-}" ]; then
      printf "$1" "${project_name}"
    else
      printf " (%s)" "${project_name}"
    fi
  fi
}

function proj() {
  if [ -z "$*" ]; then
    [ `pwd` == '/' ] && return
    [ -e .git ] && return

    cd ..
    proj

    return
  fi

  proj_dir=`find ~/Projects -path "*/$*/.git"`
  [ -z $proj_dir ] && echo "Projeto $* não encontrado" && return 1

  cd $proj_dir/..
}
