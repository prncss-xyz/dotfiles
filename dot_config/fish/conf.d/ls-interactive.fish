function ls-interactive
    echo
    eza --icons --git
    echo
    echo
    commandline -f repaint
end

bind \el ls-interactive
