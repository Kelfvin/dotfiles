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


# ── libclang ──────────────────────────────────────────────────────────
# tree-sitter-cli 等 Rust 包编译时 bindgen 需要 libclang
if [ -z "${LIBCLANG_PATH:-}" ]; then
  HAS_LIBCLANG=0
  if command -v ldconfig >/dev/null 2>&1 && ldconfig -p 2>/dev/null | grep -q libclang; then
    HAS_LIBCLANG=1
  elif find /usr/lib /usr/local/lib /usr/lib64 /opt -maxdepth 3 -name "libclang*.so*" -print -quit 2>/dev/null | grep -q .; then
    HAS_LIBCLANG=1
  elif [ "$(uname -s)" = "Darwin" ] && { [ -d "/usr/local/opt/llvm/lib" ] || [ -d "/opt/homebrew/opt/llvm/lib" ]; }; then
    HAS_LIBCLANG=1
  elif command -v clang >/dev/null 2>&1; then
    HAS_LIBCLANG=1
  fi

  if [ "$HAS_LIBCLANG" -eq 0 ]; then
    echo "libclang is required for building some Rust packages (e.g. tree-sitter-cli)."
    echo "Please install it first:"
    if [ "$(uname -s)" = "Darwin" ]; then
      echo "  brew install llvm"
      echo "  export LIBCLANG_PATH=\$(brew --prefix llvm)/lib"
    elif command -v apt-get >/dev/null 2>&1; then
      echo "  sudo apt-get install -y libclang-dev"
    elif command -v pacman >/dev/null 2>&1; then
      echo "  sudo pacman -S --needed clang"
    elif command -v dnf >/dev/null 2>&1; then
      echo "  sudo dnf install -y clang-devel"
    else
      echo "  Please install clang/libclang development package manually."
    fi
    exit 1
  fi
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

# ╭──────────────────────────────────────────────────────────╮
# │                       ImageMagick                        │
# ╰──────────────────────────────────────────────────────────╯

if ! command -v convert >/dev/null 2>&1 && ! command -v magick >/dev/null 2>&1; then
  if [ "$(uname -s)" = "Darwin" ]; then
    brew install imagemagick
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed imagemagick
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y imagemagick
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y ImageMagick
  else
    echo "WARN: Could not install ImageMagick automatically. Please install it manually."
  fi
fi

# ╭──────────────────────────────────────────────────────────╮
# │              ImageMagick magick compatibility            │
# ╰──────────────────────────────────────────────────────────╯
# Debian/Ubuntu 官方仓库的 ImageMagick 6 只提供 convert/identify，
# 而 Yazi 等现代工具统一调用 magick（ImageMagick 7 风格）。
# 为保持兼容，在仅有 convert 的系统上创建用户级 wrapper。
if command -v convert >/dev/null 2>&1 && ! command -v magick >/dev/null 2>&1; then
	if [ ! -x "$INSTALL_DIR/bin/magick" ]; then
		echo "ImageMagick 6 detected, creating ~/.local/bin/magick wrapper for Yazi compatibility..."
		tee "$INSTALL_DIR/bin/magick" > /dev/null <<'EOF'
#!/bin/sh
exec convert "$@"
EOF
		chmod +x "$INSTALL_DIR/bin/magick"
	fi

	# 确保 ~/.local/bin 在当前 PATH 中；若不在，尝试写入 shell 配置
	if ! echo ":$PATH:" | grep -q ":$INSTALL_DIR/bin:"; then
		SHELL_RC=""
		if [ -n "${ZSH_VERSION:-}" ]; then
			SHELL_RC="$HOME/.zshrc"
		elif [ -n "${BASH_VERSION:-}" ]; then
			SHELL_RC="$HOME/.bashrc"
		elif [ -f "$HOME/.zshrc" ]; then
			SHELL_RC="$HOME/.zshrc"
		elif [ -f "$HOME/.bashrc" ]; then
			SHELL_RC="$HOME/.bashrc"
		fi

		if [ -n "$SHELL_RC" ] && ! grep -qF "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" "$SHELL_RC" 2>/dev/null; then
			echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$SHELL_RC"
			echo "Added $INSTALL_DIR/bin to PATH in $SHELL_RC. Please run: source $SHELL_RC"
		fi
	fi
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
