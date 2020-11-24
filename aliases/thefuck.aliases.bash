#!/usr/bin/env bash
# see https://github.com/nvbn/thefuck
eval "$(thefuck --alias)"

function _set_pkg_aliases() {
    if ! command -v fuck &>/dev/null; then
        alias fuck='sudo $(fc -ln -1)'
    fi
}
_set_pkg_aliases
alias please=fuck
alias plz=please
alias fucking=sudo
