# Setup

English | [简体中文](README_zh_CN.md)

---

This repo sets up the development environment **I** need for daily programming.

## Installation

```bash
# install setup only
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"

# bootstrap new computer (this will install setup at the same time)
S_ALL=1 S_SET_COMPUTER_NAME=1 S_CASKS=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/bootstrap.sh)"
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

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
+ [mac-bootstrap](https://github.com/joshukraine/mac-bootstrap)
+ [mac-bootstrap](https://github.com/deild/mac-bootstrap)

## License

This project is open-sourced software licensed under the [MIT license](LICENSE).
