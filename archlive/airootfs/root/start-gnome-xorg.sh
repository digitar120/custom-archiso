echo "XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
exec gnome-session" > .xinitrc && \
startx 2>/dev/null
