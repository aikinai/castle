source ~/.vim/bootstrap.vim

if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
endif
