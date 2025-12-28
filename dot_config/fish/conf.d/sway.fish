# If running from tty1 start sway
set TTY1 (tty)
if test "$TTY1" = "/dev/tty1"
    exec dbus-run-session sway
end
