#!/usr/bin/env bash

# https://pip.pypa.io/en/stable/user_guide/#command-completion
# Of course, you should first install the pip, say on Debian:
# sudo apt-get install python-pip
# sudo apt-get install python3-pip
# If the pip package is installed within virtual environments, say, python managed by pyenv,
# you should first initilization the corresponding environment.
# So that the pip/pip3 is in system's path.
if command -v pip3 &>/dev/null; then
  eval "$(pip3 completion --bash)"
fi
