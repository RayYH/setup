#!/usr/bin/env bash

if [ -z "$SET_UP" ]; then
    export SET_UP="$(cd "$(dirname "$0")" && pwd)"
fi

if [ -z "$SET_UP_BACKUP" ]; then
    export SET_UP_BACKUP="$SET_UP/backup"
fi

if [[ -z "$SET_UP_CUSTOM" ]]; then
    SET_UP_CUSTOM="$SET_UP/custom"
fi

if [[ -z "$SET_UP_CONFIG_FILE" ]]; then
    SET_UP_CONFIG_FILE="$SET_UP/.setuprc"
fi

[ ! -f "SET_UP_CONFIG_FILE" ] && SET_UP_CONFIG_FILE="$SET_UP/.setuprc"

#####################################################
# TODO: load essentials

# Load helper
[ -f "$SET_UP/helper.sh" ] && source "$SET_UP/helper.bash"

# Load configurations
[ -f "$SET_UP_CONFIG_FILE" ] && source "$SET_UP_CONFIG_FILE" 2>/dev/null

#####################################################
# Load themes
SET_UP_THEME=${SET_UP_THEME:=agnoster}
FALLBACK_SET_UP_THEME=${FALLBACK_SET_UP_THEME:=dotfiles}

# themes only used inside iTerm2
ONLY_IN_ITERM2=(
    "agnoster"
)

# use $TERM_PROGRAM to check whether is in Terminal.app or in iTerm2
if [ "iTerm.app" != "$TERM_PROGRAM" ]; then
    # only inside iTerm, enable the provided theme
    for iterm2_theme in "${ONLY_IN_ITERM2[@]}"; do
        # the theme only for iTerm2 should be switched to dotfiles theme
        [[ "$SET_UP_THEME" == "$iterm2_theme" ]] && export SET_UP_THEME="$FALLBACK_SET_UP_THEME"
    done
fi

# load utils
source "$SET_UP/themes/colors.bash"
source "$SET_UP/themes/git.bash"
source "$SET_UP/themes/base.bash"

if is_theme "$SET_UP_CUSTOM" "$SET_UP_THEME"; then
    source "$SET_UP_CUSTOM/themes/$SET_UP_THEME/$SET_UP_THEME.theme.bash"
else
    if is_theme "$SET_UP" "$SET_UP_THEME"; then
        source "$SET_UP/themes/$SET_UP_THEME/$SET_UP_THEME.theme.bash"
    fi
fi
