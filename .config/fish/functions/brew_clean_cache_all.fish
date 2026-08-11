# 清空 Homebrew 所有缓存（包括当前版本）。
function brew_clean_cache_all --description 'Clear all Homebrew cache entries'
    if not command -q brew
        echo '错误: 找不到 brew。' >&2
        return 1
    end

    set -l cache_dir (command brew --cache)
    if test $status -ne 0
        return 1
    end

    if test -z "$cache_dir"; or test "$cache_dir" = /
        echo "❌ 缓存目录异常，终止清理：'$cache_dir'" >&2
        return 1
    end

    if test -d "$cache_dir"
        echo "⚠️ 正在清空 Homebrew 缓存：$cache_dir"
        for cache_entry in "$cache_dir"/*
            command rm -rf -- "$cache_entry"
        end
        echo '✅ 清理完成。'
    else
        echo "ℹ️ Homebrew 缓存目录不存在：$cache_dir"
    end
end
