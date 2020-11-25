#!/usr/bin/env bash

# ATTENTION: This aliases is only for my personal usage!!!
# I DONT WANT IT in the custom folder, SO I'd recommend you
# FORK this repo and make your own change
if [ "$USER" == "ray" ] || [ "$USER" == "rayyh" ] ||
    [ "$USER" == "vagrant" ]; then
    alias e="cd ~/Code/env && clear"                   # Docker/Vagrant/Kubernetes
    alias p="cd ~/Code/projects && clear"              # projects
    alias pc="cd ~/Code/projects/c && clear"           # C projects
    alias pcpp="cd ~/Code/projects/cpp && clear"       # CPP projects
    alias pphp="cd ~/Code/projects/php && clear"       # PHP projects
    alias ppython="cd ~/Code/projects/python && clear" # Python projects
    alias pjava="cd ~/Code/projects/java && clear"     # Java projects
    alias pjs="cd ~/Code/projects/javascript && clear" # JavaScript projects
    alias pshell="cd ~/Code/projects/shell && clear"   # Shell projects
    alias pgo="cd ~/Code/projects/go && clear"         # go projects
fi
