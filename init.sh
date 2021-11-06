#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

SCRIPT_PATH="$(
    cd -- "$(dirname "$0")" || exit >/dev/null 2>&1
    pwd -P
)"
WORKING_DIR="$(dirname "$SCRIPT_PATH")"

echo "$WORKING_DIR"

# load helpers
source "$WORKING_DIR/init/common.bash"
source "$WORKING_DIR/init/logger.bash"
source "$WORKING_DIR/init/packages.bash"

info "this script will setup your macos (need root privileges)"

# xcode-select
sudo xcode-select --install 2 &>/dev/null

# install brew formulas and packages
install_brew
init_php_development
init_python_development
init_js_development
init_cpp_development
init_go_development
install_quick_plugins



#install_guis
