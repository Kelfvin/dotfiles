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

# ── 取消代理 ──────────────────────────────────────────────────────────
# useage: set_proxy localhost:7897
function set_proxy() {
  proxy_ip=$1
  port=$2
  export https_proxy=http://$proxy_ip:$port http_proxy=http://$proxy_ip:$port all_proxy=socks5://$proxy_ip:$port
}

# ── 取消代理 ──────────────────────────────────────────────────────────
function unset_proxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo "代理已取消"
}


# ── 切换cuda版本 ──────────────────────────────────────────────────────
function _switch_cuda {
  local v=$1
  local cuda_base="/usr/local/cuda-$v"
  local cuda_bin="$cuda_base/bin"
  local cuda_lib="$cuda_base/lib64" # 假设是 lib64，根据实际情况调整

  # 检查目标CUDA目录是否存在
  if [ ! -d "$cuda_base" ]; then
    echo "错误: CUDA 版本 $v 的目录 $cuda_base 不存在。"
    return 1 # 返回错误码
  fi

  # 检查nvcc是否存在
  if [ ! -x "$cuda_bin/nvcc" ]; then
     echo "错误: 在 $cuda_bin 中未找到 nvcc 或其不可执行。"
     return 1
  fi

  echo "正在切换到 CUDA $v..."

  # 更新 PATH (移除末尾冒号，将新路径放在前面)
  export PATH="$cuda_bin:$PATH"

  # 设置 CUDADIR
  export CUDADIR="$cuda_base"

  # 更新 LD_LIBRARY_PATH (将新路径放在前面)
  if [ -n "$LD_LIBRARY_PATH" ]; then
    export LD_LIBRARY_PATH="$cuda_lib:$LD_LIBRARY_PATH"
  else
    export LD_LIBRARY_PATH="$cuda_lib"
  fi

  # 显示切换后的版本 (检查是否成功)
  echo -n "当前 nvcc 版本: "
  nvcc --version
}


# --------------------------------------------------
# 清空 Homebrew 所有缓存（包括当前版本）
# --------------------------------------------------
function brew_clean_cache_all() {
    local cache_dir
    cache_dir="$(brew --cache)"

    if [[ -d "$cache_dir" ]]; then
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        rm -rf "$cache_dir"/*
        echo "✅ 清理完成。"
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    fi
}

# --------------------------------------------------
# 升级所有 Homebrew 包，然后清空缓存
# --------------------------------------------------
function brew_upgrade_and_clean() {
    echo "⬆️ 正在升级 Homebrew..."
    brew update
    echo "⬆️ 正在升级 Homebrew 包..."
    brew upgrade
    echo "⬆️ 升级完成，准备清理缓存..."

    local cache_dir
    cache_dir="$(brew --cache)"

    if [[ -d "$cache_dir" ]]; then
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        rm -rf "$cache_dir"/*
        echo "✅ 升级并清理完成。"
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    fi
}


function open_remote_code(){
  local host="$1"
  local remote_path="$2"
  code --remote "ssh-remote+$host" "$remote_path"
}
