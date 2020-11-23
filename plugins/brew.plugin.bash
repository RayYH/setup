#!/usr/bin/env bash

# update brew packages
function update_brew_packages() {
    brew update
    brew upgrade
    brew cleanup
}
