" Required by Vundle to function
set nocompatible              " required
filetype off                  " required


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
set t_ZH=[3m
set t_ZR=[23m
set termguicolors

" Use same clipboard in Vim and in the system
" Note: MacOS X specific setting
set clipboard=unnamed

" Set Leader key
let mapleader = ","

" Where to put new tab when doing screen split
set splitright

" Fixing 'Press ENTER or type command' promt issue
set shortmess=a

" enable syntax highlighting
syntax enable

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

"split navigations
nnoremap <S-J> <C-W><C-J>
nnoremap <S-K> <C-W><C-K>
nnoremap <S-L> <C-W><C-L>
nnoremap <S-H> <C-W><C-H>

"============================================================================
"=                          PLUGIN INITIALIZATION                           =
"============================================================================

" set the runtime path to include Vundle and initialize
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

"=== Status line

python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

"=== Directory tree

" Directory and file tree <leader>d
Plugin 'scrooloose/nerdtree'

"=== Miscellaneous 

" Commenter helper count<leader>cc [comment]
" and count<leader>cu [uncomment]
Plugin 'scrooloose/nerdcommenter'

" Quick search plugin
Plugin 'kien/ctrlp.vim'
 
" Starting screen with recent files nad cowsay
Plugin 'mhinz/vim-startify'

" Indent guides (helping lines)
" <Leader>ig
Plugin 'nathanaelkane/vim-indent-guides'

"=== Syntax support

" Heavy and smart completion engine
Plugin 'Valloric/YouCompleteMe'

" Vim syntax veryfication engine, relies on backends
Plugin 'vim-syntastic/syntastic'

" PLantUML syntax support
Plugin 'aklt/plantuml-syntax'

" Support for Liquid and Jekyll syntax
Plugin 'tpope/vim-liquid'

" Small plugin to highlight YAML frontmatter in Markdown files
Plugin 'PProvost/vim-markdown-jekyll'

"=== Python

" Python indentation
Plugin 'vim-scripts/indentpython.vim'

" Python syntax veryfication backend
Plugin 'nvie/vim-flake8'

" Extensive python syntax support for better highlighting
Plugin 'kh3phr3n/python-syntax'

"=== Color schemas

" Monokai color scheme for VIM
Plugin 'crusoexia/vim-monokai'

"============================================================================
"=                          PLUGIN CUSTOMIZATION                            =
"============================================================================

"*********************** THEMES ***************************
" Theme colors customization
set background=light
" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_contrast_light = 'hard'
" let g:gruvbox_italic = 1
let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

"********************** POWERLINE *************************
set laststatus=2

"*********************** AIRLINE **************************
" Airline customization
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1

"*********************** YCM ******************************
" Close autocomplete window when you're done with it
let g:ycm_autoclose_preview_window_after_completion=1
" Map GoTo definition to Space+G
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

"*********************** NERDTree *************************
map <leader>d :NERDTreeToggle<CR>
" Show hidden files
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.o$', '\~$', '\.swp$', '\.git$']

"*********************** PlantUML *************************
" PlanUML Syntax plugin customization
let g:plantuml_executable_script='plantuml'

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
au BufNewFile,BufRead *.sh
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

" Enable spell checker for Markdown files
" 1) Add words to the vocabulary by hovering over them
" and typing zg command
" 2) Jump to the spell errors using ]s
au BufNewFile,BufRead *.md,*.markdown
  \ setlocal spell

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

"============================================================================
"=                            PYTHON CUSTOMIZATION                          =
"============================================================================

" Check if current directory has a Pipenv based virtual environment.
" If check is successful -> returns full path to python binary
" If not -> returns -1
function! s:GetPipenvBasedPythonPath()
   " At first, get the output of 'pipenv --venv' command.
  let pipenv_venv_path = system('pipenv --venv') 
  " The above system() call produces a non zero exit code whenever
  " a proper virtual environment has not been found.
  if shell_error == 0
    let venv_path = substitute(pipenv_venv_path, "\n", "", "")
    " Remember, that 'pipenv --venv' only points to the root directory
    " of the virtual environment, so we have to append a full path to
    " the python executable.
    return venv_path . "/bin/python"
  endif 
  return -1
endfunction

" Check if Pyenv provides a path to python executable
" If it does -> return Pyenv based result
" If not -> return -1
function! s:GetPyenvBasedPythonPath()
  let pyenv_python_path = system('pyenv which python')
  if shell_error == 0
    let python_path = substitute(pyenv_python_path, "\n", "", "")
    return python_path
  endif
  return -1
endfunction

" Set full path to correct python executable for YCM plugin
" First, check Pipenv based path
" Second, check Pyenv based path
" Third, just use system's 'python'
function! s:SetPythonPathForYCM()
  if execute("let p = s:GetPipenvBasedPythonPath() | echon p") != "-1"
    let python_path = p
  elseif execute("let p = s:GetPyenvBasedPythonPath() | echon p") != "-1"
    let python_path = p
  else
    let python_path = 'python'
  endif
  let g:ycm_python_binary_path = python_path
endfunction

au BufNewFile,BufRead *.py
  \ call s:SetPythonPathForYCM() |
  " enable all Python syntax highlighting features
  \ let python_highlight_all = 1

" Point flake8 wrapper plugin to flake8 binary
let g:flake8_cmd="/Users/vduseev/.vim/flake8/bin/flake8"
let g:flake8_quickfix_height=8

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme monokai 

