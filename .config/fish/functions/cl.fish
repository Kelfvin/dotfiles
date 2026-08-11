function cl --description 'Change directory and list its contents'
    set -l dir "$HOME"
    if test (count $argv) -gt 0; and test -n "$argv[1]"
        set dir "$argv[1]"
    end

    if test -d "$dir"
        builtin cd -- "$dir"
        and if command -q eza
            command eza
        else
            command ls
        end
    else
        echo "cl: $dir: 找不到目录"
        return 1
    end
end
