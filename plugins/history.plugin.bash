#!/usr/bin/env bash

# Show top input commands
function rh() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}
