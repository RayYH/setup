#!/usr/bin/env bash
WORKING_DIR=$(dirname "${BASH_SOURCE[0]}")
WORKING_DIR=$(cd "$WORKING_DIR" && pwd)

SETUP_REPO="https://github.com/RayYH/setup"

if ! command -v git &>/dev/null; then
    echo "git not found!"
    return
fi

if [[ "$SHELL" == *bash ]]; then
    echo "Your current shell is bash"
else
    command -v bash | sudo tee -a /etc/shells
    chsh -s "$(command -v bash)"
fi

if [ -d "$HOME/.setup" ]; then
    echo "$HOME/.setup already exists, to upgrade, run upgrade_set_up command"
    return
else
    git clone $SETUP_REPO "$HOME/.setup"
fi

if [ -f "$HOME/.setuprc" ]; then
    echo "$HOME/.setuprc already exists"
else
    cp "$HOME/.setup/.setuprc" "$HOME/"
fi

case $OSTYPE in
darwin*)
    BASH_PROFILE="$HOME/.bash_profile"
    ;;
*)
    BASH_PROFILE="$HOME/.bashrc"
    ;;
esac

if grep -q ".setup/setup.bash" "$BASH_PROFILE"; then
    echo "You've already enabled setup"
else
    # write empty line first
    echo >>"$BASH_PROFILE"
    # shellcheck disable=SC2016
    echo 'test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"' >>"$BASH_PROFILE"
    echo "setup done, restart your terminal!!"
fi

source "$BASH_PROFILE"
