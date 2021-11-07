#!/usr/bin/env bash

#============================================================
# HomeBrew and helpers
#============================================================
function install_brew() {
  if command_exists brew; then
    warning "brew already installed"
    info "update brew..."
    brew update
    info "upgrade all outdated packages..."
    brew upgrade
    info "cleanup"
    brew cleanup
  else
    info "installing brew now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
}

function install_formula() {
  if brew list "$1" &>/dev/null; then
    warning "$1 exists"
    warning "update $1 via brew"
    brew upgrade "$1"
  else
    brew install "$1"
  fi
}

function install_cask() {
  if brew list --cask "$1" &>/dev/null; then
    warning "$1 exists"
    warning "update $1 via brew"
    brew upgrade --cask "$1"
  else
    brew install --cask "$1"
  fi
}

#============================================================
# PHP Development
#============================================================
function install_pecl_package() {
  if php -m | grep "$1" &>/dev/null; then
    warning "pecl package $1 exists"
    warning "update $1 via pecl"
    pecl upgrade "$1"
  else
    pecl install "$1"
  fi
}

function init_php_development() {
  install_formula "php"
  install_formula "composer"
  pecl update-channels
  pecl upgrade
  yes | install_pecl_package "ds"
  yes | install_pecl_package "redis"
  yes | install_pecl_package "xdebug"
  yes | install_pecl_package "swoole"
  success "please run php --ini to remove some duplicated configurations inside your php.ini file"
}

#============================================================
# Python Development
#============================================================
function uninstall_all_packages_installed_by_pip() {
  pip3 freeze | xargs pip3 uninstall -y
}

function install_pip_package() {
  if pip3 list | grep -F "$1" &>/dev/null; then
    warning "pip3 package $1 exists"
    warning "update $1 via pip3"
    pip3 install "$1" --upgrade
  else
    pip3 install "$1"
  fi
}

function init_python_development() {
  install_formula "python3"
  python3 -m pip install --upgrade pip
  install_pip_package virtualenv
}

#============================================================
# Node and frontend Development
#============================================================
function install_nvm() {
  if command -v nvm &>/dev/null; then
    warning "nvm exists"
    warning "update nvm"
  fi
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
}

function install_global_node_modules() {
  if command_exists yarn; then
    npm update -g yarn
  else
    npm install --global yarn
  fi
}

function init_js_development() {
  install_nvm
  if ! command -v nvm &>/dev/null; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
  fi
  nvm install node --latest-npm  # latest version
  nvm install --lts --latest-npm # lts version
  install_global_node_modules
}

#============================================================
# C/C++ Development
#============================================================
function init_cpp_development() {
  install_formula "cmake"
}

#============================================================
# Go Development
#============================================================
function init_go_development() {
  install_formula "go"
}

#============================================================
# Some quick view plugins
#============================================================
function install_quick_plugins() {
  declare -a qps=(qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv webpquicklook suspicious-package)
  for i in "${qps[@]}"; do
    install_cask "$i"
  done
  unset qps
}

#============================================================
# Some formulas
#============================================================
function install_formulas() {
  declare -a frs=(
    "docker-compose"
    "tree"
    "ack"
  )
  for i in "${frs[@]}"; do
    install_formula "$i"
  done
  unset frs
}

#============================================================
# Other GUIs
#============================================================
function install_guis() {
  declare -a guis=(
    "1password"
    "anki"
    "baidunetdisk"
    "vlc"
    "lulu"
    "teamviewer"
    "raindropio"
    "raycast"
    "google-chrome"
    "docker"
    "obsidian"
    "tencent-meeting"
    "wechat"
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
    install_cask "$i"
  done
  unset guis
}
