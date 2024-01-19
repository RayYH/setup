#!/usr/bin/env bash
# shellcheck disable=SC1091
if type brew &>/dev/null; then
  # autojump
  [ -f "$(brew --prefix)"/etc/profile.d/autojump.sh ] && . "$(brew --prefix)"/etc/profile.d/autojump.sh
  # asdf
  [ -f "$(brew --prefix)/opt/asdf/libexec/asdf.sh" ] && . "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
  # fzf
  [ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"
fi

[ -f "${HOME}/.iterm2_shell_integration.bash" ] && test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

if [ -d "${HOME}/.sdkman" ]; then
  #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi