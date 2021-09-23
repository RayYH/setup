#!/usr/bin/env bash

function set_p() {
  local port=${SET_UP_PROXY_HTTP_PORT:=1088}
  local sock_port=${SET_UP_PROXY_SOCKS_PORT:=1086}
  local host=${SET_UP_PROXY_HTTP_HOST:=127.0.0.1}
  local sock_host=${SET_UP_PROXY_SOCKS_HOST:=127.0.0.1}
  # socks proxy in gnome
  export all_proxy=socks5://${sock_host}:${sock_port}
  export ftp_proxy=http://${host}:${port}
  export http_proxy=http://${host}:${port}
  export https_proxy=http://${host}:${port}
  export HTTP_PROXY=${http_proxy}
  export HTTPS_PROXY=${https_proxy}
  # see https://minikube.sigs.k8s.io/docs/handbook/vpn_and_proxy/
  export NO_PROXY=localhost,127.0.0.1,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24
}

function unset_p() {
  unset all_proxy
  unset ftp_proxy
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset NO_PROXY
}
