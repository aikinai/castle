#!/usr/bin/env bash

if [ ! -d "~/.vim/autoload" ]; then
  mkdir -p ~/.vim/autoload
fi

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +"PlugSnapshot! $HOME/.vim/snapshot.vim" +PlugUpgrade +PlugClean! +PlugUpdate +qa
