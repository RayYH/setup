#!/usr/bin/env bash
# https://github.com/speedenator/agnoster-bash

# see https://stackoverflow.com/questions/5687446/how-can-i-shortern-my-command-line-prompts-current-directory
PROMPT_DIRTRIM=2

# Theme Variable
SET_UP_THEME_GIT_PROMPT_DIRTY=" ●"
SET_UP_THEME_GIT_COMMITS_AHEAD_SYMBOL="⬆"
SET_UP_THEME_GIT_COMMITS_BEHIND_SYMBOL="⬇"
SET_UP_THEME_GIT_COMMITS_AHEAD_BEHIND_SYMBOL="⇵"

DEBUG=0
debug() {
    if [[ ${DEBUG} -ne 0 ]]; then
        echo >&2 -e "$@"
    fi
}

CURRENT_BG='NONE'
CURRENT_RBG='NONE'
SEGMENT_SEPARATOR=''
RIGHT_SEPARATOR=''
LEFT_SUBSEG=''
RIGHT_SUBSEG=''

text_effect() {
    case "$1" in
    reset) echo 0 ;;
    bold) echo 1 ;;
    underline) echo 4 ;;
    esac
}

# to add colors, see
# http://bitmote.com/index.php?post/2012/11/19/Using-ANSI-Color-Codes-to-Colorize-Your-Bash-Prompt-on-Linux
# under the "256 (8-bit) Colors" section, and follow the example for orange below
fg_color() {
    case "$1" in
    black) echo 30 ;;
    red) echo 31 ;;
    green) echo 32 ;;
    yellow) echo 33 ;;
    blue) echo 34 ;;
    magenta) echo 35 ;;
    cyan) echo 36 ;;
    white) echo 37 ;;
    orange) echo 38\;5\;166 ;;
    esac
}

bg_color() {
    case "$1" in
    black) echo 40 ;;
    red) echo 41 ;;
    green) echo 42 ;;
    yellow) echo 43 ;;
    blue) echo 44 ;;
    magenta) echo 45 ;;
    cyan) echo 46 ;;
    white) echo 47 ;;
    orange) echo 48\;5\;166 ;;
    esac
}

# TIL: declare is global not local, so best use a different name
# for codes (mycodes) as otherwise it'll clobber the original.
# this changes from BASH v3 to BASH v4.
ansi() {
    local seq
    declare -a mycodes=("${!1}")

    debug "ansi: ${!1} all: $* aka ${mycodes[*]}"

    seq=""
    for ((i = 0; i < ${#mycodes[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes[$i]}"
    done
    debug "ansi debug:" '\\[\\033['"${seq}"'m\\]'
    echo -ne '\[\033['"${seq}"'m\]'
}

ansi_single() {
    echo -ne '\[\033['"$1"'m\]'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    declare -a codes
    codes=("${codes[@]}" "$(text_effect reset)")
    if [[ -n $1 ]]; then
        bg=$(bg_color "$1")
        codes=("${codes[@]}" "$bg")
    fi
    if [[ -n $2 ]]; then
        fg=$(fg_color "$2")
        codes=("${codes[@]}" "$fg")
    fi
    if [[ $CURRENT_BG != NONE && $1 != "$CURRENT_BG" ]]; then

        declare -a intermediate=("$(fg_color $CURRENT_BG)" "$(bg_color "$1")")
        PR="$PR $(ansi intermediate[@])$SEGMENT_SEPARATOR"
        PR="$PR$(ansi codes[@]) "
    else
        PR="$PR$(ansi codes[@]) "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && PR="$PR$3"
}

# End the prompt, closing any open segments
prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        declare -a codes=("$(text_effect reset)" "$(fg_color "$CURRENT_BG")")
        PR="$PR $(ansi codes[@])$SEGMENT_SEPARATOR"
    fi
    declare -a reset=("$(text_effect reset)")
    PR="$PR $(ansi reset[@])"
    CURRENT_BG=''
}

prompt_virtualenv() {
    if [[ -n $VIRTUAL_ENV ]]; then
        color=cyan
        prompt_segment $color "$PRIMARY_FG"
        prompt_segment $color white "$(basename "$VIRTUAL_ENV")"
    fi
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
    local user=$(whoami)
    if [[ $user != "$DEFAULT_USER" || -n $SSH_CLIENT ]]; then
        if [[ "${SSH_TTY}" ]]; then
            prompt_segment magenta black "$user@\h"
        else
            prompt_segment white black "$user@\h"
        fi
    fi
}

# Git: branch/detached head, dirty status
prompt_git() {
    local ref dirty ahead behind
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # See themes/git.plugin.bash
        dirty=$(_parse_git_dirty)
        ref=$(git symbolic-ref HEAD 2>/dev/null) || ref="➦ $(git show-ref --head -s --abbrev | head -n1 2>/dev/null)"
        if [[ -n $dirty ]]; then
            prompt_segment yellow black
        else
            prompt_segment green black
        fi
        ahead=$(_git_commits_ahead)
        behind=$(_git_commits_behind)
        if [ -n "$ahead" ] && [ -n "$behind" ]; then
            PR="$PR${ref/refs\/heads\// } ${SET_UP_THEME_GIT_COMMITS_AHEAD_BEHIND_SYMBOL}$dirty"
        elif [ -n "$ahead" ]; then
            PR="$PR${ref/refs\/heads\// } ${SET_UP_THEME_GIT_COMMITS_AHEAD_SYMBOL}$dirty"
        elif [ -n "$behind" ]; then
            PR="$PR${ref/refs\/heads\// } ${SET_UP_THEME_GIT_COMMITS_BEHIND_SYMBOL}$dirty"
        else
            PR="$PR${ref/refs\/heads\// } $dirty"
        fi
    fi
}

# Dir: current working directory
prompt_dir() {
    prompt_segment blue black '\w'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols
    symbols=()
    [[ $RETVAL -ne 0 ]] && symbols+=("$(ansi_single "$(fg_color red)")✘")
    [[ $UID -eq 0 ]] && symbols+=("$(ansi_single "$(fg_color yellow)")⚡")
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+=("$(ansi_single "$(fg_color cyan)")⚙")

    [[ ${#symbols[@]} -ne 0 ]] && prompt_segment black default "${symbols[@]}"
}

ansi_r() {
    local seq
    declare -a mycodes2=("${!1}")
    seq=""
    for ((i = 0; i < ${#mycodes2[@]}; i++)); do
        if [[ -n $seq ]]; then
            seq="${seq};"
        fi
        seq="${seq}${mycodes2[$i]}"
    done
    echo -ne '\033['"${seq}"'m'
}

build_prompt() {
    [[ -n ${AG_EMACS_DIR+x} ]] && prompt_emacsdir
    prompt_status
    prompt_context
    prompt_virtualenv
    prompt_dir
    prompt_git
    prompt_end
}

set_bash_prompt() {
    RETVAL=$?
    PR=""
    PRIGHT=""
    CURRENT_BG=NONE
    PR="$(ansi_single "$(text_effect reset)")"
    build_prompt
    PS1=$PR
}

PROMPT_COMMAND=set_bash_prompt
