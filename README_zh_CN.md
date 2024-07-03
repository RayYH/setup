# Setup

> 该仓库已经不再维护，[新仓库](https://github.com/RayYH/dotfiles) 正在开发中，私有状态。当准备好后，我会将其公开。

[English](README.md) | 简体中文

---

该仓库用于快速设置 **我的** MacOS 开发环境。

## 安装

安装 [delta](https://github.com/dandavison/delta)， 从 [Nerd fonts site](https://www.nerdfonts.com/) 站点下载一款 nerd font.

```bash
# install setup only
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"

# bootstrap new computer (this will install setup at the same time)
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

## 更新

```bash
$ upgrade_set_up
```

## 同步全局配置文件

```bash
# 同步全局配置文件
$ sync_set_up_configs

# 清理备份配置文件
$ clean_set_up_backup_files
```

## 致谢

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
+ [mac-bootstrap](https://github.com/joshukraine/mac-bootstrap)
+ [mac-bootstrap](https://github.com/deild/mac-bootstrap)

## License

本库是一个开源项目，遵循 [MIT](LICENSE) 许可协议发布。
