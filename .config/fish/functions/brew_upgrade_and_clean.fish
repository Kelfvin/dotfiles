# 升级所有 Homebrew 包，然后清空缓存。
function brew_upgrade_and_clean --description 'Upgrade Homebrew packages and clear cache'
    echo '⬆️ 正在升级 Homebrew...'
    command brew update
    echo '⬆️ 正在升级 Homebrew 包...'
    command brew upgrade
    echo '⬆️ 升级完成，准备清理缓存...'

    if brew_clean_cache_all
        echo '✅ 升级并清理完成。'
    end
end
