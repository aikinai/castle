" Display tabs as two space
set tabstop=2
" Auto-indent with two space
set shiftwidth=2
" Tab inserts two spaces
set softtabstop=2
" Insert spaces when tab is pressed
set expandtab
" New lines inherit indentation
set autoindent
" New indendation is based on syntax
set smartindent

" Set autoformatting the way I like
" Only include 'j' option for Vim 7.3 or later (not supported earlier)
if version >= 703
    set formatoptions=troqwnmMj
else
    set formatoptions=troqwnmM
endif
