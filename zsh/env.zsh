# ╭──────────────────────────────────────────────────────────╮
# │                 Environment PATH SETTING                 │
# ╰──────────────────────────────────────────────────────────╯

# 利用 zsh 原生数组进行去重
typeset -U path PATH
path=(
  "$HOME/.cargo/bin"
  "$HOME/bin"
  "$HOME/.local/bin"
  /usr/local/bin
  $path
)
export PATH


# Hugging Face 镜像
export HF_ENDPOINT=https://hf-mirror.com

# # ── Brew 镜像配置加快下载 ─────────────────────────────────────────────
# brew update / Homebrew 自身仓库更新
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
# 包元数据查询（formula/cask API）
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
# 二进制预编译
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"


# 自定义Starship的配置目录
export STARSHIP_CONFIG=~/.config/starship/starship.toml


# 配置默认的编辑器
export EDITOR="nvim"

# 设置aliyunpan工具的配置目录
export ALIYUNPAN_CONFIG_DIR=$HOME/.config/aliyunpan/

export GOOGLE_CLOUD_PROJECT=charged-sled-465304-e0

export MUSICFOX_ROOT=$HOME/.config/go-musicfox

# fnm
FNM_PATH="/home/kelf/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

if [ -n "$SSH_AUTH_SOCK" ] && [ -S "$SSH_AUTH_SOCK" ]; then
  ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
fi

export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
