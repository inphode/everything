# If xcape command exists, set control to act as escape when pressed and released
[ -x "$(command -v xcape)" ] && xcape -t 300 -e 'Control_L=Escape;Tab=Hyper_L'
xmodmap ~/.Xmodmap
