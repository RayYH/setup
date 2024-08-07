#!/usr/bin/env bash

# tab completion for many Bash commands
if command -v brew &>/dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
  # Ensure existing Homebrew v1 completions continue to work
  BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
  export BASH_COMPLETION_COMPAT_DIR
  # shellcheck disable=SC1090
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  for file in "$BASH_COMPLETION_COMPAT_DIR/*"; do
    [[ -x $file ]] && source "$file"
  done
elif [ -f /etc/bash_completion ]; then
  # shellcheck disable=SC1091
  source /etc/bash_completion
fi

# ubuntu bash-completion: /usr/share/bash-completion/bash_completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
  # shellcheck disable=SC1091
  source /usr/share/bash-completion/bash_completion
fi

# export
complete -o nospace -S = -W "$(printenv | awk -F= "{print \$1}")" export

if ! complete -p git &>/dev/null; then
  _git_bash_completion_paths=(
    # MacOS non-system locations
    '/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash'
    '/Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash'
  )

  # Load the first completion file found
  for _comp_path in "${_git_bash_completion_paths[@]}"; do
    if [ -r "$_comp_path" ]; then
      source "$_comp_path"
      break
    fi
  done

  unset _git_bash_completion_paths
fi

# too slow
function __slow_completions() {
  # npm
  if command -v npm &>/dev/null; then
    eval "$(npm completion)"
  fi

  # pip3
  if command -v pip3 &>/dev/null; then
    eval "$(pip3 completion --bash)"
  fi
}

# osx
complete -W "NSGlobalDomain" defaults
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# https://dev.to/ahmedmusallam/how-to-autocomplete-ssh-hosts-1hob
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" "$HOME/.ssh/config" | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
