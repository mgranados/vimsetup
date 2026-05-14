" Martin's portable Vim configuration.
" This matches the local ~/.vimrc plugin set, with a few guards so it also
" works cleanly on fresh Linux dev VMs.

set nocompatible
filetype off

" Plugins are managed by Vundle. Run ./install.sh after cloning this repo.
let s:vundle_dir = expand('~/.vim/bundle/Vundle.vim')
if isdirectory(s:vundle_dir)
  execute 'set runtimepath+=' . fnameescape(s:vundle_dir)
  call vundle#begin()

  Plugin 'VundleVim/Vundle.vim'
  Plugin 'vim-scripts/indentpython.vim'
  Plugin 'kien/ctrlp.vim'
  Plugin 'jnurmine/Zenburn'
  Plugin 'altercation/vim-colors-solarized'
  Plugin 'vim-syntastic/syntastic'
  Plugin 'nvie/vim-flake8'
  Plugin 'preservim/nerdtree'
  Plugin 'junegunn/fzf'
  Plugin 'junegunn/fzf.vim'
  Plugin 'vim-python/python-syntax'
  Plugin 'psf/black'
  Plugin 'vim-airline/vim-airline'
  Plugin 'prabirshrestha/vim-lsp'
  Plugin 'mattn/vim-lsp-settings'
  Plugin 'APZelos/blamer.nvim'

  " Review-oriented Git/navigation helpers.
  Plugin 'tpope/vim-fugitive'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'tpope/vim-commentary'

  call vundle#end()
else
  " Keep Vim usable before bootstrapping; ./install.sh installs Vundle.
  let g:vimsetup_vundle_missing = 1
endif

filetype plugin indent on
syntax on

" Core editing behaviour.
set encoding=utf-8
set number
set ruler
set title
set hidden
set ttyfast
set wildmenu
set scrolloff=3
set backspace=indent,eol,start
set noswapfile
set ignorecase
set smartcase
set incsearch
set hlsearch
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set splitright
set splitbelow
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+
if exists('&signcolumn')
  set signcolumn=yes
endif

" Keep local folding muscle memory.
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Use the system clipboard when this Vim build supports it.
if has('clipboard')
  if has('macunix')
    set clipboard=unnamed
  else
    set clipboard=unnamedplus
  endif
endif

" Because the default login shell may be fish on the workstation.
if executable('/bin/bash')
  set shell=/bin/bash
endif

" Plugin settings.
let g:python_highlight_all = 1
let NERDTreeShowHidden = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:gitgutter_map_keys = 0

let g:ctrlp_map = '<leader>m'
if executable('rg')
  let g:ctrlp_user_command = 'rg --files --hidden --glob "!.git/*" %s'
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|\.git'

" Mappings from the local config.
nnoremap <silent> <leader>n :NERDTreeFocus<CR>
nnoremap <silent> <C-n> :NERDTree<CR>
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
nnoremap <silent> <C-f> :NERDTreeFind<CR>
nnoremap <silent> <C-s> :Ag<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
nnoremap <silent> <F9> :Black<CR>
nnoremap <silent> <leader>gb :BlamerToggle<CR>
nnoremap <silent> <leader>war :LspDocumentDiagnostics<CR>

" Review/code-reading mappings.
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
if executable('rg')
  nnoremap <silent> <leader>rg :Rg<CR>
else
  nnoremap <silent> <leader>rg :Ag<CR>
endif
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :Gdiffsplit<CR>
nnoremap <silent> <leader>gB :Git blame<CR>
nnoremap <silent> ]h <Plug>(GitGutterNextHunk)
nnoremap <silent> [h <Plug>(GitGutterPrevHunk)
nnoremap <silent> <leader>hp <Plug>(GitGutterPreviewHunk)
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> <leader>co :copen<CR>
nnoremap <silent> <leader>cc :cclose<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> <leader>lo :lopen<CR>
nnoremap <silent> <leader>lc :lclose<CR>
nnoremap <silent> <leader>tw :set list!<CR>

function! s:CopyPathLine() abort
  let l:ref = expand('%:.') . ':' . line('.')
  let @" = l:ref
  if has('clipboard')
    let @+ = l:ref
  endif
  echo l:ref
endfunction
nnoremap <silent> <leader>yl :call <SID>CopyPathLine()<CR>

" The old local mappings used YouCompleteMe commands, but the active plugin
" stack here is vim-lsp, so keep the keys and point them at vim-lsp commands.
nnoremap <silent> <leader>jd :LspDefinition<CR>
nnoremap <silent> <leader>ji :LspReferences<CR>

augroup martin_python
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=88 expandtab autoindent fileformat=unix
augroup END

augroup martin_markdown
  autocmd!
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

augroup martin_web
  autocmd!
  autocmd BufNewFile,BufRead *.ejs setlocal filetype=html
augroup END
