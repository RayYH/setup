#!/usr/bin/env bash

# Essential helpful plugins
# shellcheck disable=SC2145

# mkdir then cd in
function mkd() {
    mkdir -p "$@" && cd "$_" || return
}

# find file in current folder whose name matched provided string
function ff() {
    find . -name "$@"
}

# find file in current folder whose name starts with provided string
function ffs() {
    find . -name "$@"'*'
}

# find file in current folder whose name ends with provided string
function ffe() {
    find . -name '*'"$@"
}

# determine the size of file or folder
function fs() {
    if du -b /dev/null >/dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    # shellcheck disable=SC2199
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

# create a dataurl of given file
function dataurl() {
    local mimeType
    mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
