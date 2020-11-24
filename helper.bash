#!/usr/bin/env bash

function is_plugin() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/plugins/$name.plugin.bash"
}

function is_aliases() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/aliases/$name.aliases.bash"
}

function is_completion() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/completions/$name.completion.bash"
}

function is_environment() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/environments/$name.env.bash"
}

function is_theme() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/themes/$name/$name.theme.bash"
}

function append_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

function upgrade_set_up() {
    local branch=${SET_UP_ENABLED_BRANCH:=master}
    cd "$SET_UP" || return
    [ -d ".git" ] && git pull origin $branch
    cd - >/dev/null || return
}
