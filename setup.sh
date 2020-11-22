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
