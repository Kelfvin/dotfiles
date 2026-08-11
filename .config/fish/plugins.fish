# ╭──────────────────────────────────────────────────────────╮
# │                    Fish integrations                     │
# ╰──────────────────────────────────────────────────────────╯

if status is-interactive
    # Starship: prompt and environment information.
    if command -q starship
        starship init fish | source
    end

    # Zoxide: fast directory jumping (z/zi).
    if command -q zoxide
        zoxide init fish | source
    end

    # fnm: Fish equivalent of `eval "$(fnm env --shell zsh)"`.
    if command -q fnm
        fnm env --shell fish | source
    end

    # fzf: Ctrl-R history search, Ctrl-T file search, and Alt-C directory
    # search.  Fish's native completion, autosuggestions, and syntax
    # highlighting replace the corresponding zsh plugins.
    if command -q fzf; and set -l fzf_init (fzf --fish 2>/dev/null)
        printf '%s\n' $fzf_init | source
    else if test -f "$HOME/.fzf.fish"
        source "$HOME/.fzf.fish"
    else if test -f /opt/homebrew/opt/fzf/shell/key-bindings.fish
        source /opt/homebrew/opt/fzf/shell/key-bindings.fish
    else if test -f /usr/local/opt/fzf/shell/key-bindings.fish
        source /usr/local/opt/fzf/shell/key-bindings.fish
    else if test -f /usr/share/fzf/key-bindings.fish
        source /usr/share/fzf/key-bindings.fish
    end
end
