cd $HOME/.local/share/chezmoi/
gh extension install gennaro-tedesco/gh-f
git remote add origin git@github.com:prncss-xyz/chezmoi.git || true
mkdir -p ~/.config/service/dbus
mkdir -p ~/.local/state/mpd

ln -s /usr/share/examples/turnstile/dbus.run ~/.config/service/dbus/run
ln -s /usr/share/examples/turnstile/dbus.check ~/.config/service/dbus/check

cat <<EOF > ~/TODO.md
- [ ] link syncthing
- [ ] link KDEConnect
- [ ] install browser extensions
    - Consent-O-Matic
    - Cookie AutoDelete (import settings)
    - Dark Reader
    - Privacy Badger
    - React Developer Tools
    - SingleFile (configure)
    - uBlock Origin
    - Vimium
EOF
