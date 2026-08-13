# ╭──────────────────────────────────────────────────────────╮
# │                     Abbreviations                        │
# ╰──────────────────────────────────────────────────────────╯

# Fish abbreviations expand while typing and keep the expanded command in
# history, which is the Fish equivalent of most simple zsh aliases.
abbr --add python python3
abbr --add pip pip3

# tmux shortcuts
abbr --add tat 'tmux attach -t'
abbr --add tns 'tmux new -s'

abbr --add nv nvim
abbr --add lg lazygit
abbr --add hh herdr
abbr --add tg update_all
abbr --add fr fish_reload

# pi update shortcuts
abbr --add pu 'pi update'
abbr --add pua 'pi update --all'

## Modified commands
abbr --add ping 'ping -c 5'
abbr --add free 'free -h'

# These command-dependent abbreviations are reset first so fish_reload stays
# correct if a tool is installed or removed during the current session.
abbr --erase ls ll 2>/dev/null
if command -q eza
    abbr --add ls eza
    abbr --add ll 'eza -l'
else
    abbr --add ll 'ls -l'
end

abbr --erase du 2>/dev/null
if command -q dust
    abbr --add du dust
else
    abbr --add du 'du -h -c'
end

abbr --erase df 2>/dev/null
if command -q duf
    abbr --add df duf
else
    abbr --add df 'df -h'
end

abbr --add grep 'grep --color=auto'
abbr --add mkdir 'mkdir -p -v'

## Safety features
abbr --add cp 'cp -i'
abbr --add mv 'mv -i'
abbr --add rm 'rm -I'

abbr --add ff fastfetch
abbr --add c clear

# bat + tail for log viewing
abbr --add batlog 'bat --paging=never -l log'
