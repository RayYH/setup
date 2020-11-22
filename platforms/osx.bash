#!/usr/bin/env bash

# osx related functions

# change dir to the folder opened in Finder
function cdf() {
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')" || return
}

# quick look file via default Preview program provided by macos
function ql() {
	qlmanage -p "$*" >&/dev/null
}

# Open chrome window behind a socks proxy
function chromep() {
	if [ -z "${1}" ]; then
		echo "ERROR: No socks port specified."
		return 1
	fi
	if lsof -i ":$1" >/dev/null 2>&1; then
		chrome --user-data-dir="$HOME/.cache/chrome/proxy-profile" \
			--proxy-server="socks5://localhost:$1"
	else
		echo "ERROR: invalid socks port."
		return 1
	fi
}
