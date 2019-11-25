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

" Folding.
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=2
set nofoldenable
set foldlevel=2

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
    if !has('nvim')
      set ttymouse=xterm2
    endif
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

" Colorscheme and syntax highlighting setup.
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if !has('gui_running')
  set t_Co=256
endif

" Avoid performance issues by only highlighting first 200 columns (optional).
set synmaxcol=200

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
nnoremap <c-s> :Grepper -tool rg<cr>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

" vifm settings.
let g:vifm_replace_netrw = 1
nnoremap - :EditVifm<cr>
nnoremap <leader>e :EditVifm<cr>

" Buffer management.
nnoremap <s-tab> :bprevious<cr>
nnoremap <tab> :bnext<cr>
nnoremap <leader><tab> :buffer<space><tab>
nnoremap <c-e> :Buffers<cr>

" MRU.
"nnoremap <c-r> :History<cr>

" Tab management.
"nnoremap <leader>tn :tabnew<cr>
"nnoremap <leader>tc :tabclose<cr>
"nnoremap <tab> :tabnext<cr>
"nnoremap <s-tab> :tabprev<cr>

" Fast help/quickfix/etc. management.
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

" Diffing.
nnoremap dgh :diffget //2<cr>
nnoremap dgl :diffget //3<cr>
nnoremap <leader>do :diffoff<cr>

" COC linting and type-ahead for multiple languages.
let g:coc_start_at_startup = 1
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" JSON.
autocmd FileType json syntax match Comment +\/\/.\+$+

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

  " YATS
  let g:yats_host_keyword = 1

  " Begin COC configuration.
  set cmdheight=2  " easier to read messages
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
" 10/31/19: Disabled cscope module due to high CPU usage and little benefit
let g:gutentags_modules=['ctags']
"let g:gutentags_scopefile='.git/cscope.out'
let g:gutentags_cache_dir=expand('$HOME/.local/share/gutentags')

" Edit/compile/run cycle.
nmap <silent> <F5> :make<cr><cr><cr>
nmap <silent><expr> <F6> execute("Termdebug ". expand('%:r')) 

" Debugging.
let g:termdebug_wide = 143
let g:vimspector_enable_mappings = 'HUMAN'

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


" Tabline and statusline settings.
set laststatus=2
set showtabline=2

let g:lightline = {
  \ 'colorscheme': 'iceberg',
  \ 'subseparator': { 'left': '|', 'right': '|' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'cocstatus', 'currentfunction' ] ],
  \   'right': [ [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \   'fugitive': 'LightlineFugitive',
  \   'filename': 'LightlineFilename',
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction',
  \   'fileformat': 'LightlineFileformat',
  \   'fileencoing': 'LightlineFileencoding',
  \   'filetype': 'LightlineFiletype'
  \ },
  \ 'tabline': {
  \   'left': [],
  \   'right': [ [ 'close' ], [ 'buffers' ] ]
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers'
  \ },
  \ 'component_type': {
  \   'buffers': 'tabsel'
  \ },
  \ 'enable': {
  \   'statusline': 1,
  \   'tabline': 1
  \ }
  \}

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction
function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction
function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction
function! LightlineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction
function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction
function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction
function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction
function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction
function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#right_aligned = 1
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
  \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'
\}

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

let g:tmuxline_theme = 'lightline'
let g:tmuxline_powerline_separators = 0

" Kwbd - a better 'bd': close buffer without closing window.
cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Kwbd' : 'bd')<cr>


" COC extension - explorer.
nnoremap <leader>n :CocCommand explorer --toggle<cr>
function! s:coc_explorer_on_vim_enter()
  " Hook to open and reveal explorer automatically.
  if (argc() == 0)
    execute 'CocCommand explorer --reveal ' . getcwd()
  endif
endfunction
function! s:coc_explorer_on_buffer_unload()
  " Hook to quit if explorer is last buffer.
  if ((winnr('$') == 1) && exists('b:coc_explorer_inited'))
    normal quit
    return
  endif
endfunction
augroup cocexplorer
    autocmd!
    autocmd VimEnter * call s:coc_explorer_on_vim_enter()
    autocmd BufUnload * call s:coc_explorer_on_buffer_unload()
augroup END

" Startify.
let g:startify_change_to_dir = 0
nnoremap <leader>h :Startify<cr>
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Close-buffers.
nnoremap <leader>bo :Bdelete other<cr>
nnoremap <leader>bc :Bdelete this<cr>
nnoremap <leader>bx :Bdelete all<cr>
nnoremap <leader>bi :Bdelete select<cr>

" Plug. 
"   execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" Essential plugins.
Plug 'christoomey/vim-tmux-navigator'
Plug 'cocopon/iceberg.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'plasticboy/vim-markdown'
Plug 'puremourning/vimspector', {'for': ['typescript', 'javascript']}
Plug 'rgarver/kwbd.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vifm/vifm'
Plug 'xolox/vim-misc'
Plug 'yonchu/accelerated-smooth-scroll'
Plug 'asheq/close-buffers.vim'

" COC plugins.
let g:coc_global_extensions = [
\  'coc-css',
\  'coc-docker',
\  'coc-eslint',
\  'coc-explorer',
\  'coc-git',
\  'coc-gitignore',
\  'coc-html',
\  'coc-jest',
\  'coc-json',
\  'coc-lua',
\  'coc-markdownlint',
\  'coc-marketplace',
\  'coc-prettier',
\  'coc-python',
\  'coc-sql',
\  'coc-todolist',
\  'coc-tsserver',
\  'coc-yaml'
\ ]

call plug#end()

colorscheme iceberg

