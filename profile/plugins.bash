#!/usr/bin/env bash

if type brew &>/dev/null; then
  # autojump
  [ -f "$(brew --prefix)"/etc/profile.d/autojump.sh ] && . "$(brew --prefix)"/etc/profile.d/autojump.sh
  # asdf
  [ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh" ] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
  # fzf
  [ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
fi
