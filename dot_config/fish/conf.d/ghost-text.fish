# Bind ctrl-s to accept the autosuggestion (ghost text) in full.
#
# ctrl-s is the terminal's XOFF flow-control character — the tty driver
# swallows it before fish can see it. Undefine it at the tty layer so
# fish actually receives the keypress.
if status is-interactive
    stty stop undef 2>/dev/null
end

function fish_user_key_bindings
    bind \cs accept-autosuggestion
end
