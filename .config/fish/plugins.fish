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

    # mise: runtime version manager (replaces fnm). Fish equivalent of
    # `eval "$(mise activate zsh)"`.
    if command -q mise
        mise activate fish | source
    end

    # fzf: official Fish integration, sourced verbatim from `fzf --fish`.
    # Provides Ctrl-R (history), Ctrl-T (files), Alt-C (directories),
    # Shift-Tab (completion). No custom bindings on top.
    if command -q fzf
        fzf --fish | source
    end
end
