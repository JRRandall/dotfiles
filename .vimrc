"----------------------------------------------------------------------------
"  File:        .vimrc
"  Author:      Justin Randall (jrrandall AT gmail DOT com)
"  Created:     Fri Mar 16 09:00 AM 2001 EST
"  Last Change: Mon Nov 19 11:00 PM 2012 EST
"  Description: Initial setup file for VIM (Vi IMproved)
"               this file goes in a users $HOME directory and uses
"               plugins from $HOME/.vim/plugins to help make editing
"               with VIM easy and powerful.
"----------------------------------------------------------------------------

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
set visualbell     " Try to flash screen instead of beeping
set t_vb=          " Turn off flashing too :-)
set cmdheight=2    " Less Hit Return messages
set laststatus=2   " Always show status line
set modeline       " Scan for modeline commands
set report=0       " Always report line changes for : commands
"set ruler          " Show the line and column number of the cursor position
set scrolloff=2    " Keep two lines above/below cursor on screen
set showmode       " Show the mode I'm currently in
set showcmd        " Show (partial) command in status line
set splitbelow     " Put the new window below the current one
set winheight=4    " At least 4 lines for current window
set nobackup writebackup " Temporary backup before writing
set textwidth=78         " Text width (use gq to wrap)

" Text settings
set autowrite      " Automatically save the file
set backspace=indent,eol,start  " allow backspacing over all in insert mode
set expandtab      " Do not insert tab, insert a number of spaces
set smarttab       " Smart tabbing
set shiftwidth=4   " Number of spaces to use for each step of (auto)indent
set softtabstop=4  " Number of spaces that a <Tab> counts for in editing
set tabstop=4      " Set tabs to 4 characters, not 8...
set autoindent     " Set indenting to automatic
set smartindent    " Smart indenting
set cindent        " C style indenting
set cino=(0        " Line up continuation with parentheses
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
    syntax on
    "colorscheme inkpot
    colorscheme solarized
    set background=light
    " set the GUI font based off of operating system
    if has("win32")
        set guifont=Consolas:h12
    elseif has("mac")
        set guifont=Monaco:h12
    else
        set guifont=Bitstream\ Vera\ Sans\ Mono\ 12
    endif
else
    syntax off
    set term=ansi
    set mouse=a
    set ttymouse=xterm2
    syntax on
endif

" Configure status line for the solarized color scheme
function! AddStatuslineFlag(varName, goodValues)
    if has("gui_running")
        set statusline+=%#SpecialKey#
    endif
    set statusline+=[
    set statusline+=%#error#
    exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',1)}"
    if has("gui_running")
        set statusline+=%#SpecialKey#
    else
        set statusline+=%*
    endif
    exec "set statusline+=%{RenderStlFlag(".a:varName.",'".a:goodValues."',0)}"
    set statusline+=]
endfunction

" Utility for AddStatuslineFlag()
function! RenderStlFlag(value, goodValues, error)
    let goodValues = split(a:goodValues, ',')
    let good = index(goodValues, a:value) != -1
    if (a:error && !good) || (!a:error && good)
        return a:value
    else
        return ''
    endif
endfunction

" Get the file size in bytes or kilobytes
function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes . "B"
    else
        return (bytes / 1024) . "kB"
    endif
endfunction

" Get the vim syntax item name under the cursor
function! SyntaxItem()
    return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" A fancy status line with lots of information
if has('statusline')
    if has("gui_running")
        set statusline+=%#SpecialKey#
    endif
    set statusline+=%-1.2n\                       " buffer number
    if has("gui_running")
        set statusline+=%#DiffText#               " highlight name different
    else
        set statusline+=%#SignColumn#             " highlight name different
    endif
    set statusline+=%f\                           " file name
    if has("gui_running")
        set statusline+=%#SpecialKey#             " back to normal highlight
    else
        set statusline+=%*                        " back to normal highlight
    endif
    set statusline+=%h%m%r%w                      " flags
    call AddStatuslineFlag('&ff', 'unix')         " file format
    call AddStatuslineFlag('&fenc', 'utf-8')     " file encoding
    set statusline+=[%{strlen(&ft)?&ft:'none'}]\  " file type
    set statusline+=%{SyntaxItem()}\              " syntax group
    set statusline+=%=                            " ident to the right
    set statusline+=%{FileSize()}\                " file size
    set statusline+=0x%-8B\                       " character code
    set statusline+=%-7.(%l,%c%V%)\ %<%P          " position/offset
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
   let OmniCpp_GlobalScopeSearch = 1
   let OmniCpp_NamespaceSearch = 1
   let OmniCpp_DisplayMode = 0
   let OmniCpp_ShowScopeInAbbr = 0
   let OmniCpp_ShowPrototypeInAbbr = 0
   let OmniCpp_ShowAccess = 0
   let OmniCpp_MayCompleteDot = 1
   let OmniCpp_MayCompleteArrow = 1
   let OmniCpp_MayCompleteScope = 0

endif " Done with version 7+ commands

" AUTOCOMMANDS
" ------------
" When editing a file, always jump to the last cursor position
autocmd BufReadPost * if line("'\"") | exe "normal `\"" | endif

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8

" Per http://vim.sourceforge.net/tips/tip.php?tip_id=330
" this will stop the annoying html indentation.
autocmd BufEnter *.html setlocal indentexpr=
autocmd BufEnter *.htm setlocal indentexpr=
autocmd BufEnter *.xml setlocal indentexpr=
autocmd BufEnter *.xsd setlocal indentexpr=
autocmd BufEnter *.gxp setlocal indentexpr=

" Try switching the CWD to the current buffer
" It may make working with multiple windows easier...?
autocmd BufEnter * lcd %:p:h

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
nmap     <silent>  <F3>    I<C-x>cout << "*** Got Here " << __FILE__ << "(" << __LINE__ << ") ***\n";<CR>
nmap     <silent>  <F4>    :exe ":ptag ".expand("<cword>")<CR>
nmap     <silent>  <F5>    mzgg=G'z<CR>
nmap     <silent>  <F6>    :copen<CR>
nmap     <silent>  <F7>    :Dox<CR>
nmap     <silent>  <F8>    :%s/\r//gic<CR>
noremap  <silent>  <F10>   <Esc><Esc>:Tlist<CR>
" Insert mode mapping
imap     <silent>  <F2>    <Esc>:set spelllang=en_us<CR>:set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>I
imap     <silent>  <F3>    <C-x>cout << "*** Got Here " << __FILE__ << "(" << __LINE__ << ") ***\n";<CR>
imap     <silent>  <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
imap     <silent>  <F5>    <Esc>mzgg=G'z<CR>I
imap     <silent>  <F6>    <Esc>:copen<CR>
imap     <silent>  <F7>    <Esc>:Dox<CR>
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
imap ;sh #!/bin/bash<CR>#######################################################################<CR>#<CR>#<Space><Space>File:<Space><Space><Space><Space><Space><Space><Space><Space><CR>#<Space><Space>Author:<Space><Space><Space><Space><Space><Space>Justin<Space>Randall<Space>(jrrandall AT gmail DOT com)<CR>#<Space><Space>Version:<Space><Space><Space><Space><Space>0.1<CR>#<Space><Space>Created:<Space><Space><Space><Space><Space><C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><CR>#<Space><Space>Last Change:<Space><C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><CR>#<Space><Space>Description:<Space><CR>#<Space><Space>Usage:<Space><Space><Space><Space><Space><Space><Space><CR>#<Space><Space>History:<Space><Space><Space><Space><Space>none<CR>#<CR>#######################################################################<CR>PN='basename "$0"'<CR>VER='0.1'<CR><CR>

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

" XMLEdit
let xml_use_xhtml = 1

" TagList
let Tlist_Ctags_Cmd = "ctags"

" LastChange
let g:timeStampLeader    =  "Last Change: "

" C/C++ IDE
let g:C_AuthorName       =  "Justin Randall"
let g:C_AuthorRef        =  "JR"
let g:C_Email            =  "jrrandall AT gmail DOT com"
let g:C_Company          =  ""
let g:C_Project          =  ""
let g:C_CopyrightHolder  =  "(c)"
let g:C_ObjExtension     =  ".o"
let g:C_ExeExtension     =  ""
let g:C_CCompiler        =  "gcc"
let g:C_CplusCompiler    =  "g++"
let g:C_Comments         =  "yes"     " yes = C no = C++
let g:C_LoadMenus        =  "yes"    " load C/C++ menus by default
let g:C_Libs             =  "-lm" " link libraries
let s:C_CFlags           =  "-Wall -g -O0 -c -DDEBUG" " compiler flags
let s:C_LFlags           =  "-Wall -g -O0"    " linker flags

" Doxygen Toolkit
let g:DoxygenToolkit_blockHeader       = "///////////////////////////////////////////////////////////////////////////"
let g:DoxygenToolkit_blockFooter       = "///////////////////////////////////////////////////////////////////////////"
let g:DoxygenToolkit_authorName        = "Justin Randall"
let g:DoxygenToolkit_licenseTag        = "My own license\<enter>" 
let g:DoxygenToolkit_undocTag          = "DOXIGEN_SKIP_BLOCK"
let g:DoxygenToolkit_commentType       = "C++"  " use C++ style comments
let g:DoxygenToolkit_briefTag_funcName = "yes"

