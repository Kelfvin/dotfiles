function zed_ssh_open --description 'Open a remote path with Zed SSH'
    set -l host "$argv[1]"
    set -l remote_path "$argv[2]"
    command zed "ssh://$host:$remote_path"
end
