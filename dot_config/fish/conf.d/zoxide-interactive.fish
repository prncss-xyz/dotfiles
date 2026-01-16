function zoxide_interactive
    zoxide query -i | read -l result
    if test -n "$result"
        cd -- "$result"
    end
    commandline -f repaint
end

bind \eo zoxide_interactive
