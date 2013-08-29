#!/bin/sh
# Base16 Monokai - Console color setup script
# Wimer Hazenberg (http://www.monokai.nl)

color00="1d/1e/19" # Base 00 - Black
color01="ff/00/5e" # Base 08 - Red
color02="70/e6/11" # Base 0B - Green
color03="ff/ae/5d" # Base 0A - Yellow
color04="00/d8/ed" # Base 0D - Blue
color05="b0/5c/ff" # Base 0E - Magenta
color06="5b/f3/de" # Base 0C - Cyan
color07="f6/f7/ee" # Base 05 - White
color08="63/5e/4b" # Base 03 - Bright Black
color09=$color01 # Base 08 - Bright Red
color10=$color02 # Base 0B - Bright Green
color11=$color03 # Base 0A - Bright Yellow
color12=$color04 # Base 0D - Bright Blue
color13=$color05 # Base 0E - Bright Magenta
color14=$color06 # Base 0C - Bright Cyan
color15="f8/f6/f2" # Base 07 - Bright White
color16="ff/79/00" # Base 09
color17="df/44/21" # Base 0F
color18="2a/2b/24" # Base 01
color19="39/38/2f" # Base 02
color20="96/8e/71" # Base 04
color21="f3/f1/ed" # Base 06

# 16 color space
printf "\e]4;0;rgb:$color00\e\\"
printf "\e]4;1;rgb:$color01\e\\"
printf "\e]4;2;rgb:$color02\e\\"
printf "\e]4;3;rgb:$color03\e\\"
printf "\e]4;4;rgb:$color04\e\\"
printf "\e]4;5;rgb:$color05\e\\"
printf "\e]4;6;rgb:$color06\e\\"
printf "\e]4;7;rgb:$color07\e\\"
printf "\e]4;8;rgb:$color08\e\\"
printf "\e]4;9;rgb:$color09\e\\"
printf "\e]4;10;rgb:$color10\e\\"
printf "\e]4;11;rgb:$color11\e\\"
printf "\e]4;12;rgb:$color12\e\\"
printf "\e]4;13;rgb:$color13\e\\"
printf "\e]4;14;rgb:$color14\e\\"
printf "\e]4;15;rgb:$color15\e\\"


# 256 color space
if [ "$TERM" != linux ]; then
  printf "\e]4;16;rgb:$color16\e\\"
  printf "\e]4;17;rgb:$color17\e\\"
  printf "\e]4;18;rgb:$color18\e\\"
  printf "\e]4;19;rgb:$color19\e\\"
  printf "\e]4;20;rgb:$color20\e\\"
  printf "\e]4;21;rgb:$color21\e\\"
fi

# clean up
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
