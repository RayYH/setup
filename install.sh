#!/usr/bin/env bash
WORKING_DIR=$(dirname "${BASH_SOURCE[0]}")
WORKING_DIR=$(cd "$WORKING_DIR" && pwd)

SETUP_REPO="https://github.com/RayYH/setup"

if ! command -v git &>/dev/null; then
    echo "git not found!"
    exit
fi

if [[ "$SHELL" == *bash ]]; then
    echo "Your current shell is bash"
else
    [ -x "/bin/bash" ] && chsh -s /bin/bash
    [ -x "/usr/local/bin/bash" ] && chsh -s /usr/local/bin/bash
fi

if [ -d "$HOME/.setup" ]; then
    echo "$HOME/.setup already exists, to upgrade, run upgrade_set_up command"
    exit
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
    # shellcheck disable=SC2016
    echo 'test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"' >>"$BASH_PROFILE"
fi

source "$BASH_PROFILE"
