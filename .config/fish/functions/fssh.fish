# Pick an SSH host from ~/.ssh/config with fzf (fish equivalent of the
# zinit sunlei/zsh-ssh plugin).
function fssh --description 'Pick an ssh host from ~/.ssh/config with fzf'
    if not command -q fzf
        echo '错误: 找不到 fzf。' >&2
        return 1
    end

    set -l ssh_config "$HOME/.ssh/config"
    if not test -f "$ssh_config"
        echo "错误: 找不到 $ssh_config。" >&2
        return 1
    end

    set -l host (
        string match -rgi '^\s*host\s+(.+)$' <"$ssh_config" \
            | string replace -rgi '^\s*host\s+' '' \
            | string split ' ' \
            | string match -rv '[*?!]' \
            | sort -u \
            | command fzf --prompt='ssh> ' --height=40% --reverse
    )

    if test -n "$host"
        echo "ssh $host"
        command ssh $host
    end
end
