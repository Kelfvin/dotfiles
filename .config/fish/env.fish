# ╭──────────────────────────────────────────────────────────╮
# │                 Environment PATH SETTING                 │
# ╰──────────────────────────────────────────────────────────╯

# fish_add_path prepends each entry and moves existing entries to the front
# instead of duplicating them, matching zsh's `typeset -U path PATH`.  -g keeps
# this in global scope, so no fish_variables file is written.  Directories that
# do not exist are skipped silently.
fish_add_path -gm "$HOME/.cargo/bin" "$HOME/bin" "$HOME/.local/bin" /usr/local/bin

# macOS Homebrew (Apple Silicon / Intel)
if test (command uname -s) = Darwin
    fish_add_path -gm /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/local/sbin
end

# fnm is installed here by script/setup.sh.
set -l fnm_path "$HOME/.local/share/fnm"
if test -d "$fnm_path"
    fish_add_path -gm "$fnm_path"
end

# starship / zoxide 由 script/setup.sh 安装到 ~/.cargo/bin（macOS 也可 brew install）。


# ╭──────────────────────────────────────────────────────────╮
# │                 XDG Base Directories                     │
# ╰──────────────────────────────────────────────────────────╯
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"


# Hugging Face 镜像
set -gx HF_ENDPOINT https://hf-mirror.com

# ── Brew 镜像配置加快下载 ─────────────────────────────────────────────
# 仅在 macOS 上生效，Linux 服务器无 Homebrew
if test (command uname -s) = Darwin
    set -gx HOMEBREW_BREW_GIT_REMOTE https://mirrors.ustc.edu.cn/brew.git
    set -gx HOMEBREW_CORE_GIT_REMOTE https://mirrors.ustc.edu.cn/homebrew-core.git
    set -gx HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles
    set -gx HOMEBREW_API_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles/api
end


# 自定义 Starship 的配置目录
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

# 配置默认的编辑器
set -gx EDITOR nvim

# 设置 aliyunpan 工具的配置目录
set -gx ALIYUNPAN_CONFIG_DIR "$HOME/.config/aliyunpan/"

set -gx GOOGLE_CLOUD_PROJECT charged-sled-465304-e0
set -gx MUSICFOX_ROOT "$HOME/.config/go-musicfox"

# --------------------------------------------------
# Persistent SSH agent socket for tmux
# --------------------------------------------------
# 所有 shell，包括 tmux 中的 shell，都只使用固定路径
# （链接的创建由 ~/.ssh/rc 在 SSH 登录时完成）
if test -S "$HOME/.ssh/agent.sock"
    set -gx SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"
end

# fzf theme. FZF_DEFAULT_OPTS is intentionally kept as one string because
# fzf parses it as shell-style options.  The marker check keeps fish_reload
# from appending the same theme repeatedly.
set -l fzf_opts \
    '--color=bg:-1,bg+:#313244' \
    '--color=fg:#cdd6f4,fg+:#cdd6f4' \
    '--color=hl:#f38ba8,hl+:#f38ba8' \
    '--color=spinner:#f5e0dc,header:#f38ba8,info:#cba6f7' \
    '--color=pointer:#f5e0dc,marker:#b4befe,prompt:#cba6f7' \
    '--color=border:#6c7086'
if not set -q FZF_DEFAULT_OPTS
    set -gx FZF_DEFAULT_OPTS "$fzf_opts"
else if not string match -q -- '*--color=bg:-1,bg+:#313244*' "$FZF_DEFAULT_OPTS"
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS $fzf_opts"
end
