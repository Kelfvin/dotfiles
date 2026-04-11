# ╭──────────────────────────────────────────────────────────╮
# │                          Alias                           │
# ╰──────────────────────────────────────────────────────────╯
alias python="python3"
alias pip="pip3"

# tmux alias
alias tat="tmux attach -t"
alias tns="tmux new -s"

alias nv="nvim"
alias lg="lazygit"

alias zsh_reload="source ~/.zshrc"

## Modified commands
alias ping='ping -c 5'


if command -v eza>/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -l"
else
  alias ll="ls -l"
fi

if command -v dust>/dev/null 2>&1; then
  alias du="dust"
else
  alias du="du -h -c"
fi

if command -v duf>/dev/null 2>&1; then
  alias df="duf"
else
  alias df="df -h"
fi


alias grep='grep --color=auto'
alias mkdir='mkdir -p -v'

## Safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file

alias ff="fastfetch"
alias c="clear"
