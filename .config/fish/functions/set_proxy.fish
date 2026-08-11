# usage: set_proxy <host> <port>
function set_proxy --description 'Set HTTP and SOCKS5 proxy variables'
    if test (count $argv) -lt 2
        echo 'usage: set_proxy <host> <port>   e.g. set_proxy localhost 7897' >&2
        return 1
    end

    set -l proxy_ip "$argv[1]"
    set -l port "$argv[2]"
    set -gx https_proxy "http://$proxy_ip:$port"
    set -gx http_proxy "http://$proxy_ip:$port"
    set -gx all_proxy "socks5://$proxy_ip:$port"
end
