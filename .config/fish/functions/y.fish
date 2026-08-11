# Start yazi and change to its final directory on exit.
function y --description 'Open yazi and change to its final directory'
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)
    if test $status -ne 0
        return 1
    end

    command yazi $argv --cwd-file="$tmp"

    set -l cwd
    if test -f "$tmp"
        set cwd (command cat -- "$tmp")
    end
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end

    command rm -f -- "$tmp"
end
