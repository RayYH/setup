#!/usr/bin/env bash

# follow redirects
alias cul='curl -L'
# follow redirects, verbose
alias culv='curl -L -v'
# follow redirects, download as original name
alias culo='curl -L -O'
# follow redirects, download as original name, continue
alias culoc='curl -L -C - -O'
# follow redirects, download as original name, continue, retry 5 times
alias culocr='curl -L -C - -O --retry 5'
# follow redirects, fetch banner
alias culb='curl -L -I'
# see only response headers from a get request
alias culhead='curl -D - -so /dev/null'
