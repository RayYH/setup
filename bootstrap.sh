#!/usr/bin/env bash

# Configuration
export S_TIME_ZONE="Asia/Shanghai"
export S_COMPUTER_NAME="Ray-M1-MBP"
export S_GATEKEEPER_DISABLE="Yes"
export S_DEFAULT_PASSPHRASE=""
export S_UPGRADE="${S_UPGRADE:-1}"
export S_CLEANUP="${S_CLEANUP:-1}"

# essential steps
declare -a OPTIONAL_STEPS=(
    "__set_timezone"
    "__install_apple_command_line_tools"
    "__set_gatekeeper"
    "__php"
    "__ensure_brew"
    "__disable_brew_analytics"
    "__rust"
    "__python"
    "__build"
    "__go"
    "__java"
    "__lua"
    "__ql_plugins"
    "__formulas"
    "__setup"
)

# optional steps
[ -z ${S_SET_COMPUTER_NAME+x} ] || OPTIONAL_STEPS=("__set_computer_name" "${OPTIONAL_STEPS[@]}")

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
        if [ "$S_UPGRADE" -eq "1" ]; then
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
        if [ "$S_UPGRADE" -eq "1" ]; then
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
if ! wget -q --spider https://google.com; then
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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __set_timezone " ]] && __set_timezone

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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __set_computer_name " ]] && __set_computer_name

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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __install_apple_command_line_tools " ]] && __install_apple_command_line_tools

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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __set_gatekeeper " ]] && __set_gatekeeper

################################################################################
# Homebrew
################################################################################
function __ensure_brew() {
    __echo "Step $step: Ensuring Homebrew is installed and updated"
    if ! command -v brew >/dev/null; then
        __echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        export PATH="/usr/local/bin:$PATH"
    fi
    brew update
    [[ "$S_UPGRADE" -eq "1" ]] && brew upgrade
    [[ "$S_CLEANUP" -eq "1" ]] && brew cleanup
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __ensure_brew " ]] && __ensure_brew

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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __disable_brew_analytics " ]] && __disable_brew_analytics

################################################################################
# rust
################################################################################
function __rust() {
    __echo "Step $step: setup rust development"
    if ! __command_exists rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
    if [ -d "$HOME/.cargo/bin" ]; then
        export PATH="$HOME/.cargo/bin:$PATH"
    fi
    cargo install -- cargo-outdated
    cargo install -- cargo-release
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __rust " ]] && __rust

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
        yes | __install_pecl_package "ds"
        yes | __install_pecl_package "redis"
        yes | __install_pecl_package "xdebug"
        yes | __install_pecl_package "swoole"
        __echo "please run php --ini to check if your php.ini file contains duplicated configuration entries"
    fi
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __php " ]] && __php

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
[[ " ${OPTIONAL_STEPS[*]} " =~ " __python " ]] && __python

################################################################################
# build tools
################################################################################
function __build() {
    __echo "Step $step: setup build tools..."
    __install_formula "nasm"
    __install_formula "make"
    __install_formula "cmake"
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __build " ]] && __build

################################################################################
# go
################################################################################
function __go() {
    __echo "Step $step: setup go ..."
    __install_formula "go"
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __go " ]] && __go

################################################################################
# java
################################################################################
function __java() {
    __echo "Step $step: setup java ..."
    __install_formula "gradle"
    __install_formula "kotlin"
    __install_formula "maven"
    __install_formula "openjdk@8"
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __java " ]] && __java

################################################################################
# lua
################################################################################
function __lua() {
    __echo "Step $step: setup lua..."
    __install_formula "lua"
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __lua " ]] && __lua

################################################################################
# ql plugins
################################################################################
function __ql_plugins() {
    __echo "Step $step: install quicklook plugins"
    declare -a qps=(qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv webpquicklook suspicious-package)
    for i in "${qps[@]}"; do
        __install_cask "$i"
    done
    unset qps
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __ql_plugins " ]] && __ql_plugins

#============================================================
# Other formulas
#============================================================
function __formulas() {
    declare -a frs=(
        "ack"
        "autojump"
        "bash"
        "bash-completion@2"
        "coreutils"
        "curl"
        "emacs"
        "findutils"
        "gawk"
        "gh"
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
    )
    for i in "${frs[@]}"; do
        __install_formula "$i"
    done
    unset frs

    __install_formula "fzf"
    yes | . "$(brew --prefix)"/opt/fzf/install
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __formulas " ]] && __formulas

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
        "docker"
        "obsidian"
        "thunderbird"
        "wireshark"
        "foxmail"
        "onedrive"
        "virtualbox"
        "the-unarchiver"
        "postman"
        "jetbrains-toolbox"
        "iTerm2"
        "keepassxc"
    )
    for i in "${guis[@]}"; do
        __install_cask "$i"
    done
    unset guis
    __done "$((step++))"
}
[[ " ${OPTIONAL_STEPS[*]} " =~ " __casks " ]] && __casks

################################################################################
# dotfiles
################################################################################
function __setup() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"
}

[[ " ${OPTIONAL_STEPS[*]} " =~ " __setup " ]] && __setup

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
