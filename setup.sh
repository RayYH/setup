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

# use $TERM_PROGRAM to check whether is in Terminal.app or in iTerm2

if [[ -z "$SETUP_CONFIG_FILE" ]]; then
    SETUP_CONFIG_FILE="$SETUP/.setuprc"
fi

# shellcheck source=.setuprc
[ -f "$SETUP_CONFIG_FILE" ] && source "$SETUP_CONFIG_FILE" 2>/dev/null
