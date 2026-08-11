# 一键升级所有包管理器（brew、cargo、uv、TPM…），由 topgrade 统一处理。
function brew_upgrade_and_clean --description 'Upgrade everything via topgrade'
    if not command -q topgrade
        echo '错误: 找不到 topgrade。' >&2
        return 1
    end
    command topgrade
end
