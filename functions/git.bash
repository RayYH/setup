#!/usr/bin/env bash

# Git related functions

function git_aliases() {
	git config --get-regexp alias | awk '{first = $1; $1 = ""; printf "%-20s %s\n", first, $0; }'
}

# use git diff to diff files/folders
if [ ! "$(hash git &>/dev/null)" ]; then
    function diff() {
        git diff --no-index --color-words "$@"
    }
fi
