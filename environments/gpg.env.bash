#!/usr/bin/env bash

GPG_TTY="$(tty)" && export GPG_TTY # Avoid issues with `gpg` as installed via Homebrew, see https://stackoverflow.com/a/42265848/96656
