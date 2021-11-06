#!/usr/bin/env bash

end="\033[0m"
black="\033[0;30m"
red="\033[0;31m"
yellow="\033[0;33m"
blue="\033[0;34m"

function black() {
  echo -e "${black}${1}${end}"
}

function red() {
  echo -e "${red}${1}${end}"
}

function yellow() {
  echo -e "${yellow}${1}${end}"
}

function blue() {
  echo -e "${blue}${1}${end}"
}

function info() {
  black "$1"
}

function warning() {
  yellow "$1"
}

function success() {
  blue "$1"
}

function error() {
  red "$1"
}
