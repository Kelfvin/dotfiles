# 一键升级所有包管理器（brew、cargo、uv、TPM…），由 topgrade 统一处理。
# 注入 gh 的 token：mise 等步骤调用 GitHub API 时未认证限流只有 60 次/时，
# 经常 403；带 token 后限额 5000/时。gh 未登录时静默降级（无 token）。
function update_all --description 'Upgrade everything via topgrade'
    if not command -q topgrade
        echo '错误: 找不到 topgrade。' >&2
        return 1
    end
    set -lx GITHUB_TOKEN (gh auth token 2>/dev/null)
    command topgrade $argv
    set -l tg_status $status

    echo '🔄 重新生成 shell 补全...'
    refresh_completions
    return $tg_status
end
