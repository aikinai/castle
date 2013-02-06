#!/bin/bash

# This script symlinks all files (except this one) in .githooks to .git/hooks
#
# This way I can keep my hooks in .githooks which is managed by Git, but then 
# have them active in the real .git/hooks directory

cd "$(dirname "$0")"

for HOOK in *
do
    if [[ $HOOK != "link-hooks.sh" ]]; then
        ln -s ../../.githooks/${HOOK} ../.git/hooks/${HOOK}
    fi
done
