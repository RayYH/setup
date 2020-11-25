#!/usr/bin/env bash

# Git related plugins

function git-aliases() {
  git config --get-regexp alias | awk '{first = $1; $1 = ""; printf "%-20s %s\n", first, $0; }'
}

# use git diff to diff files/folders
if [ ! "$(hash git &>/dev/null)" ]; then
  function diff() {
    git diff --no-index --color-words "$@"
  }
fi

function git-dv() {
  git diff -w "$@" | vim -R -
}
