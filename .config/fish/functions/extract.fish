function extract --description 'Extract common archive formats'
    if test (count $argv) -eq 0
        return 0
    end

    set -l exit_status 0
    for archive in $argv
        set -l command_args

        if not test -r "$archive"
            printf 'extract: 文件不可读: `%s`\n' "$archive" >&2
            set exit_status 1
            continue
        end

        switch "$archive"
            case '*.tar.gz' '*.tgz' '*.tar.lz' '*.tlz' '*.tar.xz' '*.txz' '*.tar.bz' '*.tar.bz2' '*.tbz' '*.tbz2' '*.tar.lzma' '*.tar.Z' '*.taz' '*.tar.zst' '*.tzst'
                set command_args bsdtar xvf
            case '*.7z'
                set command_args 7z x
            case '*.Z'
                set command_args uncompress
            case '*.bz2'
                set command_args bunzip2
            case '*.exe'
                set command_args cabextract
            case '*.gz'
                set command_args gunzip
            case '*.rar'
                set command_args unrar x
            case '*.xz'
                set command_args unxz
            case '*.zip'
                set command_args unzip
            case '*.zst'
                set command_args unzstd
            case '*'
                printf 'extract: 无法识别的文件扩展名: `%s`\n' "$archive" >&2
                set exit_status 1
                continue
        end

        command $command_args "$archive"
        if test $status -ne 0
            set exit_status 1
        end
    end

    return $exit_status
end
