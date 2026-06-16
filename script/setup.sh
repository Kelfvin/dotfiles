#!/bin/bash

# ──────────────────────────────────────────────────────────────────────
# 此脚本用于在新机器上一键配置开发环境（无需Root权限）
# 软件将安装在 ~/.local 下
# ──────────────────────────────────────────────────────────────────────
set -euo pipefail

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

# 如果命令不存在，则执行后面的安装命令
ensure_cmd() {
    local cmd="$1"
    shift
    if ! command -v "$cmd" >/dev/null 2>&1; then
        "$@"
    fi
}

# 如果目录不存在，则执行后面的安装命令
ensure_dir() {
    local dir="$1"
    shift
    if [ ! -d "$dir" ]; then
        "$@"
    fi
}

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
    echo "WARNING: libclang not detected. Most tools will be installed via prebuilt binaries,"
    echo "but if cargo-binstall falls back to source compilation, some packages may fail."
    echo "To be safe, you can install it first:"
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
    echo ""
    echo "Continuing anyway..."
  fi
fi

# ── cargo ─────────────────────────────────────────────────────────────
# 检查是否有cargo
ensure_cmd cargo sh -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'

# 确保 cargo 及其插件在 PATH 中
export PATH="$HOME/.cargo/bin:$PATH"

# 安装 cargo-binstall（从预编译二进制快速安装 Rust 工具，避免本地编译）
ensure_cmd cargo-binstall cargo install cargo-binstall --locked


# ╭──────────────────────────────────────────────────────────╮
# │                    使用Cargo安装软件                     │
# ╰──────────────────────────────────────────────────────────╯

# 正则查找工具
ensure_cmd rg cargo binstall --no-confirm ripgrep
# 更好用的ls工具
ensure_cmd eza cargo binstall --no-confirm eza
ensure_cmd fd cargo binstall --no-confirm fd-find
# 更好用的du工具
ensure_cmd dust cargo binstall --no-confirm du-dust
# yazi--文件管理器
# 在 Linux 上使用 musl target，避免低版本 glibc 无法运行官方 gnu 构建
if [ "$(uname -s)" = "Linux" ]; then
    ensure_cmd yazi cargo binstall --no-confirm --target x86_64-unknown-linux-musl yazi-fm yazi-cli
else
    ensure_cmd yazi cargo binstall --no-confirm yazi-fm yazi-cli
fi
# tldr 便捷的命令查看器
ensure_cmd tldr cargo binstall --no-confirm tlrc
# tokei 代码统计工具
ensure_cmd tokei cargo binstall --no-confirm tokei
ensure_cmd tree-sitter cargo binstall --no-confirm tree-sitter-cli
ensure_cmd bat cargo binstall --no-confirm bat

ensure_cmd cargo-install-update cargo binstall --no-confirm cargo-update




# 安装 eget（从 GitHub Release 下载二进制文件的工具）
if ! command -v eget >/dev/null 2>&1; then
  echo "Installing eget..."
  curl https://zyedidia.github.io/eget.sh | sh
  mv eget "$INSTALL_DIR/bin/"
fi

# fzf 查找工具
ensure_cmd fzf eget junegunn/fzf --to "$INSTALL_DIR/bin"

# fastfetch 系统信息展示工具
ensure_cmd fastfetch eget fastfetch-cli/fastfetch --to "$INSTALL_DIR/bin"

# ╭──────────────────────────────────────────────────────────╮
# │                          Neovim                          │
# ╰──────────────────────────────────────────────────────────╯

# 如果是Macos系统，那么使用homebrew进行安装
if [ "$(uname -s)" = "Darwin" ]; then
  command -v nvim >/dev/null 2>&1 || brew install neovim

# 如果是 Archlinux 系统，那么使用 Pacman 进行安装
elif command -v pacman >/dev/null 2>&1; then
  command -v nvim >/dev/null 2>&1 || sudo pacman -S --needed neovim

else
  if [ ! -x "$INSTALL_DIR/bin/nvim" ]; then
    echo "Installing Neovim via eget..."
    eget neovim/neovim --to "$INSTALL_DIR/bin/nvim"
  fi
fi


# ╭──────────────────────────────────────────────────────────╮
# │                         LazyGit                          │
# ╰──────────────────────────────────────────────────────────╯

# macOS 和 Archlinux 使用包管理器安装，其他 Linux 用 eget
if [ "$(uname -s)" = "Darwin" ]; then
  if ! command -v lazygit >/dev/null 2>&1; then
    echo "Installing LazyGit via brew..."
    brew install lazygit
  fi

elif command -v pacman >/dev/null 2>&1; then
  if ! command -v lazygit >/dev/null 2>&1; then
    echo "Installing LazyGit via pacman..."
    sudo pacman -S --needed lazygit
  fi

elif ! command -v lazygit >/dev/null 2>&1; then
  echo "Installing LazyGit via eget..."
  eget jesseduffield/lazygit --to "$INSTALL_DIR/bin"
fi

# ╭──────────────────────────────────────────────────────────╮
# │                       ImageMagick                        │
# ╰──────────────────────────────────────────────────────────╯

if ! command -v convert >/dev/null 2>&1 && ! command -v magick >/dev/null 2>&1; then
  if [ "$(uname -s)" = "Darwin" ]; then
    brew install imagemagick
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed imagemagick
  else
    eget ImageMagick/ImageMagick --to "$INSTALL_DIR/bin/magick"
  fi
fi


# ── 安装TPM插件管理器 ─────────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
ensure_dir "$TPM_DIR" git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"


# 安装 uv
ensure_cmd uv sh -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'

# 安装 nvitop
ensure_cmd nvitop uv tool install nvitop


#  安装 fnm
ensure_cmd fnm eget Schniz/fnm --to "$INSTALL_DIR/bin"
