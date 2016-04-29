" don't bother with vi compatibility
set nocompatible

" configure Vundle
filetype on " without this vim emits a zero exit status, later, because of :ft off
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" install Vundle bundles
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
  source ~/.vimrc.bundles.local
endif


" --------------------
" GENERAL SETTINGS
" --------------------

filetype plugin indent on

" enable syntax highlighting
syntax enable

set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
"set backupcopy=yes                                           " see :help crontab
"set clipboard=unnamed                                        " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set list                                                     " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set showcmd
set smartcase                                                " case-sensitive search if any caps
set wildignore=log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set number
set nocursorline                                             " don't highlight current line
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set copyindent
set nowrap
set shortmess+=A                                            " ignore existing swp files

" Enable basic mouse behavior such as resizing buffers.
set mouse=a
if exists('$TMUX')  " Support resizing in tmux
  set ttymouse=xterm2
endif

" Shortcuts
let mapleader = '\'
" easier navigation between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
inoremap jk <ESC>

" Plugin Keyboard Shortcuts
map <leader>l :Align
nmap <leader>a :Ack<space>
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>
nmap <leader>ff :NERDTreeFind<CR>
nmap <leader>t :CtrlPMRU<CR>
nmap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nmap <leader>] :TagbarToggle<CR>
nmap <leader><space> :call whitespace#strip_trailing()<CR>
nmap <leader>g :GitGutterToggle<CR>
nmap <leader>c <Plug>Kwbd
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" ---------------------------------
" VIM SPECIFIC PLUGIN SETTINGS
" ---------------------------------

let g:ctrlp_match_window = 'order:ttb,max:25'
let g:NERDSpaceDelims=1
let g:gitgutter_enabled = 0
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree


" NERDCommenter mappings
if has("gui_macvim") && has("gui_running")
  map <D-/> <plug>NERDCommenterToggle<CR>
  imap <D-/> <Esc><plug>NERDCommenterToggle<CR>i
else
  map <leader> <plug>NERDCommenterToggle<CR>
endif

" in case you forgot to sudo
cmap w!! %!sudo tee > /dev/null %

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column --smart-case'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0

endif

" fdoc is yaml
autocmd BufRead,BufNewFile *.fdoc set filetype=yaml

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
" extra rails.vim help
autocmd User Rails silent! Rnavcommand decorator      app/decorators            -glob=**/* -suffix=_decorator.rb
autocmd User Rails silent! Rnavcommand observer       app/observers             -glob=**/* -suffix=_observer.rb
autocmd User Rails silent! Rnavcommand feature        features                  -glob=**/* -suffix=.feature
autocmd User Rails silent! Rnavcommand job            app/jobs                  -glob=**/* -suffix=_job.rb
autocmd User Rails silent! Rnavcommand mediator       app/mediators             -glob=**/* -suffix=_mediator.rb
autocmd User Rails silent! Rnavcommand stepdefinition features/step_definitions -glob=**/* -suffix=_steps.rb
" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


" highlight search
"set hlsearch
"nmap <leader>hl :let @/ = ""<CR>

" gui settings
if (&t_Co == 256 || has('gui_running'))
  if ($TERM_PROGRAM == 'MacVim.app')
    colorscheme solarized
  else
  "  colorscheme solarized
    colorscheme deus
  endif
endif

set backupdir^=~/.vim/_backup//    " where to put backup files.
set directory^=~/.vim/_temp//      " where to put swap files.


" Disambiguate ,a & ,t from the Align plugin, making them fast again.
"
" This section is here to prevent AlignMaps from adding a bunch of mappings
" that interfere with the very-common ,a and ,t mappings. This will get run
" at every startup to remove the AlignMaps for the *next* vim startup.
"
" If you do want the AlignMaps mappings, remove this section, remove
" ~/.vim/bundle/Align, and re-run rake in maximum-awesome.
function! s:RemoveConflictingAlignMaps()
  if exists("g:loaded_AlignMapsPlugin")
    AlignMapsClean
  endif
endfunction
command! -nargs=0 RemoveConflictingAlignMaps call s:RemoveConflictingAlignMaps()
silent! autocmd VimEnter * RemoveConflictingAlignMaps


" different tab settings for different langs
nmap \M :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
" nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
" nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

" random mappings
" nmap <C-n> :bnext<CR>
nmap <C-p> :bprev<CR>

let JSHintUpdateWriteOnly=1

nmap <leader>ww :Gstatus<CR>
nmap <leader>wg :Gdiff<CR>

" find and replace in visual mode
vmap <C-r> <Esc>:%s/<C-r>+//gc<left><left><left>

"From http://vimcasts.org/episodes/tidying-whitespace/
"Preserves/Saves the state, executes a command, and returns to the saved state
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
"strip all trailing white space
autocmd BufWritePre :call whitespace#strip_trailing()<CR>

" call ReloadAllSnippets()

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

" --------------------
" MAPPINGS HELPERS
" --------------------

let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window = 'order:ttb,max:25'
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
let g:ctrlp_max_depth=60
" let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_files = 0
let g:ctrlp_working_path_mode = 0
" nmap ; :CtrlPBuffer<CR>
nmap <leader>T :CtrlPMRU<CR>
" nmap <leader>t :CtrlPClearCache<CR>:CtrlP<CR>
nmap <leader>t :CtrlP<CR>

set omnifunc=syntaxcomplete#Complete


if filereadable(expand("~/.vimrc.local.mappings"))
  source ~/.vimrc.local.mappings
endif

" if !exists('g:snips_trigger_key')
"   let g:snips_trigger_key = '< tab>'
" endif

let g:SuperTabDefaultCompletionType = "context"

" remove preview window for tern completion
autocmd BufEnter * set completeopt-=preview

imap <C-c> <CR><Esc>O


let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" ---------------
" JAVASCRIPT
" ---------------

au BufRead,BufNewFile *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2


" generate doc comment template
map <leader>wc :JsDoc<cr>
let g:jsdoc_default_mapping = 0
let g:jsdoc_additional_descriptions = 1
let g:jsdoc_allow_input_prompt = 1

" JSBeuatify config
map <c-f> :call JsBeautify()<cr>
" or
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
autocmd FileType scss noremap <buffer> <c-f> :call CSSBeautify()<cr>


let JSHintUpdateWriteOnly=1

" show quotes in json files
let g:vim_json_syntax_conceal = 0

" --------------------
" PYTHON
" --------------------
au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

let python_highlight_all=1
syntax on

" Legacy

" Split files
" if filereadable(expand("~/.vimrc.local"))
  " " In your .vimrc.local, you might like:
  " "
  " " set autowrite
  " " set nocursorline
  " " set nowritebackup
  " " set whichwrap+=<,>,h,l,[,] " Wrap arrow keys between lines
  " "
  " autocmd! bufwritepost .vimrc source ~/.vimrc
  " source ~/.vimrc.local
" endif

" call ReloadAllSnippets()
" imap <c-j> <Plug>snipMateNextOrTrigger
" imap <C-s> <Plug>snipMateShow
" smap <c-u> <Plug>snipMateNextOrTrigger
"" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" remove preview window for tern completion
autocmd BufEnter * set completeopt-=preview

imap <C-c> <CR><Esc>O


let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" show quotes in json files
let g:vim_json_syntax_conceal = 0

" Gist options
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1

let g:clang_library_path = "/usr/lib"
let g:clang_library_file = "libclang.so.1"
let g:clang_use_library = 1
let b:clang_user_options = '-std=c++11'
let g:clang_complete_auto = 1

let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set termencoding=utf-8

if has("gui_running")
  let s:uname = system("uname")
  if s:uname == 'Darwin\n'
    set guifont=Inconsolata\ for\ Powerline:h15
  endif
else
  set term=xterm-256color
endif


let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_javascript_jsxhint_exec = 'jsx-jshint-wrapper'
" let g:EclimCompletionMethod = 'omnifunc'

let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:Show_diagnostics_ui = 1 "default 1

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1


let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''


let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info


let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
let g:ycm_confirm_extra_conf = 1


let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'

autocmd filetype lisp,scheme,art setlocal equalprg=scmindent.rkt

" tslime {{{
let g:tslime_ensure_trailing_newlines = 1
let g:tslime_normal_mapping = '<localleader>q'
let g:tslime_visual_mapping = '<localleader>q'
let g:tslime_vars_mapping = '<localleader>Q'
" }}}

" niji {{{
let g:niji_dark_colours = [
    \ [ '81', '#5fd7ff'],
    \ [ '99', '#875fff'],
    \ [ '1',  '#dc322f'],
    \ [ '76', '#5fd700'],
    \ [ '3',  '#b58900'],
    \ [ '2',  '#859900'],
    \ [ '6',  '#2aa198'],
    \ [ '4',  '#268bd2'],
    \ ]
" }}}

