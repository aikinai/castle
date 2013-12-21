#!/bin/bash
#
# Prints out basic Bash colors
#

for LEFT in "0" "1"
do 
    for RIGHT in {30..36}
    do
        echo -e "\x1B[${LEFT};${RIGHT}m $LEFT:$RIGHT Test"
    done
done
