# README

## Install

### Termux

```bash
termux-change-repo
pkg update && pkg upgrade
pkg install proot-distro && pd i void
pd login void
pd login void --termux-home --user root
pd login void --termux-home --user prncss
```

### MacOs

```bash
brew install chezmoi fish git yazi
```

### Voidlinux

live usb

- login: root
- password: voidlinux

```fish
# xbps-query -m | awk '{ print $1 }'
# base-devel: depends="autoconf automake bc binutils bison ed flex gcc gettext groff libtool m4 make patch pkg-config texinfo unzip xz"

xbps-install -Syu xbps void-repo-nonfree
xbps-install -y 7zip base-devel clang StyLua bat chezmoi curl ddgr eza fd fish-shell fzf git github-cli go gopls htop jq lsof lua-language-server neovim openjdk21 pass pnpm poppler resvg ripgrep rsync rust shfmt starship uv w3m wget yazi zoxide
# maximal desktop
xbps-install -y ImageMagick SignalDesktop SwayNotificationCenter Waybar apparmor base-system binutils bluetuith bluez brightnessctl celluloid cheese chezmoi chromium clang cryptsetup darkman dejavu-fonts-ttf easyeffects efibootmgr elogind ffmpeg firefox foot fuzzel ghostty gnome-keyring grim htop imv intel-ucode intel-video-accel iwd iwgtk kdeconnect lvm2 lz4 mesa-vulkan-intel mpv neovide openntpd pinentry-gnome pipewire polkit-gnome poppler qmk qt5-wayland qt6-wayland river sway swayidle syncthing tessen tlp tpm turnstile udiskie vlc vulkan waylock wev wl-clipboard wlsunset wtype xdg-desktop-portal-gtk xdg-desktop-portal-wlr youtube-dl
```

### Alpine

```bash


apk update
apk add build-base chezmoi doas fish git neovim pass shadow starship wget yazi zoxide # minimal option
apk 7zip add bat build-base chezmoi doas eza fd fish fzf git github-cli go jq neovim openjdk21-jre pass pnpm ripgrep rust shadow starship uv w3m wget yazi youtube-dl zoxide

```

### Arch

```bash
pacstrap /mnt linux linux-firmware base base-devel git fscrypt

genfstab -U /mnt >>/mnt/etc/fstab
arch-chroot /mnt

ln -sf /dev/null /etc/pacman.d/hooks/90-mkinitcpio-install.hook
ln -sf /dev/null /etc/pacman.d/hooks/60-mkinitcpio-remove.hook

timedatectl set-ntp true
hwclock --systohc
```

## All

````bash
setfont ter-132b
echo "%wheel ALL=(ALL) ALL">>/etc/sudoers

echo "permit :wheel" > /etc/doas.conf
chmod 0400 /etc/doas.conf
chown root:root /etc/doas.conf

useradd -m -s /usr/bin/fish prncss -G wheel,input,lp,users
passwd prncss

su prncss
cd
chezmoi init prncss-xyz --apply --source projects/dotfiles
fish



## Fscrypt


```bash
fscrypt setup
fscrypt setup /home

rm /home/"$USER1"/.*

sudo -u "$USER1" fscrypt encrypt /home/"$USER1"
sudo -u "$USER1" git clone --recursive "$GIT"
sudo -u "$USER1" sh Dotfiles/post-install.sh
````

```

```
