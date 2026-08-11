# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯

if status is-interactive
    # Match zsh's emacs keymap and make Ctrl-F move forward one character.
    set -g fish_key_bindings fish_default_key_bindings
    bind --mode default \cf forward-char

    # fzf's Fish integration uses Shift-Tab by default.  Bind Tab as well so
    # Fish behaves like the old zsh/fzf-tab setup.  If fzf is unavailable,
    # leave Fish's native Tab completion untouched.
    if functions -q fzf_complete
        bind --mode default tab fzf_complete
        bind --mode insert tab fzf_complete
    end
end
