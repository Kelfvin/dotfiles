# ╭──────────────────────────────────────────────────────────╮
# │                      Function Space                      │
# ╰──────────────────────────────────────────────────────────╯

# ── yazi function ─────────────────────────────────────────────────────
# 使用 y 来启动yazi，按下q后将cd到查看的目录
# 如果不想切换目录，那么使用shift-q来退出
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd yazi_status
	yazi "$@" --cwd-file="$tmp"
	yazi_status=$?
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
	return "$yazi_status"
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
# 重新生成自装工具的 shell 补全（zsh + fish）
# 清单见 script/completions.sh，幂等可随时重跑
# --------------------------------------------------
function refresh_completions() {
    bash "$DOTFILES/script/completions.sh"
}

# --------------------------------------------------
# 一键升级所有包管理器（brew、cargo、uv、TPM…），由 topgrade 统一处理
# 注入 gh 的 token：mise 等步骤调用 GitHub API 时未认证限流只有 60 次/时，
# 经常 403；带 token 后限额 5000/时。gh 未登录时静默降级（无 token）。
# --------------------------------------------------
function update_all() {
    if command -v topgrade >/dev/null 2>&1; then
        echo "⬆️ 使用 topgrade 升级所有包管理器（brew、cargo、uv、TPM…）..."
        local gh_token
        gh_token=$(gh auth token 2>/dev/null)
        if [[ -n "$gh_token" ]]; then
            GITHUB_TOKEN="$gh_token" topgrade "$@"
        else
            topgrade "$@"
        fi
        local tg_ret=$?
        echo "🔄 重新生成 shell 补全..."
        refresh_completions
        return $tg_ret
    fi

    if ! command -v brew >/dev/null 2>&1; then
        echo "错误: 找不到 topgrade 或 brew，请先安装其中一个。" >&2
        return 1
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
    local c e i rc

    (($#)) || return 0
    e=0

    for i; do
        c=''

        if [[ ! -r $i ]]; then
            echo "$0: 文件不可读: \`$i'" >&2
            e=1
            continue
        fi

        case $i in
            *.tar.gz|*.tgz|*.tar.lz|*.tlz|*.tar.xz|*.txz|*.tar.bz|*.tar.bz2|*.tbz|*.tbz2|*.tar.lzma|*.tar.Z|*.taz|*.tar.zst|*.tzst)
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
        rc=$?
        (( rc == 0 )) || e=1
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
  [[ -n "$host" && -n "$remote_path" ]] || {
    echo "usage: zed_ssh_open <host> <absolute-remote-path>" >&2
    return 1
  }
  [[ "$remote_path" == /* ]] || remote_path="/$remote_path"
  zed "ssh://${host}${remote_path}"
}

