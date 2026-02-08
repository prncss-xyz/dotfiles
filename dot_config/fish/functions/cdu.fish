function cdu
    set -l dir (pwd)

    while true
        set dir (dirname "$dir")
        if test "$dir" = "/"
            break
        end
        if test -f "$dir/package.json" -o -d "$dir/.git"
            cd "$dir"
            return
        end
    end
end
