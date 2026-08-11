# Fish entry point.

# Resolve the dotfiles root from this file's real path (stow symlinks are
# followed); fall back to the documented $HOME/dotfiles location.
set -l dotfiles_root (path resolve (status filename)/../../..)
if test -d "$dotfiles_root/.git"
    set -gx DOTFILES "$dotfiles_root"
else if test -d "$HOME/dotfiles"
    set -gx DOTFILES "$HOME/dotfiles"
end

for config_file in env.fish history.fish plugins.fish abbreviations.fish keybinds.fish
    set -l config_path "$__fish_config_dir/$config_file"
    if test -f "$config_path"
        source "$config_path"
    end
end

# Machine-specific settings live outside the repository.
set -l local_config "$__fish_config_dir/config.local.fish"
if test -f "$local_config"
    source "$local_config"
end
