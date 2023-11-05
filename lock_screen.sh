#!/usr/bin/env sh

BLANK='#00000000'
CLEAR='#dfdfdf'
DEFAULT='#dfdfdf'
TEXT='#dfdfdf'
WRONG='#ff6c6b'
VERIFYING='#c678dd'
# i3lock-color -i "$tmpbg" -eu -p "win" --wrong-text="Ah ah ah! You didn't say the magic word!"
i3lock-color \
--insidever-color=$CLEAR     \
--ringver-color=$VERIFYING   \
\
--insidewrong-color=$CLEAR   \
--ringwrong-color=$WRONG     \
\
--inside-color=$BLANK        \
--ring-color=$DEFAULT        \
--line-color=$BLANK          \
--separator-color=$DEFAULT   \
\
--verif-color=$TEXT          \
--wrong-color=$TEXT          \
--time-color=$TEXT           \
--date-color=$TEXT           \
--layout-color=$TEXT         \
--keyhl-color=$WRONG         \
--bshl-color=$WRONG          \
\
--screen 1                   \
--blur 5                     \
--clock                      \
--indicator                  \
--time-str="%H:%M:%S"        \
--date-str="%d/%m/%Y"       \
