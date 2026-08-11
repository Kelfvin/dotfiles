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
end
