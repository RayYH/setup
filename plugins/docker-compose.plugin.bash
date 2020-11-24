#!/usr/bin/env bash
function docker-compose-fresh() {
    local DCO_FILE_PARAM=""
    if [ -n "$1" ]; then
        echo "Using docker-compose file: $1"
        DCO_FILE_PARAM="--file $1"
    fi

    docker-compose "$DCO_FILE_PARAM" stop
    docker-compose "$DCO_FILE_PARAM" rm -f
    docker-compose "$DCO_FILE_PARAM" up -d
    docker-compose "$DCO_FILE_PARAM" logs -f --tail 100
}
