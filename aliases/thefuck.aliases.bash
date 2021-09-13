#!/usr/bin/env bash
# see https://github.com/nvbn/thefuck

if command -v thefuck &>/dev/null; then
  eval "$(thefuck --alias)"
fi

if ! command -v fuck &>/dev/null; then
  alias fuck='sudo $(fc -ln -1)'
fi

alias please=fuck
alias plz=please
alias fucking=sudo
