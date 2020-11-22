#!/usr/bin/env bash

# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git() {
    # If set GIT_OPTIONAL_LOCKS to 0, Git will complete any requested operation
    # without performing any optional sub-operations that require taking a lock.
    GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Checks if working tree is dirty
function parse_git_dirty() {
    local STATUS
    local -a FLAGS
    FLAGS=('--porcelain')
    # If hideDirty set to false
    if [[ "$(__git_prompt_git config --get setup.hideDirty)" != "true" ]]; then
        if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
            FLAGS+=('--untracked-files=no')
        fi
        case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
        git)
            # let git decide (this respects per-repo config in .gitmodules)
            ;;
        *)
            # if unset: ignore dirty submodules
            # other values are passed to --ignore-submodules
            FLAGS+=("--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}")
            ;;
        esac
        STATUS=$(__git_prompt_git status "${FLAGS[@]}" 2>/dev/null | tail -n1)
    fi
    if [[ -n $STATUS ]]; then
        echo "$SETUP_THEME_GIT_PROMPT_DIRTY"
    else
        echo "$SETUP_THEME_GIT_PROMPT_CLEAN"
    fi
}

# Outputs current branch info in themes format
function git_prompt_info() {
    local ref
    if [[ "$(__git_prompt_git config --get setup.hideStatus 2>/dev/null)" != "true" ]]; then
        ref=$(__git_prompt_git symbolic-ref HEAD 2>/dev/null) ||
            ref=$(__git_prompt_git rev-parse --short HEAD 2>/dev/null) || return 0
        echo "$SETUP_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$SETUP_THEME_GIT_PROMPT_SUFFIX"
    fi
}

# Gets the difference between the local and remote branches
function git_remote_status() {
    local remote ahead behind git_remote_status git_remote_status_detailed
    # hook_com=([branch]=dev) can change branch manually
    git_remote_origin=$(command git rev-parse --verify "${hook_com[branch]}@{upstream}" --symbolic-full-name 2>/dev/null)
    remote=${git_remote_origin/refs\/remotes\//}
    if [[ -n ${remote} ]]; then
        ahead=$(__git_prompt_git rev-list "${hook_com[branch]}@{upstream}..HEAD" 2>/dev/null | wc -l)
        behind=$(__git_prompt_git rev-list "HEAD..${hook_com[branch]}@{upstream}" 2>/dev/null | wc -l)
        if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$SETUP_THEME_GIT_PROMPT_EQUAL_REMOTE"
        elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$SETUP_THEME_GIT_PROMPT_AHEAD_REMOTE"
            git_remote_status_detailed="$SETUP_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$SETUP_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))${reset_color}"
        elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
            git_remote_status="$SETUP_THEME_GIT_PROMPT_BEHIND_REMOTE"
            git_remote_status_detailed="$SETUP_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$SETUP_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))${reset_color}"
        elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
            git_remote_status="$SETUP_THEME_GIT_PROMPT_DIVERGED_REMOTE"
            git_remote_status_detailed="$SETUP_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$SETUP_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))${reset_color}$SETUP_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$SETUP_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))${reset_color}"
        fi

        if [[ -n $SETUP_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
            git_remote_status="$SETUP_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$remote$git_remote_status_detailed$SETUP_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
        fi

        echo "$git_remote_status"
    fi
}

# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_symbolic_ref() {
    __git_prompt_git symbolic-ref -q HEAD 2>/dev/null
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
function git_current_branch() {
    local ref
    ref=$(git_symbolic_ref)
    local ret=$?
    if [[ $ret != 0 ]]; then
        [[ $ret == 128 ]] && return # no git repo.
        ref=$(__git_prompt_git rev-parse --short HEAD 2>/dev/null) || return
    fi
    echo "${ref#refs/heads/}"
}

# Gets the number of commits ahead from remote
function git_commits_ahead() {
    if __git_prompt_git rev-parse --git-dir &>/dev/null; then
        local commits="$(__git_prompt_git rev-list --count "@{upstream}..HEAD" 2>/dev/null)"
        if [[ -n "$commits" && "$commits" != 0 ]]; then
            echo "$SETUP_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$SETUP_THEME_GIT_COMMITS_AHEAD_SUFFIX"
        fi
    fi
}

# Gets the number of commits behind remote
function git_commits_behind() {
    if __git_prompt_git rev-parse --git-dir &>/dev/null; then
        local commits="$(__git_prompt_git rev-list --count "HEAD..@{upstream}" 2>/dev/null)"
        if [[ -n "$commits" && "$commits" != 0 ]]; then
            echo "$SETUP_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$SETUP_THEME_GIT_COMMITS_BEHIND_SUFFIX"
        fi
    fi
}

# Outputs if current branch is ahead of remote
function git_prompt_ahead() {
    if [[ -n "$(__git_prompt_git rev-list "origin/$(git_current_branch)..HEAD" 2>/dev/null)" ]]; then
        echo "$SETUP_THEME_GIT_PROMPT_AHEAD"
    fi
}

# Outputs if current branch is behind remote
function git_prompt_behind() {
    if [[ -n "$(__git_prompt_git rev-list "HEAD..origin/$(git_current_branch)" 2>/dev/null)" ]]; then
        echo "$SETUP_THEME_GIT_PROMPT_BEHIND"
    fi
}

# Outputs if current branch exists on remote or not
function git_prompt_remote() {
    if [[ -n "$(__git_prompt_git show-ref "origin/$(git_current_branch)" 2>/dev/null)" ]]; then
        echo "$SETUP_THEME_GIT_PROMPT_REMOTE_EXISTS"
    else
        echo "$SETUP_THEME_GIT_PROMPT_REMOTE_MISSING"
    fi
}

function git_short_sha() {
    __git_prompt_git rev-parse --short HEAD 2>/dev/null
}

function git_long_sha() {
    __git_prompt_git rev-parse HEAD 2>/dev/null
}

# Formats themes string for current git commit short SHA
function git_prompt_short_sha() {
    local SHA
    SHA=$(git_short_sha) && echo "$SETUP_THEME_GIT_PROMPT_SHA_BEFORE$SHA$SETUP_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats themes string for current git commit long SHA
function git_prompt_long_sha() {
    local SHA
    SHA=$(git_long_sha) && echo "$SETUP_THEME_GIT_PROMPT_SHA_BEFORE$SHA$SETUP_THEME_GIT_PROMPT_SHA_AFTER"
}

# Outputs the name of the current user
# Usage example: $(git_current_user_name)
function git_current_user_name() {
    __git_prompt_git config user.name 2>/dev/null
}

# Outputs the email of the current user
# Usage example: $(git_current_user_email)
function git_current_user_email() {
    __git_prompt_git config user.email 2>/dev/null
}

# Output the name of the root directory of the git repository
# Usage example: $(git_repo_name)
function git_repo_name() {
    local repo_path
    if repo_path="$(__git_prompt_git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
        echo "${repo_path:t}"
    fi
}

# ✹%{%}✭%{%}
function git_prompt_status() {
    [[ "$(__git_prompt_git config --get setup.hideStatus 2>/dev/null)" == 1 ]] && return
    # Maps a git status prefix to an internal constant
    # This cannot use the themes constants, as they may be empty
    local -A prefix_constant_map
    prefix_constant_map=(
        ['\?\? ']='UNTRACKED'
        ['A  ']='ADDED'
        ['M  ']='ADDED'
        ['MM ']='ADDED'
        [' M ']='MODIFIED'
        ['AM ']='MODIFIED'
        [' T ']='MODIFIED'
        ['R  ']='RENAMED'
        [' D ']='DELETED'
        ['D  ']='DELETED'
        ['UU ']='UNMERGED'
        ['ahead']='AHEAD'
        ['behind']='BEHIND'
        ['diverged']='DIVERGED'
        ['stashed']='STASHED'
    )

    # Maps the internal constant to the themes theme
    local -A constant_prompt_map
    constant_prompt_map=(
        ['UNTRACKED']="$SETUP_THEME_GIT_PROMPT_UNTRACKED"
        ['ADDED']="$SETUP_THEME_GIT_PROMPT_ADDED"
        ['MODIFIED']="$SETUP_THEME_GIT_PROMPT_MODIFIED"
        ['RENAMED']="$SETUP_THEME_GIT_PROMPT_RENAMED"
        ['DELETED']="$SETUP_THEME_GIT_PROMPT_DELETED"
        ['UNMERGED']="$SETUP_THEME_GIT_PROMPT_UNMERGED"
        ['AHEAD']="$SETUP_THEME_GIT_PROMPT_AHEAD"
        ['BEHIND']="$SETUP_THEME_GIT_PROMPT_BEHIND"
        ['DIVERGED']="$SETUP_THEME_GIT_PROMPT_DIVERGED"
        ['STASHED']="$SETUP_THEME_GIT_PROMPT_STASHED"
    )

    # The order that the themes displays should be added to the themes
    local status_constants
    status_constants=(
        UNTRACKED ADDED MODIFIED RENAMED DELETED
        STASHED UNMERGED AHEAD BEHIND DIVERGED
    )

    local status_text="$(__git_prompt_git status --porcelain -b 2>/dev/null)"

    # Don't continue on a catastrophic failure
    if [[ $? -eq 128 ]]; then
        return 1
    fi

    # A lookup table of each git status encountered
    local -A statuses_seen

    if __git_prompt_git rev-parse --verify refs/stash &>/dev/null; then
        statuses_seen[STASHED]=1
    fi

    local status_lines
    readarray -t status_lines <<<"$status_text"
    # If the tracking line exists, get and parse it
    tmp_regex="^## [^ ]+ \[(.*)\]"
    if [[ "${status_lines[0]}" =~ $tmp_regex ]]; then
        local branch_statuses
        match=${BASH_REMATCH[1]}
        IFS=',' read -ra branch_statuses <<<"$match"
        for branch_status in $branch_statuses; do
            tmp_regex="(behind|diverged|ahead) ([0-9]+)?"
            if [[ ! $branch_status =~ $tmp_regex ]]; then
                continue
            fi
            local last_parsed_status=${prefix_constant_map[${BASH_REMATCH[1]}]}
            statuses_seen[$last_parsed_status]=${BASH_REMATCH[2]}
        done
    fi

    # For each status prefix, do a regex comparison
    for status_prefix in "${!prefix_constant_map[@]}"; do
        local status_constant="${prefix_constant_map[$status_prefix]}"
        local status_regex=$'(^|\n)'"$status_prefix"
        if [[ "$status_text" =~ $status_regex ]]; then
            statuses_seen[$status_constant]=1
        fi
    done

    # Display the seen statuses in the order specified
    local status_prompt
    for status_constant in "${status_constants[@]}"; do
        local element=${statuses_seen[$status_constant]}
        if [ -n "$element" ]; then
            local next_display=${constant_prompt_map[$status_constant]}
            status_prompt="$next_display$status_prompt"
        fi
    done

    echo "$status_prompt"
}

function git_tag() {
    __git_prompt_git describe --tags --exact-match 2>/dev/null
}

function git_commit_description() {
    __git_prompt_git describe --contains --all 2>/dev/null
}

# Friendly ref
function git_friendly_ref() {
    _git_branch || _git_tag || _git_commit_description || _git_short_sha
}
