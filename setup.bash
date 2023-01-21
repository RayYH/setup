#!/usr/bin/env bash

WORKING_DIR=$(dirname "${BASH_SOURCE[0]}")
WORKING_DIR=$(cd "$WORKING_DIR" && pwd)

# Set the `SET_UP`, `SET_UP_BACKUP`, `SET_UP_CUSTOM` envs safely
[ -z "$SET_UP" ] && export SET_UP="$WORKING_DIR"
[ -z "$SET_UP_BACKUP" ] && export SET_UP_BACKUP="$SET_UP/backup"

# Set the configuration file
SET_UP_CONFIG_FILE="$HOME/.setuprc"
# If configuration file not exist, use the default configuration template file
[ ! -f "$SET_UP_CONFIG_FILE" ] && SET_UP_CONFIG_FILE="$SET_UP/.setuprc"
# Load configuration file
[ -f "$SET_UP_CONFIG_FILE" ] && source "$SET_UP_CONFIG_FILE" 2>/dev/null

source "$SET_UP"/profile/env.bash
source "$SET_UP"/profile/aliases.bash
[ -f "$SET_UP/profile/$USER.bash" ] && source "$SET_UP/profile/$USER.bash"
[ -f "$SET_UP"/profile/custom.bash ] && source "$SET_UP"/profile/custom.bash
source "$SET_UP"/profile/completions.bash
source "$SET_UP"/profile/functions.bash
source "$SET_UP"/profile/plugins.bash
if command -v starship >/dev/null; then
  # if starship is installed
  eval "$(starship init bash)"
else
  source "$SET_UP"/profile/prompt.bash
fi

# Change additional shell optional behavior
# -s (set) -u (unset)
# http://www.hep.by/gnu/bash/The-Shopt-Builtin.html#The-Shopt-Builtin
# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Append to the Bash history file, rather than overwriting it
shopt -s histappend
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Enable some Bash 4 features when possible:
# `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
  shopt -s "$option" 2>/dev/null
done

# Set git configurations
if [ -n "$GIT_AUTHOR_NAME" ] && [ "$GIT_AUTHOR_NAME" != " " ]; then
  git config --global user.name "$GIT_AUTHOR_NAME"
fi

if [ -n "$GIT_AUTHOR_EMAIL" ] && [ "$GIT_AUTHOR_EMAIL" != " " ]; then
  git config --global user.email "$GIT_AUTHOR_EMAIL"
fi

if [ -n "$GIT_SIGNING_KEY" ] && [ "$GIT_SIGNING_KEY" != " " ]; then
  git config --global commit.gpgsign true &&
    git config --global user.signingkey "$GIT_SIGNING_KEY"
fi
