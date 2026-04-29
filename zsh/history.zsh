# ╭──────────────────────────────────────────────────────────╮
# │                     ZSH 历史命令相关                     │
# ╰──────────────────────────────────────────────────────────╯
# zsh 历史命令保存位置
export HISTFILE=~/.zsh_history

# 内存里最多保存多少条命令
export HISTSIZE=5000

# 写入文件时保存多少条命令
export SAVEHIST=5000

# 追加历史而不是覆盖
setopt APPEND_HISTORY

# 实时写入，而不是退出时才写
setopt INC_APPEND_HISTORY

# 多个终端共享历史
setopt SHARE_HISTORY
