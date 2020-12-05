# Setup

[English](README.md) | 简体中文

---

该仓库用于快速设置 **我的** 开发环境，只针对 macos 和 linux (ubuntu)，未在 windows 下测试，但是 windows terminal + WSL 应该可以使用。

## 目录结构

```
.
├── aliases       # 别名
├── backup        # 备份目录
├── config        # 一些插件的全局配置文件
├── custom        # 用户自定义脚本
├── environments  # 环境变量
├── plugins       # 插件目录
├── setup.sh      # 启动脚本
└── themes        # 主题目录
```

## 安装

### 快速安装

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/rayyh/setup/master/install.sh)"
```

### 手动安装

如果你正在使用其他 Shell（可以使用 `echo $SHELL` 命令查看当前 Shell），比如 mac 新版本就默认使用 `zsh` 而不是 `bash`，你需要先切换到 `bash`：

```bash
$ chsh -s /bin/bash
# 或者使用通过 brew 或者其他方式安装的 bash，确保 `etc/shells` 已经包含 `/usr/local/bin/bash`
# # sudo echo /usr/local/bin/bash >> /etc/shells
$ chsh -s /usr/local/bin/bash
```

然后你可以通过 `git` 来安装本库（确保你已安装了 `git`）：


```bash
$ git clone https://github.com/rayyh/setup ~/.setup
$ cp ~/.setup/.setuprc ~/
```

> 我喜欢把该库放在 `~/Code/projects/shell/setup`, 然后通过 `ln -s` 命令链接到 `~/.setup`.

接下来你需要把下面的一行代码放在你的 `.bash_profile` (macos) 或 `.bashrc` (linux) 文件的末尾：

```
test -e "${HOME}/.setup/setup.bash" && source "${HOME}/.setup/setup.bash"
```

然后重启终端，或者执行下面的命令：

```bash
# mac
$ suorce ~/.bash_profile

# linux
$ source ~/.bashrc
```

## 升级

在终端执行命令 `upgrade_set_up` 即可。

## 同步全局配置文件

```bash
# 同步 .gitconifg, .gitignore 等文件到 Home 目录
$ sync_set_up_configs 

# 清除所有已备份的文件
$ clean_set_up_backup_files
```

## 配置项

下面是我的 `~/.setuprc` 文件，查看我们的 [wiki](https://github.com/RayYH/setup/wiki) 以获得更多信息。

```bash
# 主题，你可以将主题设置为 random，这样你会随机使用我们提供的一个主题。
# 如果你使用 mac，你需要安装 coreutils: `brew install coreutils`。
# 你可以通过命令 `echo $SET_UP_THEME` 来获得当前的主题名称。
SET_UP_THEME='agnoster'

# 备选主题，之所以提供该配置，是因为有些默认的 terminal 不支持
# powerline 字体，比如我喜欢的 agnoster 主题就不能很好地显示
# 此时，我们就要选择一个可以在任何终端环境都能显示的主题
FALLBACK_SET_UP_THEME='dotfiles'

# 配置环境变量、别名、插件... 为空表示加载所有插件
# 你也可以只加载部分插件：
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

# 下面的配置项，前两个是必须配置的，第三个是你开启了签名需要配置的，留空则不开启签名
GIT_AUTHOR_NAME="rayyh"
GIT_AUTHOR_EMAIL="rayyounghong@gmail.com"
GIT_SIGNING_KEY="XXXXXXXXXXXXXXXX"
```

## 致谢

+ [bash-it](https://github.com/Bash-it/bash-it)
+ [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

## License

本库是一个开源项目，遵循 [MIT](LICENSE) 许可协议发布。
