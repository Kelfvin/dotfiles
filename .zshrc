# Resolve the dotfiles directory whether ~/.zshrc is a symlink or a regular file
DOTFILES="${0:A:h}"
if [[ ! -f "$DOTFILES/zsh/plugins.zsh" ]]; then
    DOTFILES="$HOME/dotfiles"
fi
export DOTFILES

source "$DOTFILES/zsh/env.zsh"
source "$DOTFILES/zsh/history.zsh"
source "$DOTFILES/zsh/plugins.zsh"
source "$DOTFILES/zsh/alias.zsh"
source "$DOTFILES/zsh/keybinds.zsh"
source "$DOTFILES/zsh/functions.zsh"

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
