#!/bin/bash

# ──────────────────────────────────────────────────────────────────────
# 此脚本用于在新机器上一键配置开发环境（无需Root权限）
# 软件将安装在 ~/.local/bin 下
# ──────────────────────────────────────────────────────────────────────
set -euo pipefail

# ╭──────────────────────────────────────────────────────────╮
# │                        常量设置                          │
# ╰──────────────────────────────────────────────────────────╯

INSTALL_DIR="$HOME/.local/"
CONFIG_DIR="./config"
TARGET_DIR="$HOME/.config"
# Github 下载的镜像配置
GITHUB_MIRROR="https://ghfast.top/"

# 创建安装文件基本目录
install -d $INSTALL_DIR/bin $INSTALL_DIR/share $INSTALL_DIR/lib

# 切换到脚本所在的目录
cd "$(dirname "$0")"

# ╭──────────────────────────────────────────────────────────╮
# │                       检查必要工具                       │
# ╰──────────────────────────────────────────────────────────╯

# ── cmake ─────────────────────────────────────────────────────────────
# 编译工作
if ! command -v cmake >/dev/null 2>&1; then
	echo "cmake is required..."
	exit 1
fi


# ── curl ──────────────────────────────────────────────────────────────
# 用于下载
if ! command -v curl >/dev/null 2>&1; then
	echo "curl is required..."
	exit 1
fi

# ── wget ──────────────────────────────────────────────────────────────
if ! command -v wget >/dev/null 2>&1; then
	echo "wget is required..."
	exit 1
fi


# ── git ───────────────────────────────────────────────────────────────
if ! command -v git >/dev/null 2>&1; then
	echo "git is required..."
	exit 1
fi


# ── cargo ─────────────────────────────────────────────────────────────
# 检查是否有cargo
if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh
fi

# ╭──────────────────────────────────────────────────────────╮
# │                    使用Cargo安装软件                     │
# ╰──────────────────────────────────────────────────────────╯

# fzf 查找工具
command -v fzf >/dev/null 2>&1 || (git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install)
# 正则查找工具
command -v rg >/dev/null 2>&1 || cargo install ripgrep
# 更好用的ls工具
command -v eza >/dev/null 2>&1 || cargo install eza
command -v fd >/dev/null 2>&1 || cargo install fd-find
# 更好用的du工具
command -v dust >/dev/null 2>&1 || cargo install du-dust
# yazi--文件管理器
command -v yazi >/dev/null 2>&1 || cargo install --locked yazi-fm yazi-cli
# tldr 便捷的命令查看器
command -v tldr >/dev/null 2>&1 || cargo install --locked tlrc
# tokei 代码统计工具
command -v tokei >/dev/null 2>&1 || cargo install --git https://github.com/XAMPPRocky/tokei.git tokei
command -v tree-sitter >/dev/null 2>&1 || cargo install --locked tree-sitter-cli 

# ╭──────────────────────────────────────────────────────────╮
# │                          Neovim                          │
# ╰──────────────────────────────────────────────────────────╯
NVIM_VERSION="v0.12.0"

# 如果是Macos系统，那么使用homebrew进行安装k
if [ "$(uname -s)" = "Darwin" ]; then
  command -v nvim >/dev/null 2>&1 || brew install neovim

# 如果是 Archlinux 系统，那么使用 Pacman 进行安装
elif command -v pacman >/dev/null 2>&1; then
  command -v nvim >/dev/null 2>&1 || sudo pacman -S --needed neovim

else
  NEOVIM_RELEASE_URL="${GITHUB_MIRROR}https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"

  if [ ! -x "$INSTALL_DIR/bin/nvim" ]; then
    echo "Starting download Neovim from github"
    DOWNLOAD_FILE="nvim.tar.gz"
    wget -O "$DOWNLOAD_FILE" "$NEOVIM_RELEASE_URL"
    tar -xzf "$DOWNLOAD_FILE"
    EXTRACT_DIR="nvim-linux-x86_64"

    cp -r "$EXTRACT_DIR"/{bin,share,lib} "$INSTALL_DIR"

    rm -rf "$EXTRACT_DIR"
    rm -f "$DOWNLOAD_FILE"
  fi
fi


# ╭──────────────────────────────────────────────────────────╮
# │                         LazyGit                          │
# ╰──────────────────────────────────────────────────────────╯

LAZYGIT_RELEASE_URL="${GITHUB_MIRROR}jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz"

if ! command -v lazygit >/dev/null 2>&1; then
  # 下载指定URL的包
	echo "Starting download LazyGit from github"
  DOWNLOAD_FILE="lazygit.tar.gz"
  wget -O $DOWNLOAD_FILE $LAZYGIT_RELEASE_URL

  EXTRACT_DIR="lazygit"
  mkdir $EXTRACT_DIR

  tar -xf $DOWNLOAD_FILE -C $EXTRACT_DIR
  cp $EXTRACT_DIR/lazygit $INSTALL_DIR/bin

  # 清理下载文件
  rm -rf $EXTRACT_DIR
  rm $DOWNLOAD_FILE
fi

# ── 安装TPM插件管理器 ─────────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm" 
if [ ! -d "$TPM_DIR" ]; then
  echo "$TPM_DIR does not exist. Using git to clone."
  git clone https://github.com/tmux-plugins/tpm $TPM_DIR
fi


# 安装 uv
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi


#  安装 nvm 
if ! command -v fnm >/dev/null 2>&1; then
   curl -fsSL https://fnm.vercel.app/install | bash
fi
