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

# macOS Homebrew (Apple Silicon / Intel)
if [ "$(uname -s)" = "Darwin" ]; then
  path=( /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin $path )
fi

export PATH


# ╭──────────────────────────────────────────────────────────╮
# │                 XDG Base Directories                     │
# ╰──────────────────────────────────────────────────────────╯
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"


# Optional machine-specific mirrors live in ~/.zshrc.local.
# Example: export HF_ENDPOINT=https://hf-mirror.com
# Example: export DOTFILES_USE_USTC_BREW_MIRROR=1
if [ "${DOTFILES_USE_USTC_BREW_MIRROR:-0}" = "1" ] && [ "$(uname -s)" = "Darwin" ]; then
  export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
  export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
fi


# 自定义Starship的配置目录
export STARSHIP_CONFIG=~/.config/starship/starship.toml


# 配置默认的编辑器
export EDITOR="nvim"

# 设置 aliyunpan 工具的配置目录
export ALIYUNPAN_CONFIG_DIR="$HOME/.config/aliyunpan/"

# GOOGLE_CLOUD_PROJECT and MUSICFOX_ROOT are machine-specific; set them in
# ~/.zshrc.local when needed.

# --------------------------------------------------
# Persistent SSH agent socket for tmux
# --------------------------------------------------
# 所有 shell，包括 tmux 中的 shell，都只使用固定路径
# （链接的创建由 ~/.ssh/rc 在 SSH 登录时完成）
if [ -S "$HOME/.ssh/agent.sock" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
fi

# mise: runtime version manager (replaces fnm)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi


FZF_THEME_OPTS="--color=bg:-1,bg+:#313244 \
  --color=fg:#cdd6f4,fg+:#cdd6f4 \
  --color=hl:#f38ba8,hl+:#f38ba8 \
  --color=spinner:#f5e0dc,header:#f38ba8,info:#cba6f7 \
  --color=pointer:#f5e0dc,marker:#b4befe,prompt:#cba6f7 \
  --color=border:#6c7086"
case " ${FZF_DEFAULT_OPTS:-} " in
  *" --color=bg:-1,bg+:#313244 "*) ;;
  *) export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }$FZF_THEME_OPTS" ;;
esac
unset FZF_THEME_OPTS
