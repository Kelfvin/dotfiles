# ╭──────────────────────────────────────────────────────────╮
# │                    Fish history                          │
# ╰──────────────────────────────────────────────────────────╯

# Fish manages append/merge semantics itself and shares history between
# interactive sessions.  The file is $XDG_DATA_HOME/fish/fish_history.
# There is no direct HISTSIZE/SAVEHIST equivalent in fish; keep its native
# history handling instead of touching the existing ~/.zsh_history.
#
# Note: `main` starts a fresh history file (main_history), separate from any
# previous fish history.  To import existing zsh history, convert
# ~/.zsh_history into fish's format with one of the community scripts, e.g.
# https://github.com/xx4h/fish-history-merge or a small awk one-liner.
set -g fish_history main
