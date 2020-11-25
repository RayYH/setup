#!/usr/bin/env bash

# setting brew mirror, see https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
# use brew mirror is not suggested, pleas use proxy as soon as possible
function set_brew_mirror() {
  pw_d=$(pwd)
  local mirror=${SET_UP_BREW_MIRROR:="https://mirrors.tuna.tsinghua.edu.cn"}
  git -C "$(brew --repo)" remote set-url origin "$mirror"/git/homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin "$mirror"/git/homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin "$mirror"/git/homebrew/homebrew-cask.git
  git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin "$mirror"/git/homebrew/homebrew-cask-fonts.git
  git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin "$mirror"/git/homebrew/homebrew-cask-drivers.git
  cd "${pw_d}" || return
}

function reset_brew_mirror() {
  pw_d=$(pwd)
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
  git -C "$(brew --repo homebrew/cask-fonts)" remote set-url origin https://github.com/Homebrew/homebrew-cask-fonts.git
  git -C "$(brew --repo homebrew/cask-drivers)" remote set-url origin https://github.com/Homebrew/homebrew-cask-drivers.git
  cd "${pw_d}" || return
}

# setting Composer mirror, see https://developer.aliyun.com/composer
function set_composer_mirror() {
  local mirror=${SET_UP_COMPOSER_MIRROR:="https://mirrors.aliyun.com/composer/"}
  composer config -g repo.packagist composer $mirror
}

function reset_composer_mirror() {
  composer config -g --unset repos.packagist
}

# setting npm mirror, see https://npm.taobao.org/
function set_npm_mirror() {
  local mirror=${SET_UP_NPM_MIRROR:="https://registry.npm.taobao.org"}
  npm config set registry=$mirror
}

function reset_npm_mirror() {
  npm config delete registry
}

# setting yarn mirror
function set_yarn_mirror() {
  local mirror=${SET_UP_YARN_MIRROR:="https://registry.npm.taobao.org"}
  yarn config set registry $mirror
}

function reset_yarn_mirror() {
  yarn config delete registry
}
