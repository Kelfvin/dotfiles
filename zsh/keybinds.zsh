# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯
# editor default keymap to emacs ('-e') or vi (*-v')
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
# 覆盖 emacs 默认的 forward-char / backward-char，按词移动
bindkey '^F' forward-word
bindkey '^B' backward-word
