
    if not test -n "$NAME"
        echo "Usage: gwta <branch-name>"
        return 1
    end

    git worktree add $NAME $argv[2..] && cd $NAME && i
end
