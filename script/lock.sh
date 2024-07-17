img=/tmp/i3lock.png

scrot -o $img
convert $img -scale 6.25% -scale 1600% $img

i3lock -u -i $img
