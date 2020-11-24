# Setup

English | [简体中文](README_zh_CN.md)

---

This repo sets up the development environment **I** need for daily programming.

## Structure

```
.
├── aliases       # aliases
├── backup        # backup files (not used yet)
├── config        # global config files
├── custom        # custom scripts
├── environments  # exports
├── plugins       # plugins
├── setup.sh      # bootstrap script
└── themes        # themes
```

## Installation

If you use other shells, switch to `bash` first:

```bash
# check current shell: echo $SHELL
$ chsh -s /bin/bash
# or
$ chsh -s /usr/local/bin/bash
```

Then install `setup` via `git` tool (make sure you have `git` installed).

```bash
$ git clone https://github.com/rayyh/setup ~/.setup
$ cp ~/.setup/.setuprc ~/
```

> I like to keep it in `~/Code/projects/shell/setup`, with `~/.setup` as a symlink.

Now add below lines to your `.bash_profile` or your `.bashrc`:

```
test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"
```

`suorce ~/.bash_profile` (macos) or `source ~/.bashrc` (linux).

## Upgrade

```bash
$ upgrade_set_up
```

## Sync global configuration files

```bash
# sync files like .gitconifg, .gitignore and so on
$ sync_set_up_configs 

# clean all backup files
$ clean_set_up_backup_files
```

## `.setuprc` Example

```bash
SET_UP_THEME='agnoster'

FALLBACK_SET_UP_THEME='dotfiles'

environments=(
)

completions=(
)

aliases=(
)

plugins=(
)

GIT_AUTHOR_NAME="rayyh"
GIT_AUTHOR_EMAIL="rayyounghong@gmail.com"
GIT_SIGNING_KEY="XXXXXXXXXXXXXXXX"
```

## Thanks to

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

## License

This project is open-source software licensed under the [MIT License](LICENSE).
