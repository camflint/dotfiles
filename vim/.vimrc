" Syntax highlighting.
syntax enable

" So-called 'sane' defaults.
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set relativenumber
set mouse=n
set textwidth=80
set fo=croqj

" Better search defaults.
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

" Map <leader> to <space>
let mapleader = ' '

" Clear search highlighting.
nnoremap <leader>l :noh<cr>

" Backup settings.
set swapfile
set directory^=~/.vim/swap//
set writebackup
set nobackup
set backupcopy=auto

" Indentation rules.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

" Undo persistence.
set undofile
set undodir^=~/.vim/undo//

" Load filetype-based plugins and indentation rules (~/.vim/ftplugin, ~/.vim/indent).
filetype plugin indent on

" Colorscheme.
colorscheme gruvbox
let g:gruvbox_contrast_dark='soft'
set background=dark

" Python.
set showmatch
"let python_highlight_all = 1

" C.
set path=.,**
set path+=/usr/local/include
set path+=/usr/include
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

"silent let gcc_prefix = get(systemlist("brew --prefix gcc"), 0, "")
"if !v:shell_error && !empty(gcc_prefix)
"    let &path = &path .. "," .. gcc_prefix .. "/include/**"
"endif
set path+=/usr/local/opt/gcc/include/**
set tags+=./tags;$HOME

augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" Edit/compile/run cycle.
nmap <silent> <F5> :make<cr><cr><cr>
nmap <silent><expr> <F6> execute("Termdebug ". expand('%:r')) 

" Debugging.
let g:termdebug_wide = 143

" Typescript.
let g:typescript_compiler_options = '--lib es6,dom --downLevelIteration --target es5'

" Keyword completion (autocomplete).
set complete-=i  " Don't search include files for every keyword completion.

" Better man pages (when viewed with K or :Man <topic>).
runtime ftplugin/man.vim
set keywordprg=:Man

" Ranger integration.
"let g:ranger_terminal = 'xterm -e'
"map <leader>rr :RangerEdit<cr>
"map <leader>rv :RangerVSplit<cr>
"map <leader>rs :RangerSplit<cr>
"map <leader>rt :RangerTab<cr>
"map <leader>ri :RangerInsert<cr>
"map <leader>ra :RangerAppend<cr>
"map <leader>rc :set operatorfunc=RangerChangeOperator<cr>g@
"map <leader>rd :RangerCD<cr>
"map <leader>rld :RangerLCD<cr>

" Tmux fixups.
if &term =~ '^screen'
    " Fix shift key.
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"

    " Fix mouse.
    set ttymouse=xterm2
endif

" Fast split navigation with <Ctrl> + hjkl.
"tnoremap <c-h> <c-w>h
"tnoremap <c-j> <c-w>j
"tnoremap <c-k> <c-w>k
"tnoremap <c-l> <c-w>l

" Map ':' to ';'
nnoremap ; :
nnoremap <leader>; ;
nnoremap <leader>, ,

" Fast split management.
nnoremap <leader>ss <C-w>s<C-w>j
nnoremap <leader>sv <C-w>v<C-w>l
nnoremap <leader>sc <C-w>h
nnoremap <leader>so <C-w>o
nnoremap <leader>sz <C-w>\|<C-w>_
nnoremap <leader>s= :set equalalways<cr> \| <C-w>= \| :set noequalalways<cr>
nnoremap <leader>sh <c-w>h
nnoremap <leader>sl <c-w>l
nnoremap <leader>sj <c-w>j
nnoremap <leader>sk <c-w>k
nnoremap <leader>sf :Vifm<cr>

" Rolodex windows/splits.
"set noequalalways
"set winminheight=0 winheight=9999 helpheight=9999
"set winminwidth=0 winwidth=9999

" Fast tab management.
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>

" Fast help/quickfix/etc. management.
nnoremap <leader>hc :helpclose<cr>
nnoremap <leader>hg :helpgrep 

nnoremap <leader>qc :cclose<cr>

" Fast config editing and reloading.
nnoremap <leader>ve :e $MYVIMRC<cr>
nnoremap <leader>vr :so $MYVIMRC<cr>

" Pasting from system clipboard.
map <leader>y "+y
map <leader>p "+[p

" File management.
let g:ctrlp_working_path_mode = 'wra'
let g:ctrlp_show_hidden = 1
"nnoremap <leader>f :CtrlP<cr>
"nnoremap <leader>b :CtrlPBuffer<cr>
"nnoremap <leader>m :CtrlPMRUFiles<cr>
"
" Buffer management.
nnoremap <s-tab> :bprevious<cr>
nnoremap <tab> :bnext<cr>
"set wildcharm=<C-z>
"nnoremap <leader>b :buffer <C-z><S-Tab>
"nnoremap <leader>b :ls<cr>:buffer<space>

" CtrlP mappings.
nnoremap <C-p> :CtrlPBuffer<cr>

" Tab management.
"nnoremap <tab> :tabnext<cr>
"nnoremap <s-tab> :tabprev<cr>

" netrw settings.
let g:netrw_preview      = 1
let g:netrw_liststyle    = 0
let g:netrw_keepdir      = 0
let g:netrw_browse_split = 1
let g:netrw_altv         = 1
let g:netrw_winsize      = 25
let g:netrw_list_hide    = netrw_gitignore#Hide() . '\(^\|\s\s\)\zs\.\S+'
"augroup ProjectDrawer autocmd!  autocmd VimEnter * :Vexplore augroup END

" Nerdtree settings.
let NERDTreeChDirMode   = 2  " Synchronize NERDTree root with Vim's cwd.
let NERDTreeHijackNetrw = 1
let NERDTreeMinimalUI   = 1
let NERDTreeStatusline  = 'NERD'
map <leader>n :NERDTreeToggle<cr>
map <leader>s :NERDTreeFind<cr>
"augroup ProjectDrawer
"    autocmd!
"    autocmd VimEnter * :NERDTree
"augroup END

" Unite settings.
" NOTE: Additional settings are located in ~/.vim/after/plugin/unite.vim.
set wildignore+=*/node_modules/*,*.swp,*.*~
let g:unite_source_history_yank_enable = 1
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   file_rec<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     file_mru<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline outline<cr>
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

" Airline/statusline settings.
set showtabline=2
set ttimeoutlen=10
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
"let g:airline_statusline_ontop = 1
"autocmd VimEnter * set laststatus=0  " Override airline's force.

" pydoc settings.
let g:pydoc_window_lines=0.5

" Grep settings.
set grepprg=grep\ -nri\ $*\ .
command! -nargs=+ MyGrep execute 'silent! grep! <args>' | copen 20 | redraw!
nnoremap <leader>/ :MyGrep 
nnoremap K :MyGrep <cword><cr>

" Fzf and fzf.vim.
set rtp+=/usr/local/opt/fzf
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>m :Marks<cr>
nnoremap <leader>gf :GFiles<cr>
nnoremap <leader>gs :GFiles?<cr>
nnoremap <leader>gc :Commits<cr>

" vifm settings.
let g:vifm_replace_netrw = 1
nnoremap <leader>e :EditVifm<cr>

" Search settings.
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
nnoremap <leader><space> :set nohlsearch<bar>:cclose<cr>

" Tabular setup.
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

