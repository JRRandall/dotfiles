if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  export QT_QPA_PLATFORMTHEME="gtk3" # make Qt theme look like our gtk one
  export QT_AUTO_SCREEN_SCALE_FACTOR=0
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
  export QT_STYLE_OVERRIDE="kvantum"
  exec startx
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
