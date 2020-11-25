#!/usr/bin/env bash

# Essential helpful plugins
# shellcheck disable=SC2145

# mkdir then cd in
function mkd() {
  mkdir -p "$@" && cd "$_" || return
}

# find file in current folder whose name matched provided string
function ff() {
  find . -name "$@"
}

# find file in current folder whose name starts with provided string
function ffs() {
  find . -name "$@"'*'
}

# find file in current folder whose name ends with provided string
function ffe() {
  find . -name '*'"$@"
}

# determine the size of file or folder
function fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  # shellcheck disable=SC2199
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

# create a dataurl of given file
function dataurl() {
  local mimeType
  mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# extract file: extract *.tgz
function extract() {
  if [ -f "$1" ]; then
    case $1 in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar e "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# create a `.tar.gz` archive
function targz() {
  local tmpFile="${*%/}.tar"
  tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

  size=$(
    stat -f"%z" "${tmpFile}" 2>/dev/null # macOS `stat`
    stat -c"%s" "${tmpFile}" 2>/dev/null # GNU `stat`
  )

  local cmd=""
  if ((size < 52428800)) && hash zopfli 2>/dev/null; then
    # the .tar file is smaller than 50 MB and Zopfli is available; use it
    cmd="zopfli"
  else
    if hash pigz 2>/dev/null; then
      cmd="pigz"
    else
      cmd="gzip"
    fi
  fi

  echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…"
  "${cmd}" -v "${tmpFile}" || return 1
  [ -f "${tmpFile}" ] && rm "${tmpFile}"

  zippedSize=$(
    stat -f"%z" "${tmpFile}.gz" 2>/dev/null # macOS `stat`
    stat -c"%s" "${tmpFile}.gz" 2>/dev/null # GNU `stat`
  )

  echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
}

# start a HTTP Server via http-server package (node) - `npm i http-server -g`
# if http-server not installed, use python instead
function server() {
  if command -v http-server &>/dev/null; then
    http-server -p "${1:-8000}" || return
  fi
  python -m SimpleHTTPServer "${1:-8000}"
}

# show the compression ratio
function gz() {
  local origsize
  origsize=$(wc -c <"$1")
  local gzipsize
  gzipsize=$(gzip -c "$1" | wc -c)
  local ratio
  ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
  printf "orig: %d bytes\n" "$origsize"
  printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# get all subdomains, e.g. getcertnames baidu.com
function getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified."
    return 1
  fi

  local domain="${1}"
  echo "Testing ${domain}…"
  echo "" # newline

  local tmp
  tmp=$(echo -e "GET / HTTP/1.0\nEOT" |
    openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)

  if [[ "${tmp}" == *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText
    certText=$(echo "${tmp}" |
      openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version")
    echo "Common Name:"
    echo "" # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
    echo "" # newline
    echo "Subject Alternative Name(s):"
    echo "" # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
      sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
    return 0
  else
    echo "ERROR: Certificate not found."
    return 1
  fi
}

# open folder
function o() {
  if command -v open &>/dev/null; then
    if [ $# -eq 0 ]; then
      open .
    else
      open "$@"
    fi
  fi
}

# optimized tree command，omit some folder: please run brew install tree first
function tre() {
  tree -aC -I '.git|node_modules|bower_components|vendor' --dirsfirst "$@" | less -FRNX
}

# url decode
function urldecode() {
  : "${*//+/ }"
  echo -e "${_//%/\\x}"
}
