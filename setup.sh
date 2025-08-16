#!/bin/bash

# 此setup脚本不需要root权限
# 将需要使用的软件都放在 ~/.local/bin 下
# 需要将"$HOME/.local/bin"添加到PATH中
INSTALL_DIR="$HOME/.local/bin"

# 基本设置
# 使用curl来下载GitHub发布的包
if [ ! -x "$(command -v curl)" ]; then
	echo "curl is required..."
	exit 1
fi

# 切换到脚本所在的目录
cd "$(dirname "$0")"

# 配置~/.config
CONFIG_DIR="./config"
TARGET_DIR="$HOME/.config"


# 下面安装需要使用的一些工具

[ -d "$HOME/.fzf" ] || (git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && $HOME/.fzf/install)

[ -x "$(command -v cargo)" ] || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
[ -x "$(command -v rg)" ] || cargo install ripgrep
[ -x "$(command -v eza)" ] || cargo install eza
[ -x "$(command -v fd)" ] || cargo install fd-find
[ -x "$(command -v dust)" ] || cargo install du-dust
[ -x "$(command -v yazi)" ] || cargo install --locked yazi-fm yazi-cli


# install tmux>=3.3 for allow-passthrough option
tmux_version=$(tmux -V | awk '{print $2}')
if [[ ! ${tmux_version: -1} =~ [0-9] ]]; then
	tmux_version="${tmux_version::-1}"
fi
if (($(echo "$tmux_version < 3.3" | bc -l))); then
	curl -Lo tmux-3.5a.tar.gz https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz
	tar -xvzf tmux-3.5a.tar.gz
	cd tmux-3.5a
	if pkg-config --cflags --libs libevent &> /dev/null; then
		./configure --prefix=$HOME/.local && make -j$(nproc)
	elif PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOME/.local/lib/pkgconfig pkg-config --cflags --libs libevent &> /dev/null; then
		./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" && make -j$(nproc)
	else
		curl -Lo libevent.tar.gz https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
		tar -xvzf libevent.tar.gz
		cd libevent
		mkdir build && cd build
		cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/.local
		make -j$(nproc)
		make install
		cd ../..
		./configure --prefix=$HOME/.local CFLAGS="-I$HOME/.local/include" LDFLAGS="-L$HOME/.local/lib" && make -j$(nproc)
	fi
	make install
	cd ..
	rm -rf tmux-3.5a tmux-3.5a.tar.gz
	echo "$(tmux -V) has been installed!"
fi

# 配置 tmux
TPM_DIR="$HOME/.tmux/" 
if [ ! -d "$TPM_DIR" ]; then
  echo "$TPM_DIR does not exist. Using git to clone."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

source ~/.zshrc
