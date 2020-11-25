#!/usr/local/bin/bash

# brew aliases
alias brewp='brew pin'                                                      # Pin the specified formula, preventing them from being upgraded
alias brews='brew list -1'                                                  # List all installed formulae or casks
alias brewlp='brew list --pinned'                                           # List all pinned formulas or casks
alias brewuo='brew update && brew outdated'                                 # List outdated formulas
alias brewur='brew update-reset'                                            # Reset your homebrew-core
alias brewuc='brew upgrade && brew cleanup'                                 # Upgrade outdated packages
alias brewu='bubo && bubc'                                                  # Update brew & formulas
alias brewuf='brew upgrade --formula'                                       # Upgrade only formulas
alias brewuoc='brew update && brew outdated --cask'                         # Show outdated casks
alias brewroc='brew cask reinstall $(brew outdated --cask) && brew cleanup' # Reinstall outdated casks
