# [WIP] Setup

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
chsh -s /bin/bash
# or
chsh -s /usr/local/bin/bash
```

Then install `setup` via `git` tool (make sure you have `git` installed).

```bash
git clone https://github.com/rayyh/setup ~/.setup
cp ~/.setup/.setuprc ~/
```

> I like to keep it in `~/Code/projects/shell/setup`, with `~/.setup` as a symlink.

Now add below lines to your `.bash_profile` or your `.bashrc`:

```
test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"
```

Restart the terminal session or `suorce ~/.bash_profile`/`source ~/.bashrc`

## Upgrade

```bash
$ upgrade_set_up
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

## Todos

+ [x] color util
+ [x] git functionality for prompt
+ [x] bootstrap script
+ [x] load theme elegantly
+ [x] basic themes: dotfiles for Terminal, agnoster for iTerm
+ [ ] more themes...
+ [x] load plugins (aliases, completion, functions...)
+ [x] upgrade script (use git pull, not backup)
+ [x] steal useful code (old dotfiles repo)
+ [ ] sync global config files
+ [ ] provide images for themes
+ [ ] write a wiki

## Thanks to

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

## License

This project is open-source software licensed under the [MIT License](LICENSE).
