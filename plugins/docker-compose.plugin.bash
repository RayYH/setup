#!/usr/bin/env bash
function docker-compose-fresh() {
    if [ -n "$1" ]; then
        echo "Using docker-compose file: $1"
        docker-compose --file "$1" stop
        docker-compose --file "$1" rm -f
        docker-compose --file "$1" up -d
        docker-compose --file "$1" logs -f --tail 100
    else
        docker-compose stop
        docker-compose rm -f
        docker-compose up -d
        docker-compose logs -f --tail 100
    fi
}
