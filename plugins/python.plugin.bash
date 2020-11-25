#!/usr/bin/env bash

function update_pypi_packages() {
  # always use mirror
  local mirror=https://pypi.tuna.tsinghua.edu.cn/simple
  if command -v pip3 &>/dev/null && pip3 list --outdated | grep -v '^\-e'; then
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U -i $mirror
  fi
  if command -v pip &>/dev/null && pip list --outdated | grep -v '^\-e'; then
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U -i $mirror
  fi
}
