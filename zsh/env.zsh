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

# --------------------------------------------------
# Persistent SSH agent socket for tmux
# --------------------------------------------------
SSH_AGENT_LINK="$HOME/.ssh/agent.sock"

# 新 SSH 登录时，将固定路径指向本次连接创建的真实 socket
if [ -n "${SSH_AUTH_SOCK:-}" ] \
    && [ -S "$SSH_AUTH_SOCK" ] \
    && [ "$SSH_AUTH_SOCK" != "$SSH_AGENT_LINK" ]; then
    ln -sfn "$SSH_AUTH_SOCK" "$SSH_AGENT_LINK"
fi

# 所有 shell，包括 tmux 中的 shell，都只使用固定路径
if [ -S "$SSH_AGENT_LINK" ]; then
    export SSH_AUTH_SOCK="$SSH_AGENT_LINK"
fi

unset SSH_AGENT_LINK

FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi


# kimi-code
export PATH="/home/kelf/.kimi-code/bin:$PATH"
