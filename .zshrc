#### Environment

# PATH 都在此处配置
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# 自定义Starship的配置目录
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Hugging Face 镜像
export HF_ENDPOINT=https://hf-mirror.com

# 配置默认的编辑器
export EDITOR="nvim"

# homebrew mirror
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"


# XDG_DATA_HOME=$HOME/.local/share/
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

# --- 记录历史命令
zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin


# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


# completion style
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}" # 匹配的时候忽略大小写


#### --------alias-----------
alias python="python3"
alias ll="ls -l --color"
alias c="clear"
alias pip="pip3"
alias v="nvim"

# tmux alias
alias tat="tmux attach -t"
alias tns="tmux new -s"


### key-binds
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' forward-word    
bindkey '^B' backward-word   



# ----yazi-----
# 配置退出时自动cd目录
# 必须使用 y 来启动，按下q来退出
# 如果不想切换目录，那么使用Q来退出
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# -----快速代理------
# useage: set_proxy localhost:7897
function set_proxy() {
  proxy_ip=$1
  port=$2
  export https_proxy=http://$proxy_ip:$port http_proxy=http://$proxy_ip:$port all_proxy=socks5://$proxy_ip:$port
}


function _switch_cuda {
│  v=$1
│  export PATH=/usr/local/cuda-$v/bin:$PATH:
│  export CUDADIR=/usr/local/cuda-$v
│  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-$v/lib64
│  nvcc --version
}


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(zoxide init zsh)" # 这个不能缺少，缺少了按Tab不能补全
eval "$(starship init zsh)"
