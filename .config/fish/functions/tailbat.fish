# Follow a log file and render it with bat.
function tailbat --description 'Follow log files with bat syntax highlighting'
    command tail -f $argv | command bat --paging=never -l log
end
