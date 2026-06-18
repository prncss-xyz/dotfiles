if set -q WAYLAND_DISPLAY
    return
end

set TTY1 (tty)
# if running from tty1 start wm
if test "$TTY1" = /dev/tty1
    # exec sway
    # exec mango
    exec river
end
