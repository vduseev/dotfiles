
"============================================================================
"=                            BASIC SETTING                                 =
"============================================================================

" UTF-8 support
set encoding=utf-8

" YouCompleteMe does not work with fish
set shell=/bin/bash

" show line numbers
set number
set relativenumber

" show the matching part of the pair for [] {} and ()
set showmatch

" Enable TrueColor 24-bit colors in Vim
"let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
"let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set t_ZH=
set t_ZR=
"set termguicolors

" Use same clipboard in Vim and in the system
" Note: MacOS X specific setting
set clipboard=unnamed

" Set Leader key
let mapleader = ","

" Where to put new tab when doing screen split
set splitright

" enable syntax highlighting
syntax enable

" Makes text search case insensitive when query contains any capital letters
set smartcase

"============================================================================
"=                            KEYS REMAPPING                                =
"============================================================================

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Split navigations
nnoremap <S-J> <C-W><C-J>
nnoremap <S-K> <C-W><C-K>
nnoremap <S-L> <C-W><C-L>
nnoremap <S-H> <C-W><C-H>

" Replacing word under cursor when pressing <Leader>s
" https://vim.fandom.com/wiki/Search_and_replace_the_word_under_the_cursor
nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

"============================================================================
"=                          PLUGIN INITIALIZATION                           =
"============================================================================


"============================================================================
"=                     FILE EXTENSTION CUSTOMIZATIONS                       =
"============================================================================

" The proper PEP8 indentation for Python files
au BufNewFile,BufRead *.py
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  " \ set textwidth=4 |
  \ set expandtab |
  " \ set autoindent |
  \ set fileformat=unix

" YAML indentation
au BufNewFile,BufRead *.yml,*.yaml
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set expandtab |
  \ set fileformat=unix

" HTML indentation
au BufNewFile,BufRead *.html,*.css,*.json
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set expandtab |
  \ set fileformat=unix

" Bash indentation
au BufNewFile,BufRead *.sh,.vimrc,.bash_profile,.bashrc
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set expandtab |
  \ set fileformat=unix

" JavaScript indentation
au BufNewFile,BufRead *.js
  \ set softtabstop=4 |
  \ set shiftwidth=4 |
  \ set expandtab |
  \ set fileformat=unix

" Treat Jekyll's include and layout files as liquid syntax
au BufNewFile,BufRead */_includes*,*/_layout*
  \ set filetype=liquid

" Terraform indentation
au BufNewFile,BufRead *.tf,*.tfvars,*.tfstate
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set expandtab |
  \ set fileformat=unix

" Enable spell checker for Markdown files
" 1) Add words to the vocabulary by hovering over them
" and typing zg command
" 2) Jump to the spell errors using ]s
au BufNewFile,BufRead *.md,*.markdown
  \ setlocal spell

au BufNewFile,BufRead *.puml,*.plantuml,*.pu
  \ set filetype=plantuml |
  \ set softtabstop=2 |
  \ set shiftwidth=2 |
  \ set expandtab |
  \ set fileformat=unix

" Flugging Unnecessary Whitespace
" au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"============================================================================
"                   AUTO-CREATING DIRECTORIES ON SAVE
"============================================================================

function! s:MakeNonExistingDir2(file, buf)
  " Regex here prevents from creation of directories like ftp://*
  " Also checks for non-empty bufftype (whatever the hell it means)
  if empty(getbufvar(a:buf, '&buftype')) && a:file !~# '\v^\w+\:\/'
    let dir = fnamemodify(a:file, ':h')
    " Do not create directory if it already exists
    if !isdirectory(dir)
      " Call mkdir -p dir
      call mkdir(dir, 'p')
    endif
  endif
endfunction

aug BWCCreateDir
  " Remove all existing autocommands in this group
  au!
  " Call function prior to write operation
  au BufWritePre *
    \ :call s:MakeNonExistingDir2(expand('<afile>'), +expand('<abuf>'))
aug END
