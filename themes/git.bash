#!/usr/bin/env bash

# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git() {
  # If set GIT_OPTIONAL_LOCKS to 0, Git will complete any requested operation
  # without performing any optional sub-operations that require taking a lock.
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Checks if working tree is dirty
function _parse_git_dirty() {
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
    echo "$SCM_GIT_PROMPT_DIRTY"
  else
    echo "$SCM_GIT_PROMPT_CLEAN"
  fi
}

# Outputs current branch info in themes format
function _git_prompt_info() {
  local ref
  if [[ "$(__git_prompt_git config --get setup.hideStatus 2>/dev/null)" != "1" ]]; then
    ref=$(__git_prompt_git symbolic-ref HEAD 2>/dev/null) ||
      ref=$(__git_prompt_git rev-parse --short HEAD 2>/dev/null) || return 0
    echo "$SCM_GIT_PROMPT_PREFIX${ref#refs/heads/}$(_parse_git_dirty)$SCM_GIT_PROMPT_SUFFIX"
  fi
}

# Gets the difference between the local and remote branches
function _git_remote_status() {
  local remote ahead behind _git_remote_status _git_remote_status_detailed
  # hook_com=([branch]=dev) can change branch manually
  git_remote_origin=$(command git rev-parse --verify "${hook_com[branch]}@{upstream}" --symbolic-full-name 2>/dev/null)
  remote=${git_remote_origin/refs\/remotes\//}
  if [[ -n ${remote} ]]; then
    ahead=$(__git_prompt_git rev-list "${hook_com[branch]}@{upstream}..HEAD" 2>/dev/null | wc -l)
    behind=$(__git_prompt_git rev-list "HEAD..${hook_com[branch]}@{upstream}" 2>/dev/null | wc -l)
    if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
      git_remote_status="$SCM_GIT_PROMPT_EQUAL_REMOTE"
    elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
      git_remote_status="$SCM_GIT_PROMPT_AHEAD_REMOTE"
      git_remote_status_detailed="$SCM_GIT_PROMPT_AHEAD_REMOTE_COLOR$SCM_GIT_PROMPT_AHEAD_REMOTE$((ahead))${reset_color}"
    elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
      git_remote_status="$SCM_GIT_PROMPT_BEHIND_REMOTE"
      git_remote_status_detailed="$SCM_GIT_PROMPT_BEHIND_REMOTE_COLOR$SCM_GIT_PROMPT_BEHIND_REMOTE$((behind))${reset_color}"
    elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
      git_remote_status="$SCM_GIT_PROMPT_DIVERGED_REMOTE"
      git_remote_status_detailed="$SCM_GIT_PROMPT_AHEAD_REMOTE_COLOR$SCM_GIT_PROMPT_AHEAD_REMOTE$((ahead))${reset_color}$SCM_GIT_PROMPT_BEHIND_REMOTE_COLOR$SCM_GIT_PROMPT_BEHIND_REMOTE$((behind))${reset_color}"
    fi

    if [[ -n $SCM_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
      git_remote_status="$SCM_GIT_PROMPT_REMOTE_STATUS_PREFIX$remote$git_remote_status_detailed$SCM_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
    fi

    echo "$git_remote_status"
  fi
}

# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function _git_symbolic_ref() {
  __git_prompt_git symbolic-ref -q HEAD 2>/dev/null
}

# Outputs the name of the current branch
# Usage example: git pull origin $(_git_current_branch)
function _git_current_branch() {
  local ref
  ref=$(_git_symbolic_ref)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return # no git repo.
    ref=$(__git_prompt_git rev-parse --short HEAD 2>/dev/null) || return
  fi
  echo "${ref#refs/heads/}"
}

# Gets the number of commits ahead from remote
function _git_commits_ahead() {
  if __git_prompt_git rev-parse --git-dir &>/dev/null; then
    local commits="$(__git_prompt_git rev-list --count "@{upstream}..HEAD" 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$SCM_GIT_COMMITS_AHEAD_PREFIX$commits$SCM_GIT_COMMITS_AHEAD_SUFFIX"
    fi
  fi
}

# Gets the number of commits behind remote
function _git_commits_behind() {
  if __git_prompt_git rev-parse --git-dir &>/dev/null; then
    local commits="$(__git_prompt_git rev-list --count "HEAD..@{upstream}" 2>/dev/null)"
    if [[ -n "$commits" && "$commits" != 0 ]]; then
      echo "$SCM_GIT_COMMITS_BEHIND_PREFIX$commits$SCM_GIT_COMMITS_BEHIND_SUFFIX"
    fi
  fi
}

# Outputs if current branch is ahead of remote
function _git_prompt_ahead() {
  if [[ -n "$(__git_prompt_git rev-list "origin/$(_git_current_branch)..HEAD" 2>/dev/null)" ]]; then
    echo "$SCM_GIT_PROMPT_AHEAD"
  fi
}

# Outputs if current branch is behind remote
function _git_prompt_behind() {
  if [[ -n "$(__git_prompt_git rev-list "HEAD..origin/$(_git_current_branch)" 2>/dev/null)" ]]; then
    echo "$SCM_GIT_PROMPT_BEHIND"
  fi
}

# Outputs if current branch exists on remote or not
function _git_prompt_remote() {
  if [[ -n "$(__git_prompt_git show-ref "origin/$(_git_current_branch)" 2>/dev/null)" ]]; then
    echo "$SCM_GIT_PROMPT_REMOTE_EXISTS"
  else
    echo "$SCM_GIT_PROMPT_REMOTE_MISSING"
  fi
}

function _git_short_sha() {
  __git_prompt_git rev-parse --short HEAD 2>/dev/null
}

function _git_long_sha() {
  __git_prompt_git rev-parse HEAD 2>/dev/null
}

# Formats themes string for current git commit short SHA
function _git_prompt_short_sha() {
  local SHA
  SHA=$(_git_short_sha) && echo "$SCM_GIT_PROMPT_SHA_BEFORE$SHA$SCM_GIT_PROMPT_SHA_AFTER"
}

# Formats themes string for current git commit long SHA
function _git_prompt_long_sha() {
  local SHA
  SHA=$(_git_long_sha) && echo "$SCM_GIT_PROMPT_SHA_BEFORE$SHA$SCM_GIT_PROMPT_SHA_AFTER"
}

# Outputs the name of the current user
# Usage example: $(_git_current_user_name)
function _git_current_user_name() {
  __git_prompt_git config user.name 2>/dev/null
}

# Outputs the email of the current user
# Usage example: $(_git_current_user_email)
function _git_current_user_email() {
  __git_prompt_git config user.email 2>/dev/null
}

# Output the name of the root directory of the git repository
# Usage example: $(_git_repo_name)
function _git_repo_name() {
  local repo_path
  if repo_path="$(__git_prompt_git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
    echo "${repo_path:t}"
  fi
}

function _git_upstream() {
  local ref
  ref="$(_git_symbolic_ref)" || return 1
  __git_prompt_git for-each-ref --format="%(upstream:short)" "${ref}"
}

function _git_hide_status() {
  [[ "$(__git_prompt_git config --get setup.hideStatus)" == "1" ]]
}

function _git_upstream_behind_ahead() {
  __git_prompt_git rev-list --left-right --count "$(_git_upstream)...HEAD" 2>/dev/null
}

function _git_upstream_branch() {
  local ref
  ref="$(_git_symbolic_ref)" || return 1

  # git versions < 2.13.0 do not support "strip" for upstream format
  # regex replacement gives the wrong result for any remotes with slashes in the name,
  # so only use when the strip format fails.
  __git_prompt_git for-each-ref --format="%(upstream:strip=3)" "${ref}" 2>/dev/null || __git_prompt_git for-each-ref --format="%(upstream)" "${ref}" | sed -e "s/.*\/.*\/.*\///"
}

function _git_upstream_remote() {
  local upstream
  upstream="$(_git_upstream)" || return 1

  local branch
  branch="$(_git_upstream_branch)" || return 1
  echo "${upstream%"/${branch}"}"
}

function _git_status() {
  local git_status_flags=
  # shellcheck disable=SC2015
  [[ "${SCM_GIT_IGNORE_UNTRACKED}" == "true" ]] && git_status_flags='-uno' || true
  __git_prompt_git status --porcelain ${git_status_flags} 2>/dev/null
}

function git_status_counts() {
  _git_status | awk '
  BEGIN {
    untracked=0;
    unstaged=0;
    staged=0;
  }
  {
    if ($0 ~ /^\?\? .+/) {
      untracked += 1
    } else {
      if ($0 ~ /^.[^ ] .+/) {
        unstaged += 1
      }
      if ($0 ~ /^[^ ]. .+/) {
        staged += 1
      }
    }
  }
  END {
    print untracked "\t" unstaged "\t" staged
  }'
}

# ✹%{%}✭%{%}
function _git_prompt_status() {
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
    ['UNTRACKED']="$SCM_GIT_PROMPT_UNTRACKED"
    ['ADDED']="$SCM_GIT_PROMPT_ADDED"
    ['MODIFIED']="$SCM_GIT_PROMPT_MODIFIED"
    ['RENAMED']="$SCM_GIT_PROMPT_RENAMED"
    ['DELETED']="$SCM_GIT_PROMPT_DELETED"
    ['UNMERGED']="$SCM_GIT_PROMPT_UNMERGED"
    ['AHEAD']="$SCM_GIT_PROMPT_AHEAD"
    ['BEHIND']="$SCM_GIT_PROMPT_BEHIND"
    ['DIVERGED']="$SCM_GIT_PROMPT_DIVERGED"
    ['STASHED']="$SCM_GIT_PROMPT_STASHED"
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

function _git_branch() {
  if [[ "${SCM_GIT_GITSTATUS_RAN}" == "true" ]]; then
    test -n "${VCS_STATUS_LOCAL_BRANCH}" && echo "${VCS_STATUS_LOCAL_BRANCH}" || return 1
  else
    __git_prompt_git symbolic-ref -q --short HEAD 2>/dev/null || return 1
  fi
}

function _git_num_remotes() {
  git remote | wc -l
}

function _git_remote_info() {
  # prompt handling only, reimplement because patching the routine below gets ugly
  if [[ "${SCM_GIT_GITSTATUS_RAN}" == "true" ]]; then
    [[ "${VCS_STATUS_REMOTE_NAME}" == "" ]] && return
    [[ "${VCS_STATUS_LOCAL_BRANCH}" == "${VCS_STATUS_REMOTE_BRANCH}" ]] && local same_branch_name=true
    local same_branch_name=
    [[ "${VCS_STATUS_LOCAL_BRANCH}" == "${VCS_STATUS_REMOTE_BRANCH}" ]] && same_branch_name=true
    # no multiple remote support in gitstatusd
    if [[ "${SCM_GIT_SHOW_REMOTE_INFO}" == "true" || "${SCM_GIT_SHOW_REMOTE_INFO}" == "auto" ]]; then
      if [[ "${same_branch_name}" != "true" ]]; then
        remote_info="${VCS_STATUS_REMOTE_NAME}/${VCS_STATUS_REMOTE_BRANCH}"
      else
        remote_info="${VCS_STATUS_REMOTE_NAME}"
      fi
    elif [[ ${same_branch_name} != "true" ]]; then
      remote_info="${VCS_STATUS_REMOTE_BRANCH}"
    fi
    if [[ -n "${remote_info}" ]]; then
      # no support for gone remote branches in gitstatusd
      local branch_prefix="${SCM_THEME_BRANCH_TRACK_PREFIX}"
      echo "${branch_prefix}${remote_info}"
    fi
  else
    [[ "$(_git_upstream)" == "" ]] && return

    [[ "$(_git_branch)" == "$(_git_upstream_branch)" ]] && local same_branch_name=true
    local same_branch_name=
    [[ "$(_git_branch)" == "$(_git_upstream_branch)" ]] && same_branch_name=true
    if [[ ("${SCM_GIT_SHOW_REMOTE_INFO}" == "auto" && "$(_git_num_remotes)" -ge 2) || "${SCM_GIT_SHOW_REMOTE_INFO}" == "true" ]]; then
      if [[ "${same_branch_name}" != "true" ]]; then
        remote_info="\$(_git_upstream)"
      else
        remote_info="$(_git_upstream_remote)"
      fi
    elif [[ ${same_branch_name} != "true" ]]; then
      remote_info="\$(_git_upstream_branch)"
    fi
    if [[ -n "${remote_info}" ]]; then
      local branch_prefix
      if _git_upstream_branch_gone; then
        branch_prefix="${SCM_THEME_BRANCH_GONE_PREFIX}"
      else
        branch_prefix="${SCM_THEME_BRANCH_TRACK_PREFIX}"
      fi
      echo "${branch_prefix}${remote_info}"
    fi
  fi
}

function _git_tag() {
  __git_prompt_git describe --tags --exact-match 2>/dev/null
}

function _git_commit_description() {
  __git_prompt_git describe --contains --all 2>/dev/null
}

# Friendly ref
function git_friendly_ref() {
  _git_branch || _git_tag || _git_commit_description || _git_short_sha
}

__git_eread() {
  local f="$1"
  shift
  test -r "$f" && read -r "$@" <"$f"
}
__git_ps1() {
  # preserve exit status
  local exit=$?
  local pcmode=no
  local detached=no
  local ps1pc_start='\u@\h:\w '
  local ps1pc_end='\$ '
  local printf_format=' (%s)'

  case "$#" in
  2 | 3)
    pcmode=yes
    ps1pc_start="$1"
    ps1pc_end="$2"
    printf_format="${3:-$printf_format}"
    # set PS1 to a plain prompt so that we can
    # simply return early if the prompt should not
    # be decorated
    PS1="$ps1pc_start$ps1pc_end"
    ;;
  0 | 1)
    printf_format="${1:-$printf_format}"
    ;;
  *)
    return $exit
    ;;
  esac

  # ps1_expanded:  This variable is set to 'yes' if the shell
  # subjects the value of PS1 to parameter expansion:
  #
  #   * bash does unless the promptvars option is disabled
  #   * zsh does not unless the PROMPT_SUBST option is set
  #   * POSIX shells always do
  #
  # If the shell would expand the contents of PS1 when drawing
  # the prompt, a raw ref name must not be included in PS1.
  # This protects the user from arbitrary code execution via
  # specially crafted ref names.  For example, a ref named
  # 'refs/heads/$(IFS=_;cmd=sudo_rm_-rf_/;$cmd)' might cause the
  # shell to execute 'sudo rm -rf /' when the prompt is drawn.
  #
  # Instead, the ref name should be placed in a separate global
  # variable (in the __git_ps1_* namespace to avoid colliding
  # with the user's environment) and that variable should be
  # referenced from PS1.  For example:
  #
  #     __git_ps1_foo=$(do_something_to_get_ref_name)
  #     PS1="...stuff...\${__git_ps1_foo}...stuff..."
  #
  # If the shell does not expand the contents of PS1, the raw
  # ref name must be included in PS1.
  #
  # The value of this variable is only relevant when in pcmode.
  #
  # Assume that the shell follows the POSIX specification and
  # expands PS1 unless determined otherwise.  (This is more
  # likely to be correct if the user has a non-bash, non-zsh
  # shell and safer than the alternative if the assumption is
  # incorrect.)
  #
  local ps1_expanded=yes
  [ -z "${ZSH_VERSION-}" ] || [[ -o PROMPT_SUBST ]] || ps1_expanded=no
  [ -z "${BASH_VERSION-}" ] || shopt -q promptvars || ps1_expanded=no

  local repo_info rev_parse_exit_code
  repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
    --is-bare-repository --is-inside-work-tree \
    --short HEAD 2>/dev/null)"
  rev_parse_exit_code="$?"

  if [ -z "$repo_info" ]; then
    return $exit
  fi

  local short_sha=""
  if [ "$rev_parse_exit_code" = "0" ]; then
    short_sha="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
  fi
  local inside_worktree="${repo_info##*$'\n'}"
  repo_info="${repo_info%$'\n'*}"
  local bare_repo="${repo_info##*$'\n'}"
  repo_info="${repo_info%$'\n'*}"
  local inside_gitdir="${repo_info##*$'\n'}"
  local g="${repo_info%$'\n'*}"

  if [ "true" = "$inside_worktree" ] &&
    [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] &&
    [ "$(git config --bool bash.hideIfPwdIgnored)" != "false" ] &&
    git check-ignore -q .; then
    return $exit
  fi

  local r=""
  local b=""
  local step=""
  local total=""
  if [ -d "$g/rebase-merge" ]; then
    __git_eread "$g/rebase-merge/head-name" b
    __git_eread "$g/rebase-merge/msgnum" step
    __git_eread "$g/rebase-merge/end" total
    if [ -f "$g/rebase-merge/interactive" ]; then
      r="|REBASE-i"
    else
      r="|REBASE-m"
    fi
  else
    if [ -d "$g/rebase-apply" ]; then
      __git_eread "$g/rebase-apply/next" step
      __git_eread "$g/rebase-apply/last" total
      if [ -f "$g/rebase-apply/rebasing" ]; then
        __git_eread "$g/rebase-apply/head-name" b
        r="|REBASE"
      elif [ -f "$g/rebase-apply/applying" ]; then
        r="|AM"
      else
        r="|AM/REBASE"
      fi
    elif [ -f "$g/MERGE_HEAD" ]; then
      r="|MERGING"
    elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
      r="|CHERRY-PICKING"
    elif [ -f "$g/REVERT_HEAD" ]; then
      r="|REVERTING"
    elif [ -f "$g/BISECT_LOG" ]; then
      r="|BISECTING"
    fi

    if [ -n "$b" ]; then
      :
    elif [ -h "$g/HEAD" ]; then
      # symlink symbolic ref
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      local head=""
      if ! __git_eread "$g/HEAD" head; then
        return $exit
      fi
      # is it a symbolic ref?
      b="${head#ref: }"
      if [ "$head" = "$b" ]; then
        detached=yes
        b="$(
          case "${GIT_PS1_DESCRIBE_STYLE-}" in
          contains)
            git describe --contains HEAD
            ;;
          branch)
            git describe --contains --all HEAD
            ;;
          tag)
            git describe --tags HEAD
            ;;
          describe)
            git describe HEAD
            ;;
          *)
            git describe --tags --exact-match HEAD
            ;;
          esac 2>/dev/null
        )" ||
          b="$short_sha..."
        b="($b)"
      fi
    fi
  fi

  if [ -n "$step" ] && [ -n "$total" ]; then
    r="$r $step/$total"
  fi

  local w=""
  local i=""
  local s=""
  local u=""
  local c=""
  local p=""

  if [ "true" = "$inside_gitdir" ]; then
    if [ "true" = "$bare_repo" ]; then
      c="BARE:"
    else
      b="GIT_DIR!"
    fi
  elif [ "true" = "$inside_worktree" ]; then
    if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ] &&
      [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
      git diff --no-ext-diff --quiet || w="*"
      git diff --no-ext-diff --cached --quiet || i="+"
      if [ -z "$short_sha" ] && [ -z "$i" ]; then
        i="#"
      fi
    fi
    if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ] &&
      git rev-parse --verify --quiet refs/stash >/dev/null; then
      s="$"
    fi

    if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ] &&
      [ "$(git config --bool bash.showUntrackedFiles)" != "false" ] &&
      git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null; then
      u="%${ZSH_VERSION+%}"
    fi

    if [ -n "${GIT_PS1_SHOWUPSTREAM-}" ]; then
      __git_ps1_show_upstream
    fi
  fi

  local z="${GIT_PS1_STATESEPARATOR-" "}"

  # NO color option unless in PROMPT_COMMAND mode
  if [ $pcmode = yes ] && [ -n "${GIT_PS1_SHOWCOLORHINTS-}" ]; then
    __git_ps1_colorize_gitstring
  fi

  b=${b##refs/heads/}
  if [ $pcmode = yes ] && [ $ps1_expanded = yes ]; then
    __git_ps1_branch_name=$b
    b="\${__git_ps1_branch_name}"
  fi

  local f="$w$i$s$u"
  local gitstring="$c$b${f:+$z$f}$r$p"

  if [ $pcmode = yes ]; then
    if [ "${__git_printf_supports_v-}" != yes ]; then
      # shellcheck disable=SC2059
      gitstring=$(printf -- "$printf_format" "$gitstring")
    else
      # shellcheck disable=SC2059
      printf -v gitstring -- "$printf_format" "$gitstring"
    fi
    PS1="$ps1pc_start$gitstring$ps1pc_end"
  else
    # shellcheck disable=SC2059
    printf -- "$printf_format" "$gitstring"
  fi

  return $exit
}
