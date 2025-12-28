if set -q WAYLAND_DISPLAY
  return
end

set TTY1 (tty)
# If running from tty1 start sway
if test "$TTY1" = "/dev/tty1"
  exec sway
end
