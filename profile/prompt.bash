#!/usr/bin/env bash

# Thanks @paulirish @mathiasbynens
# https://github.com/mathiasbynens/dotfiles
# https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123

if infocmp -a xterm-kitty >/dev/null 2>&1; then
  export TERM='xterm-kitty'
elif [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

prompt_git() {
  local s=''
  local branchName=''
  local hasManyCommits=0
  local repoUrlsOfManyCommits=${REPO_URLS_OF_MANY_COMMITS:='group/many-commits.git'}

  # Check if the current directory is in a Git repository.
  git rev-parse --is-inside-work-tree &>/dev/null || return

  # Check for what branch we’re on.
  # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
  # tracking remote branch or tag. Otherwise, get the
  # short SHA for the latest commit, or give up.
  branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
    git describe --all --exact-match HEAD 2>/dev/null ||
    git rev-parse --short HEAD 2>/dev/null ||
    echo '(unknown)')"

  repoUrl="$(git config --get remote.origin.url)"

  for i in "${repoUrlsOfManyCommits[@]}"; do
    if grep -q "$i" <<<"${repoUrl}"; then
      hasManyCommits=1
    fi
  done

  if [ "$hasManyCommits" -eq "1" ]; then
    s+='*'
  else
    # Check for uncommitted changes in the index.
    if ! git diff --quiet --ignore-submodules --cached; then
      s+='+'
    fi
    # Check for unstaged changes.
    if ! git diff-files --quiet --ignore-submodules --; then
      s+='!'
    fi
    # Check for untracked files.
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
      s+='?'
    fi
    # Check for stashed files.
    if git rev-parse --verify refs/stash &>/dev/null; then
      s+='$'
    fi
  fi

  [ -n "${s}" ] && s=" [${s}]"

  echo -e "${1}${branchName}${2}${s}"
}

# 配色
# shellcheck disable=SC2034
if tput setaf 1 &>/dev/null; then
  tput sgr0
  bold=$(tput bold)
  reset=$(tput sgr0)
  black=$(tput setaf 0)
  blue=$(tput setaf 33)
  cyan=$(tput setaf 37)
  green=$(tput setaf 64)
  orange=$(tput setaf 166)
  purple=$(tput setaf 125)
  red=$(tput setaf 124)
  violet=$(tput setaf 61)
  white=$(tput setaf 15)
  yellow=$(tput setaf 136)
else
  bold=''
  reset="\e[0m"
  black="\e[1;30m"
  blue="\e[1;34m"
  cyan="\e[1;36m"
  green="\e[1;32m"
  orange="\e[1;33m"
  purple="\e[1;35m"
  red="\e[1;31m"
  violet="\e[1;35m"
  white="\e[1;37m"
  yellow="\e[1;33m"
fi

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
  userStyle="${red}"
else
  userStyle="${cyan}"
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
  hostStyle="${bold}${red}"
else
  hostStyle="${cyan}"
fi

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"
PS1+="\[${bold}\]\n"
# conda
if [ -n "${CONDA_DEFAULT_ENV}" ]; then
  PS1+="\[${green}\](\$(basename \$CONDA_DEFAULT_ENV)) "
fi
PS1+="\[${userStyle}\]\u"
PS1+="\[${white}\] at "
PS1+="\[${hostStyle}\]\h"
PS1+="\[${white}\] in "
PS1+="\[${green}\]\w"
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"
PS1+=$'\n'
PS1+="\[${white}\]\$ \[${reset}\]"
export PS1
PS2="\[${cyan}\]→ \[${reset}\]"
export PS2
