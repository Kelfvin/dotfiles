function zed_ssh_open --description 'Open a remote path with Zed SSH'
    if test (count $argv) -lt 2; or test -z "$argv[1]"; or test -z "$argv[2]"
        echo 'usage: zed_ssh_open <host> <absolute-remote-path>' >&2
        return 1
    end

    set -l host "$argv[1]"
    set -l remote_path "$argv[2]"
    string match -q -- '/*' "$remote_path"; or set remote_path "/$remote_path"
    command zed "ssh://$host$remote_path"
end
