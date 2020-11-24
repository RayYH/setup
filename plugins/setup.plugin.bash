#!/usr/bin/env bash

function __sync_files() {
    local now home_conf_file
    now=$(date '+%Y%m%d_%H_%I_%S')
    mkdir -p "$SET_UP_BACKUP/$now"
    shopt -s dotglob
    for conf_file in "$SET_UP"/config/**/.*; do
        home_conf_file=$HOME/$(basename "$conf_file")
        [ -f "$home_conf_file" ] && rsync -ah --no-perms "$home_conf_file" "$SET_UP_BACKUP/$now"
        [ -f "$conf_file" ] && rsync -ah --no-perms "$conf_file" ~
    done
    echo -e "all old files have been moved into \033[0;32m$SET_UP_BACKUP/$now\033[0m folder"
    shopt -u dotglob
}

function __clean_backups() {
    for f in "$SET_UP_BACKUP"/*; do
        if [ -d "$f" ]; then
            # avoid empty SET_UP_BACKUP
            [[ $f == "$HOME"/* ]] && rm -r "$f"
        fi
    done
}

function sync_set_up_configs() {
    if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        __sync_files
    else
        read -rp "This may overwrite existing files (we will backup replaced files) in your home directory. Are you sure? (y/n) " -n 1
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            __sync_files
        fi
    fi
}

function clean_set_up_backup_files() {
    if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
        __clean_backups
    else
        read -rp "This may remove all sub-folders of the $SET_UP_BACKUP. Are you sure? (y/n) " -n 1
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            __clean_backups
        fi
    fi
}

function upgrade_set_up() {
    local branch=${SET_UP_ENABLED_BRANCH:=master}
    cd "$SET_UP" || return
    [ -d ".git" ] && git pull origin $branch
    cd - >/dev/null || return
}
