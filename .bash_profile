if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  export QT_QPA_PLATFORMTHEME=gtk3 # make Qt theme look like our gtk one
  exec startx
fi
