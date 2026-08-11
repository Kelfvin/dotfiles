# ╭──────────────────────────────────────────────────────────╮
# │                      Function Space                      │
# ╰──────────────────────────────────────────────────────────╯

# ── yazi function ─────────────────────────────────────────────────────
# 使用 y 来启动yazi，按下q后将cd到查看的目录
# 如果不想切换目录，那么使用shift-q来退出
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ── Python Venv Active ────────────────────────────────────────────────
# 用于激活python的.venv环境
function act(){
  [ -f '.venv/bin/activate' ] && source .venv/bin/activate
}

# ── 设置代理 ──────────────────────────────────────────────────────────
# usage: set_proxy <host> <port>   e.g. set_proxy localhost 7897
function set_proxy() {
  if [ $# -lt 2 ]; then
    echo "usage: set_proxy <host> <port>   e.g. set_proxy localhost 7897" >&2
    return 1
  fi
  local proxy_ip="$1"
  local port="$2"
  export https_proxy=http://$proxy_ip:$port http_proxy=http://$proxy_ip:$port all_proxy=socks5://$proxy_ip:$port
}

# ── 取消代理 ──────────────────────────────────────────────────────────
function unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo "代理已取消"
}


# --------------------------------------------------
# 清空 Homebrew 所有缓存（包括当前版本）
# --------------------------------------------------
function brew_clean_cache_all() {
    local cache_dir
    cache_dir="$(brew --cache)"

    if [[ -z "$cache_dir" || "$cache_dir" == "/" ]]; then
        echo "❌ 缓存目录异常，终止清理：${cache_dir:-<empty>}" >&2
        return 1
    fi

    if [[ -d "$cache_dir" ]]; then
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        rm -rf "${cache_dir%/}"/*
        echo "✅ 清理完成。"
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    fi
}

# --------------------------------------------------
# 一键升级所有包管理器（brew、cargo、uv、TPM…），由 topgrade 统一处理
# --------------------------------------------------
function update_all() {
    if command -v topgrade >/dev/null 2>&1; then
        echo "⬆️ 使用 topgrade 升级所有包管理器（brew、cargo、uv、TPM…）..."
        topgrade
        return $?
    fi

    echo "⬆️ 正在升级 Homebrew..."
    brew update
    echo "⬆️ 正在升级 Homebrew 包..."
    brew upgrade
    echo "⬆️ 升级完成，准备清理缓存..."

    brew_clean_cache_all && echo "✅ 升级并清理完成。"
}


function code_open_remote(){
  local host="$1"
  local remote_path="$2"
  code --remote "ssh-remote+$host" "$remote_path"
}


function extract() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: 文件不可读: \`$i'" >&2
            continue
        fi

        case $i in
            *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz|zst)))))
                   c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *.zst) c=(unzstd);;
            *)     echo "$0: 无法识别的文件扩展名: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

function cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	else
		echo "cl: $dir: 找不到目录"
	fi
}

function zed_ssh_open(){
  local host="$1"
  local remote_path="$2"
  zed "ssh://${host}:${remote_path}"
}

