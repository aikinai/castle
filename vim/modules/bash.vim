" Make it so bash commands opened in vi use bash syntax highlighting
au BufRead,BufNewFile bash-fc-* set filetype=sh

" Set vimpager (used as less) to use UTF-8
if !exists("vimpager")
    set encoding=UTF8
    set fileencoding=UTF8
endif
