function gcg --description 'Clone or create a GitHub repository and enter it'
    set -l target (command git-clone-github $argv)
    or return $status

    if test -n "$target"
        builtin cd -- (dirname "$target")
    end
end
