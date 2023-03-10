# Setup

English | [简体中文](README_zh_CN.md)

---

This repo sets up the development environment **I** need for daily programming.

## Installation

Download `Inconsolata Nerd Font` from [Nerd fonts site](https://www.nerdfonts.com/).

```bash
# install setup only
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"

# bootstrap new computer (including setup)
S_SET_COMPUTER_NAME=1 S_CASKS=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/bootstrap.sh)"

# update formulas, casks...
S_ONLY_UPDATE=1 S_CASKS=1 ./bootstrap.sh
```

## Troubleshooting

```
warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
```

```shell
sudo dpkg-reconfigure locales
```

## Upgrade

```bash
$ upgrade_set_up
```

## Sync global configuration files

```bash
# sync files
$ sync_set_up_configs

# clean all backup files
$ clean_set_up_backup_files
```

## Thanks to

* [bash-it](https://github.com/Bash-it/bash-it)
* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* [mac-bootstrap](https://github.com/joshukraine/mac-bootstrap)
* [mac-bootstrap](https://github.com/deild/mac-bootstrap)

## License

This project is open-sourced software licensed under the [MIT license](LICENSE).
