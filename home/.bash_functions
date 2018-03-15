#!/bin/bash

function proj() {
  [ `pwd` == '/' ] && return
  [ -e .editorconfig ] && return
  [ -e .git ] && return

  cd ..
  proj
}

function java_use() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
  export PATH=$JAVA_HOME/bin:$PATH
  java -version
}