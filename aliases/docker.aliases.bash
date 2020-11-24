#!/usr/bin/env bash

alias dk='docker'
alias dklc='docker ps -l'                                                            # List last Docker container
alias dklcid='docker ps -l -q'                                                       # List last Docker container ID
alias dklcip='docker inspect -f "{{.NetworkSettings.IPAddress}}" $(docker ps -l -q)' # Get IP of last Docker container
alias dkps='docker ps'                                                               # List running Docker containers
alias dkpsa='docker ps -a'                                                           # List all Docker containers
alias dki='docker images'                                                            # List Docker images
alias dkrmac='docker rm $(docker ps -a -q)'                                          # Delete all Docker containers
alias dkelc='docker exec -it $(dklcid) bash --login'                                 # enter last docker
alias dkrmflast='docker rm -f $(dklcid)'                                             # force delete last docker
alias dkbash='dkelc'                                                                 # enter last docker
alias dkex='docker exec -it '                                                        # Useful to run any commands into container without leaving host
alias dkri='docker run --rm -i '                                                     # run tmp container
alias dkric='docker run --rm -i -v $PWD:/cwd -w /cwd '                               # run tmp container
alias dkrit='docker run --rm -it '                                                   # run tmp container
alias dkritc='docker run --rm -it -v $PWD:/cwd -w /cwd '                             # run tmp container
alias dkip='docker image prune -a -f'                                                # clean image not used
alias dkvp='docker volume prune -f'                                                  # clean volume not used
alias dksp='docker system prune -a -f'                                               # clean resources not used

case $OSTYPE in
darwin* | *bsd* | *BSD*)
    alias dkrmui='docker images -q -f dangling=true | xargs docker rmi' # Delete all untagged Docker images
    ;;
*)
    alias dkrmui='docker images -q -f dangling=true | xargs -r docker rmi' # Delete all untagged Docker images
    ;;
esac
