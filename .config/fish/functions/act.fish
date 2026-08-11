# Activate the Python virtual environment in the current Fish shell.
function act --description 'Activate the project .venv'
    set -l activate_file .venv/bin/activate.fish
    if test -f "$activate_file"
        source "$activate_file"
        return $status
    end

    echo '找不到 .venv/bin/activate.fish，请先创建 Python 虚拟环境。' >&2
    return 1
end
