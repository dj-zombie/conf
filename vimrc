" My Vim configuration, inspired in part by:
"
" 1. https://statico.github.io/vim3.html and https://github.com/statico/dotfiles/blob/master/.vim/vimrc
" 2. https://tomjwatson.com/blog/vim-tips/
"
"
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plugins
Plug '/usr/local/opt/fzf'
Plug 'airblade/vim-gitgutter'
Plug 'docunext/closetag.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'her/central.vim'
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'rakr/vim-one'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'

" Initialize plugin system
call plug#end()

" From https://github.com/rakr/vim-one
" Credit joshdick
" Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
" If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
" (see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  " For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  " For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  " Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  "  < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Because everything is UTF-8.
set encoding=utf-8

" Disable line wrapping.
set nowrap

" Essential for filetype plugins.
filetype plugin indent on

" Because syntax matters.
syntax on

" Color scheme setup.
colorscheme one
set background=dark

" Magic line numbers.
set number relativenumber

" Indentation.
set autoindent smartindent breakindent
set breakindentopt=shift:2

" White space, tabs, and text.
set list                    " Show whitespace as special chars - see listchars
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:· " Unicode characters for various things
set autoread                " Don't bother me when a file changes
set expandtab               " No tabs
set shiftround              " Shift to certain columns, not just n spaces
set shiftwidth=2            " Number of spaces to shift for autoindent or >,<
set ignorecase              " Ignore case by default.
set smartcase               " Lets you search for ALL CAPS
set softtabstop=2           " Spaces 'feel' like tabs
set tabstop=2               " The One True Tab
set textwidth=100           " 100 is the new 80
set wildmenu                " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,*.pyc,.git,node_modules  " Ignore certain files in tab-completion

" Remove all the scrollbars.
set guioptions-=r
set guioptions-=l
set guioptions-=R
set guioptions-=L

" Jump to last cursor position unless it's invalid or in an event handler
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc#L95
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" Disable balloon tooltips. Always.
autocmd BufNewFile,BufRead * set noballooneval

" YAML is indentation-sensitive.
autocmd Syntax yaml setlocal foldmethod=indent

" Set the fold method to syntax for certain file types.
autocmd Syntax xml,html,xhtml,ruby,javascript,json,eruby setlocal foldmethod=syntax

" Unfold everything for the above syntaxes.
autocmd Syntax xml,html,xhtml,ruby,javascript,json,eruby,yaml normal zR

" Makefiles should always have actual tab characters.
autocmd FileType make setlocal noexpandtab

" Wrap markdown text.
autocmd Syntax markdown setlocal wrap

" Turn off linewise keys.
nmap j gj
nmap k gk

" Delete all buffers.
nmap <Leader>bd :bufdo :bd<CR>

" Use the space key to toggle folds.
nnoremap <space> za
vnoremap <space> zf

" Key combos
nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>a :Ack!<Space>

" Because lazy.
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>

" Like Command+, but for Vim.
nmap <Leader>, :e ~/.vimrc<CR>

" Splits
nmap <Leader>vs :vs<CR>
nmap <Leader>sp :sp<CR>

" Fugitive
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gc :Gcommit<CR>

" For quick session saving and restoring.
nmap <Leader>ss :mksession!<CR>
nmap <Leader>sl :source Session.vim<CR>

" Insert newlines.
" Via https://stackoverflow.com/questions/6765211/vim-command-to-insert-blank-line-in-normal-mode#6765349
nnoremap <silent> [<space> :pu! _<cr>:']+1<cr>
nnoremap <silent> ]<space> :pu _<cr>:'[-1<cr>

" Keep ack.vim from opening the first result.
cnoreabbrev Ack Ack!

" Taken from https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Use Silver Searcher for ack.vim
let g:ackprg = 'ag --vimgrep'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Command to generate tags file
let g:fzf_tags_command = 'ctags'

" ALE
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters = { 'eruby': ['erubi'] }
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '▲'

highlight link ALEWarningSign String
highlight link ALEErrorSign Title

nmap ]l :ALENextWrap<CR>
nmap [l :ALEPreviousWrap<CR>

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Resize panes when window/terminal gets resize
autocmd VimResized * :wincmd =

