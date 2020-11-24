#!/usr/bin/env bash
# see https://github.com/nvbn/thefuck

function _set_pkg_aliases() {
    if command -v thefuck &>/dev/null; then
        eval "$(thefuck --alias)"
    fi
    if ! command -v fuck &>/dev/null; then
        alias fuck='sudo $(fc -ln -1)'
    fi
}
_set_pkg_aliases
alias please=fuck
alias plz=please
alias fucking=sudo
