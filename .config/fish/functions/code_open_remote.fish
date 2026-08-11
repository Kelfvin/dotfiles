function code_open_remote --description 'Open a remote path with VS Code Remote SSH'
    set -l host "$argv[1]"
    set -l remote_path "$argv[2]"
    command code --remote "ssh-remote+$host" "$remote_path"
end
