function __fzf_complete
    set -l token (commandline -ct)

    set -l selected (
        complete --do-complete (commandline -b) |
        fzf --select-1 --exit-0 --query="$token" --height=~40% --layout=reverse --bind=tab:accept
    )

    set -l completion (string split \t -- "$selected")[1]

    if test -n "$completion"
        commandline -t -- $completion
    end

    commandline -f repaint
end

function __fzf_complete_key_bindings --on-variable fish_key_bindings
    set -l modes
    if test "$fish_key_bindings" = fish_default_key_bindings
        set modes default insert
    else
        set modes insert default
    end

    bind --mode $modes[1] \et __fzf_complete
    bind --mode $modes[1] tab __fzf_complete
    bind --mode $modes[2] \et __fzf_complete
    bind --mode $modes[2] tab __fzf_complete
end

__fzf_complete_key_bindings
