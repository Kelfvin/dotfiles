# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯
# editor default keymap to emacs ('-e') or vi (*-v')
bindkey -e
# zsh emacs keymap 默认不绑定 ^F，这里补上按字符前进（与 ^B=backward-char 对称）
bindkey '^F' forward-char
