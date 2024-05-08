"----------------------------------------------------------------------------
"  File:        .vimrc
"  Author:      Justin Randall
"  Created:     Fri Mar 16 09:00 AM 2001 EST
"  Last Change: Tue May 07 10:00 PM 2024 EDT
"  Description: Initial setup file for VIM (Vi IMproved)
"               this file goes in a users $HOME directory and uses
"               plugins from $HOME/.vim/plugins to help make editing
"               with VIM easy and powerful.
"----------------------------------------------------------------------------

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'arcticicestudio/nord-vim'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Interface settings
let c_comment_strings=1  " Highlight strings in C/C++ comments
syntax on          " Enable syntax highlighting
if exists(':filetype')
    filetype plugin indent on
endif
set nocompatible   " Use Vim defaults instead of vi (much better!)
scriptencoding utf8
set comments=b:#,:%,fb:-,n:>,n:)b:\"n:: " Comments may start with these chars
set formatoptions+=n " Add list support
set cpoptions-=u   " Allow the vim multi level undo
set list           " Try showing this all the time with better listchars
if &encoding == 'utf-8'
    set listchars=tab:·\ ,trail:.
else
    set listchars=tab:>\ ,trail:.
endif
set matchpairs=(:),{:},[:],<:> " Matching pair characters
set shortmess=aoOtT " Abbreviate the status messages
set showmatch      " When a bracket is inserted, briefly jump to matching one
set sidescroll=1   " The minimal number of columns to scroll horizontally
set suffixes=      " Set a priority between files with almost the same name
set wildmenu       " Command-line completion operates in an enhanced mode
set wildmode=longest,list,list:full " vim wildcard behavior
set noerrorbells   " Stop the beeping
set t_vb=          " Turn off flashing too :-)
set cmdheight=1    " Less Hit Return messages
set modeline       " Scan for modeline commands
set report=0       " Always report line changes for : commands
set scrolloff=2    " Keep two lines above/below cursor on screen
set showcmd        " Show (partial) command in status line
set splitbelow     " Put the new window below the current one
set winheight=4    " At least 4 lines for current window
set nobackup writebackup " Temporary backup before writing
"set textwidth=78         " Text width (use gq to wrap)

" Text settings
set autowrite      " Automatically save the file
set backspace=indent,eol,start  " allow backspacing over all in insert mode
set expandtab      " Do not insert tab, insert a number of spaces
set smarttab       " Smart tabbing
set shiftwidth=2   " Number of spaces to use for each step of (auto)indent
set softtabstop=2  " Number of spaces that a <Tab> counts for in editing
set tabstop=2      " Set tabs to 2 characters
set noautoindent     " Set indenting to automatic
set nosmartindent    " Smart indenting
set cino=j1,(0,ws,Ws,N-s
set history=100    " Number of commands to save in history.
set shellslash     " Force forward slashes, required by some plugins
set grepprg=grep\ -nH\ $*
set tags=tags;     " The ctags file to use for browsing source code
set noshortname    " don't use dos-style filenames

" Search settings
set incsearch      " Incremental searching
set hlsearch       " Highlight the search patterns that are found
set ignorecase smartcase " Ignore case implied if search string is lowercase

" GUI and Terminal settings for color schemes and mouse control
if has("gui_running")
    "colorscheme solarized
    colorscheme nord
    " set the GUI font based off of operating system
    if has("win32")
        set guifont=Consolas:h11
    elseif has("mac")
        set guifont=Monaco:h10
    else
        "set guifont=Bitstream\ Vera\ Sans\ Mono\ 10
        set guifont=Consolas\ 11
    endif
else
    set term=xterm-256color
    set mouse=a
    set ttymouse=xterm2
    set t_Co=256
endif


" version 7+ commands
if version >= 700
   " enable auto-spelling commands
   " :]s - Move to the next mis-spelled word in the document.
   " :[s - Same as above command but searches backwards.
   " z= - Shows a list of close matches to the mis-spelled word.
   " zg - add words permanently to your personal word list. 
   " zw - marks a word as misspelled.
   set sps=best,10

   " PLUGINS
   " omnicppcomplete plugin for C++ intelisense
   " configure tags - add additional tags here or comment out not-used ones
   set tags+=~/.vim/tags/cpp_tags
   " build tags of your own project with Ctrl-F12
   map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

   " OmniCppComplete
   let OmniCpp_NamespaceSearch = 1
   let OmniCpp_GlobalScopeSearch = 1
   let OmniCpp_ShowAccess = 1
   let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
   let OmniCpp_MayCompleteDot = 1      " autocomplete after .
   let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
   let OmniCpp_MayCompleteScope = 1    " autocomplete after ::
   let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD", "_GLIBCXX_STD_A", "_GLIBCXX_STD_B", "_GLIBCXX_STD_C"]
   " automatically open and close the popup menu / preview window
   au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
   set completeopt=menuone,menu,longest,preview

endif " Done with version 7+ commands

" AUTOCOMMANDS
" ------------
" When editing a file, always jump to the last cursor position
"autocmd BufReadPost * if line("'\"") | exe "normal `\"" | endif

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" GetDatestamp() will return today's date, type ";de" to run
function! GetDatestamp(...)
   let Month01 = "January"
   let Month02 = "February"
   let Month03 = "March"
   let Month04 = "April"
   let Month05 = "May"
   let Month06 = "June"
   let Month07 = "July"
   let Month08 = "August"
   let Month09 = "September"
   let Month10 = "October"
   let Month11 = "November"
   let Month12 = "December"
   let YearNumber=strftime("%Y")
   let MonthNumber=strftime("%m")
   let DayNumber=strftime("%d")
   let DayNumber = substitute(DayNumber,"^0","","")
   execute "let Stamp = \"" . DayNumber . " \" . " "Month" . MonthNumber " . \" " . YearNumber . "\""
   return Stamp
endfunction

" Date mapping from GetDatestamp(), use ;de
nmap ;de 3cw<C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><ESC>
imap ;de <C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR>

"-------------------------------------------------------------------------------
"  KEY MAPPINGS for Home, End, and F* keys!
"-------------------------------------------------------------------------------
"    F1   -  run help command
"    F2   -  toggle spell checking (version 7+ only)
"    F3   -  insert debug prints
"    F4   -  show tag under cursor in the preview window (tagfile must exist!)
"    F5   -  pretty format file tabify
"    F6   -  list all errors
"    F7   -  used by doxygen plugin to insert doxygen comments
"    F8   -  removes the  characters from a file
"    F9   -  not used here, used instead for C/C++ extension
"    F10  -  toggle the taglist window
"-------------------------------------------------------------------------------
" Normal mode mapping
nmap     <silent>  <F2>    :set spelllang=en_us<CR>:set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
nmap     <silent>  <F3>    I<C-x>std::cout << "*** Got Here " << __FILE__ << "(" << __LINE__ << ") ***\n";<CR>
nmap     <silent>  <F4>    :exe ":ptag ".expand("<cword>")<CR>
nmap     <silent>  <F5>    mzgg=G'z<CR>
nmap     <silent>  <F6>    :copen<CR>
nmap     <silent>  <F7>    :Dox<CR><Esc>mzgg=G'z<CR><Up><Esc>$A
nmap     <silent>  <F8>    :%s/\r//gic<CR>
noremap  <silent>  <F10>   <Esc><Esc>:Tlist<CR>
" Insert mode mapping
imap     <silent>  <F2>    <Esc>:set spelllang=en_us<CR>:set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>I
imap     <silent>  <F3>    <C-x>std::cout << "*** Got Here " << __FILE__ << "(" << __LINE__ << ") ***\n";<CR>
imap     <silent>  <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
imap     <silent>  <F5>    <Esc>mzgg=G'z<CR>I
imap     <silent>  <F6>    <Esc>:copen<CR>
imap     <silent>  <F7>    <Esc>:Dox<CR><Esc>mzgg=G'z<CR><Up>$A
imap     <silent>  <F8>    <Esc>:%s/\r//gic<CR>
inoremap <silent>  <F10>   <Esc><Esc>:Tlist<CR>


nnoremap <silent> <PageUp> <C-U><C-U>
vnoremap <silent> <PageUp> <C-U><C-U>
inoremap <silent> <PageUp> <C-\><C-O><C-U><C-\><C-O><C-U>

nnoremap <silent> <PageDown> <C-D><C-D>
vnoremap <silent> <PageDown> <C-D><C-D>
inoremap <silent> <PageDown> <C-\><C-O><C-D><C-\><C-O><C-D>

" select all with Ctrl+a
nnoremap <C-a> ggVG

" quick regex with Ctrl+<spacebar>
nnoremap <C-Space> :s///<Left><Left>

" switching buffers with tab and shift+tab
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>

" Ctrl+x to cut, Ctrl+y to copy, Ctrl+p to paste
vnoremap <silent> <C-x> "+x
vnoremap <silent> <C-c> "+y
nnoremap <silent> <C-p> "+gP

" Big mapping for new shell script. In <InsertMode> type ;sh in a new buffer.
imap ;sh #!/bin/bash<CR>#######################################################################<CR>#<CR>#<Space><Space>File:<Space><Space><Space><Space><Space><Space><Space><Space><CR>#<Space><Space>Author:<Space><Space><Space><Space><Space><Space>Justin<Space>Randall<CR>#<Space><Space>Version:<Space><Space><Space><Space><Space>0.1<CR>#<Space><Space>Created:<Space><Space><Space><Space><Space><C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><CR>#<Space><Space>Last Change:<Space><C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><CR>#<Space><Space>Description:<Space><CR>#<Space><Space>Usage:<Space><Space><Space><Space><Space><Space><Space><CR>#<Space><Space>History:<Space><Space><Space><Space><Space>none<CR>#<CR>#######################################################################<CR>PN='basename "$0"'<CR>VER='0.1'<CR><CR>

"-------------------------------------------------------------------------------
"  PLUGINS and other settings
"-------------------------------------------------------------------------------

" ToggleComment
noremap <silent> ,# :call CommentLineToEnd('# ')<CR>+
noremap <silent> ,/ :call CommentLineToEnd('// ')<CR>+
noremap <silent> ," :call CommentLineToEnd('" ')<CR>+
noremap <silent> ,; :call CommentLineToEnd('; ')<CR>+
noremap <silent> ,- :call CommentLineToEnd('-- ')<CR>+
noremap <silent> ,* :call CommentLinePincer('/* ', ' */')<CR>+
noremap <silent> ,< :call CommentLinePincer('<!-- ', ' -->')<CR>+
noremap <silent> ,! :call CommentLineToEnd('! ')<CR>+

" TagList
"let Tlist_Ctags_Cmd = "\ctags"
"let Tlist_Ctags_Cmd = "$HOME/bin/ctags"

" LastChange
let g:timeStampLeader    =  "Last Change: "

" C/C++ IDE
let g:C_AuthorName       =  "Justin Randall"
let g:C_AuthorRef        =  "randall"
let g:C_Email            =  ""
let g:C_Company          =  ""
let g:C_Project          =  ""
let g:C_CopyrightHolder  =  "(c)"
let g:C_ObjExtension     =  ".o"
let g:C_ExeExtension     =  ""
let g:C_CCompiler        =  "gcc"
let g:C_CplusCompiler    =  "g++"
let g:C_Comments         =  "no"     " yes = C no = C++
let g:C_LoadMenus        =  "yes"    " load C/C++ menus by default
let g:C_Libs             =  "-lm -lrt" " link libraries
let s:C_CFlags           =  "-Wall -g -O3 -c -DDEBUG -std=c++11 " " compiler flags
let s:C_LFlags           =  "-Wall -g -O3"    " linker flags
let g:C_FormatDate       =  "%e %B %Y"
let g:C_FormatTime       =  "%k:%M %z %Z"
let g:C_FormatYear       =  "%Y"

" Doxygen Toolkit
"let g:DoxygenToolkit_blockHeader       = "/////////////////////////////////////////////////////////////////////"
"let g:DoxygenToolkit_blockFooter       = "/////////////////////////////////////////////////////////////////////"
let g:DoxygenToolkit_authorName        = "Justin Randall"
let g:DoxygenToolkit_undocTag          = "DOX_SKIP_BLOCK"
let g:DoxygenToolkit_commentType       = "C"  " comment style C or C++
let g:DoxygenToolkit_briefTag_funcName = "no"
let g:DoxygenToolkit_startCommentTag   = "/*****************************************************************//**"
let g:DoxygenToolkit_interCommentTag   = "* "
let g:DoxygenToolkit_endCommentTag     = "********************************************************************/"
let g:DoxygenToolkit_startCommentBlock = "/*****************************************************************//**"
let g:DoxygenToolkit_interCommentBlock = "* "
let g:DoxygenToolkit_endCommentBlock   = "********************************************************************/"


" If we're in console mode, try to fix all the key mappings...
if !has("gui_running")

    " Try to get the correct main terminal type
    if &term =~ "xterm"
        let myterm = "xterm"
    else
        let myterm =  &term
    endif
    let myterm = substitute(myterm, "cons[0-9][0-9].*$",  "linux", "")
    let myterm = substitute(myterm, "vt1[0-9][0-9].*$",   "vt100", "")
    let myterm = substitute(myterm, "vt2[0-9][0-9].*$",   "vt220", "")
    let myterm = substitute(myterm, "\\([^-]*\\)[_-].*$", "\\1",   "")

    " Here we define the keys of the NumLock in keyboard transmit mode of
    " xterm which misses or hasn't activated Alt/NumLock Modifiers.  Often
    " not defined within termcap/terminfo and we should map the character
    " printed on the keys.
    if myterm == "xterm" || myterm == "ansi" || myterm == "gnome"
        " keys in insert/command mode.
        map! <ESC>Oo  :
        map! <ESC>Oj  *
        map! <ESC>Om  -
        map! <ESC>Ok  +
        map! <ESC>Ol  ,
        map! <ESC>Ow  7
        map! <ESC>Ox  8
        map! <ESC>Oy  9
        map! <ESC>Ot  4
        map! <ESC>Ou  5
        map! <ESC>Ov  6
        map! <ESC>Oq  1
        map! <ESC>Or  2
        map! <ESC>Os  3
        map! <ESC>Op  0
        map! <ESC>On  .
        " keys in normal mode
        map <ESC>Oo  :
        map <ESC>Oj  *
        map <ESC>Om  -
        map <ESC>Ok  +
        map <ESC>Ol  ,
        map <ESC>Ow  7
        map <ESC>Ox  8
        map <ESC>Oy  9
        map <ESC>Ot  4
        map <ESC>Ou  5
        map <ESC>Ov  6
        map <ESC>Oq  1
        map <ESC>Or  2
        map <ESC>Os  3
        map <ESC>Op  0
        map <ESC>On  .
    endif

    " xterm but without activated keyboard transmit mode
    " and therefore not defined in termcap/terminfo.
    if myterm == "xterm" || myterm == "ansi" || myterm == "gnome"
        " keys in insert/command mode.
        map! <Esc>[H  <Home>
        map! <Esc>[F  <End>
        " Home/End: older xterms do not fix termcap/terminfo.
        map! <Esc>[1~ <Home>
        map! <Esc>[4~ <End>
        " Up/Down/Right/Left
        map! <Esc>[A  <Up>
        map! <Esc>[B  <Down>
        map! <Esc>[C  <Right>
        map! <Esc>[D  <Left>
        " KP_5 (NumLock off)
        map! <Esc>[E  <Insert>
        " Insert key: older xterms do not fix termcap/terminfo.
        map! <ESC>[2~ <Insert>
        " PageUp/PageDown
        map <ESC>[5~ <PageUp>
        map <ESC>[6~ <PageDown>
        map <ESC>[5;2~ <PageUp>
        map <ESC>[6;2~ <PageDown>
        map <ESC>[5;5~ <PageUp>
        map <ESC>[6;5~ <PageDown>
        " keys in normal mode
        map <ESC>[H  0
        map <ESC>[F  $
        " Home/End: older xterms do not fix termcap/terminfo.
        map <ESC>[1~ 0
        map <ESC>[4~ $
        " Insert key: older xterms do not fix termcap/terminfo.
        map <ESC>[2~ i
        " Up/Down/Right/Left
        map <ESC>[A  k
        map <ESC>[B  j
        map <ESC>[C  l
        map <ESC>[D  h
        " KP_5 (NumLock off)
        map <ESC>[E  i
    endif

    " xterm/kvt but with activated keyboard transmit mode.
    " Sometimes not or wrong defined within termcap/terminfo.
    if myterm == "xterm" || myterm == "ansi" || myterm == "gnome"
        " keys in insert/command mode.
        map! <Esc>OH <Home>
        map! <Esc>OF <End>
        map! <ESC>O2H <Home>
        map! <ESC>O2F <End>
        map! <ESC>O5H <Home>
        map! <ESC>O5F <End>
        map! <Esc>[2;2~ <Insert>
        map! <Esc>[3;2~ <Delete>
        map! <Esc>[2;5~ <Insert>
        map! <Esc>[3;5~ <Delete>
        map! <Esc>O2A <PageUp>
        map! <Esc>O2B <PageDown>
        map! <Esc>O2C <S-Right>
        map! <Esc>O2D <S-Left>
        map! <Esc>O5A <PageUp>
        map! <Esc>O5B <PageDown>
        map! <Esc>O5C <S-Right>
        map! <Esc>O5D <S-Left>
        " KP_5 (NumLock off)
        map! <Esc>OE <Insert>
        " keys in normal mode
        map <ESC>OH  0
        map <ESC>OF  $
        map <ESC>O2H  0
        map <ESC>O2F  $
        map <ESC>O5H  0
        map <ESC>O5F  $
        map <Esc>[2;2~ i
        map <Esc>[3;2~ x
        map <Esc>[2;5~ i
        map <Esc>[3;5~ x
        map <ESC>O2A  ^B
        map <ESC>O2B  ^F
        map <ESC>O2D  b
        map <ESC>O2C  w
        map <ESC>O5A  ^B
        map <ESC>O5B  ^F
        map <ESC>O5D  b
        map <ESC>O5C  w
        " KP_5 (NumLock off)
        map <ESC>OE  i
    endif

    if myterm == "linux"
        " keys in insert/command mode.
        map! <Esc>[G  <Insert>
        " KP_5 (NumLock off)
        " keys in normal mode
        " KP_5 (NumLock off)
        map <ESC>[G  i
    endif

    " This escape sequence is the well known ANSI sequence for
    " Remove Character Under The Cursor (RCUTC[tm])
    map! <Esc>[3~ <Delete>
    map  <ESC>[3~    x

endif


" Disable syntax highlighting in diff mode
if &diff
    syntax off
else
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") | exe "normal `\"" | endif
endif

" Set the lightline status bar theme etc.
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }
