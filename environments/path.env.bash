#!/usr/bin/env bash

# brew
append_path "/usr/local/bin"
append_path "/usr/local/sbin"

# mysql
append_path "/usr/local/opt/mysql-client/bin"

# curl
append_path "/usr/local/opt/curl/bin"

# qt
append_path "/usr/local/opt/qt/bin"

# go
[ -d "$HOME/Code/projects/go" ] && export GOPATH="$HOME/Code/projects/go" && append_path "$GOPATH/bin"

# rust
append_path "$HOME/.cargo/bin"

# Custom Path
append_path "$HOME/Bin"

# sed: illegal option -- r
# you should install gnu-sed first via command: brew install gnu-sed
append_path "/usr/local/opt/gnu-sed/libexec/gnubin"
