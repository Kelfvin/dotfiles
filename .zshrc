# ╭──────────────────────────────────────────────────────────╮
# │                 Environment PATH SETTING                 │
# ╰──────────────────────────────────────────────────────────╯
# 
export PATH=$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# 自定义Starship的配置目录
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Hugging Face 镜像
export HF_ENDPOINT=https://hf-mirror.com

# 配置默认的编辑器
export EDITOR="nvim"

# ── Brew 镜像配置加快下载 ─────────────────────────────────────────────
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# 设置aliyunpan工具的配置目录
export ALIYUNPAN_CONFIG_DIR=$HOME/.config/aliyunpan/

export GOOGLE_CLOUD_PROJECT=charged-sled-465304-e0

export MUSICFOX_ROOT=$HOME/.config/go-musicfox

# ╭──────────────────────────────────────────────────────────╮
# │                     ZSH 历史命令相关                     │
# ╰──────────────────────────────────────────────────────────╯
# zsh 历史命令保存位置
export HISTFILE=~/.zsh_history

# 内存里最多保存多少条命令
export HISTSIZE=5000

# 写入文件时保存多少条命令
export SAVEHIST=5000

# 追加历史而不是覆盖
setopt APPEND_HISTORY

# 实时写入，而不是退出时才写
setopt INC_APPEND_HISTORY

# 多个终端共享历史
setopt SHARE_HISTORY


# ╭──────────────────────────────────────────────────────────╮
# │                      ZINIT Plugins                       │
# ╰──────────────────────────────────────────────────────────╯

# ── 安装zinit ─────────────────────────────────────────────────────────
XDG_DATA_HOME=$HOME/.local/share/
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

source "$HOME/dotfiles/zsh/fzf-tab.zsh"


# ---- starship: 美化，提供环境信息
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

## Zoxide: 快速跳转历史文件夹
zinit ice as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

# --- fzf-tab: 更好的候选栏
zinit light Aloxaf/fzf-tab
# --- 更好的代码补全，支持
zinit light zsh-users/zsh-completions 
# --- 更方便的ssh选择
zinit light sunlei/zsh-ssh
# --- 根据历史记录预测要按的命令
zinit light zsh-users/zsh-autosuggestions
# --- 高亮输入的命令和参数
zinit light zdharma-continuum/fast-syntax-highlighting


# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


# completion style
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}" # 匹配的时候忽略大小写

# ╭──────────────────────────────────────────────────────────╮
# │                          Alias                           │
# ╰──────────────────────────────────────────────────────────╯
alias python="python3"

alias ls="eza"
alias ll="eza -l"

alias c="clear"
alias pip="pip3"

# tmux alias
alias tat="tmux attach -t"
alias tns="tmux new -s"

alias nv="nvim"
alias lg="lazygit"

alias zsh_reload="source ~/.zshrc"

# replace cd with zoxide
alias cd="z"


# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯
# editor default keymap to emacs ('-e') or vi (*-v')
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' forward-word    
bindkey '^B' backward-word   

# ╭──────────────────────────────────────────────────────────╮
# │                      Function Space                      │
# ╰──────────────────────────────────────────────────────────╯

# ── yazi function ─────────────────────────────────────────────────────
# 使用 y 来启动yazi，按下q后将cd到查看的目录
# 如果不想切换目录，那么使用shift-q来退出
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ── Python Venv Active ────────────────────────────────────────────────
# 用于激活python的.venv环境
function act(){
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
}

# ── 取消代理 ──────────────────────────────────────────────────────────
# useage: set_proxy localhost:7897
function set_proxy() {
  proxy_ip=$1
  port=$2
  export https_proxy=http://$proxy_ip:$port http_proxy=http://$proxy_ip:$port all_proxy=socks5://$proxy_ip:$port
}

# ── 取消代理 ──────────────────────────────────────────────────────────
function unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo "代理已取消"
}


# ── 切换cuda版本 ──────────────────────────────────────────────────────
function _switch_cuda {
  local v=$1
  local cuda_base="/usr/local/cuda-$v"
  local cuda_bin="$cuda_base/bin"
  local cuda_lib="$cuda_base/lib64" # 假设是 lib64，根据实际情况调整

  # 检查目标CUDA目录是否存在
  if [ ! -d "$cuda_base" ]; then
    echo "错误: CUDA 版本 $v 的目录 $cuda_base 不存在。"
    return 1 # 返回错误码
  fi

  # 检查nvcc是否存在
  if [ ! -x "$cuda_bin/nvcc" ]; then
     echo "错误: 在 $cuda_bin 中未找到 nvcc 或其不可执行。"
     return 1
  fi

  echo "正在切换到 CUDA $v..."

  # 更新 PATH (移除末尾冒号，将新路径放在前面)
  export PATH="$cuda_bin:$PATH"

  # 设置 CUDADIR
  export CUDADIR="$cuda_base"

  # 更新 LD_LIBRARY_PATH (将新路径放在前面)
  if [ -n "$LD_LIBRARY_PATH" ]; then
    export LD_LIBRARY_PATH="$cuda_lib:$LD_LIBRARY_PATH"
  else
    export LD_LIBRARY_PATH="$cuda_lib"
  fi

  # 显示切换后的版本 (检查是否成功)
  echo -n "当前 nvcc 版本: "
  nvcc --version
}


# --------------------------------------------------
# 清空 Homebrew 所有缓存（包括当前版本）
# --------------------------------------------------
function brew_clean_cache_all() {
    local cache_dir
    cache_dir="$(brew --cache)"

    if [[ -d "$cache_dir" ]]; then
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        rm -rf "$cache_dir"/*
        echo "✅ 清理完成。"
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    fi
}

# --------------------------------------------------
# 升级所有 Homebrew 包，然后清空缓存
# --------------------------------------------------
function brew_upgrade_and_clean() {
    echo "⬆️ 正在升级 Homebrew..."
    brew update
    echo "⬆️ 正在升级 Homebrew 包..."
    brew upgrade
    echo "⬆️ 升级完成，准备清理缓存..."

    local cache_dir
    cache_dir="$(brew --cache)"

    if [[ -d "$cache_dir" ]]; then
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        rm -rf "$cache_dir"/*
        echo "✅ 升级并清理完成。"
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    fi
}


# ╭──────────────────────────────────────────────────────────╮
# │                           fzf                            │
# ╰──────────────────────────────────────────────────────────╯
# Set up fzf key bindings and fuzzy completion
# 非常强大，<C-r> 可以搜索历史命令，直接替代了atuin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 


eval "$(zoxide init zsh)" # 这个不能缺少，缺少了按Tab不能补全
eval "$(starship init zsh)"
