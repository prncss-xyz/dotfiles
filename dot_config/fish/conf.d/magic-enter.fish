function magic-enter
    if status --is-interactive-read
        commandline -f execute
        return
    end

    set -l cmd (commandline)
    if test -z "$cmd"
        echo
        eza --icons --git
    end
    commandline -f execute
end

bind \r magic-enter
