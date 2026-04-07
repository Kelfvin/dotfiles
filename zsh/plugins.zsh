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
# │                           fzf                            │
# ╰──────────────────────────────────────────────────────────╯
# Set up fzf key bindings and fuzzy completion
# 非常强大，<C-r> 可以搜索历史命令，直接替代了atuin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh 
