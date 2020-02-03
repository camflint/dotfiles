" Leader keys.
let mapleader = '\'
let maplocalleader = ','

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
set mouse=n
set textwidth=120
set breakindent
set breakindentopt=shift:2
set showbreak=↳
set formatoptions=croqj

" Don't autoformat (esp. autowrap) text in some files.
augroup autoformat
  autocmd!
  autocmd FileType markdown setlocal formatoptions-=c | setlocal textwidth=0
augroup END

set nocompatible

" More natural split opening.
set splitright
set splitbelow

" Line numbers.
set number relativenumber
augroup numbertoggle
  autocmd!
  " Need to fix Goyo.
  "autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  "autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
"set colorcolumn=120

" Folding.
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=2
set nofoldenable
set foldlevel=2
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <space> zA
nnoremap <localleader>z zMzvzz
" Workaround to prevent folds from changing when switching buffers / typing in
" insert mode.
"autocmd InsertLeave,WinEnter,BufWinEnter * let &l:foldmethod=g:oldfoldmethod
"autocmd InsertEnter,WinLeave,BufWinLeave * let g:oldfoldmethod=&l:foldmethod | setlocal foldmethod=manual

" Selection.
nnoremap vv 0v$

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

" Show certain invisibles.
set list
set listchars=tab:

" Keyword completion (autocomplete).
set complete-=i  " Don't search include files for every keyword completion.

" Search settings.
nnoremap / /\v
vnoremap / /\v
set ignorecase smartcase
set gdefault
set incsearch

" Temporarily enable 'hlsearch' only when typing the search query.
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Shortcut to close all temporary windows and turn off highlighting.
nnoremap <localleader>l :noh<cr> \| :cclose<cr> \| :lclose<cr> \| <plug>(lsp-preview-close)

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
nnoremap <localleader>; ;
nnoremap <localleader>, ,

" Command-mode history shortcuts (avoid using arrow keys).
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Fast config editing and reloading.
nnoremap <leader>ve :e $MYVIMRC<cr>
nnoremap <leader>vr :so $MYVIMRC<cr>

" Copy/paste.
" Don't move cursor after yanking. Related tip: use Ctrl+O to toggle between top and bottom of a visual selection as
xmap y ygv<esc>
map <localleader>yy "+y
" Put current buffer path onto system clipboard.
map <localleader>yb :let @+=expand('%:p')<CR>
map <localleader>pp "+[p

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
" 'termguicolors' works in consoles with 24-bit (RGB) color support only.
" When set, 'termguicolors' instructs vim to issue RGB color escape codes with
" the colors from gui, guifg, guibg etc. (see :help :highlight).
if exists('+termguicolors') && $TERM !~# '^\%(screen\|tmux|rxvt\)'
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
else
  set notermguicolors
endif

if !has('gui_running')
  set t_Co=256
endif

" Avoid performance issues by only highlighting first 200 columns (optional).
"set synmaxcol=200

" Window management.
nnoremap <localleader>s- <C-w>s<C-w>j
nnoremap <localleader>s<pipe> <C-w>v<C-w>l
nnoremap <localleader>s\ <C-w>v<C-w>l
nnoremap <localleader>sx <C-w>q
nnoremap <localleader>so <C-w>o
nnoremap <localleader>sz <C-w>\|<C-w>_
nnoremap <localleader>s= :set equalalways<cr> \| <C-w>= \| :set noequalalways<cr>
" Redistribute windows when the client is resized.
autocmd VimResized * wincmd =

function! WinBufSwap()
  let thiswin = winnr()
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)

  exec  lastwin . " wincmd w" ."|".
      \ "buffer ". thisbuf ."|".
      \ thiswin ." wincmd w" ."|".
      \ "buffer ". lastbuf
endfunction
nnoremap <localleader>ss <C-c>:call WinBufSwap()<cr>

" Fuzzy file search, opening etc.
nnoremap <c-p> :Files <c-r>=getcwd()<cr><cr>
nnoremap <m-p> :Files <c-r>=expand('%:h')<cr><cr>

" Grep settings.
let g:grepper = {}
let g:grepper.tools = ['git', 'grep', 'rg']
let g:grepper.rg = {
  \ 'grepprg': 'rg --no-heading --with-filename --vimgrep --hidden --ignore-case',
  \ 'grepformat': '%f:%l:%c:%m',
  \ 'escape': '\^$.*+?()[]{}|',
  \ }
let g:grepper.open = 1
let g:grepper.switch = 1
let g:grepper.jump = 0
let g:grepper.dir = 'cwd'
let g:grepper.prompt_text = '$t> '
let g:grepper.prompt_mapping_tool = '<leader>g'
nnoremap <c-s> :Grepper -tool rg<cr>
nnoremap <localleader>* :Grepper -tool rg -cword -noprompt<cr>

" vifm settings.
let g:vifm_replace_netrw = 1
nnoremap - :EditVifm<cr>
nnoremap <leader>e :EditVifm<cr>

" Buffer management.
"nnoremap <leader><tab> :bnext<cr>
nnoremap <localleader><tab> :Buffers<cr>

" Tab management.
nnoremap <leader><tab> :tabnext<cr>

" Help window positioning.
set helpheight=9999
augroup vert_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" Fzf and fzf.vim.
"   slightly different configuration depending on OS.
if !empty(glob('/usr/local/opt/fzf'))
  set rtp+=/usr/local/opt/fzf
elseif !empty(glob('/usr/share/doc/fzf'))
  set rtp+=/usr/share/doc/fzf
  source /usr/share/doc/fzf/examples/fzf.vim
endif
let g:fzf_history_dir = '~/.local/share/fzf-vim-history'

" Universal snippets.
imap <C-d> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

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

" nnoremap <silent> <C-g> :call Cscope('3', expand('<cword>'))<CR>
nnoremap <localleader>t :Tags<cr>

" Fugitive / git setup.
nnoremap <leader>fs :Git<cr>
nnoremap <leader>fc :Gcommit<cr>
nnoremap <leader>fp :Gpull<cr>
nnoremap <leader>fb :Gblame<cr>
nnoremap <leader>fg :Ggrep<space>
nnoremap <leader>fl :Gclog<cr>
nnoremap <leader>fm :Gmove<space>
nnoremap <leader>fb :Gbrowse!<cr>
nnoremap <leader>fd :Gvdiffsplit!<cr>
nnoremap <leader>fy :.,.Gbrowse!<cr>

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
" let g:coc_start_at_startup = 1
" let g:coc_status_error_sign = '✗'
" let g:coc_status_warning_sign = '◆'
" let g:coc_status_info_sign = 'כֿ'
" let g:coc_status_hint_sign = ''
" set updatetime=300
" set shortmess+=c
" set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
"inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" nmap <silent> [g <Plug>(coc-javascriptdiagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

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
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" JSON.
autocmd FileType json syntax match Comment +\/\/.\+$+

" Python.
set showmatch
let g:pydoc_window_lines=0.5
"let python_highlight_all = 1

" Javascript.
" let g:javascript_plugin_jsdoc = 1
" augroup javascript
"   autocmd!
"   autocmd FileType javascript setlocal foldmethod=syntax
" augroup END

" Typescript.
function! s:setuptypescript()
  " makeprg
  let l:root = findfile('tsconfig.json', expand('%:p:h').';')
  let &makeprg = 'tsc -p ' . fnameescape(l:root)

  " YATS
  " let g:yats_host_keyword = 1

  " Begin COC configuration.
  set cmdheight=2  " easier to read messages
endfunction
augroup typescript
  autocmd!
  "Let the tsc compiler discover and use the tsconfig.json rather than
  "overriding here.
  autocmd FileType typescript call s:setuptypescript()

  " Map TSX/JSX filetypes so that vim-lsp/coc-tsserver works.
  " autocmd FileType typescriptreact set filetype=typescript.tsx
  " autocmd FileType javascriptreact set filetype=javascript.jsx
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
nmap <Leader>mm <Plug>BookmarkToggle
nmap <Leader>mi  <Plug>BookmarkAnnotate
nmap <Leader>ma <Plug>BookmarkShowAll
nmap <Leader>mj <Plug>BookmarkNext
nmap <Leader>mk <Plug>BookmarkPrev
nmap <Leader>mc <Plug>BookmarkClear
nmap <Leader>mx <Plug>BookmarkClearAll
" unmap <silent> mg
" unmap <silent> mjj
" unmap <silent> mkk
map <leader><leader>mj <Plug>BookmarkMoveDown
map <leader><leader>mk <Plug>BookmarkMoveUp

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
  \ 'colorscheme': 'base16',
  \ 'subseparator': { 'left': '|', 'right': '|' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ] ],
  \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'readonly' ] ]
  \ },
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \   'fugitive': 'LightlineFugitive',
  \   'filename': 'LightlineFilename',
  \   'currentfunction': 'CocCurrentFunction',
  \   'nearestfunction': 'CocNearestFunction',
  \   'fileformat': 'LightlineFileformat',
  \   'fileencoing': 'LightlineFileencoding',
  \   'filetype': 'LightlineFiletype'
  \ },
  \ 'component_expand': {
  \   'buffers': 'lightline#bufferline#buffers',
  \   'linter_warnings': 'LightlineCocWarnings',
  \   'linter_errors': 'LightlineCocErrors',
  \   'linter_infos': 'LightlineCocInfos',
  \   'linter_hints': 'LightlineCocHints'
  \ },
  \ 'tabline': {
  \   'left': [ [ 'tabs' ] ],
  \   'right': [ [ 'close' ], [ 'buffers' ] ]
  \ },
  \ 'tab': {
  \   'active': [ 'tabnum', 'modified' ],
  \   'inactive': [ 'tabnum', 'modified' ]
  \ },
  \ 'component_type': {
  \   'readonly': 'error',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_infos': 'tabsel',
  \   'linter_hints': 'middle',
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
function! CocNearestFunction()
  return get(b:, 'vista_nearest_method_or_function', '')
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
function! s:lightline_coc_diagnostic(kind, sign) abort
  let info = get(b:, 'coc_diagnostic_info', 0)
  if empty(info) || get(info, a:kind, 0) == 0
    return ''
  endif
  if a:sign == 'error'
    let s = g:coc_status_error_sign
  elseif a:sign == 'warning'
    let s = g:coc_status_warning_sign
  elseif a:sign == 'info'
    let s = g:coc_status_info_sign
  elseif a:sign == 'hint'
    let s = g:coc_status_hint_sign
  else
    let s = ''
  endif
  return printf('%s %d', s, info[a:kind])
endfunction

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
function! LightlineCocErrors() abort
  return s:lightline_coc_diagnostic('error', 'error')
endfunction
function! LightlineCocWarnings() abort
  return s:lightline_coc_diagnostic('warning', 'warning')
endfunction
function! LightlineCocInfos() abort
  return s:lightline_coc_diagnostic('information', 'info')
endfunction
function! LightlineCocHints() abort
  return s:lightline_coc_diagnostic('hints', 'hint')
endfunction
autocmd BufWritePost,TextChanged,TextChangedI * call s:MaybeUpdateLightline()
autocmd User CocDiagnosticChange call lightline#update()
  
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#right_aligned = 1
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
  \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'
\}

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

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

" let g:tmuxline_theme = 'lightline'
" let g:tmuxline_powerline_separators = 0

" Kwbd - a better 'bd': close buffer without closing window.
cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Kwbd' : 'bd')<cr>

" vim-lsp.
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.local/share/nvim/lsp/vim-lsp.log')
let g:lsp_settings_servers_dir = expand('~/.local/share/nvim/lsp/')

" Disable typeahead due to severe performance issues.
let g:asyncomplete_auto_popup = 0

" let g:lsp_settings = {
"   \   'whitelist': [
"   \     'typescript-language-server',
"   \     'pyls',
"   \     'emmylua-ls',
"   \     'vim-language-server',
"   \     'bash-language-server',
"   \     'yaml-language-server',
"   \     'dockerfile-language-server-nodejs',
"   \     'lsp4xml',
"   \     'json-languageserver',
"   \     'texlab',
"   \     'gopls'
"   \   ]
"   \}

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:setupvimlsp()
  " Having serious performance issues with folding.
  "   https://github.com/prabirshrestha/vim-lsp/issues/671
  " set foldmethod=expr
  "   \ foldexpr=lsp#ui#vim#folding#foldexpr()
  "   \ foldtext=lsp#ui#vim#folding#foldtext()
  
  inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <cr>  pumvisible() ? "\<C-y>" : "\<cr>"

  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ asyncomplete#force_refresh()

  if has("gui_running")
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  endif
  
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gp <plug>(lsp-peek-definition)
  nmap <buffer> gc <plug>(lsp-declaration)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gn <plug>(lsp-rename)
  nmap <buffer> gh <plug>(lsp-hover)
  nmap <buffer> gs <plug>(lsp-signature-help)
  nmap <buffer> <leader>o <plug>(lsp-document-symbol)
  nmap <buffer> <leader>O <plug>(lsp-workspace-symbol)
  nmap <buffer> <leader>e <plug>(lsp-document-diagnostics)
  nmap <buffer> ]e <plug>(lsp-next-error)
  nmap <buffer> [e <plug>(lsp-previous-error)
  nmap <buffer> ]w <plug>(lsp-next-warning)
  nmap <buffer> [w <plug>(lsp-previous-warning)
  nmap <buffer> <leader>a <plug>(lsp-code-action)
  map <buffer> <leader>f <plug>(lsp-document-range-format)
endfunction
augroup myvimlsp
  autocmd!
  autocmd FileType
    \ typescript,typescriptreact,javascript,javascriptreact,python,go,lua,vim,bash,yaml,dockerfile,xml,json
    \ call s:setupvimlsp()
augroup end
command! LspSetupVimLsp call s:setupvimlsp()

" NERDTree
function! s:togglenerdtree()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeClose
  elseif filereadable(expand('%'))
    NERDTreeFind
  else
    NERDTree
  endif
endfunction
command! MyToggleNERDTree call s:togglenerdtree()
nnoremap <leader>s <cmd>MyToggleNERDTree<cr>
let g:NERDTreeBookmarksFile = expand('~/.config/local/vim/nerdtree/bookmarks')
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1

" If vim is opened with a single directory argument, launch NERDTree.
function! s:handle_open_with_dir_arg()
  if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
    exe 'NERDTree' argv()[0] 
    wincmd p 
    ene 
    exe 'cd '.argv()[0] 
  endif
endfunction
function! s:handle_close_with_single_buffer_remaining()
  if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) 
    quit
  endif
endfunction
augroup nerdtree_setup
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * call s:handle_open_with_dir_arg()
  autocmd BufEnter * call s:handle_close_with_single_buffer_remaining()
augroup END

" COC extension - explorer.
" nnoremap \n :CocCommand explorer --toggle<cr>
" function! s:coc_explorer_on_vim_enter()
"   " Hook to open and reveal explorer automatically.
"   if (argc() == 0)
"     execute 'CocCommand explorer --reveal ' . getcwd()
"   endif
" endfunction
" function! s:coc_explorer_on_buffer_unload()
"   " Hook to quit if explorer is last buffer.
"   if ((winnr('$') == 1) && exists('b:coc_explorer_inited'))
"     normal quit
"     return
"   endif
" endfunction
" augroup cocexplorer
"     autocmd!
    "autocmd VimEnter * call s:coc_explorer_on_vim_enter()
    "autocmd BufUnload * call s:coc_explorer_on_buffer_unload()
" augroup END

" Vista - symbol viewer.
let g:vista_default_executive = 'vim_lsp'
let g:vista_finder_alternative_executives = ['ctags']
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_width= 47
let g:vista_echo_cursor_strategy = 'scroll'
let g:vista#renderer#enable_icon = 1
autocmd FileType vista,vista_kind nnoremap <buffer><silent> / :<c-u>call vista#finder#fzf#Run(g:vista_default_executive)<cr>
nnoremap <leader>o :Vista vim_lsp<cr>

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

" Cursorcross.
let g:cursorcross_no_map_CR=1

" Diminactive.
" let g:diminactive_use_colorcolumn=0
" let g:diminactive_use_syntax=1
" let g:diminactive_enable_focus=1

"augroup diminactive_focus
"  au! FocusGained * DimInactiveOn
"  au! FocusLost * DimInactiveOff
"augroup END

" Vimwiki.
let g:vimwiki_list = [{
  \ 'path': '$HOME/notes',
  \ 'path_html': '$HOME/notes/dist'
  \ }]
let g:vimwiki_listsym_rejected = '✗'
let g:vimwiki_use_mouse = 1
let g:vimwiki_folding = 'syntax'

" Goyo.
let g:goyo_width = 150
function! s:goyo_enter()
  setlocal nonumber norelativenumber
  "CocCommand git.toggleGutters
endfunction

function! s:goyo_leave()
  setlocal number relativenumber
  "CocCommand git.toggleGutters
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap \g :Goyo<cr>
 
" Easymotion.
map <space> <Plug>(easymotion-prefix)

" Navmode.
nmap \n :call Navmode()<cr>

" vim-markdown-preview.
let vim_markdown_preview_hotkey = '<C-m>'
let vim_markdown_preview_browser = 'Firefox'
let vim_markdown_preview_github = 1

" Quickfix window & vim-qf.
nnoremap <leader>q :copen<cr>

function! s:setupvimqf()
  "map <buffer> <cr> :cclose<cr>
endfunction
augroup myvimqf
  autocmd!
  autocmd FileType qf call s:setupvimqf()
augroup END
command! SetupVimQf :call s:setupvimqf()

" vim-which-key
" nnoremap <silent> <leader> :<c-u>WhichKey ','<cr>
" nnoremap <silent> <leader>m :<c-u>WhichKey ',m'<cr>
" nnoremap <silent> <leader>f :<c-u>WhichKey ',f'<cr>
" nnoremap <silent> <leader>v :<c-u>WhichKey ',v'<cr>
" nnoremap <silent> <leader>y :<c-u>WhichKey ',y'<cr>
" nnoremap <silent> <leader>p :<c-u>WhichKey ',p'<cr>
" nnoremap <silent> <leader>w :<c-u>WhichKey ',v'<cr>
" nnoremap <silent> <leader>s :<c-u>WhichKey ',s'<cr>
" nnoremap <silent> \\ :<c-u>WhichKey '\\'<cr>

" vim-orgmode
let g:org_heading_shade_leading_stars=1
let g:org_indent=1
let g:org_aggressive_conceal=1
function! s:setuporgmode()
  imap <buffer> <tab> <Cmd><Plug>(OrgDemoteOnHeadingInsert)<cr>
  imap <buffer> <s-tab> <Cmd><Plug>(OrgPromoteOnHeadingInsert)<cr>
endfunction
augroup MyOrgMode
  autocmd! FileType org :call s:setuporgmode()
augroup END


" Plug. 
"   execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" Essential plugins.
"Plug 'mattn/vim-lsp-settings'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'asheq/close-buffers.vim'
Plug 'camflint/vim-superman'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'fcpg/vim-navmode'
Plug 'godlygeek/tabular'
Plug 'hiphish/info.vim'
Plug 'inkarkat/vim-PatternsOnText'
Plug 'inkarkat/vim-ingo-library'
Plug 'itchyny/lightline.vim'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'mattn/vim-lsp-settings'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'mtth/cursorcross.vim'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector', {'for': ['typescript', 'javascript']}
Plug 'rgarver/kwbd.vim'
Plug 'romainl/vim-qf'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'wellle/targets.vim'
Plug 'whiteinge/diffconflicts'
Plug 'xolox/vim-misc'
Plug 'jceb/vim-orgmode'
Plug 'itchyny/calendar.vim'

" nvim-only plugins.
if has('nvim')
  Plug 'shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" COC plugins.
let g:coc_global_extensions = [
\  'coc-explorer',
\  'coc-git',
\  'coc-gitignore',
\ ]

call plug#end()

" Base16 colorscheme.
function! s:base16_customize() abort
  "hi! ColorColumn ctermbg=18 guibg=#2a3448

  " Lightline customizations.
  let s:base00 = [ "#".g:base16_gui00, g:base16_cterm00 ] " black
  let s:base01 = [ "#".g:base16_gui01, g:base16_cterm01 ]
  let s:base02 = [ "#".g:base16_gui02, g:base16_cterm02 ]
  let s:base03 = [ "#".g:base16_gui03, g:base16_cterm03 ]
  let s:base04 = [ "#".g:base16_gui04, g:base16_cterm04 ]
  let s:base05 = [ "#".g:base16_gui05, g:base16_cterm05 ]
  let s:base06 = [ "#".g:base16_gui06, g:base16_cterm06 ]
  let s:base07 = [ "#".g:base16_gui07, g:base16_cterm07 ] " white

  let s:base08 = [ "#".g:base16_gui08, g:base16_cterm08 ] " red
  let s:base09 = [ "#".g:base16_gui09, g:base16_cterm09 ] " orange
  let s:base0A = [ "#".g:base16_gui0A, g:base16_cterm0A ] " yellow
  let s:base0B = [ "#".g:base16_gui0B, g:base16_cterm0B ] " green
  let s:base0C = [ "#".g:base16_gui0C, g:base16_cterm0C ] " teal
  let s:base0D = [ "#".g:base16_gui0D, g:base16_cterm0D ] " blue
  let s:base0E = [ "#".g:base16_gui0E, g:base16_cterm0E ] " pink
  let s:base0F = [ "#".g:base16_gui0F, g:base16_cterm0F ] " brown

  let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

  let s:p.normal.left     = [ [ s:base01, s:base03 ], [ s:base05, s:base02 ] ]
  let s:p.insert.left     = [ [ s:base00, s:base0D ], [ s:base05, s:base02 ] ]
  let s:p.visual.left     = [ [ s:base00, s:base09 ], [ s:base05, s:base02 ] ]
  let s:p.replace.left    = [ [ s:base00, s:base08 ], [ s:base05, s:base02 ] ]
  let s:p.inactive.left   = [ [ s:base02, s:base00 ] ]

  let s:p.normal.middle   = [ [ s:base07, s:base01 ] ]
  let s:p.inactive.middle = [ [ s:base01, s:base00 ] ]

  let s:p.normal.right    = [ [ s:base01, s:base03 ], [ s:base01, s:base02 ] ]
  let s:p.inactive.right  = [ [ s:base01, s:base00 ] ]

  let s:p.normal.error    = [ [ s:base07, s:base08 ] ]
  let s:p.normal.warning  = [ [ s:base07, s:base09 ] ]

  let s:p.tabline.left    = [ [ s:base05, s:base02 ] ]
  let s:p.tabline.middle  = [ [ s:base05, s:base01 ] ]
  let s:p.tabline.right   = [ [ s:base05, s:base02 ] ]
  let s:p.tabline.tabsel  = [ [ s:base01, s:base0A ] ]

  let g:lightline#colorscheme#base16#palette = lightline#colorscheme#flatten(s:p)

  call LightlineReload()
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

if filereadable(expand('~/.vimrc_background'))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Use italic for comments.
hi! Comment cterm=italic gui=italic

" Iceberg theme customizations.
"hi! CursorLine cterm=NONE ctermbg=238 guibg=#3e445e
"hi! Visual ctermbg=238 guibg=#3e445e

