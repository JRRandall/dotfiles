"----------------------------------------------------------------------------
"  File:        .vimrc
"  Author:      Justin Randall
"  Created:     Fri Mar 16 09:00 AM 2001 EST
"  Last Change: Fri Jul 31 09:00 PM 2026 EDT
"----------------------------------------------------------------------------
" --- Plugins ---
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'vim-scripts/OmniCppComplete'
call plug#end()
" --- Basics / UI ---
set nocompatible
syntax on
filetype plugin indent on
scriptencoding utf-8
set formatoptions+=n
set cpoptions-=u
set list
if &encoding ==# 'utf-8'
  set listchars=tab:·\ ,trail:.
else
  set listchars=tab:>\ ,trail:.
endif
set matchpairs=(:),{:},[:],<:>
set shortmess=aoOtT
set showmatch
set sidescroll=1
if &suffixes ==# ''
  set suffixes=.bak,~,.o,.h,.info,.swp,.obj
endif
set wildmenu
set wildmode=longest,list,list:full
set noerrorbells
set t_vb=
set cmdheight=1
set nomodeline
set report=0
set scrolloff=2
set showcmd
set splitbelow
set winheight=4
set nobackup writebackup
set textwidth=80
" --- Indent policy ---
set noautoindent
set nosmartindent
" set cindent
set cino=j1,(0,ws,Ws,N-s
" --- Editing defaults ---
set autowrite
set backspace=indent,eol,start
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set history=100
if has('win32')
  set shellslash
endif
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
else
  set grepprg=grep\ -nH\ $*
endif
set tags=tags;
set tags+=~/.vim/tags/cpp_tags
" --- Search ---
set incsearch
set hlsearch
set ignorecase smartcase
" --- Colors & mouse (works in GUI & terminal) ---
if has('termguicolors')
  set termguicolors
endif
if has("gui_running")
  set guifont=Berkeley\ Mono\ Regular\ 10
endif
set mouse=a
try
  colorscheme Tomorrow-Night-Blue
catch /^Vim\%((\a\+)\)\=:E185/
  set background=dark | colorscheme default
endtry
let g:lightline = { 'colorscheme': 'Tomorrow_Night_Blue' }
" --- Numbers for motion practice ---
set number
set relativenumber
augroup NumberToggle
  autocmd!
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END
" Make line numbers/signcolumn match comment color
highlight! link LineNr Comment
highlight! link CursorLineNr Comment
highlight! link SignColumn LineNr
" --- Completion (OmniCppComplete) ---
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD", "_GLIBCXX_STD_A", "_GLIBCXX_STD_B", "_GLIBCXX_STD_C"]
set completeopt=menuone,menu,longest,preview
" --- Clipboard ---
set clipboard=unnamedplus
" --- Filetype-specific ---
autocmd FileType make set noexpandtab shiftwidth=8
" --- Date helper (use %-d on GNU; %e on BSD/macOS) ---
function! GetDatestamp(...) abort
  return strftime('%-d %B %Y')
endfunction
nmap ;de 3cw<C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR><ESC>
imap ;de <C-O>"=GetDatestamp()<CR><ESC><C-R>=<CR>
" --- F-key mappings ---
nnoremap <silent> <F2> :set spelllang=en_us<CR>:set spell!<CR>\|echo 'Spell Check: '.strpart('OffOn', 3 * &spell, 3)<CR>
nnoremap <silent> <F3> I<C-x>printf("*** Got Here %s(%d) ***\n", __FILE__, __LINE__);<CR>
nnoremap <silent> <F4> :exe ':ptag '.expand('<cword>')<CR>
nnoremap <silent> <F5> mzgg=G'z<CR>
nnoremap <silent> <F6> :copen<CR>
nnoremap <silent> <F7> :Dox<CR><Esc>mzgg=G'z<CR><Up><Esc>$A
nnoremap <silent> <F8> :%s/\r//gic<CR>
nnoremap <silent> <F10> <Esc><Esc>:Tlist<CR>
inoremap <silent> <F2> <Esc>:set spelllang=en_us<CR>:set spell!<CR>\|echo 'Spell Check: '.strpart('OffOn', 3 * &spell, 3)<CR>i
inoremap <silent> <F3> <C-x>printf("*** Got Here %s(%d) ***\n", __FILE__, __LINE__);<CR>
inoremap <silent> <F4> <Esc>:exe ':ptag '.expand('<cword>')<CR>
inoremap <silent> <F5> <Esc>mzgg=G'z<CR>i
inoremap <silent> <F6> <Esc>:copen<CR>
inoremap <silent> <F7> <Esc>:Dox<CR><Esc>mzgg=G'z<CR><Up>$A
inoremap <silent> <F8> <Esc>:%s/\r//gic<CR>
inoremap <silent> <F10> <Esc><Esc>:Tlist<CR>
" PageUp/PageDown behavior
nnoremap <silent> <PageUp>   <C-U><C-U>
vnoremap <silent> <PageUp>   <C-U><C-U>
inoremap <silent> <PageUp>   <C-\><C-O><C-U><C-\><C-O><C-U>
nnoremap <silent> <PageDown> <C-D><C-D>
vnoremap <silent> <PageDown> <C-D><C-D>
inoremap <silent> <PageDown> <C-\><C-O><C-D><C-\><C-O><C-D>
" Quick regex with Ctrl+Space
nnoremap <C-Space> :s///<Left><Left>
" Buffer next/prev on Tab / S-Tab
nnoremap <silent> <Tab>   :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>
" Snippet for new shell script in Insert mode (;sh)
imap ;sh #!/bin/bash<CR><CR>
" --- Diff mode syntax off + last cursor pos restore ---
if &diff
  syntax off
else
  augroup LastPos
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"' | endif
  augroup END
endif
" Do not show built-in mode (Lightline handles it)
set noshowmode
" ToggleComment
noremap <silent> ,# :call CommentLineToEnd('# ')<CR>+
noremap <silent> ,/ :call CommentLineToEnd('// ')<CR>+
noremap <silent> ," :call CommentLineToEnd('" ')<CR>+
noremap <silent> ,; :call CommentLineToEnd('; ')<CR>+
noremap <silent> ,- :call CommentLineToEnd('-- ')<CR>+
noremap <silent> ,* :call CommentLinePincer('/* ', ' */')<CR>+
noremap <silent> ,< :call CommentLinePincer('<!-- ', ' -->')<CR>+
noremap <silent> ,! :call CommentLineToEnd('! ')<CR>+
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
"let g:C_LoadMenus        =  "yes"    " load C/C++ menus by default
let g:C_Libs             =  "-lm -lrt" " link libraries
let s:C_CFlags           =  "-Wall -g -O3 -c -DDEBUG -std=c++11 " " compiler flags
let s:C_LFlags           =  "-Wall -g -O3"    " linker flags
let g:C_FormatDate       =  "%e %B %Y"
let g:C_FormatTime       =  "%k:%M %z %Z"
let g:C_FormatYear       =  "%Y"
" Doxygen Toolkit
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
