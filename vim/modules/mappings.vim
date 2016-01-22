" Use semicolon as default leader
let mapleader = ";"

" Map shift-enter to escape
inoremap <S-cr> <esc>
noremap <S-cr> <esc>

" Also map ctrl-j to escape since that's what some terminals actually send
" iTerm does not do this by default, but I have it set to
inoremap <C-J> <esc>
noremap <C-J> <esc>

" Map space to scroll down ten lines
noremap <space> 10<C-e>
