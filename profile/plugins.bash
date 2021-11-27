#!/usr/bin/env bash

if type brew &>/dev/null; then
  # autojump
  [ -f "$(brew --prefix)"/etc/profile.d/autojump.sh ] && . "$(brew --prefix)"/etc/profile.d/autojump.sh
  # asdf
  [ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh" ] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
  # fzf
  [ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
fi

if [ "$GIT_SIGNING_KEY" == "" ]; then
  if command -v gpg &>/dev/null; then
    fullKey="$(gpg --list-secret-keys --keyid-format=long | grep sec | awk '{print $2}')"
    key=${fullKey#"ed25519/"}
    GIT_SIGNING_KEY="$key"
  fi
fi

if [ -n "$GIT_SIGNING_KEY" ] && [ "$GIT_SIGNING_KEY" != " " ]; then
  git config --global commit.gpgsign true &&
    git config --global user.signingkey "$GIT_SIGNING_KEY"
fi
