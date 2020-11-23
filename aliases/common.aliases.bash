#!/usr/bin/env bash

if [ ! "$(uname -s)" = 'Darwin' ]; then
    # Mac
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
else
    # Others - I use mac and ubuntu, so, this means linux
    alias chrome=google-chrome
fi
