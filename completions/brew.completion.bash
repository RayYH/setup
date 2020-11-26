#!/usr/bin/env bash

if [[ "$(uname -s)" != 'Darwin' ]]; then
  return 0
fi

command_exists brew || return 0

BREW_PREFIX=${BREW_PREFIX:-$(brew --prefix)}

if [[ -r "$BREW_PREFIX"/etc/bash_completion.d/brew ]]; then
  source "$BREW_PREFIX"/etc/bash_completion.d/brew
elif [[ -r "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh ]]; then
  source "$BREW_PREFIX"/Library/Contributions/brew_bash_completion.sh
elif [[ -f "$BREW_PREFIX"/completions/bash/brew ]]; then
  source "$BREW_PREFIX"/completions/bash/brew
fi
