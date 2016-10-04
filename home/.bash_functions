#!/bin/bash

function proj() {
  [ `pwd` == '/' ] && return
  [ -e .git ] && return

  cd ..
  proj
}
