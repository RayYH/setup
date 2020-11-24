#!/usr/bin/env bash
shopt -s histappend                                      # append to bash_history if Terminal.app quits
export HISTSIZE=${HISTSIZE:-32768}                       # Increase Bash history size.
export HISTFILESIZE="${HISTSIZE}"                        # Increase Bash history size.
export HISTCONTROL=${HISTCONTROL:-ignorespace:erasedups} # erase duplicates; alternative option: export HISTCONTROL=ignoredups
export HISTCONTROL='ignoreboth'                          # Omit duplicates and commands that begin with a space from history.
export AUTOFEATURE=${AUTOFEATURE:-true autotest}         # Cucumber / Autotest integration
