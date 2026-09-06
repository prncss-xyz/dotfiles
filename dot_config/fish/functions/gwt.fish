function gwt --description 'Create a Git worktree and enter it'
    set -l target (command git-worktree $argv)
    or return $status

    if test -n "$target"
        builtin cd -- "$target"
    end
end
