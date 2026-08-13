# Regenerate shell completions for self-installed tools (script/completions.sh).
# Idempotent; also run automatically after update_all.
function refresh_completions --description 'Regenerate shell completions'
    if not set -q DOTFILES
        set -l dotfiles_root (path resolve "$__fish_config_dir/../../..")
        if test -d "$dotfiles_root/.git"
            set -gx DOTFILES "$dotfiles_root"
        end
    end

    if test -f "$DOTFILES/script/completions.sh"
        bash "$DOTFILES/script/completions.sh"
    else
        echo '错误: 找不到 script/completions.sh。' >&2
        return 1
    end
end
