#!/usr/bin/env bash

# determine if command exists
function command_exists() {
  type "$1" &>/dev/null
}

# determine if cask installed
function cask_installed() {
  brew info --cask "$1" | grep "$1" &>/dev/null
}

# determine if formula installed
function formula_installed() {
  brew info "$1" | grep "$1" &>/dev/null
}
