# If running from tty1 start sway
set TTY1 (tty)
if test "$TTY1" = "/dev/tty1"
    # TODO: runit user services
    /usr/bin/gnome-keyring-daemon --start
    dbus-update-activation-environment --all
    dbus-update-activation-environment XDG_CURRENT_DESKTOP=sway WAYLAND_DISPLAY
    gpg-connect-agent /bye
    /usr/libexec/polkit-gnome-authentication-agent-1 &
    pipewire &
    kdeconnectd &
    syncthing serve --no-browser --no-restart --logflags=0 &

    exec dbus-run-session sway
end
