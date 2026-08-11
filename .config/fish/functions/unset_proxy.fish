function unset_proxy --description 'Unset proxy variables'
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
    echo '代理已取消'
end
