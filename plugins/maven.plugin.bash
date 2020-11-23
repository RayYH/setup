#!/usr/bin/env bash

# generate a maven project quickly
function mvn_g() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: mvn_g [groupId] [artifactId]"
    else
        mvn archetype:generate \
            -DgroupId="$1" \
            -DartifactId="$2" \
            -DarchetypeGroupId=org.apache.maven.archetypes \
            -DarchetypeArtifactId=maven-archetype-quickstart \
            -DarchetypeVersion=1.4 \
            -DinteractiveMode=false &&
            cd "$2" || return
    fi
}
