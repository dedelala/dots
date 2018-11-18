#!/bin/bash

die() { echo "oh noes: $*"; exit 1; }

xbps-install -Suyy || die "update"
xbps-install -Suyy || die "update"

xbps-install -Syy linux-firmware alsa-lib ntp exfat-dkms exfat-utils \
  font-awesome5 terminus-font || die "install"

xbps-install -Syy glxinfo libEGL libXft libXinerama xdpyinfo xev \
  xf86-video-intel xfontsel xhost xinit xmodmap xorg-fonts xorg-minimal \
  xprop xrandr xrdb xset xsetroot || die "install"

xbps-install -Syy docker go gnupg jq make pkg-config shellcheck tree \
  unzip zip zsh firefox lemonbar-xft scrot || die "install"

tee /etc/rc.conf <<! || die "rc.conf"
TIMEZONE=Australia/Melbourne
KEYMAP=us
FONT="ter-132n"
TTYS=2
!

rm -fv /var/service/agetty-tty{3..9}
rm -fv /var/service/sshd
ln -sv /etc/sv/docker /var/service/
ln -sv /etc/sv/ntpd /var/service/
