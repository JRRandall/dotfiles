#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -load "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#nvidia-settings --load-config-only

#xrdb -all -global -load ~/.Xdefaults
#. /opt/MaXX/etc/system.desktopenv
#. $HOME/.maxxdesktop/desktopenv

# gnome-terminal &
# /opt/MaXX/bin/5Dwm
#/opt/MaXX/etc/skel/Xsession.dt
#gnome-session
#exec startxfce4
#exec nscde
exec fvwm3

