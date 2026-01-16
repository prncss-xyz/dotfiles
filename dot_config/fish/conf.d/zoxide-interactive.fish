function zoxide-interactive
    set -l result (zoxide query -i)
    if test -n "$result"
        cd "$result"
    end
    commandline -f repaint
end

bind \eo __zoxide_interactive
