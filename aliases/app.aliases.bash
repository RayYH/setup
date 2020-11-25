#!/usr/bin/env bash

# Application aliases

if [ "$(uname -s)" == 'Darwin' ]; then
  # Mac
  alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
else
  # Others - I use mac and ubuntu, so, this means linux
  alias chrome=google-chrome
fi

# cross-platform open command
if [ ! "$(uname -s)" = 'Darwin' ]; then
  if grep -q Microsoft /proc/version; then
    # Ubuntu on Windows using the Linux subsystem
    alias open='explorer.exe'
  else
    alias open='xdg-open'
  fi
fi
