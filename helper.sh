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

function is_completion() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/completions/$name.completion.bash"
}

function is_plugin() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/plugins/$name.plugin.bash"
}

function is_theme() {
    local base_dir=$1
    local name=$2
    test -f "$base_dir/themes/$name/$name.theme.bash"
}
