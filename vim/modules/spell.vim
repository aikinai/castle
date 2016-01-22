" Create spell directory if it doesn't exist
if isdirectory($HOME . '/.vim/spell') == 0
  :silent !mkdir -p ~/.vim/spell >/dev/null 2>&1
endif

" Set spell file
set spellfile=~/.vim/spell/en.utf-8.add
