function gco
    if count $argv > /dev/null
        git checkout $argv
        return
    end

    set -l branch (git branch --all | grep -v (git rev-parse --abbrev-ref HEAD) | fzf | tr -d '[:space:]')
    if test -n "$branch"
        git checkout $branch
    end
end
