#!/bin/bash

# ──────────────────────────────────────────────────────────────────────
# 此脚本用于在新机器上一键配置开发环境（无需Root权限）
# 软件将安装在 ~/.local/bin 下
# ──────────────────────────────────────────────────────────────────────

# ╭──────────────────────────────────────────────────────────╮
# │                        常量设置                          │
# ╰──────────────────────────────────────────────────────────╯

INSTALL_DIR="$HOME/.local/"
CONFIG_DIR="./config"
TARGET_DIR="$HOME/.config"

# 创建安装文件基本目录
install -d $INSTALL_DIR/bin $INSTALL_DIR/share $INSTALL_DIR/lib

# 切换到脚本所在的目录
cd "$(dirname "$0")"

# ╭──────────────────────────────────────────────────────────╮
# │                       检查必要工具                       │
# ╰──────────────────────────────────────────────────────────╯

# ── cmake ─────────────────────────────────────────────────────────────
# 编译工作
if [ ! -x "$(command -v cmake)" ]; then
	echo "cmake is required..."
	exit 1
fi


# ── curl ──────────────────────────────────────────────────────────────
# 用于下载
if [ ! -x "$(command -v curl)" ]; then
	echo "curl is required..."
	exit 1
fi

# ── wget ──────────────────────────────────────────────────────────────
if [ ! -x "$(command -v wget)" ]; then
	echo "wget is required..."
	exit 1
fi


# ── git ───────────────────────────────────────────────────────────────
if [ ! -x "$(command -v git)" ]; then
	echo "git is required..."
	exit 1
fi




# ── cargo ─────────────────────────────────────────────────────────────
# 检查是否有rustup
if [ ! -x "$(command -v rustup)" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	exit 1
fi

# ╭──────────────────────────────────────────────────────────╮
# │                    使用Cargo安装软件                     │
# ╰──────────────────────────────────────────────────────────╯

# fzf 查找工具
[ -d "$HOME/.fzf" ] || (git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install)
# 正则查找工具
[ -x "$(command -v rg)" ] || cargo install ripgrep
# 更好用的ls工具
[ -x "$(command -v eza)" ] || cargo install eza
[ -x "$(command -v fd)" ] || cargo install fd-find
# 更好用的du工具
[ -x "$(command -v dust)" ] || cargo install du-dust
# yazi--文件管理器
[ -x "$(command -v yazi)" ] || cargo install --locked yazi-fm yazi-cli
# tldr 便捷的命令查看器
[ -x "$(command -v tldr)" ] || cargo install --locked tlrc


# ╭──────────────────────────────────────────────────────────╮
# │                          Neovim                          │
# ╰──────────────────────────────────────────────────────────╯

NEOVIM_RELEASE_URL="https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.tar.gz"

# 查找~/.lcoal/share/nvim 是否存在，如果不存在就下载。
if [ ! -d "$INSTALL_DIR/bin/nvim"  ]; then
  # 下载指定URL的包
	echo "Starting download Neovim from github"
  DOWNLOAD_FILE="nvim.tar.gz"
  wget -O $DOWNLOAD_FILE $NEOVIM_RELEASE_URL
  tar -xf $DOWNLOAD_FILE
  EXTRACT_DIR="nvim-linux-x86_64"
  
  # 将解压后的文件复制到安装路径当中
  cp -r $EXTRACT_DIR/{bin,share,lib} $INSTALL_DIR

  # 清理下载文件
  rm -rf $EXTRACT_DIR
  rm $DOWNLOAD_FILE
fi


# ╭──────────────────────────────────────────────────────────╮
# │                         LazyGit                          │
# ╰──────────────────────────────────────────────────────────╯

LAZYGIT_RELEASE_URL="https://github.com/jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz"

# 查找~/.lcoal/share/nvim 是否存在，如果不存在就下载。
if [ ! -x "$INSTALL_DIR/bin/lazygit"  ]; then
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


# ╭──────────────────────────────────────────────────────────╮
# │                     Tmux 安装与配置                      │
# ╰──────────────────────────────────────────────────────────╯

# ── 安装Tmux ───────────────────────────────────────────────────────
# TODO: 这里的安装逻辑还有问题

# install tmux>=3.3 for allow-passthrough option

# tmux_version=$(tmux -V | awk '{print $2}')
# if [[ ! ${tmux_version: -1} =~ [0-9] ]]; then
# 	tmux_version="${tmux_version::-1}"
# fi
# if (($(echo "$tmux_version < 3.3" | bc -l))); then
# 	curl -Lo tmux-3.5a.tar.gz https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz
# 	tar -xvzf tmux-3.5a.tar.gz
# 	cd tmux-3.5a
# 	if pkg-config --cflags --libs libevent &> /dev/null; then
# 		./configure --prefix=$HOME/.local && make -j$(nproc)
# 	elif PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig pkg-config --cflags --libs libevent &> /dev/null; then
# 		./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" && make -j$(nproc)
# 	else
# 		curl -Lo libevent.tar.gz https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
# 		tar -xvzf libevent.tar.gz
# 		cd libevent-*/
# 		mkdir build && cd build
# 		cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
# 		make -j$(nproc)
# 		make install
# 		cd ../..
# 		./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" && make -j$(nproc)
# 	fi
# 	make install
# 	cd ..
# 	rm -rf tmux-3.5a tmux-3.5a.tar.gz
# 	echo "$(tmux -V) has been installed!"
# fi

# ── 安装TPM插件管理器 ─────────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/" 
if [ ! -d "$TPM_DIR" ]; then
  echo "$TPM_DIR does not exist. Using git to clone."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

