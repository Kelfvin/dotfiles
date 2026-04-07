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

# ── Brew 镜像配置加快下载 ─────────────────────────────────────────────
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
