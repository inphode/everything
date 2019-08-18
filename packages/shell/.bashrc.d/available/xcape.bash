# If xcape command exists, set control to act as escape when pressed and released
[ -x "$(command -v xcape)" ] && xcape -e 'Control_L=Escape'
