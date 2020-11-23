# [WIP] Setup

This repo sets up the development environment **I** need for daily programming.

## Structure

```
.
├── aliases       # aliases
├── backup        # backup .bashrc or .bash_profile
├── config        # global config files
├── custom        # custom scripts
├── environments  # exports
├── plugins       # plugins
├── setup.sh      # bootstrap script
└── themes        # themes
```

## Installation

```bash
git clone https://github.com/rayyh/setup ~/.setup
cp ~/.setup/.setuprc ~/
```

Now add below lines to your `.bash_profile` or your `.bashrc`:

```
test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"
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
+ [ ] upgrade script
+ [x] steal useful code (old dotfiles repo)
+ [ ] sync global config files
+ [ ] provide image for themes
+ [ ] write a wiki

## Thanks to

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
+ [oh-my-bash](https://github.com/ohmybash/oh-my-bash)

## License

This project is open-source software licensed under the [MIT License](LICENSE).
