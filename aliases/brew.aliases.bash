#!/usr/local/bin/bash

# brew aliases
alias brewp='brew pin'                                                    # Pin the specified formula, preventing them from being upgraded
alias brews='brew list -1'                                                # List all installed formulae or casks
alias brewsp='brew list --pinned'                                         # List all pinned formulas or casks
alias bubo='brew update && brew outdated'                                 # List outdated formulas
alias bubc='brew upgrade && brew cleanup'                                 # Upgrade outdated packages
alias bubu='bubo && bubc'                                                 # Update brew & formulas
alias buf='brew upgrade --formula'                                        # Upgrade only formulas
alias bcubo='brew update && brew outdated --cask'                         # Show outdated casks
alias bcubc='brew cask reinstall $(brew outdated --cask) && brew cleanup' # Reinstall outdated casks
