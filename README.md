# Setup

English | [简体中文](README_zh_CN.md)

---

This repo sets up the development environment **I** need for daily programming.

## Structure

```
.
├── aliases       # aliases
├── backup        # backup files (backup old files will be replaced)
├── config        # global config files
├── custom        # custom scripts
├── environments  # exports
├── plugins       # plugins
├── setup.sh      # bootstrap script
└── themes        # themes
```

## Installation

### Installing using `install.sh`

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"
```

### Installing manually

If you use other shells, switch to `bash` first:

```bash
# check current shell: echo $SHELL
$ chsh -s /bin/bash
# or - Make sure your `etc/shells` file contains `/usr/local/bin/bash` item
# sudo echo /usr/local/bin/bash >> /etc/shells
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

Run command `suorce ~/.bash_profile` (macos) or `source ~/.bashrc` (linux) in your terminal.

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

## Configuration

Below is my `~/.setuprc` file, refer to [our wiki](https://github.com/RayYH/setup/wiki) for more information.

```bash
# Theme, you can set this variable to `random` to get a random theme
# If you are working on mac, you should install coreutils via brew:
# `brew install coreutils` since we use the `shuf` command to pick
# a random theme. You can always get current theme name via 
# `echo $SET_UP_THEME` command
SET_UP_THEME='agnoster'

# Fallback theme
# when theme provided but can noly be used when launched `iTerm2.app`
# we should switch to a theme can be used in a non-iTerm2 app to avoid
# broken styles, if you are sure your terminal supports powerline, you
# can still switch to a theme like `agnoster` by modifying below value
FALLBACK_SET_UP_THEME='dotfiles'

# empty means load all envs, plugins, ..
# or you can use syntax like this:
# plugins=(
#   git
#   docker
# )
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

This project is open-sourced software licensed under the [MIT license](LICENSE).
