#!/usr/bin/env bash

if [ -z "$SETUP" ]; then
    export SETUP="$(cd "$(dirname "$0")" && pwd)"
fi

if [ -z "$SETUP_BACKUP" ]; then
    export SETUP_BACKUP="$SETUP/backup"
fi

if [[ -z "$SETUP_CUSTOM" ]]; then
    SETUP_CUSTOM="$SETUP/custom"
fi

if [[ -z "$SETUP_CONFIG_FILE" ]]; then
    SETUP_CONFIG_FILE="$SETUP/.setuprc"
fi

#####################################################
# TODO: load essentials

# Load helper
[ -f "$SETUP/helper.sh" ] && source "$SETUP/helper.sh"

# Load configurations
[ -f "$SETUP_CONFIG_FILE" ] && source "$SETUP_CONFIG_FILE" 2>/dev/null

#####################################################
# Load themes
SETUP_THEME=${SETUP_THEME:=agnoster}
FALLBACK_SETUP_THEME=${FALLBACK_SETUP_THEME:=dotfiles}

# themes only used inside iTerm2
ONLY_IN_ITERM2=(
    "agnoster"
)

# use $TERM_PROGRAM to check whether is in Terminal.app or in iTerm2
if [ "iTerm.app" != "$TERM_PROGRAM" ]; then
    # only inside iTerm, enable the provided theme
    for iterm2_theme in "${ONLY_IN_ITERM2[@]}"; do
        # the theme only for iTerm2 should be switched to dotfiles theme
        [[ "$SETUP_THEME" == "$iterm2_theme" ]] && export SETUP_THEME="$FALLBACK_SETUP_THEME"
    done
fi

# load utils
source "$SETUP/themes/colors.bash"
source "$SETUP/themes/git.bash"
source "$SETUP/themes/base.bash"

if is_theme "$SETUP_CUSTOM" "$SETUP_THEME"; then
    source "$SETUP_CUSTOM/themes/$SETUP_THEME/$SETUP_THEME.theme.bash"
else
    if is_theme "$SETUP" "$SETUP_THEME"; then
        source "$SETUP/themes/$SETUP_THEME/$SETUP_THEME.theme.bash"
    fi
fi
