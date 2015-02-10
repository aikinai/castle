#!/usr/bin/env bash
#
# Prints out all 255 colors to terminal
#

for code in {0..255}
do 
    echo -e "\x1B[38;05;${code}m $code: Test"
done
