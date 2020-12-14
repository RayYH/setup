#!/usr/bin/env bash

# Install go
if ! command -v go &>/dev/null; then
  case $OSTYPE in
  darwin*)
    brew update
    brew install go go
    ;;
  # other systems
  *)
    if command -v snap &>/dev/null; then
      sudo snap install --classic go
    elif command -v apt &>/dev/null; then
      sudo add-apt-repository ppa:longsleep/golang-backports
      sudo apt update
      sudo apt install golang-go
    fi
    ;;
  esac
fi

# Create go working directory
[ -d "$HOME/Code/projects/go" ] || mkdir -p "$HOME/Code/projects/go"

# github packages
command -v git &>/dev/null && [ -n "$(git config user.name 2>/dev/null)" ] && mkdir -p "$HOME/Code/projects/go/src/github.com/$(git config user.name 2>/dev/null)"
