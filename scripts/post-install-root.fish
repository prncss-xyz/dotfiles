rsync -Lr ~/.sysfiles/* / # update-sysfiles
chsh -s /bin/fish
xbps-install -Syu nonfree
xbps-install -y (cat ~/void/installed)
mkdir -p /etc/pipewire/pipewire.conf.d
ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
for service in bluetoothd dbus dhcpd iwd sshd seatd tlp turnstiled
    ln -sf /etc/sv/$service /etc/runit/runsvdir/default/
end
ln -sf /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.avail/
xbps-reconfigure -f fontconfig

