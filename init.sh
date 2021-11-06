#!/usr/bin/env bash

SCRIPT_PATH="$(
    cd -- "$(dirname "$0")" || exit >/dev/null 2>&1
    pwd -P
)"
WORKING_DIR="$SCRIPT_PATH"

# load helpers
source "$WORKING_DIR/init/helper.bash"
source "$WORKING_DIR/init/logger.bash"
source "$WORKING_DIR/init/packages.bash"

info "This script will setup your macos development environment, please be patient (some script will need root privileges)..."

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
