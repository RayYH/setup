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

function transform-git-ro() {
  origin=$(git remote -v | grep "origin" | head -n1)
  url=""
  # convert git to https
  if echo "$origin" | grep "git@" &>/dev/null; then
    regex=".+git@([0-9a-zA-Z\-\_\.]+):([0-9a-zA-Z\-\_]+)/([0-9a-zA-Z\-]+)\.git"
    if [[ $origin =~ $regex ]]; then
      hostname="${BASH_REMATCH[1]}"
      username="${BASH_REMATCH[2]}"
      repo="${BASH_REMATCH[3]}"
      url="https://$hostname/$username/$repo"
    fi
  # convert https to git
  else
    regex=".+https://([0-9a-zA-Z\-\_\.]+)/([0-9a-zA-Z\-\_]+)/([0-9a-zA-Z\-]+)"
    if [[ $origin =~ $regex ]]; then
      hostname="${BASH_REMATCH[1]}"
      username="${BASH_REMATCH[2]}"
      repo="${BASH_REMATCH[3]}"
      repo=${repo%".git"}
      url="git@$hostname:$username/$repo.git"
    fi
  fi
  [ -n "$url" ] && echo "set origin: $url" && git remote set-url origin "$url"
}

function git-clone() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "git-clone <hostname> <username> <repo>"
  else
    url="git@$1:$2/$3.git"
    command -v git &>/dev/null && git clone "$url"
  fi
}
