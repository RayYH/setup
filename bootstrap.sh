#!/usr/bin/env bash

# Configuration
export S_TIME_ZONE="Asia/Shanghai"
if [[ $(uname -m) == 'arm64' ]]; then
    export S_COMPUTER_NAME="$USER-M1-MBP"
else
    export S_COMPUTER_NAME="$USER-MBP"
fi
export S_GATEKEEPER_DISABLE="Yes"
export S_DEFAULT_PASSPHRASE=""
export S_UPGRADE="${S_UPGRADE:-1}"
export S_CLEANUP="${S_CLEANUP:-1}"

if [ -n "${S_ONLY_UPDATE+1}" ]; then
    S_UPGRADE=1
fi

################################################################################
# helper functions
################################################################################

function __echo() {
    local fmt="$1"
    shift
    # shellcheck disable=SC2059
    printf "\\n[INFO] $fmt\\n" "$@"
}

function __error() {
    local fmt="$1"
    shift
    # shellcheck disable=SC2059
    printf "\\n[ERROR] $fmt\\n" "$@"
    exit 1
}

function __done() {
    __echo "Step $1 \\e[0;32m[✔]\\e[0m"
}

# determine if command exists
function __command_exists() {
    command -v "$1" &>/dev/null
}

# install formula via brew
function __install_formula() {
    if brew list "$1" &>/dev/null; then
        __echo "$1 exists"
        if [[ "$S_UPGRADE" -eq "1" ]]; then
            __echo "update $1 via brew"
            brew upgrade "$1"
        fi
    else
        brew install "$1"
    fi
}

# install cask via brew
function __install_cask() {
    if brew list --cask "$1" &>/dev/null; then
        __echo "$1 exists"
        if [[ "$S_UPGRADE" -eq "1" ]]; then
            __echo "update $1 via brew"
            brew upgrade --cask "$1"
        fi
    else
        brew install --cask "$1"
    fi
}

################################################################################
# Detect if running on mac
################################################################################
if [ "$(uname)" != "Darwin" ]; then
    __error "Oops, this script only supports macOS."
fi

################################################################################
# Detect if network is fine
################################################################################
if ! ping -q -c 1 -W 1 google.com >/dev/null; then
    __error "Oops, cannot visit google site, please configure your proxy settings"
fi

################################################################################
# Welcome and setup
################################################################################
printf '\n'
printf '************************************************************************\n'
printf '*******                                                           ******\n'
printf '*******                 Welcome to Mac Bootstrap!                 ******\n'
printf '*******                                                           ******\n'
printf '************************************************************************\n'
printf '\n'

sudo -v

# Authenticate
if ! sudo -nv &>/dev/null; then
    printf 'Before we get started, we need to have sudo access\n'
    printf 'Enter your password (for sudo access):\n'
    sudo /usr/bin/true
    # Keep-alive: update existing `sudo` time stamp until bootstrap has finished
    while true; do
        sudo -n /usr/bin/true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
fi

set -e

step=1

################################################################################
# Set the timezone
################################################################################
function __set_timezone() {
    __echo "Step $step: Set the timezone to $S_TIME_ZONE"
    sudo systemsetup -settimezone "$S_TIME_ZONE" >/dev/null
    __done "$((step++))"
}
[ -n "${S_ONLY_UPDATE+1}" ] || __set_timezone

################################################################################
# Set the timezone
################################################################################

function __set_computer_name() {
    __echo "Step $step: Set computer name to $S_COMPUTER_NAME"
    sudo scutil --set ComputerName "$S_COMPUTER_NAME"
    sudo scutil --set HostName "$S_COMPUTER_NAME"
    sudo scutil --set LocalHostName "$S_COMPUTER_NAME"
    __done "$((step++))"
}
[ -z ${S_SET_COMPUTER_NAME+x} ] || __set_computer_name

################################################################################
# Install Apple's Command Line Tools
################################################################################
function __install_apple_command_line_tools() {
    if command -v xcode-select >&- && xpath=$(xcode-select --print-path) &&
        test -d "${xpath}" && test -x "${xpath}"; then
        __echo "Step $step: Apple's command line tools are already installed."
    else
        __echo "Step $step: Installing Apple's command line tools"
        xcode-select --install
        while ! command -v xcode-select >&-; do
            sleep 60
        done
    fi
    __done "$((step++))"
}
[ -n "${S_ONLY_UPDATE+1}" ] || __install_apple_command_line_tools

################################################################################
# Gatekeeper
################################################################################
function __set_gatekeeper() {
    __echo "Step $step: Disable or enable Gatekeeper control"
    if [[ $S_GATEKEEPER_DISABLE =~ Yes ]]; then
        sudo spctl --master-disable
    else
        sudo spctl --master-enable
    fi
    __done "$((step++))"
}
[ -n "${S_ONLY_UPDATE+1}" ] || __set_gatekeeper

################################################################################
# Homebrew
################################################################################
function __ensure_brew() {
    __echo "Step $step: Ensuring Homebrew is installed and updated"
    if ! command -v brew >/dev/null; then
        __echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    export PATH="/usr/local/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
    brew update
    [[ "$S_UPGRADE" -eq "1" ]] && brew upgrade
    [[ "$S_CLEANUP" -eq "1" ]] && brew cleanup
    __done "$((step++))"
}
__ensure_brew

################################################################################
# disable brew analytics
################################################################################
function __disable_brew_analytics() {
    __echo "Step $step: Disable Homebrew analytics"
    if [ "$(brew analytics)" != "Analytics are disabled." ]; then
        brew analytics off
    fi
    __done "$((step++))"
}
[ -n "${S_ONLY_UPDATE+1}" ] || __disable_brew_analytics

#============================================================
# install curl and bash first
#============================================================
function __bash_and_curl() {
    __echo "Step $step: install bash and curl"
    declare -a frs=(
        "bash"
        "bash-completion@2"
        "curl"
    )
    for i in "${frs[@]}"; do
        __install_formula "$i"
    done
    unset frs
    export HOMEBREW_FORCE_BREWED_CURL=1
    __done "$((step++))"
}
__bash_and_curl

################################################################################
# dotfiles
################################################################################
function __install_setup() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"
}

function __setup() {
    __echo "Step $step: Install setup..."
    __install_setup
    if __command_exists "sync_set_up_configs"; then
        yes | sync_set_up_configs
    else
        __echo "please run sync_set_up_configs command manually"
    fi
    __done "$((step++))"
}

[ -n "${S_ONLY_UPDATE+1}" ] || __setup

#============================================================
# install common formulas first
#============================================================
function __formulas() {
    declare -a frs=(
        "ack"
        "autojump"
        "coreutils"
        "curl"
        "findutils"
        "gawk"
        "git"
        "gnu-sed"
        "gnupg"
        "grep"
        "imagemagick"
        "jq"
        "qemu"
        "qt"
        "shellcheck"
        "telnet"
        "tmux"
        "tree"
        "vim"
        "wget"
        "make"
        "mysql-client"
        "git-delta" # https://github.com/dandavison/delta
        "viu"       # https://github.com/atanunq/viu
    )
    for i in "${frs[@]}"; do
        __install_formula "$i"
    done
    unset frs

    __install_formula "fzf"
    yes | /bin/bash "$(brew --prefix)"/opt/fzf/install &>/dev/null
    # load this file in setup.bash
    [ -f "$HOME/.bashrc" ] && /usr/bin/sed -i '' '/fzf\.bash/d' "$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && /usr/bin/sed -i '' '/fzf\.zsh/d' "$HOME/.zshrc"
}
__formulas

#============================================================
# tap 3rd repos
#============================================================
function __taps() {
    __echo "Step $step: add 3rd repos via bre tap"
    declare -a taps=(
        "homebrew/cask-versions"
        "dart-lang/dart"
        "ringohub/redis-cli"
        "shivammathur/php"
    )
    for i in "${taps[@]}"; do
        brew tap "$i"
    done
    unset taps
    __done "$((step++))"
}
__taps

#============================================================
# Other GUIs
#============================================================
function __casks() {
    __echo "Step $step: install some casks"
    declare -a guis=(
        "anki"
        "vlc"
        "raycast"
        "google-chrome"
        "chromedriver"
        "obsidian"
        "kitty"
        "the-unarchiver"
        "postman"
        "jetbrains-toolbox"
        "iTerm2"    # https://github.com/gnachman/iTerm2
        "flameshot" # https://github.com/flameshot-org/flameshot
        "hiddenbar" # https://github.com/dwarvesf/hidden
        "keycastr"  # https://github.com/keycastr/keycastr
        "multipass" # https://github.com/canonical/multipass
        "visual-studio-code"
    )
    for i in "${guis[@]}"; do
        __install_cask "$i"
    done
    unset guis
    __done "$((step++))"
}
[ -z ${S_CASKS+x} ] || __casks

################################################################################
# rust
################################################################################
function __rust() {
    __echo "Step $step: setup rust development"
    if ! __command_exists rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    rustup update
    if [ -d "$HOME/.cargo/bin" ]; then
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    cargo install -- cargo-outdated
    cargo install -- cargo-release
    __done "$((step++))"
}
__rust

################################################################################
# php
################################################################################
function __install_pecl_package() {
    if php -m | grep "$1" &>/dev/null; then
        __echo "pecl package $1 exists"
        if [ "$S_UPGRADE" -eq "1" ]; then
            __echo "update $1 via pecl"
            pecl upgrade "$1"
        fi
    else
        pecl install "$1"
    fi
}

function __php() {
    __echo "Step $step: setup php development: php, composer, pecl ..."
    __install_formula "php"
    __install_formula "composer"
    if __command_exists pecl; then
        pecl update-channels
        pecl upgrade
        [ -d "$(pecl config-get ext_dir)" ] || mkdir -p "$(pecl config-get ext_dir)"
        # yes | __install_pecl_package "igbinary"
        # yes | __install_pecl_package "redis" # redis needs it
        # yes | __install_pecl_package "xdebug"
        # __echo "please run php --ini to check if your php.ini file contains duplicated configuration entries"
    fi
    __done "$((step++))"
}
__php

################################################################################
# python
################################################################################
function __install_pip_package() {
    if pip3 list | grep -F "$1" &>/dev/null; then
        __echo "pip3 package $1 exists"
        if [ "$S_UPGRADE" -eq "1" ]; then
            __echo "update $1 via pip3"
            pip3 install -U "$1" --upgrade
        fi
    else
        pip3 install -U "$1"
    fi
}

function __python() {
    __echo "Step $step: setup python development: python3, yapf, flake8, pytest ..."
    __install_formula "python3"
    python3 -m pip install --upgrade pip
    declare -a pkgs=(
        "yapf"
        "flake8"
        "pytest"
    )
    for i in "${pkgs[@]}"; do
        __install_pip_package "$i"
    done
    __done "$((step++))"
}
__python

################################################################################
# build tools
################################################################################
function __build() {
    __echo "Step $step: setup build tools..."
    __install_formula "nasm"
    __install_formula "cmake"
    __done "$((step++))"
}
__build

################################################################################
# go
################################################################################
function __go() {
    __echo "Step $step: setup go ..."
    __install_formula "go"
    __done "$((step++))"
}
__go

################################################################################
# java
################################################################################
function __java() {
    __echo "Step $step: setup java ..."
    __install_formula "gradle"
    __install_formula "kotlin"
    __install_formula "maven"
    # m1 cannot install java8 runtime
    __install_cask "temurin8"
    __done "$((step++))"
}
__java

################################################################################
# lua
################################################################################
function __lua() {
    __echo "Step $step: setup lua..."
    __install_formula "lua"
    __done "$((step++))"
}
__lua

################################################################################
# asdf
################################################################################
function __install_asdf_plugin() {
    local name="$1"
    local url="$2"

    if ! asdf plugin-list | grep -Fq "$name"; then
        asdf plugin-add "$name" "$url"
    fi
}

function __install_asdf_language() {
    local language="$1"
    local version="$2"
    asdf install "$language" "$version"
    asdf global "$language" "$version"
}

function __install_global_node_modules() {
    if __command_exists "npm"; then
        npm update -g "$1"
    else
        npm install --global "$1"
    fi
}

function __asdf() {
    __echo "Step $step: setup asdf and nodejs..."
    __install_formula "asdf"
    [ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh" ] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
    [[ "$S_UPGRADE" -eq "1" ]] && [ -f "$HOME/.asdf/bin/asdf" ] && "$HOME/.asdf/bin/asdf" update
    [[ "$S_UPGRADE" -eq "1" ]] && [ -f "$HOME/.asdf/bin/asdf" ] && "$HOME/.asdf/bin/asdf" plugin-update --all

    # install nodejs plugin
    __install_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

    # install latest nodejs version
    __install_asdf_language "nodejs" "latest"

    __echo "Node --> $(command -v node)"
    node -v
    __echo "NPM --> $(command -v npm)"
    npm -v
    __echo "Installing default npm packages..."

    __install_global_node_modules "typescript"
    __install_global_node_modules "http-server"
    __install_global_node_modules "yarn"
    __done "$((step++))"
}
__asdf

################################################################################
# ql plugins
################################################################################
function __ql_plugins() {
    __echo "Step $step: install quicklook plugins"
    declare -a qps=(qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv webpquicklook suspicious-package webpquicklook)
    for i in "${qps[@]}"; do
        __install_cask "$i"
    done
    unset qps
    __done "$((step++))"
}
__ql_plugins

################################################################################
# preferences
################################################################################
function __preferences() {
    __echo "Step $step: Setting macOS preferences..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/macos-defaults.sh)"
    __done "$((step++))"
}
[ -n "${S_ONLY_UPDATE+1}" ] || __preferences

################################################################################
# workspaces
################################################################################
function __workspace() {
    __echo "Step $step: setup workspace..."
    CODE_DIR="$HOME/Code"
    [ -d "$CODE_DIR" ] || mkdir -p "$CODE_DIR"
    declare -a dirs=(
        "c"
        "cpp"
        "go"
        "gopath" # for GOPATH
        "java"
        "python"
        "javascript"
        "php"
        "rust"
        "shell"
        "work"
    )
    for i in "${dirs[@]}"; do
        [ -d "$CODE_DIR/$i" ] || mkdir -p "$CODE_DIR/$i"
    done
    __done "$((step++))"
}

[ -n "${S_ONLY_UPDATE+1}" ] || __workspace

################################################################################
# End
################################################################################
printf '\n'
printf '************************************************************************\n'
printf '****                                                              ******\n'
printf '**** Mac Bootstrap complete! Please restart your computer.        ******\n'
printf '****                                                              ******\n'
printf '************************************************************************\n'
printf '\n'
