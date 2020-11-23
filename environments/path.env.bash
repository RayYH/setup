#!/usr/bin/env bash

# brew
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# mysql
[ -d "/usr/local/opt/mysql-client/bin" ] && export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# curl
[ -d "/usr/local/opt/curl/bin" ] && export PATH="/usr/local/opt/curl/bin:$PATH"

# qt
[ -d "/usr/local/opt/qt/bin" ] && export PATH="/usr/local/opt/qt/bin:$PATH"

# go
[ -d "$HOME/Code/projects/go" ] && export GOPATH=$HOME/Code/projects/go && export PATH="$GOPATH/bin:$PATH"

# rust
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

# Custom Path
export PATH="$HOME/Bin:$PATH"
