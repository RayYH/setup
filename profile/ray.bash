#!/usr/bin/env bash
# shellcheck disable=SC2139

alias one="cd ~/OneDrive && clear"                                       # OneDrive
alias obsi="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents" # Obsidian

CODE_DIR="$HOME/Code"
alias p="cd $CODE_DIR"
alias pwo="cd $CODE_DIR/work"
alias ppr="cd $CODE_DIR/projects"

# kitty alias
alias icat="kitty +kitten icat"
alias d="kitty +kitten diff"
alias gdt="git difftool --no-symlinks --dir-diff"

#if [[ "$OSTYPE" == "linux-gnu"* ]]; then
#  if command -v xclip &>/dev/null; then
#    alias pbcopy='xclip -selection clipboard'
#    alias pbpaste='xclip -selection clipboard -o'
#  fi
#fi

alias wiki="cd $CODE_DIR/wiki"