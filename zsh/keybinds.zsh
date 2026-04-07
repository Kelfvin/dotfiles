# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯
# editor default keymap to emacs ('-e') or vi (*-v')
bindkey -e
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^F' forward-word    
bindkey '^B' backward-word   
