# kelf's dotfiles

## 什么是 dotfile？

在 Unix / Linux / macOS 里，**dotfile** 指以 `.` 开头的隐藏配置文件。它们保存了用户的个性化设置、环境变量、程序配置等信息。借助 dotfile，可以在新机器上一键复刻完整的开发环境。

## 🖥️ 开发环境

目前主力机器是一台 **MacBook Air**，日常通过 SSH 连接实验室服务器进行远程开发。

## 🛠️ 核心工具栈

| 类别 | 工具 | 说明 |
| ------ | ------ | ------ |
| 编辑器 | [Neovim](https://neovim.io/) | 极速启动，SSH 场景下秒开项目；使用 **VimPack** 进行插件管理 |
| 终端 | ~~Kitty~~ → [Ghostty](https://ghostty.org/) | 新一代终端模拟器，GPU 加速渲染，速度极快 |
| Shell | [Fish](https://fishshell.com/) | 主 shell，原生补全/语法高亮/autosuggestion；zsh 配置保留作服务器 fallback |
| 终端多代理面板 | [herdr](https://herdr.dev/) | 终端内多代理面板（tmux 内嵌）；部分服务器只有 tmux，相关配置仍保留 |
| AI 编程助手 | [Pi](https://github.com/earendil-works/pi-coding-agent) | 终端 AI 编码代理，支持多代理与扩展生态 |
| 窗口管理 | [Aerospace](https://github.com/nikitabobko/AeroSpace) | 平铺式窗口管理器，支持虚拟桌面与快速窗口切换 |
| 工作区自动化 | [flashspace](https://github.com/wojciech-kulik/FlashSpace) | 按应用自动切换桌面空间 |
| 启动器 | [Raycast](https://www.raycast.com/) | 启动器与效率工具，快速查找文件、启动应用 |
| 输入法 | ~~Rime~~ → 微信输入法 | 搭配 **Karabiner-Elements** 实现 `ESC` 切换英文模式 |
| 按键映射 | [Karabiner-Elements](https://karabiner-elements.pqrs.org/) | `ESC` 切换输入法、`Caps Lock` ↔ `Ctrl` 交换、外接 Windows 键盘适配 |

## 📦 CLI 工具箱

| 工具 | 说明 |
| ------ | ------ |
| [lazygit](https://github.com/jesseduffield/lazygit) | 终端里的 Git TUI，直观高效 |
| [fzf](https://github.com/junegunn/fzf) | 模糊查找神器：文件、历史记录、命令…… |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` 的替代品，智能跳转已访问目录 |
| [mise](https://mise.jdx.dev/) | 运行时版本管理器（Node 等），替代 fnm |
| [bat](https://github.com/sharkdp/bat) | 带语法高亮的 `cat` |
| [tldr](https://tldr.sh/) | 简洁版 `man`，直击常用示例 |
| [ripgrep (rg)](https://github.com/BurntSushi/ripgrep) | 极速 `grep`，默认高亮 |
| [fd](https://github.com/sharkdp/fd) | 更友好的 `find`，快速且带高亮 |
| [yazi](https://github.com/sxyazi/yazi) | 终端文件管理器 |
| [tokei](https://github.com/XAMPPRocky/tokei) | 代码统计，支持多种语言 |
| [duf](https://github.com/muesli/duf) | 更友好的 `df`，磁盘用量一览 |
| [topgrade](https://github.com/topgrade-rs/topgrade) | 一键升级全部包管理器（brew、cargo、uv、TPM…） |

## 🚀 快速开始

### 一键安装

`setup.sh` 用于在新机器上一键安装常用软件：

```bash
bash ./script/setup.sh
```

> 预编译二进制优先，通常无需额外依赖；仅在 cargo-binstall 回退到源码编译时需要 `cmake`。

### setup.sh 原理

这个脚本的设计目标是**在新机器上一键构建完整的 CLI 开发环境**，尽量不需要 root（Linux 下仅系统包管理步骤需要 sudo）。

**安装位置：**

- `cargo-binstall` / `cargo install` 安装的工具位于 `~/.cargo/bin`
- `eget` 下载的二进制位于 `~/.local/bin`
- 平台相关的系统级软件（Neovim、ImageMagick、lazygit）优先使用系统包管理器

**三层安装策略：**

1. **Rust CLI 工具** — 通过 `cargo-binstall` 从预编译二进制直接安装（免编译）
   - ripgrep、eza、fd-find、du-dust、yazi、tlrc、tokei、tree-sitter-cli、bat

2. **GitHub Release 二进制** — 通过 `eget` 自动下载最新 release
   - fzf、fastfetch、mise、ImageMagick

3. **系统包管理器** — 平台适配，优先使用系统原生包
   - **macOS**：`brew install`（Neovim、ImageMagick、lazygit），需要提前安装 Homebrew
   - **Arch Linux**：`sudo pacman -S`（Neovim、ImageMagick、lazygit）
   - **其他 Linux**：fallback 到 `eget` 下载预编译包

**其他工具：**

- **TPM**（Tmux Plugin Manager）：`git clone` 到 `~/.tmux/plugins/tpm`
- **uv**（Python 包管理器）：curl 官方脚本安装
- **starship / zoxide**：`cargo binstall` 安装（fish 主 shell 依赖）
- **Python CLI**：`nvitop` 仅在 Linux 有 NVIDIA 环境时安装

### 使用 GNU Stow 管理软链接

[GNU Stow](https://www.gnu.org/software/stow/) 会在系统对应位置创建指向本仓库的符号链接，方便集中管理配置。

示例效果：

```bash
❯ ls -l ~/.zshrc ~/.tmux.conf
lrwxr-xr-x  1 kelf  staff  19  6  6 12:00 /Users/kelf/.tmux.conf -> /Users/kelf/dotfiles/.tmux.conf
lrwxr-xr-x  1 kelf  staff  15  6  6 12:00 /Users/kelf/.zshrc -> /Users/kelf/dotfiles/.zshrc
```

**创建软链接（避免整个目录被软链，运行时数据污染仓库）：**

```bash
stow --no-folding .
```

**取消软链接：**

```bash
stow -D --no-folding .
```

> 部分文件和目录已通过 `.stow-local-ignore` 排除（如 `assets/`、`doc/`、`script/` 等），避免误链接。

### 归档配置（archive/）

已弃用但保留历史参考的配置放在 `archive/` 目录（不会被 Stow 链接）：

- `kitty/`、`wezterm/` — 旧终端，已迁移到 Ghostty
- `yabai/`、`skhd/` — 旧窗口管理器，已迁移到 Aerospace

### 其他已纳入仓库的配置

| 配置 | 说明 |
| ------ | ------ |
| `.config/sketchybar/` | macOS 菜单栏状态栏（Spaces/时钟/音量/电池） |
| `.config/flashspace/` | 按应用自动切换桌面空间 |
| `.config/karabiner/` | 按键映射（ESC 切输入法、Caps↔Ctrl） |
| `.config/aerospace/` | 平铺窗口管理器 |
| `.ssh/rc` | SSH 登录时固定 agent socket 路径（配合 tmux 复用） |

### 辅助脚本（script/）

- `setup.sh` — 一键安装开发环境（见上文）
- `backup_mac.sh` — 备份 Brewfile 和 .ssh 到 OneDrive
- `start-camera-ftp.sh` — 启动相机 FTP 传输服务器（pure-ftpd）

### 文档（doc/）

- `doc/Neovim.md` — Neovim 配置结构说明（vim.pack 插件管理）

### Fish Shell（主 shell）

Fish 是日常主 shell，配置位于 `.config/fish/`，按环境变量、历史记录、插件、缩写和快捷键拆分；`functions/` 中是迁移自 zsh 的函数。zsh 配置（`.zshrc`、`zsh/`）保留用于服务器等不支持 fish 的环境，两者可以并存。

```bash
stow --no-folding .
chsh -s "$(command -v fish)"  # 将 Fish 设为默认 shell（需手动执行，会提示密码）
```

Fish 使用原生补全、语法高亮和 autosuggestion，Tab 补全启用 `fish_completion_match_mode fuzzy` 模糊匹配；fzf 官方集成（`fzf --fish`）提供 `Ctrl-R` 历史搜索、`Ctrl-T` 文件搜索、`Alt-C` 目录跳转、`Shift-Tab` 补全。机器相关的 Fish 设置可放在 `~/.config/fish/config.local.fish`；修改后运行 `fish_reload`。

### 系统级配置

| 文件 | 说明 |
|------|------|
| `.tmux.conf` | tmux 配置（TPM 插件、状态栏、窗口图标映射；仅服务器环境使用） |
| `.zshrc` + `zsh/` | zsh fallback 配置（服务器环境使用） |

### Tmux（服务器环境）

本地终端面板已由 herdr 替代；但部分服务器只提供 tmux，`.tmux.conf` 与 [TPM](https://github.com/tmux-plugins/tpm) 仍保留。首次进入服务器 Tmux 后按 `<C-space> + I`（大写 i）自动安装插件。

### Pi 配置

Pi 的全局设置位于 `~/.pi/agent/settings.json`，仓库中对应路径为 `.pi/agent/settings.json`，由 Stow 直接管理软链（`--no-folding` 只链接单个文件，不会把运行时目录链进来）。

```bash
# 用 Stow 部署其他配置（.pi/agent/settings.json 会一并链接）
stow --no-folding .
```

> 注意：`~/.pi/agent/` 下还有其他运行时数据（会话、缓存、npm 包等），仅 `settings.json` 通过软链纳入仓库管理。
