#!/usr/bin/env bash

if type brew &>/dev/null; then
  # autojump
  [ -f "$(brew --prefix)"/etc/profile.d/autojump.sh ] && . "$(brew --prefix)"/etc/profile.d/autojump.sh
fi
