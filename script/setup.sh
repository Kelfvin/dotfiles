#!/bin/bash

# ──────────────────────────────────────────────────────────────────────
# 此脚本用于在新机器上一键配置开发环境
# 尽量不需要 root；具体安装位置因工具而异：
#   - cargo 工具 -> ~/.cargo/bin
#   - eget 二进制 -> ~/.local/bin
#   - 系统级软件（Neovim 等）-> 平台包管理器
# ──────────────────────────────────────────────────────────────────────
set -euo pipefail

# ╭──────────────────────────────────────────────────────────╮
# │                        常量设置                          │
# ╰──────────────────────────────────────────────────────────╯

INSTALL_DIR="$HOME/.local/"
TARGET_DIR="$HOME/.config"

# 创建安装文件基本目录
install -d "$INSTALL_DIR/bin" "$INSTALL_DIR/share" "$INSTALL_DIR/lib"

# 切换到脚本所在的目录（捕获绝对路径，避免后续 cd 后相对引用失效）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# macOS: 确保 Homebrew 路径在 PATH 中（Apple Silicon / Intel）
if [ "$(uname -s)" = "Darwin" ]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
fi

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
# 仅当 cargo-binstall 回退到源码编译时才需要（默认走预编译二进制）
if ! command -v cmake >/dev/null 2>&1; then
  echo "WARNING: cmake not found. Prebuilt binaries will be used;"
  echo "         only needed if cargo-binstall falls back to source compilation."
fi

# ── curl ──────────────────────────────────────────────────────────────
# 用于下载
if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required..."
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
# 更好用的 du 工具
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

# 确保 eget 和后面安装到 ~/.local/bin 的工具能被找到
export PATH="$INSTALL_DIR/bin:$PATH"

# fzf 查找工具
ensure_cmd fzf eget junegunn/fzf --to "$INSTALL_DIR/bin"

# fastfetch 系统信息展示工具
ensure_cmd fastfetch eget fastfetch-cli/fastfetch --to "$INSTALL_DIR/bin"

# starship 提示符 & zoxide 目录跳转（fish 主 shell 依赖，不依赖 zinit）
ensure_cmd starship cargo binstall --no-confirm starship
ensure_cmd zoxide cargo binstall --no-confirm zoxide

# topgrade 一键升级所有包管理器（brew、cargo、uv、TPM…）
ensure_cmd topgrade cargo binstall --no-confirm topgrade

# atuin 跨机同步的 shell 历史（Ctrl-R 搜索 + 端到端加密同步）
ensure_cmd atuin cargo binstall --no-confirm atuin

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

# 安装 nvitop（仅 Linux 有 NVIDIA 环境才需要）
if [ "$(uname -s)" = "Linux" ]; then
  ensure_cmd nvitop uv tool install nvitop
fi

#  安装 mise（运行时版本管理器，替代 fnm；官方脚本默认安装到 ~/.local/bin）
#  MISE_INSTALL_PATH 显式指定安装位置，避免脚本探测路径的歧义
ensure_cmd mise sh -c 'MISE_INSTALL_PATH="'"$INSTALL_DIR"'bin/mise" curl https://mise.jdx.dev/install.sh | sh'

# ╭──────────────────────────────────────────────────────────╮
# │              效率工具（9 件套）                           │
# │ delta/direnv/glow/chafa/gdu/gping/yq/jless/duf            │
# ╰──────────────────────────────────────────────────────────╯
# 优先系统包管理器（自带补全）；Ubuntu 等无包/版本旧的平台走 binstall/eget。
# 已验证：binstall 支持 git-delta/gping/jless；eget 支持 direnv/glow/gdu/duf/yq
# （chafa 无预编译 release，Ubuntu 走 apt）
# 二进制名:包名映射（不同平台的 gdu 命令名不同）
EFFICIENCY_TOOLS="delta:git-delta direnv:direnv glow:glow chafa:chafa duf:duf gdu:gdu gping:gping yq:yq jless:jless"

if [ "$(uname -s)" = "Darwin" ]; then
  # Homebrew installs gdu as gdu-go to avoid a coreutils conflict.
  EFFICIENCY_TOOLS="delta:git-delta direnv:direnv glow:glow chafa:chafa duf:duf gdu-go:gdu gping:gping yq:yq jless:jless"
  # 已安装的工具直接跳过，避免 brew 刷一堆 already installed 警告
  for pair in $EFFICIENCY_TOOLS; do
    ensure_cmd "${pair%%:*}" brew install "${pair#*:}"
  done
elif command -v pacman >/dev/null 2>&1; then
  for pair in $EFFICIENCY_TOOLS; do
    ensure_cmd "${pair%%:*}" sudo pacman -S --needed "${pair#*:}"
  done
else
  ensure_cmd delta cargo binstall --no-confirm git-delta
  ensure_cmd gping cargo binstall --no-confirm gping
  ensure_cmd jless cargo binstall --no-confirm jless
  ensure_cmd direnv eget direnv/direnv --to "$INSTALL_DIR/bin"
  ensure_cmd glow eget charmbracelet/glow --to "$INSTALL_DIR/bin"
  ensure_cmd gdu eget dundee/gdu --to "$INSTALL_DIR/bin"
  ensure_cmd duf eget muesli/duf --to "$INSTALL_DIR/bin"
  ensure_cmd yq eget mikefarah/yq --to "$INSTALL_DIR/bin"
  ensure_cmd chafa sudo apt-get install -y chafa
fi

# ── 生成补全（zsh + fish，每台机器本地生成，不进 dotfiles 仓库）────────
# 所有自装工具的补全由 script/completions.sh 统一管理（清单驱动，
# 与安装方式/平台解耦，幂等）；系统包管理器（pacman/brew/apt）安装的
# 工具自带补全，清单中的生成器/静态文件会覆盖到用户目录（优先级更高），
# 内容一致，无害。
bash "$SCRIPT_DIR/completions.sh"
