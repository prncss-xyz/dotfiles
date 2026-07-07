if status is-interactive
    fish_config theme choose Rosé\ Pine
    bind \cy 'commandline -b | fish_clipboard_copy'

    fzf --fish | source
    starship init fish | source
    zoxide init fish | source
    atuin init fish | source
end
