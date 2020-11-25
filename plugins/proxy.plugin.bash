#!/usr/bin/env bash

function set_p() {
  local port=${SET_UP_PROXY_HTTP_PORT:=8118}
  local sock_port=${SET_UP_PROXY_SOCKS_PORT:=1080}
  # socks proxy in gnome
  export all_proxy=socks5://127.0.0.1:${sock_port}
  export ftp_proxy=http://127.0.0.1:${port}
  export http_proxy=http://127.0.0.1:${port}
  export https_proxy=http://127.0.0.1:${port}
}

function unset_p() {
  unset all_proxy
  unset ftp_proxy
  unset http_proxy
  unset https_proxy
}
