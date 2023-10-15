#!/usr/bin/env sh

tmpbg='/tmp/screen.png'
scrot $tmpbg -o

i3lock-color -i "$tmpbg" -eu -p "win" --wrong-text="Ah ah ah! You didn't say the magic word!"
