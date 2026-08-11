# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯

if status is-interactive
    # Match zsh's emacs keymap and make Ctrl-F move forward one character.
    set -g fish_key_bindings fish_default_key_bindings
    bind --mode default \cf forward-char

    # Use Fish's built-in fuzzy completion in the pager instead of fzf.
    set -g fish_completion_match_mode fuzzy
end
