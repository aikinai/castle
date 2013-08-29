"-----------------------------------------------------------------------------
" Alan's own settings
"-----------------------------------------------------------------------------
if !exists("vimpager") 
    set encoding=UTF8
    set fileencoding=UTF8
endif
" set lines=50 columns=80 textwidth=80 linebreak
" set lines=50 columns=80 wrapmargin=0 linebreak
set nocompatible
set formatoptions=troqwnmMj

" Show lines at the bottom of window
set display=lastline
" Use comma as default leader
let mapleader = ";"
" Use CTRL-E to replace the original comma mapping
nnoremap <C-E> ,
" Dark base16-tomorrow colors
set background=dark
let base16colorspace=256 " Needed for all colors in Base16
colorscheme base16-default

" Make enter to escape in insert mode
inoremap <S-cr> <esc>
noremap <S-cr> <esc>
" Map space to scroll down ten lines
noremap <space> 10<C-e>
" Map shift-space to scroll up ten lines
noremap <S-space> 10<C-y>
" I have no idea what this does - need to look it up
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                    \ exe "normal g'\"" | endif
" Change the cursor color when in Japanese (only works in Windows?)
if has('multi_byte_ime') || has('xim')
highlight CursorIM guibg=#b1d631 guifg=NONE
endif

" ---------------------- "
" NEOCOMPLCACHE SETTINGS "
" ---------------------- "
" Enable NeoComplCache
let g:neocomplcache_enable_at_startup = 1
" Disable auto-complete
let g:neocomplcache_disable_auto_complete = 1
" Enable tab-completion
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : "\<C-x>\<C-u>"
function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
endfunction


if has("gui_running")
    " ----------------- "
    " GUI-ONLY SETTINGS "
    " ----------------- "
    set lines=50 columns=80

    if has("win32")
        " Use Ricty 14pt for Windows
        set guifont=Ricty\ Regular:h14
    else
        " Use Ricty 18pt for OS X
        set guifont=Ricty\ Regular:h18
    endif
else
    " --------------------- "
    " CONSOLE-ONLY SETTINGS "
    " --------------------- "

    " --------------- "
    " VUNDLE SETTINGS "
    " --------------- "
    filetype off " Required to make Vundle work; turned on later

    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " Let Vundle manage Vundle; required
    Bundle 'gmarik/vundle'

    " My bundles
    " ----------
    Bundle 'ctrlp.vim'
    Bundle 'EasyMotion'
    Bundle 'fugitive.vim'
    Bundle 'Gundo'
    Bundle 'L9'
    Bundle 'tpope/vim-markdown'
    Bundle 'neocomplcache'
    Bundle 'surround.vim'
    Bundle 'godlygeek/tabular'
    Bundle 'tomtom/tcomment_vim'
    Bundle 'vim-scripts/Align'

    filetype plugin indent on " Required!

endif

" ----------------- "
" TCOMMENT SETTINGS "
" ----------------- "
let g:tcommentOptions = {'col': 1}

" --------------- "
" CTRL-P SETTINGS "
" --------------- "
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_show_hidden = 1

set wildignore+=*.swp

" Make it so bash commands opened in vi use bash syntax highlighting
au BufRead,BufNewFile bash-fc-* set filetype=sh

" Use double-width for ambiguous-width characters
" This seems safest for Ricty
set ambiwidth=double

" Set universal spell file
set spellfile=~/.vim/spell/en.utf-8.add

" Command-j for window movement in OS X
noremap <D-j> <C-w>

" F5 to toggle Gundo, undo map window
noremap <silent> <F5> :GundoToggle<CR>

" Ctrl-space for unbreakable space
inoremap <C-Space> <C-q>160

" Set undo points after every sentence
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u

" Join all paragraphs in buffer and clear search string
noremap <silent> <leader>J :%s/\(\S\)\n\(\S\)/\1 \2/ <bar> let @/ = ""<CR>

noremap <silent> <leader>K :g/\%60v.\+/ join<CR>

noremap <silent> <leader>en :call English()<CR>
function! English()
    " setlocal breakat&
    setlocal ambiwidth=single
    setlocal iminsert=0 imsearch=0
endfunction

noremap <silent> <leader>ej :call Japanese()<CR>
function! Japanese()
    setlocal breakat=
    setlocal ambiwidth=double
    setlocal iminsert=2 " imsearch=2
endfunction

" ------------------------ "
" BACKUP AND SWAP SETTINGS "
" ------------------------ "
" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
  :silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undofile
endif

"-----------------------------------------------------------------------------
" Alan's replacements
"-----------------------------------------------------------------------------
" Wrapping functions
" Default to wrapping on
" set wrap linebreak textwidth=0
" noremap  <buffer> <silent> <Up>   gk
" noremap  <buffer> <silent> <Down> gj
" noremap  <buffer> <silent> <Home> g<Home>
" noremap  <buffer> <silent> <End>  g<End>
" inoremap <buffer> <silent> <Up>   <C-o>gk
" inoremap <buffer> <silent> <Down> <C-o>gj
" inoremap <buffer> <silent> <Home> <C-o>g<Home>
" inoremap <buffer> <silent> <End>  <C-o>g<End>
" noremap  <buffer> <silent> k gk
" noremap  <buffer> <silent> j gj
" noremap  <buffer> <silent> 0 g0
" noremap  <buffer> <silent> $ g$

" Set up wrapping functions
function! WrapOn()
    setlocal wrap linebreak nolist tw=0
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$
endfunction

function! WrapOff()
    setlocal nowrap
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
    silent! iunmap <buffer> k
    silent! iunmap <buffer> j
    silent! iunmap <buffer> 0
    silent! iunmap <buffer> $
endfunction

" Set up wrap toggle function
noremap <silent> <leader>W :call ToggleWrap()<CR>
function! ToggleWrap()
if &wrap
    call WrapOff()
else
    call WrapOn()
endif
endfunction

"-----------------------------------------------------------------------------
" Alan's Python settings
"-----------------------------------------------------------------------------
" Python folding
set foldmethod=indent
set foldlevel=99
" Python code completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview


"-----------------------------------------------------------------------------
" Alan's Handy Functions
"-----------------------------------------------------------------------------

" Hex to decimal convertor
command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V0x\x\+/\=submatch(0)+0/g'
    else
      let cmd = 's/0x\x\+/\=submatch(0)+0/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
  endif
endfunction

" Decimal to hex convertor
command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%x', a:arg + 0)
  endif
endfunction


"-----------------------------------------------------------------------------
" Global Stuff
"-----------------------------------------------------------------------------

" Tabstops are 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent

" set the search scan to wrap lines
set wrapscan

" set the forward slash to be the slash of note.  Backslashes suck
set shellslash

" Setup shells for unix and Windows (work)
if has("win32")
    " Set up general Windows stuff
    if has("gui_running")
        let $HOME = 'C:\Users\alanro01'
        cd $HOME
    endif
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set shell=C:/cygwin/bin/bash
    set shellcmdflag=--login\ -c
    set shellxquote=\"
    " Turn off IME in insert mode and search mode
    set iminsert=0
    set imsearch=0
    set backupdir=~/.vim/backup,/temp
else
    set shell=bash
  " set wildignorecase
endif

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Make sure that unsaved buffers that are to be put in the background are 
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions=ces$

" Set the status line the way Derek likes it
set stl=%f\ %m\ %r%{fugitive#statusline()}\ Line:%l/%L[%p%%]\ Col:%v\ Buf:#%n\ [%b][0x%B]

" tell VIM to always put a status line in, even if there is only one window
set laststatus=2

" Don't update the display while executing macros
set lazyredraw

" Don't show the current command in the lower right corner.  In OSX, if this is
" set and lazyredraw is set then it's slow as molasses, so we unset this
set showcmd

" Show the current mode
set showmode

" Switch on syntax highlighting.
syntax on

" Hide the mouse pointer while typing
set mousehide

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" set the gui options the way I like
set guioptions=Acg

" Setting this below makes it so that error messages don't disappear after one second on startup.
" set debug=msg

" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"      "," key and the "d" key.  If the "d" key isn't pressed before the
"      timeout expires, one of two things happens: The "," command is executed
"      if there is one (which there isn't) or the command aborts.
set timeoutlen=500

" Keep some stuff in the history
set history=100

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" When the page starts to scroll, keep the cursor 10 lines from the top and 10
" lines from the bottom
set scrolloff=10

" Allow the cursor to go in to invalid places
" set virtualedit=all

" Disable encryption (:X)
set key=

" Make the command-line completion better
set wildmenu

" Alright... let's try this out
imap jj <esc>

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

"-----------------------------------------------------------------------------
" Set up the window colors and size
"-----------------------------------------------------------------------------
:nohls

set showfulltag

" get rid of the silly characters in separators
set fillchars = ""

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" Add the unnamed register to the clipboard
if $TMUX == ''
    set clipboard+=unnamed
endif

" Automatically read a file that has changed on disk
set autoread

set grepprg=grep\ -nH\ $*

" Wipe out all buffers
nmap <silent> <leader>wa :1,9000bwipeout<cr>

" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" Turn off that stupid highlight search
nmap <silent> <leader>n :nohls<CR>

" put the vim directives for my file editing settings in
nmap <silent> <leader>vi ovim:set ts=2 sts=2 sw=2:<CR>vim600:fdm=marker fdl=1 fdc=0:<ESC>

" Show all available VIM servers
nmap <silent> <leader>ss :echo serverlist()<CR>

" The following beast is something i didn't write... it will return the 
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as 
" syntax highlighting goes.
nmap <silent> <leader>qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <End>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>

" Maps to make handling windows a bit easier
noremap <silent> <leader>h :wincmd h<CR>
noremap <silent> <leader>j :wincmd j<CR>
noremap <silent> <leader>k :wincmd k<CR>
noremap <silent> <leader>l :wincmd l<CR>
noremap <silent> <leader>sb :wincmd p<CR>
noremap <silent> <C-F9>  :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
noremap <silent> <leader>s8 :vertical resize 83<CR>
noremap <silent> <leader>cj :wincmd j<CR>:close<CR>
noremap <silent> <leader>ck :wincmd k<CR>:close<CR>
noremap <silent> <leader>ch :wincmd h<CR>:close<CR>
noremap <silent> <leader>cl :wincmd l<CR>:close<CR>
noremap <silent> <leader>cc :close<CR>
noremap <silent> <leader>cw :cclose<CR>
noremap <silent> <leader>ml <C-W>L
noremap <silent> <leader>mk <C-W>K
noremap <silent> <leader>mh <C-W>H
noremap <silent> <leader>mj <C-W>J
noremap <silent> <C-7> <C-W>>
noremap <silent> <C-8> <C-W>+
noremap <silent> <C-9> <C-W>+
noremap <silent> <C-0> <C-W>>

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Search the current file for what's currently in the search register and display matches
nmap <silent> <leader>gs :vimgrep /<C-r>// %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Search the current file for the word under the cursor and display matches
nmap <silent> <leader>gw :vimgrep /<C-r><C-w>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Search the current file for the WORD under the cursor and display matches
nmap <silent> <leader>gW :vimgrep /<C-r><C-a>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

" Swap two words
nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

" Toggle fullscreen mode
nmap <silent> <F3> :call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>

" Underline the current line with '='
nmap <silent> <leader>ul :t.\|s/./=/g\|:nohls<cr>

" Shrink the current window to fit the number of lines in the buffer.  Useful
" for those buffers that are only a few lines
nmap <silent> <leader>sw :execute ":resize " . line('$')<cr>

" Use the bufkill plugin to eliminate a buffer but keep the window layout
nmap <leader>bd :BD<cr>

" Don't highlight matching parentheses
" let loaded_matchparen = 1

" Highlight the current line and column
" Don't do this - It makes window redraws painfully slow
set nocursorline
set nocursorcolumn

"-----------------------------------------------------------------------------
" FSwitch mappings
"-----------------------------------------------------------------------------
nmap <silent> <leader>of :FSHere<CR>
nmap <silent> <leader>ol :FSRight<CR>
nmap <silent> <leader>oL :FSSplitRight<CR>
nmap <silent> <leader>oh :FSLeft<CR>
nmap <silent> <leader>oH :FSSplitLeft<CR>
nmap <silent> <leader>ok :FSAbove<CR>
nmap <silent> <leader>oK :FSSplitAbove<CR>
nmap <silent> <leader>oj :FSBelow<CR>
nmap <silent> <leader>oJ :FSSplitBelow<CR>

"-----------------------------------------------------------------------------
" FuzzyFinder Settings
"-----------------------------------------------------------------------------
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|class|meta|lock|orig|jar|swp)$|/test/data\.|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
nmap <silent> <leader>fv :FufFile ~/.vim/<cr>
nmap <silent> <leader>fb :FufBuffer<cr>
nmap <silent> <leader>ff :FufFile<cr>
nmap <silent> <leader>fc :FufMruCmd<cr>
nmap <silent> <leader>fm :FufMruFile<cr>
nmap <silent> <leader>fp :FufFile ~/git/*<cr>

"-----------------------------------------------------------------------------
" Functions
"-----------------------------------------------------------------------------
" if !exists('g:bufferJumpList')
"     let g:bufferJumpList = {}
" endif
" 
" function! MarkBufferInJumpList(bufstr, letter)
"     let g:bufferJumpList[a:letter] = a:bufstr
" endfunction
" 
" function! JumpToBufferInJumpList(letter)
"     if has_key(g:bufferJumpList, a:letter)
"         exe ":buffer " . g:bufferJumpList[a:letter]
"     else
"         echoerr a:letter . " isn't mapped to any existing buffer"
"     endif
" endfunction
" 
" function! ListJumpToBuffers()
"     for key in keys(g:bufferJumpList)
"         echo key . " = " . g:bufferJumpList[key]
"     endfor
" endfunction
" 
" function! IndentToNextBraceInLineAbove()
"     :normal 0wk
"     :normal "vyf(
"     let @v = substitute(@v, '.', ' ', 'g')
"     :normal j"vPl
" endfunction
" 
" nmap <silent> <leader>ii :call IndentToNextBraceInLineAbove()<cr>
" 
" nmap <silent> <leader>mba :call MarkBufferInJumpList(expand('%:p'), 'a')<cr>
" nmap <silent> <leader>mbb :call MarkBufferInJumpList(expand('%:p'), 'b')<cr>
" nmap <silent> <leader>mbc :call MarkBufferInJumpList(expand('%:p'), 'c')<cr>
" nmap <silent> <leader>mbd :call MarkBufferInJumpList(expand('%:p'), 'd')<cr>
" nmap <silent> <leader>mbe :call MarkBufferInJumpList(expand('%:p'), 'e')<cr>
" nmap <silent> <leader>mbf :call MarkBufferInJumpList(expand('%:p'), 'f')<cr>
" nmap <silent> <leader>mbg :call MarkBufferInJumpList(expand('%:p'), 'g')<cr>
" nmap <silent> <leader>jba :call JumpToBufferInJumpList('a')<cr>
" nmap <silent> <leader>jbb :call JumpToBufferInJumpList('b')<cr>
" nmap <silent> <leader>jbc :call JumpToBufferInJumpList('c')<cr>
" nmap <silent> <leader>jbd :call JumpToBufferInJumpList('d')<cr>
" nmap <silent> <leader>jbe :call JumpToBufferInJumpList('e')<cr>
" nmap <silent> <leader>jbf :call JumpToBufferInJumpList('f')<cr>
" nmap <silent> <leader>jbg :call JumpToBufferInJumpList('g')<cr>
" nmap <silent> <leader>ljb :call ListJumpToBuffers()<cr>

function! DiffCurrentFileAgainstAnother(snipoff, replacewith)
    let currentFile = expand('%:p')
    let otherfile = substitute(currentFile, "^" . a:snipoff, a:replacewith, '')
    only
    execute "vertical diffsplit " . otherfile
endfunction

command! -nargs=+ DiffCurrent call DiffCurrentFileAgainstAnother(<f-args>)

function! RunSystemCall(systemcall)
    let output = system(a:systemcall)
    let output = substitute(output, "\n", '', 'g')
    return output
endfunction

function! HighlightAllOfWord(onoff)
    if a:onoff == 1
        :augroup highlight_all
            :au!
            :au CursorMoved * silent! exe printf('match Search /\<%s\>/', expand('<cword>'))
        :augroup END
    else
        :au! highlight_all
        match none /\<%s\>/
    endif
endfunction

:nmap <leader>ha :call HighlightAllOfWord(1)<cr>
:nmap <leader>hA :call HighlightAllOfWord(0)<cr>

function! LengthenCWD()
	let cwd = getcwd()
    if cwd == '/'
        return
    endif
	let lengthend = substitute(cwd, '/[^/]*$', '', '')
    if lengthend == ''
        let lengthend = '/'
    endif
    if cwd != lengthend
	    exec ":lcd " . lengthend
	endif
endfunction

:nmap <leader>ld :call LengthenCWD()<cr>

function! ShortenCWD()
	let cwd = split(getcwd(), '/')
	let filedir = split(expand("%:p:h"), '/')
    let i = 0
    let newdir = ""
    while i < len(filedir)
        let newdir = newdir . "/" . filedir[i]
        if len(cwd) == i || filedir[i] != cwd[i]
            break
        endif
        let i = i + 1
    endwhile
    exec ":lcd /" . newdir
endfunction

:nmap <leader>sd :call ShortenCWD()<cr>

function! RedirToYankRegisterF(cmd, ...)
    let cmd = a:cmd . " " . join(a:000, " ")
    redir @*>
    exe cmd
    redir END
endfunction

command! -complete=command -nargs=+ RedirToYankRegister 
  \ silent! call RedirToYankRegisterF(<f-args>)

"-----------------------------------------------------------------------------
" Commands
"-----------------------------------------------------------------------------
function! FreemindToListF()
    setl filetype=
    silent! :%s/^\(\s*\).*TEXT="\([^"]*\)".*$/\1- \2/
    silent! :g/^\s*</d
    silent! :%s/&quot;/"/g
    silent! :%s/&apos;/\'/g
    silent! g/^-/s/- //
    silent! g/^\w/t.|s/./=/g
    silent! g/^\s*-/normal O
    silent! normal 3GgqG
    silent! %s/^\s\{4}\zs-/o/
    silent! %s/^\s\{12}\zs-/+/
    silent! %s/^\s\{16}\zs-/*/
    silent! %s/^\s\{20}\zs-/#/
    silent! normal gg
endfunction

command! FreemindToList call FreemindToListF()

"-----------------------------------------------------------------------------
" Auto commands
"-----------------------------------------------------------------------------
augroup derek_xsd
    au!
    au BufEnter *.xsd,*.wsdl,*.xml setl tabstop=4 shiftwidth=4
    au BufEnter *.xsd,*.wsdl,*.xml setl formatoptions=crq textwidth=120 colorcolumn=120
augroup END

augroup Binary
  au!
  au BufReadPre   *.bin let &bin=1
  au BufReadPost  *.bin if &bin | %!xxd
  au BufReadPost  *.bin set filetype=xxd | endif
  au BufWritePre  *.bin if &bin | %!xxd -r
  au BufWritePre  *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END


"-----------------------------------------------------------------------------
" Fix constant spelling mistakes
"-----------------------------------------------------------------------------

iab teh       the
iab Teh       The
iab taht      that
iab Taht      That
iab alos      also
iab Alos      Also
iab aslo      also
iab Aslo      Also
iab becuase   because
iab Becuase   Because
iab shoudl    should
iab Shoudl    Should
iab adn       and
