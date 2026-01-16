function magic-enter
    set -l cmd (commandline)
    if test -z "$cmd"
        echo
        eza --icons --git
    end
    commandline -f execute
end

bind \r magic-enter
