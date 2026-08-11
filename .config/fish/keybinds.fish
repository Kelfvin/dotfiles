# ╭──────────────────────────────────────────────────────────╮
# │               Fix Shortcut in Tmux context               │
# ╰──────────────────────────────────────────────────────────╯

if status is-interactive
    # Match zsh's emacs keymap and make Ctrl-F move forward one character.
    set -g fish_key_bindings fish_default_key_bindings
    bind --mode default \cf forward-char

    # Fish's built-in pager fuzzy matching (Tab completion).
    # fzf's official Shift-Tab completion comes from `fzf --fish` in plugins.fish.
    set -g fish_completion_match_mode fuzzy

    # Tab triggers fzf completion directly instead of the native pager.
    # Binds the official fzf_complete function (loaded by `fzf --fish`);
    # fzf_complete itself restores native complete-and-search when the pager
    # is already open. Only bind when the official function exists.
    if functions -q fzf_complete
        bind --mode default \t fzf_complete
        bind --mode insert \t fzf_complete
    end
end
