#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.vim/autoload"

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +"PlugSnapshot! $HOME/.vim/snapshot.vim" +PlugUpgrade +PlugClean! +PlugUpdate +qa
