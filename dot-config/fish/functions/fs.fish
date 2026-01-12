function fs -w "fzf --select-1 --query" -d "Find nvim sessions and cd into root dir"
    set -l fzf_args --select-1
    if test (count $argv) -gt 0
        set -a fzf_args --query $argv
    end
    set -l result (ls ~/.local/share/nvim/session/ | sed 's/__/:\//g; s/_/\//g; s/.json$//' | fzf $fzf_args)
    if test -n "$result"
        cd $result
    end
end
