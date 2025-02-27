#### PATH
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# XDG_DATA_HOME=$HOME/.local/share/
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

source "$HOME/dotfiles/zsh/fzf-tab.zsh"

# load completions
autoload -U compinit && compinit

zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

zinit ice as"command" from"gh-r" lucid \
  mv"zoxide*/zoxide -> zoxide" \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!'
zinit light ajeetdsouza/zoxide

zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-completions 
zinit light sunlei/zsh-ssh
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin


#### alias
alias python="python3"
alias ll="ls -l"
alias c="clear"


# ----yazi-----
# use y instead of yazi to start
# press q to quit, you'll see the CWD changed. 
# Sometimes, you don't want to change, press Q to quit.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


function set_proxy() {
  proxy_ip=$1
  port=$2
  export https_proxy=http://$proxy_ip:$port http_proxy=http://$proxy_ip:$port all_proxy=socks5://$proxy_ip:$port
}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

eval "$(zoxide init zsh)" # 这个不能缺少，缺少了按Tab不能补全
eval "$(starship init zsh)"
