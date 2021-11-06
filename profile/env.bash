#!/usr/bin/env bash

# paths
unshift_path "/usr/local/bin"                                                                 # brew
unshift_path "/usr/local/sbin"                                                                # brew

unshift_path "$HOME/.composer/vendor/bin"                                                     # composer
[ -d "$HOME/Code/gopath" ] && export GOPATH="$HOME/Code/gopath" && unshift_path "$GOPATH/bin" # go
unshift_path "$HOME/.cargo/bin"                                                               # rust
unshift_path "$HOME/Bin"                                                                      # custom path (jetbrains shell scripts path)
unshift_path "/usr/local/opt/mysql-client/bin"                                                # mysql client
unshift_path "/usr/local/opt/curl/bin"                                                        # curl
unshift_path "/usr/local/opt/gnu-sed/libexec/gnubin"                                          # sed: illegal option -- r, you should install gnu-sed first via command: brew install gnu-sed
# use java8
if [ -d "/usr/local/opt/openjdk@8" ]; then
  unshift_path "/usr/local/opt/openjdk@8/bin"
else
  [ -f "/usr/libexec/java_home" ] && export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
fi

# Common
export EDITOR='vim'         # Make vim the default editor.
export LANG='en_US.UTF-8'   # Prefer US English and use UTF-8.
export LC_ALL='en_US.UTF-8' # Prefer US English and use UTF-8.

# TERM
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] &&
  infocmp gnome-256color >/dev/null 2>&1; then
  export TERM='gnome-256color'
elif infocmp xterm-256color >/dev/null 2>&1; then
  export TERM='xterm-256color'
fi

# force using Go modules
export GO111MODULE=on

# avoid issues with `gpg` as installed via Homebrew, see https://stackoverflow.com/a/42265848/96656
GPG_TTY="$(tty)" && export GPG_TTY

# history
shopt -s histappend                                      # append to bash_history if Terminal.app quits
export HISTSIZE=${HISTSIZE:-32768}                       # Increase Bash history size.
export HISTFILESIZE="${HISTSIZE}"                        # Increase Bash history size.
export HISTCONTROL=${HISTCONTROL:-ignorespace:erasedups} # erase duplicates; alternative option: export HISTCONTROL=ignoredups
export HISTCONTROL='ignoreboth'                          # Omit duplicates and commands that begin with a space from history.
export AUTOFEATURE=${AUTOFEATURE:-true autotest}         # Cucumber / Autotest integration

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline
export MANPAGER='less -X'                 # don’t clear the screen after quitting a manual page

# node
export NODE_REPL_HISTORY=~/.node_history  # Enable persistent REPL history for `node`, see https://nodejs.org/api/repl.html
export NODE_REPL_HISTORY_SIZE='32768'     # Allow 32³ entries; the default is 1000.
export NODE_REPL_MODE='sloppy'            # Use sloppy mode by default, matching web browsers.

# osx
export BASH_SILENCE_DEPRECATION_WARNING=1 # hide the ‘default interactive shell is now zsh’

# python
export PYTHONIOENCODING='UTF-8' # Make Python use UTF-8 encoding for output to stdin, stdout, and stderr.
