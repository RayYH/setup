#!/usr/bin/env bash
WORKING_DIR=$(dirname "${BASH_SOURCE[0]}")
WORKING_DIR=$(cd "$WORKING_DIR" && pwd)

if [ -z "$SET_UP" ]; then
    export SET_UP="$WORKING_DIR"
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

# Load helper
[ -f "$SET_UP/helper.bash" ] && source "$SET_UP/helper.bash"
# Load configurations
[ -f "$SET_UP_CONFIG_FILE" ] && source "$SET_UP_CONFIG_FILE" 2>/dev/null

#####################################################
# Load orders: environments -> aliases -> completions -> plugins

# Load environments
test -e "$SET_UP"/environments/common.env.bash && source "$SET_UP"/environments/common.env.bash
if [ ${#environments[@]} -eq 0 ]; then
    # load all environments
    for exe_file in "$SET_UP"/environments/*.env.bash; do
        test -e "$exe_file" && source "$exe_file"
    done
else
    for env in "${environments[@]}"; do
        exe_file="$SET_UP"/environments/"$env".env.bash
        custom_exe_file="$SET_UP"/custom/environments/"$env".env.bash
        test -e "$exe_file" && source "$exe_file"
        test -e "$custom_exe_file" && source "$custom_exe_file"
    done
fi

# Load aliases
test -e "$SET_UP"/aliases/common.aliases.bash && source "$SET_UP"/aliases/common.aliases.bash
if [ ${#aliases[@]} -eq 0 ]; then
    for exe_file in "$SET_UP"/aliases/*.aliases.bash; do
        test -e "$exe_file" && source "$exe_file"
    done
else
    for aliases in "${aliases[@]}"; do
        exe_file="$SET_UP"/aliases/"$aliases".aliases.bash
        custom_exe_file="$SET_UP"/custom/aliases/"$aliases".aliases.bash
        test -e "$exe_file" && source "$exe_file"
        test -e "$custom_exe_file" && source "$custom_exe_file"
    done
fi

# Load completions
test -e "$SET_UP"/completions/common.completion.bash && source "$SET_UP"/completions/common.completion.bash
if [ ${#completions[@]} -eq 0 ]; then
    # load all completions
    for exe_file in "$SET_UP"/completions/*.completion.bash; do
        test -e "$exe_file" && source "$exe_file"
    done
else
    for completion in "${completions[@]}"; do
        exe_file="$SET_UP"/completions/"$completion".completion.bash
        custom_exe_file="$SET_UP"/custom/completions/"$completion".completion.bash
        test -e "$exe_file" && source "$exe_file"
        test -e "$custom_exe_file" && source "$custom_exe_file"
    done
fi

# Load plugins
test -e "$SET_UP"/plugins/common.plugin.bash && source "$SET_UP"/plugins/common.plugin.bash
if [ ${#plugins[@]} -eq 0 ]; then
    for exe_file in "$SET_UP"/plugins/*.plugin.bash; do
        test -e "$exe_file" && . "$exe_file"
    done
else
    for plugin in "${plugins[@]}"; do
        exe_file="$SET_UP"/plugins/"$plugin".plugin.bash
        custom_exe_file="$SET_UP"/custom/plugins/"$plugin".plugin.bash
        test -e "$exe_file" && . "$exe_file"
        test -e "$custom_exe_file" && . "$custom_exe_file"
    done
fi

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
