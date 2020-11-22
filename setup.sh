#!/usr/bin/env bash

if [ -z "$SETUP" ]; then
    export SETUP="$(cd "$(dirname "$0")" && pwd)"
fi

if [ -z "$SETUP_BACKUP" ]; then
    export SETUP_BACKUP="$SETUP/backup"
fi

if [[ -z "$SETUP_CUSTOM" ]]; then
    SETUP_CUSTOM="$SETUP/custom"
fi

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.sh \
    || test -f $base_dir/plugins/$name/_$name
}

# use $TERM_PROGRAM to check whether is in Terminal.app or in iTerm2
