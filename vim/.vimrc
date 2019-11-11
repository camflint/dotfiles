" Syntax highlighting.
syntax enable

" Colorscheme and syntax highlighting setup.
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1

colorscheme nord

" Avoid performance issues by only highlighting first 200 columns (optional).
set synmaxcol=200

" Load filetype-based plugins and indentation rules (~/.vim/ftplugin, ~/.vim/indent).
filetype plugin indent on

" Leader key.
let mapleader = ','

" So-called 'sane' defaults.
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=full
set wildcharm=<Tab>
set wildignore+=*/node_modules/*,*.swp,*.*~
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
set breakindent
set breakindentopt=shift:2
set showbreak=↳

" Backup settings.
set swapfile
set directory^=~/.local/share/vim/backup//
set writebackup
set nobackup
set backupcopy=auto

" Undo persistence.
set undofile
set undodir^=~/.local/share/vim/undo//

" Indentation rules.
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" Keyword completion (autocomplete).
set complete-=i  " Don't search include files for every keyword completion.

" Search settings.
nnoremap / /\v
vnoremap / /\v
set ignorecase
set infercase
set gdefault
set incsearch

" Temporarily enable 'hlsearch' only when typing the search query.
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

nnoremap <leader>l :noh<cr> \| :cclose<cr> \| :lclose<cr>

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

" Map ':' to ';'
nnoremap ; :
nnoremap <leader>; ;
nnoremap <leader>, ,

" Command-mode history shortcuts (avoid using arrow keys).
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Fast config editing and reloading.
nnoremap <leader>ve :e $MYVIMRC<cr>
nnoremap <leader>vr :so $MYVIMRC<cr>

" Pasting from system clipboard.
map <leader>y "+y
map <leader>p "+[p

" Better man pages (when viewed with K or :Man <topic>).
runtime ftplugin/man.vim
set keywordprg=:Man

" Scrolling and movement.
map <PageDown> <C-D>
map <PageUp> <C-U>
map <End> <C-F>
map <Home> <C-B>

" More natural linewise movement.
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Split (vim window) management.
nnoremap <leader>s- <C-w>s<C-w>j
nnoremap <leader>s\| <C-w>v<C-w>l
nnoremap <leader>sc <C-w>q
nnoremap <leader>so <C-w>o
nnoremap <leader>sz <C-w>\|<C-w>_
nnoremap <leader>s= :set equalalways<cr> \| <C-w>= \| :set noequalalways<cr>
nnoremap <leader>sh <c-w>h
nnoremap <leader>sl <c-w>l
nnoremap <leader>sj <c-w>j
nnoremap <leader>sk <c-w>k
nnoremap <leader>sf :Vifm<cr>
autocmd VimResized * wincmd =

" Fuzzy file search, opening etc.
nnoremap <c-p> :Files <c-r>=getcwd()<cr><cr>
nnoremap <m-p> :Files <c-r>=expand('%:h')<cr><cr>

" Grep settings.
let g:grepper = {}
let g:grepper.tools = ['git', 'grep', 'rg']
let g:grepper.open = 1
let g:grepper.switch = 1
let g:grepper.jump = 0
let g:grepper.dir = 'repo,cwd'
let g:grepper.prompt_text = '$t> '
let g:grepper.prompt_mapping_tool = '<leader>g'
nnoremap <c-f> :Grepper -tool rg<cr>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

" Pure vim grepping.
"set grepprg=rg\ --hidden\ --colors=always\ $*\
"command! -nargs=+ MyGrep execute 'silent! grep! <args>' | copen 20 | redraw!
"nnoremap <leader>/ :MyGrep 
"nnoremap K :MyGrep <cword><cr>

" vifm settings.
let g:vifm_replace_netrw = 1
nnoremap - :EditVifm<cr>
nnoremap <leader>e :EditVifm<cr>

" Buffer management.
nnoremap <s-tab> :bprevious<cr>
nnoremap <tab> :bnext<cr>
nnoremap <leader><tab> :buffer<space><tab>
nnoremap <c-e> :Buffers<cr>
" Pure vim buffer switching (instead of FZF).
"set wildcharm=<C-z>
"nnoremap <leader>b :buffer <C-z><S-Tab>
"nnoremap <leader>b :ls<cr>:buffer<space>

" Tab management.
"nnoremap <leader>tn :tabnew<cr>
"nnoremap <leader>tc :tabclose<cr>
"nnoremap <tab> :tabnext<cr>
"nnoremap <s-tab> :tabprev<cr>

" Fast help/quickfix/etc. management.
nnoremap <leader>hc :helpclose<cr>
nnoremap <leader>hg :helpgrep 
nnoremap <leader>qc :cclose<cr>

" Help window positioning.
set helpheight=9999
augroup vert_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" Fzf and fzf.vim.
set rtp+=/usr/local/opt/fzf
let g:fzf_history_dir = '~/.local/share/fzf-vim-history'

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

" Fzf/cscope integration.
"   source: https://alex.dzyoba.com/blog/vim-revamp/
function! Cscope(option, query)
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
  \ 'down': '40%'
  \ }
  function! opts.sink(lines) 
    let data = split(a:lines)
    let file = split(data[0], ":")
    execute 'e ' . '+' . file[1] . ' ' . file[0]
  endfunction
  call fzf#run(opts)
endfunction

nnoremap <silent> <C-g> :call Cscope('3', expand('<cword>'))<CR>
nnoremap <leader>t :Tags<cr>
nnoremap <leader>o :BTags<cr>

" Fugitive / git setup.
nnoremap <leader>fs :Git<cr>
nnoremap <leader>fc :Gcommit<cr>
nnoremap <leader>fp :Gpull<cr>
nnoremap <leader>fb :Gblame<cr>
nnoremap <leader>fg :Ggrep<space>
nnoremap <leader>fl :Gclog<cr>
nnoremap <leader>fm :Gmove<space>
nnoremap <leader>fb :Gbrowse<cr>
nnoremap <leader>fd :Gvdiffsplit!<cr>
nnoremap dgh :diffget //2<cr>
nnoremap dgl :diffget //3<cr>
nnoremap do :diffoff<cr>

" Delete all Git conflict markers
" Creates the command :GremoveConflictMarkers
function! RemoveConflictMarkers() range
  echom a:firstline.'-'.a:lastline
  execute a:firstline.','.a:lastline . ' g/^<\{7}\|^|\{7}\|^=\{7}\|^>\{7}/d'
endfunction
"-range=% default is whole file
command! -range=% GremoveConflictMarkers <line1>,<line2>call RemoveConflictMarkers()

" Python.
set showmatch
let g:pydoc_window_lines=0.5
"let python_highlight_all = 1

" Javascript.
let g:javascript_plugin_jsdoc = 1
augroup javascript
  autocmd!
  autocmd FileType javascript setlocal foldmethod=syntax
augroup END

" Typescript.
function! s:setuptypescript()
  " makeprg
  let l:root = findfile('tsconfig.json', expand('%:p:h').';')
  let &makeprg = 'tsc -p ' . fnameescape(l:root)

  " tsuquyomi
  "let g:tsuquyomi_completion_detail = 1
  "nmap <buffer> <leader>x : <C-u>echo tsuquyomi#hint()<cr>
endfunction
augroup typescript
  autocmd!
  "Let the tsc compiler discover and use the tsconfig.json rather than
  "overriding here.
  autocmd FileType typescript call s:setuptypescript()
augroup END
"let g:typescript_compiler_options='--lib es6,dom --downLevelIteration --target es5'

" C.
set path=.,**
set path+=/usr/local/include
set path+=/usr/include
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" Just hardcode gcc include directory in tags, since `brew --prefix` callout
" takes a long time.
"silent let gcc_prefix = get(systemlist("brew --prefix gcc"), 0, "")
"if !v:shell_error && !empty(gcc_prefix)
"    let &path = &path .. "," .. gcc_prefix .. "/include/**"
"endif
set path+=/usr/local/opt/gcc/include/**
set tags+=./tags;$HOME,./.git/tags;$HOME

" Ctags, gutentags, etc.
let g:gutentags_modules=['ctags']
"let g:gutentags_ctags_tagfile='.git/tags'
"let g:gutentags_scopefile='.git/cscope.out'
let g:gutentags_cache_dir=expand('$HOME/.local/share/gutentags')

" Edit/compile/run cycle.
nmap <silent> <F5> :make<cr><cr><cr>
nmap <silent><expr> <F6> execute("Termdebug ". expand('%:r')) 

" Debugging.
let g:termdebug_wide = 143

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

" Bookmarks plugin.
"let g:bookmark_auto_save_file = expand('$HOME/.local/share/vim/bookmarks/.vim-bookmarks')
let g:bookmark_auto_close = 1
let g:bookmark_center = 1
let g:bookmark_disable_ctrlp = 1
let g:bookmark_show_warning = 0
let g:bookmark_show_toggle_warning = 0
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" Finds the Git super-project directory.
function! g:BMWorkDirFileLocation()
    let filename = 'bookmarks'
    let location = ''
    if isdirectory('.git')
        " Current work dir is git's work tree
        let location = getcwd().'/.git'
    else
        " Look upwards (at parents) for a directory named '.git'
        let location = finddir('.git', '.;')
    endif
    if len(location) > 0
        return location.'/'.filename
    else
        return getcwd().'/.'.filename
    endif
endfunction


" Airline/statusline settings.
set showtabline=2
set ttimeoutlen=10
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tmuxline#enabled = 0  " Disable tmuxline/airline integration since we use tmux-nord.
let g:airline_theme = 'nord'
let g:airline_powerline_fonts = 1
"let g:airline_statusline_ontop = 1
"autocmd VimEnter * set laststatus=0  " Override airline's force.

"
" SECTION: settings for plugins I don't use anymore.
"

" CtrlP settings.
"let g:ctrlp_working_path_mode = 'wra'
"let g:ctrlp_show_hidden = 1
"nnoremap <leader>f :CtrlP<cr>
"nnoremap <leader>b :CtrlPBuffer<cr>
"nnoremap <leader>m :CtrlPMRUFiles<cr>

" Ranger settings.
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

" netrw settings.
"let g:netrw_preview      = 1
"let g:netrw_liststyle    = 0
"let g:netrw_keepdir      = 0
"let g:netrw_browse_split = 1
"let g:netrw_altv         = 1
"let g:netrw_winsize      = 25
"let g:netrw_list_hide    = netrw_gitignore#Hide() . '\(^\|\s\s\)\zs\.\S+'
"augroup ProjectDrawer autocmd!  autocmd VimEnter * :Vexplore augroup END

" Nerdtree settings.
"let NERDTreeChDirMode   = 2  " Synchronize NERDTree root with Vim's cwd.
"let NERDTreeHijackNetrw = 1
"let NERDTreeMinimalUI   = 1
"let NERDTreeStatusline  = 'NERD'
"map <leader>n :NERDTreeToggle<cr>
"map <leader>s :NERDTreeFind<cr>
"augroup ProjectDrawer
"    autocmd!
"    autocmd VimEnter * :NERDTree
"augroup END

" Unite settings.
" NOTE: Additional settings are located in ~/.vim/after/plugin/unite.vim.
"let g:unite_source_history_yank_enable = 1
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file<cr>
"nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   file_rec<cr>
"nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     file_mru<cr>
"nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline outline<cr>
"nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
"nnoremap <leader>e :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>

