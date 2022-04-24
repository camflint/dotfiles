" Basic options -----------------------------------------------------------{{{1
" Self-explanatory defaults.
set encoding=utf-8
set autoindent
set noruler
set showmatch

" Mouse settings.
set mouse=a
set mousefocus
set mousemodel=popup
set selectmode=mouse

" Backup settings.
set swapfile
set directory^=~/.local/share/vim/backup//
set writebackup
set nobackup
set backupcopy=auto

" Undo persistence.
if has('persistent_undo')
    set undofile
    set undodir^=~/.local/share/vim/undo//
endif

" Indentation rules (defaults).
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" 120 chars per line.
set textwidth=120
if exists('&colorcolumn')
    set colorcolumn=120
endif

" Highlight the row and column.
"  (managed by vim-cursorcross plugin also)
"set cursorcolumn
"set cursorline

" Folding rules (defaults).
set foldmethod=indent
set foldnestmax=10
set foldlevel=2
set foldlevelstart=99
set nofoldenable

" Show certain invisibles.
set list
set listchars=tab:

" Performance tweaks.
set synmaxcol=1000    " stop highlighting for long columns (like XML files)
set lazyredraw

" Reduce timeout length by half.
set timeoutlen=500

" Silence most hit-enter prompts.
set shortmess=aIT

" Keyword completion (autocomplete).
set complete-=i  " Don't search include files for every keyword completion.

" Update swapfile more frequently to prevent long delays (?).
set updatetime=300

" Make sure backspace/delete work as expected in INSERT mode.
set backspace=indent,eol,start

" Don't beep.
set visualbell

" Line numbers.
set number
set relativenumber

" Basic status bar visual options.
set showmode
set showcmd

" Give more space for displaying messages.
set cmdheight=2

" Scroll N lines at a time rather than default, which is half-window.
set scroll=10
" Make sure we can always see 3 lines of context around the cursor.
set scrolloff=3

" Allow switching away from a dirty buffer without saving.
set hidden

" More natural new split opening.
set splitright
set splitbelow

" Search.
set ignorecase smartcase " ignore case unless mixed case is present in search query
set gdefault             " global substitution is default
set incsearch            " search immediately rather than requiring <cr>

" Only enable 'hlsearch' when focused on the command line.
augroup ModalHighlightSearch
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Show tab suggestions in the command bar.
set wildmenu
set wildmode=full
set wildcharm=<Tab>
set wildignore+=*/node_modules/*,*.swp,*.*~

" Visually indent wrapped lines, with a ↳ symbol prefixed.
set breakindent
set breakindentopt=shift:2
set showbreak=↳

" Keep the cursor column stable when moving around.
set nostartofline

" Don't automatically add <EOL> to the file (preserve existing).
if exists('&fixeol')
    set nofixeol
endif

" Smart comment formatting (when using 'gq').
set formatoptions=croqj

" Better man pages (when viewed with :Man <topic>).
runtime ftplugin/man.vim
set keywordprg=:Man

" Allow the cursor to be positioned anywhere during visual block mode.
set virtualedit=block

" Don't double-space.
set nojoinspaces

" Use vertical panes when diffing. Try to align diff chunks left and right using
" filler spacing.
set diffopt=filler,vertical

" Automatically reload the buffer when the filsystem changes (but not when the
" file is deleted, so in-memory changes aren't lost).
set autoread

" Status line and tab line ------------------------------------------------{{{1

" statusline.
function! StatuslineBufferIndex()
  let buffers = getbufinfo({'buflisted': 1, 'bufloaded': 1})
  if len(buffers) ==# 0
    return '' 
  endif
  let index = 1
  let found = v:false
  for buf in buffers
    if buf.bufnr ==# bufnr()
      let found = v:true
      break
    endif
    let index += 1
  endfor
  if found
    return index .. '/' .. len(buffers)
  else
    return ''
  endif
endfunction
function! StatuslineFilename()
  return ' ' .. expand('%:t') .. (&mod ? ' [+] ' : ' ')
endfunction
set laststatus=2
set statusline=%-10.25(%#User1#%{StatuslineFilename()}%#TabLineFill#\ %{StatuslineBufferIndex()}%)%=%m%r\ %y\ %l:%c\ %p%%

" tabline (format).
function MyTabLine()
  let s = ''
  let s .= '%#TabLineFill#%='
  let t = tabpagenr()
  let i = 1
  while i <= tabpagenr('$')
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    let s .= '%' . i . 'T'
    let s .= ' '
    let s .= i
    let s .= '%T '
    let i = i + 1
  endwhile
  let s .= '%#TabLine#'
  return s
endfunction
set showtabline=1
set tabline=%!MyTabLine()

" Tmux integration --------------------------------------------------------{{{1

" Note that vim-tmux-navigator plugin takes care of <C-hjkl> keys.
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

" Mapping to quickly switch between full-screen vim and half-screen vim (meant
" to play nicely with 50% tmux panes).
nnoremap <silent> <leader>z 
      \ :call system("tmux resize-pane -Z")<cr>

" Color scheme & themes ---------------------------------------------------{{{1
" Use 256-color by default.
" if !has('gui_running')
"   set t_Co=256
" endif

" 'termguicolors' works in consoles with 24-bit (RGB) color support only.  When set, 'termguicolors' instructs vim to
" issue RGB color escape codes with the colors from gui, guifg, guibg etc. (see :help :highlight).
if exists('+termguicolors') && $TERM !~# '\v^(screen|rxvt)'
  " let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  " let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
else
  set notermguicolors
endif

" NOTE: See the very bottom of this file for the code that actually triggers the theme.

" Filetype customization --------------------------------------------------{{{1

function! s:setup_code_general()
  " YouCompleteMe mappings.
  " nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
  " nnoremap <buffer> gc :YcmCompleter GoToDeclaration<cr>
  " nnoremap <buffer> gi :YcmCompleter GoToImplementation<cr>
  " nnoremap <buffer> gt :YcmCompleter GoToType<cr>
  " nnoremap <buffer> gr :YcmCompleter GoToReferences<cr>
  " nnoremap <buffer> gh :YcmCompleter GetDoc<cr>

  " vim-lsp mappings.
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gp <plug>(lsp-peek-definition)
  nmap <buffer> gc <plug>(lsp-declaration)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gn <plug>(lsp-rename)
  nmap <buffer> gh <plug>(lsp-hover)
  nmap <buffer> gs <plug>(lsp-signature-help)
  nmap <buffer> <localleader>o <plug>(lsp-document-symbol)
  nmap <buffer> <localleader>O <plug>(lsp-workspace-symbol)
  nmap <buffer> <localleader>q <plug>(lsp-document-diagnostics)
  nmap <buffer> ]e <plug>(lsp-next-error)
  nmap <buffer> [e <plug>(lsp-previous-error)
  nmap <buffer> ]w <plug>(lsp-next-warning)
  nmap <buffer> [w <plug>(lsp-previous-warning)
  nmap <buffer> <localleader>a <plug>(lsp-code-action)
  map <buffer> <localleader>gq <plug>(lsp-document-range-format)

  " vim-lsp settings.
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  let g:lsp_format_sync_timeout = 500
  let g:lsp_fold_enabled = 0

  " Close the preview window when completion is done.
  augroup lsp_close_popup
    autocmd!
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  augroup END
  
  inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"
  
  " Enable autocomplete preview.
  setlocal completeopt=menuone,noinsert,noselect,preview

  " Tabbing between autocomplete menu items.
  " inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
  " imap <c-space> <Plug>(asyncomplete_force_refresh)

  function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
  endfunction

  " Uncomment this if g:asyncomplete_auto_popup = 0
  " inoremap <silent><expr> <TAB>
  "   \ pumvisible() ? "\<C-n>" :
  "   \ <SID>check_back_space() ? "\<TAB>" :
  "   \ asyncomplete#force_refresh()
  " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
endfunction

" Filetype: javascript
function! s:setup_filetype_javascript()
  call <SID>setup_js_ts_snippets()
  call <SID>setup_code_general()
endfunction

" Filetype: json
function! s:setup_filetype_json()
  syntax match Comment +\/\/.\+$+
endfunction

" Filetype: markdown
function! s:setup_filetype_markdown()
  " Don't autoformat (esp. autowrap) text in some files.
  setlocal formatoptions-=c | setlocal textwidth=0
endfunction

" Filetype: org
function! s:setup_filetype_org()
  setlocal foldenable
  setlocal foldlevelstart=0
  setlocal foldlevel=0
  setlocal textwidth=80
  call <SID>setup_org_mode_mappings()
endfunction

" Filetype: typescript
function! s:setup_filetype_typescript()
  " makeprg
  let l:root = findfile('tsconfig.json', expand('%:p:h').';')
  let &makeprg = 'tsc -p ' . fnameescape(l:root)
  call <SID>setup_code_general()
endfunction

" Filetype: vim
function! s:setup_filetype_vim()
  setlocal foldenable
  setlocal foldmethod=marker
  setlocal foldlevelstart=0
  setlocal foldlevel=0
  setlocal textwidth=80
  call <SID>setup_code_general()
endfunction

" Filetype: help
function! s:setup_filetype_help()
  " Don't show hidden chars, since helpfiles contain a lot of tabs.
  setlocal nolist
endfunction

function! s:setup_filetype_python()
  let g:ycm_python_interpreter_path = trim(system('pyenv which python3'))
  let g:ycm_autoclose_preview_window_after_completion=1

  nmap <localleader>p <Plug>(YCMFindSymbolInWorkspace)
  nmap <localleader><localleader>p <Plug>(YCMFindSymbolInDocument)
  nmap gd :YcmCompleter GoToDefinitionElseDeclaration<CR>

  " NOTE: make sure you have autopep8 installed for best results.
  "  $ pip install --upgrade autopep8
  autocmd BufWrite * :Autoformat
  call <SID>setup_code_general()
endfunction

" Activate base coding keyboard shortcuts whenever LSP activates on a buffer. 
augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call <SID>setup_code_general()
augroup END

augroup setup_filetypes
  autocmd!
  autocmd FileType javascript,typescript :call <SID>setup_filetype_javascript()
  autocmd FileType json                  :call <SID>setup_filetype_json()
  autocmd FileType markdown              :call <SID>setup_filetype_markdown()
  autocmd FileType org                   :call <SID>setup_filetype_org()
  autocmd FileType typescript            :call <SID>setup_filetype_typescript()
  autocmd FileType vim,vifm              :call <SID>setup_filetype_vim()
  autocmd FileType help                  :call <SID>setup_filetype_help()
  autocmd FileType python                :call <SID>setup_filetype_python()
augroup END

" Always re-apply filetype settings when .vimrc is sourced (because sourcing
" .vimrc may potentially overwrite global settings).
execute 'set filetype=' . &filetype

" Re-expand to cursor.
execute 'normal zMzvzz'

" Mappings ----------------------------------------------------------------{{{1

" Leader keys.
let mapleader = '\'
let maplocalleader = ','

" Home.
nnoremap == :Startify<cr>

" Quick suspend.
nnoremap Z :suspend<cr>

" Saving (:update is more efficient than :write, so better for my trigger finger).
inoremap <C-s> <C-O>:update<cr>
nnoremap <C-s>      :update<cr>

" Macros - qq to record, Q to replay.
nnoremap Q @q

" Automatically unfold to cursor when searching forward/backward.
nnoremap n nzzzv
nnoremap N Nzzzv

" Close all folds except under cursor.
nnoremap <localleader>z zMzvzz

" Map ':' to ';'
nnoremap ; :
nnoremap <localleader>; ;
nnoremap <localleader>, ,

" Fast config editing and reloading.
" Note explicit path for editing, since $MYVIMRC only sources ~/.vimrc.
nnoremap <leader>ve :vsplit ~/.vimrc<cr>
nnoremap <leader>vr :so $MYVIMRC<cr>

" Select only text and not prefix/suffix whitespace (contrast with V).
nnoremap vv ^v$

" Move lines up and down (disabled because conflicts with '-' to open file
" explorer).
" nnoremap - ddp
" nnoremap _ ddkP

" Command-mode history shortcuts (avoids using arrow keys).
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Uppercase the current word, without changing the cursor position or mode.
inoremap <c-u> <esc>viwU`^i

" Use very-magic search mode, so regular expressions are more intuitive.
nnoremap / /\v
vnoremap / /\v

" More natural, i.e. visual linewise movement.
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" PageUp/Down and Home/End keys.
map <PageDown> <C-D>
map <PageUp> <C-U>
map <End> <C-F>
map <Home> <C-B>

" Shortcut to close the {quickfix, location} windows, plus turn off highlighting, plus reset editing states.
nnoremap <localleader>l :noh<cr> \|
\ :cclose<cr> \|
\ :lclose<cr> \|
\ <plug>(ExchangeClear) \|
"\ <plug>(lsp-preview-close) \|
\ <plug>(clever-f-reset)

" Readline-style key bindings (from rsi.vim).
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

" Copy/paste shortcuts.
" Don't move cursor after yanking. Related tip: use Ctrl+O to toggle between top and bottom of a visual selection.
xmap y ygv<esc>                               |" Don't move cursor after yanking.
map <localleader>yy "+y                       |" Yank to system clipboard.
map <localleader>pp "+[p                      |" Paste from the system clipboard, performing indentation.
map <localleader>yb :let @+=expand('%:p')<CR> |" Put current buffer path onto system clipboard.

" Buffer management.
nmap <tab> <Plug>unimpairedBNext
nmap <S-tab> <Plug>unimpairedBPrevious
"nnoremap <leader>b :Buffers<cr>
nnoremap <leader>b :Clap buffers<cr>

nnoremap <localleader>bo :Bdelete other<cr>
nnoremap <localleader>bc :Bdelete this<cr>
nnoremap <localleader>bx :Bdelete all<cr>
nnoremap <localleader>bi :Bdelete select<cr>

" Recent files.
nnoremap <leader>r :Clap history<cr>

" Git-tree files.
nnoremap <leader>g :Clap git_diff_files<cr>
nnoremap <leader>G :Clap git_files<cr>

" Tab management.
" 8/30 - disabled due to 'J' join line conflict.
" nnoremap J :tabprev<CR>
" nnoremap K :tabnext<CR>

" Split management.
nnoremap <localleader>s- <C-w>s<C-w>j                                             |" Split vertically.
nnoremap <localleader>s<pipe> <C-w>v<C-w>l                                        |" Split horizontally.
nnoremap <localleader>s\ <C-w>v<C-w>l                                             |" Split horizontally (lazy fingers).
nnoremap <localleader>sx <C-w>q                                                   |" Kill split.
nnoremap <localleader>so <C-w>o                                                   |" Kill other splits ("only").
nnoremap <localleader>sz <C-w>\|<C-w>_                                            |" Zoom split.
nnoremap <localleader>s= :set equalalways<cr> \| <C-w>= \| :set noequalalways<cr> |" Distribute splits.
" augroup split_resize
"   autocmd!
"   autocmd VimResized * wincmd =                                                   |" Redistribute windows when the client is resized.
" augroup END

function! WinBufSwap()
  let thiswin = winnr()
  let thisbuf = bufnr("%")
  let lastwin = winnr("#")
  let lastbuf = winbufnr(lastwin)

  exec  lastwin . " wincmd w" ."|".
      \ "buffer ". thisbuf ."|".
      \ thiswin ." wincmd w" ."|".
      \ "buffer ". lastbuf . "|".
      \ lastwin . " wincmd w"
endfunction
nnoremap <localleader>ss <C-c>:call WinBufSwap()<cr> |" Swap this and the last window.

" Fuzzy file finder (double-tap leader for path-relative search).
nnoremap <leader>f :Clap files ++finder=fd --type f --follow --hidden<cr>
nnoremap <leader><leader>f :Clap files ++finder=fd --type f --follow --hidden %:p:h<cr>

" Ivy-like file navigator.
nnoremap <leader>e :<c-u>Clap filer<cr>
nnoremap <leader><leader>e :<c-u>Clap filer %:p:h<cr><cr>

" Grep.
nnoremap <leader>s :Clap grep<cr>
nnoremap <leader><leader>s :Clap grep %:p:h<cr>
nnoremap K :Clap grep ++query=<cword><cr>

" File explorers.
nnoremap - :Vifm<cr>
"nnoremap <leader>o :<c-u>MyToggleNERDTree<cr>

" Command history.
nnoremap <leader>c :<c-u>Clap command_history<cr>

" Command browser (all commands).
nnoremap <leader><leader>c :<c-u>Clap command<cr>

" Yank history.
nnoremap <leader>y :<c-u>Clap yanks<cr>

" Search history.
nnoremap <localleader>/ :<c-u>Clap search_history<cr>

" Help tags/
nnoremap <leader>h :<c-u>Clap help_tags<cr>

" Quickfix list.
nnoremap <leader>q :<c-u>Clap quickfix<cr>

" Jump history.
nnoremap <leader>j :<c-u>Clap jumps<cr>

function! s:CustomizeYcmQuickFixWindow()
  " Show YcmCompleter results in Clap popup instead of the quickfix window.
  cclose
  execute ':Clap quickfix'
endfunction
autocmd User YcmQuickFixOpened call <SID>CustomizeYcmQuickFixWindow()

let g:ycm_always_populate_location_list = 1

" Intellisense (LSP) mappings.
" function! s:setup_vim_lsp_keymaps()
"   " Having serious performance issues with folding.
"   "   https://github.com/prabirshrestha/vim-lsp/issues/671
"   " set foldmethod=expr
"   "   \ foldexpr=lsp#ui#vim#folding#foldexpr()
"   "   \ foldtext=lsp#ui#vim#folding#foldtext()

"   setlocal omnifunc=lsp#complete
  
" endfunction
" augroup myvimlsp
"   autocmd!
"   autocmd User lsp_buffer_enabled call <SID>setup_vim_lsp_keymaps()
" augroup end
" command! LspRefresh call <SID>setup_vim_lsp_keymaps()

" Git.
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :Gpull<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gg :Ggrep<space>
nnoremap <leader>gl :Gclog<cr>
nnoremap <leader>gm :Gmove<space>
nnoremap <leader>gb :Gbrowse!<cr>
nnoremap <leader>gd :Gvdiffsplit!<cr>
nnoremap <leader>gy :.,.Gbrowse!<cr>

" Delete all Git conflict markers
" Creates the command :GremoveConflictMarkers
function! RemoveConflictMarkers() range
  echom a:firstline.'-'.a:lastline
  execute a:firstline.','.a:lastline . ' g/^<\{7}\|^|\{7}\|^=\{7}\|^>\{7}/d'
endfunction
"-range=% default is whole file
command! -range=% GremoveConflictMarkers <line1>,<line2>call RemoveConflictMarkers()

" Diffing.
set diffopt+=internal,algorithm:patience
nnoremap dgh :diffget //2<cr>
nnoremap dgl :diffget //3<cr>
nnoremap <leader>do :diffoff<cr>

" Bookmark management.
" Finds the Git super-project directory.
" function! g:BMWorkDirFileLocation()
"     let filename = 'bookmarks'
"     let location = ''
"     if isdirectory('.git')
"         " Current work dir is git's work tree
"         let location = getcwd().'/.git'
"     else
"         " Look upwards (at parents) for a directory named '.git'
"         let location = finddir('.git', '.;')
"     endif
"     if len(location) > 0
"         return location.'/'.filename
"     else
"         return getcwd().'/.'.filename
"     endif
" endfunction
" nnoremap <Leader>mm <Plug>BookmarkToggle
" nnoremap <Leader>mi  <Plug>BookmarkAnnotate
" nnoremap <Leader>ma <Plug>BookmarkShowAll
" nnoremap <Leader>mj <Plug>BookmarkNext
" nnoremap <Leader>mk <Plug>BookmarkPrev
" nnoremap <Leader>mc <Plug>BookmarkClear
" nnoremap <Leader>mx <Plug>BookmarkClearAll
" map <leader><leader>mj <Plug>BookmarkMoveDown
" map <leader><leader>mk <Plug>BookmarkMoveUp
nnoremap <leader>m :Clap marks<cr>

" Invoke Goyu for a distraction-free writing environment.
nnoremap <leader><leader>w :Goyo<cr>
 
" Invoke Easymotion for rapid movement.
map <space> <Plug>(easymotion-prefix)

" Enter navmode for less-like scrolling.
"nnoremap \n :call Navmode()<cr>

" Open the quickfix window.
nnoremap <localleader>q :copen<cr>

" Orgmode mappings.
function! s:setup_org_mode_mappings()
  nmap <buffer><silent> <localleader>1 <Cmd>OrgAgendaTimeline<CR>
  nmap <buffer><silent> <localleader>2 <Cmd>OrgAgendaTodo<CR>
  nmap <buffer><silent> <localleader>3 <Cmd>OrgAgendaWeek<CR>

  imap <buffer><silent> <c-m-h> <Plug>OrgDemoteOnHeadingInsert
  imap <buffer><silent> <c-m-l> <Plug>OrgPromoteOnHeadingInsert
  imap <buffer><silent> <m-h> <Plug>OrgNewHeadingBelowAfterChildrenInsert
  imap <buffer><silent> <m-i> <Plug>OrgPlainListItemNewBelow
  imap <buffer><silent> <m-I> <Plug>OrgPlainListItemNewAbove
  imap <buffer><silent> <m-c> <Plug>OrgCheckBoxNewBelow
  imap <buffer><silent> <m-C> <Plug>OrgCheckBoxNewAbove
  imap <buffer><silent> <m-x> <Plug>OrgCheckBoxToggle
  imap <buffer><silent> <m-d> <Plug>OrgDateInsertTimestampActiveCmdLine
  imap <buffer><silent> <m-l> <Plug>OrgHyperlinkInsert
  imap <buffer><silent> <m-t> <Plug>OrgSetTags
endfunction
command! SetupOrgModeMappings :call <SID>setup_org_mode_mappings()

" Markdown mappings.
function! s:setup_markdown_mappings()
  map <m-m> <plug>MarkdownPreviewToggle
endfunction
augroup SetupMarkdownMappings
  autocmd! filetype markdown call <SID>setup_markdown_mappings()
augroup END


" Text snippets -----------------------------------------------------------{{{1
" A syntax for placeholders
" Pressing CTRL-n jumps to the next match.
inoremap <c-n> <Esc>/<++><CR><Esc>cf>

" Insert datetime.
"inoremap <C-d> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

" Javascript/Typescript snippets.
function! s:setup_js_ts_snippets()
  iabbrev <buffer> describe@ 
        \describe(`<++>`, () => {
        \  <cr><tab><++><cr>
        \});<c-n>
  iabbrev <buffer> context@ 
        \context(`<++>`, () => {
        \<cr><tab><++><cr>
        \});<c-n>
  iabbrev <buffer> it@ 
        \it(`<++>`, async () => {
        \<cr><tab><++><cr>
        \});<c-n>
  iabbrev <buffer> before@ 
        \before(() => {
        \<cr><tab><++><cr>
        \});<c-n>
  iabbrev <buffer> beforeEach@ 
        \beforeEach(() => {
        \<cr><tab><++><cr>
        \});<c-n>
  iabbrev <buffer> inspect@ 
        \const util = require('util');<cr>
        \console.log(util.inspect(`<++>`), {depth: 2});
        \<c-n>
endfunction
command! SetupJsTsSnippets :call <SID>setup_js_ts_snippets()

" Plugin settings ---------------------------------------------------------{{{1
" Grepper.
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

" Vifm.
let g:vifm_replace_netrw = 1

" Fzf.
if !empty(glob('/usr/local/opt/fzf'))
  set rtp+=/usr/local/opt/fzf
elseif !empty(glob('/usr/share/doc/fzf'))
  set rtp+=/usr/share/doc/fzf
  source /usr/share/doc/fzf/examples/fzf.vim
endif
let g:fzf_history_dir = expand('~/.local/share/fzf-vim-history')
" let g:fzf_colors =
" \ { 'fg':      ['fg', 'Normal'],
"   \ 'bg':      ['bg', 'WildMenu'],
"   \ 'hl':      ['bg', 'Warning'],
"   \ 'fg+':     ['fg', 'Normal'],
"   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"   \ 'hl+':     ['bg', 'Warning'],
"   \ 'info':    ['fg', 'PreProc'],
"   \ 'border':  ['fg', 'WildMenu'],
"   \ 'prompt':  ['fg', 'Conditional'],
"   \ 'pointer': ['fg', 'Exception'],
"   \ 'marker':  ['fg', 'Keyword'],
"   \ 'spinner': ['fg', 'Label'],
"   \ 'header':  ['bg', 'WildMenu'],
"   \ 'gutter':  ['bg', 'WildMenu'] }
let g:fzf_preview_window = ''

autocmd! FileType fzf set laststatus=0 noshowmode noruler nonumber norelativenumber
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler number relativenumber

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

" Tags.
" nnoremap <silent> <C-g> :call Cscope('3', expand('<cword>'))<CR>
"nnoremap <localleader>t :Tags<cr>

" Pydoc.
let g:pydoc_window_lines=0.5

" Tabularize.
if exists(":Tabularize")
  nmap <localleader>t= :Tabularize /=<CR>
  vmap <localleader>t= :Tabularize /=<CR>
  nmap <localleader>t: :Tabularize /:\zs<CR>
  vmap <localleader>t: :Tabularize /:\zs<CR>
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

" Bookmarks .
let g:bookmark_auto_save_file = expand('~/.local/share/vim/.vim-bookmarks')
let g:bookmark_auto_close = 1
let g:bookmark_center = 1
let g:bookmark_disable_ctrlp = 1
let g:bookmark_show_warning = 0
let g:bookmark_show_toggle_warning = 0
"let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" Clap.
nnoremap <leader>t <c-u>:Clap tags<cr>

let g:clap_layout = { 'relative': 'editor', 'width': '90%', 'col': '5%', 'height': '50%', 'row': '5%' }
let g:clap_open_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
\}
"let g:clap_disable_run_rooter = v:true
let g:clap_provider_grep_executable = 'rg'
let g:clap_provider_grep_delay = 10  " ms
let g:clap_provider_grep_opts = '-H --no-heading --vimgrep --color=never --smart-case --hidden --vimgrep -g !.git/ -g !node_modules/ -g !dist/'
let g:clap_insert_mode_only = v:true
let g:clap_enable_icon = 1
"let g:clap_enable_debug = v:true
"let g:clap_default_external_filter = 'fzf'
let g:clap_preview_direction = 'UD' " preview on bottom, not right

" Use K to search the word under cursor (TODO)
"nnoremap <silent> K :call <SID>show_documentation()<CR>

" C/C++.
set path=.,**
set path+=/usr/local/include
set path+=/usr/include
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include

augroup project
  autocmd!
  autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

if !empty(glob('/usr/local/opt/gcc/include/**'))
  set path+=/usr/local/opt/gcc/include/**
endif
set tags+=./tags;$HOME,./.git/tags;$HOME

" Ctags, gutentags, etc.
" 10/31/19: Disabled cscope module due to high CPU usage and little benefit
let g:gutentags_modules=['ctags']
let g:gutentags_cache_dir=expand('~/.local/share/gutentags')

" Edit/compile/run cycle.
nnoremap <silent> <F5> :make<cr><cr><cr>
nnoremap <silent><expr> <F6> execute("Termdebug ". expand('%:r')) 

" Vimspector and termdebug.
let g:termdebug_wide = 143
let g:vimspector_enable_mappings = 'HUMAN'

" " Lightline.
" let s:black =   [ '#202c3d', 0 ]
" let s:red =     [ '#f76f6e', 1 ]
" let s:green =   [ '#4eac6d', 2 ]
" let s:yellow =  [ '#af9a0a', 3 ]
" let s:blue =    [ '#609fda', 4 ]
" let s:magenta = [ '#cc84ad', 5 ]
" let s:cyan =    [ '#3dab95', 6 ]
" let s:white =   [ '#919ab9', 7 ]

" let s:brightblack =   [ '#352f49', 0 ]
" let s:brightred =     [ '#eb7b4d', 1 ]
" let s:brightgreen =   [ '#57ad47', 2 ]
" let s:brightyellow =  [ '#bd951a', 3 ]
" let s:brightblue =    [ '#8196e8', 4 ]
" let s:brightmagenta = [ '#c97ed7', 5 ]
" let s:brightcyan =    [ '#2aa9b6', 6 ]
" let s:brightwhite =   [ '#a0abae', 7 ]

" let s:fg =      [ '#a0abae', 15 ]
" let s:bg =      [ '#202c3d', 0 ]
" let s:fgalt =   [ '#919ab9', 7 ]
" let s:bgalt =   [ '#352f49', 8 ]

" let s:verywhite =    [ '#dadada', 253 ]
" let s:superwhite =    [ '#eeeeee', 255 ]

" let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'visual': {}, 'replace': {}, 'tabline': {}}
" let s:p.normal.left = [ [ s:superwhite, s:green ] ]
" let s:p.normal.right = [ [ s:verywhite, s:bg ], [ s:verywhite, s:bg ] ]
" let s:p.normal.middle = [ [ s:fgalt, s:bg ] ]
" let s:p.normal.error = [ [ s:fgalt, s:red ] ]
" let s:p.normal.warning = [ [ s:fgalt, s:yellow ] ]
" let s:p.insert.left = [ [ s:superwhite, s:blue ] ]
" let s:p.visual.left = [ [ s:superwhite, s:cyan ] ]
" let s:p.replace.left = [ [ s:superwhite, s:magenta ] ]
" let s:p.tabline.left = [ [ s:verywhite, s:bg ] ]
" let s:p.tabline.tabsel = [ [ s:bg, s:fgalt ] ]
" let s:p.tabline.middle = [ [ s:fgalt, s:bg ] ]
" let s:p.tabline.right = copy(s:p.normal.right)
" let s:p.inactive.left =  [ [ s:bg, s:fgalt ] ]
" let s:p.inactive.right = [ [ s:bg, s:fgalt ], [ s:bg, s:fgalt ] ]
" " let s:p.insert.left = [ [ s:bgalt, s:green ], [ s:bgalt, s:bgalt ] ]
" " let s:p.replace.left = [ [ s:bgalt, s:red ], [ s:bgalt, s:bgalt ] ]
" " let s:p.visual.left = [ [ s:bgalt, s:magenta ], [ s:bgalt, s:bgalt ] ]
" " let s:p.inactive.middle = [ [ s:bgalt, s:bgalt ] ]
" " let s:p.tabline.left = [ [ s:bgalt, s:bgalt ] ]
" " let s:p.tabline.tabsel = [ [ s:bgalt, s:bgalt ] ]
" " let s:p.tabline.middle = [ [ s:bgalt, s:bgalt ] ]
" " let s:p.tabline.right = copy(s:p.normal.right)
" " let s:p.normal.error = [ [ s:bgalt, s:red ] ]
" " let s:p.normal.warning = [ [ s:bgalt, s:yellow ] ]

" let g:lightline#colorscheme#tempus_summer#palette = lightline#colorscheme#flatten(s:p)

" let g:lightline = {
"   \ 'colorscheme': 'tempus_summer',
"   \ 'subseparator': { 'left': '|', 'right': '|' },
"   \ 'active': {
"   \   'left': [ ],
"   \   'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'readonly' ], [ 'mode' ] ]
"   \ },
"   \ 'component_function': {
"   \   'mode': 'LightlineMode',
"   \   'fugitive': 'LightlineFugitive',
"   \   'filename': 'LightlineFilename',
"   \   'currentfunction': 'CocCurrentFunction',
"   \   'nearestfunction': 'CocNearestFunction',
"   \   'fileformat': 'LightlineFileformat',
"   \   'fileencoing': 'LightlineFileencoding',
"   \   'filetype': 'LightlineFiletype'
"   \ },
"   \ 'component_expand': {
"   \   'buffers': 'lightline#bufferline#buffers',
"   \   'linter_warnings': 'LightlineCocWarnings',
"   \   'linter_errors': 'LightlineCocErrors',
"   \   'linter_infos': 'LightlineCocInfos',
"   \   'linter_hints': 'LightlineCocHints'
"   \ },
"   \ 'tabline': {
"   \   'left': [ [ 'tabs' ] ],
"   \   'right': [ [ 'close' ], [ 'buffers' ] ]
"   \ },
"   \ 'tab': {
"   \   'active': [ 'tabnum', 'modified' ],
"   \   'inactive': [ 'tabnum', 'modified' ]
"   \ },
"   \ 'component_type': {
"   \   'readonly': 'error',
"   \   'linter_warnings': 'warning',
"   \   'linter_errors': 'error',
"   \   'linter_infos': 'tabsel',
"   \   'linter_hints': 'middle',
"   \   'buffers': 'tabsel'
"   \ },
"   \ 'enable': {
"   \   'statusline': 1,
"   \   'tabline': 1
"   \ }
"   \}

" " Lightline component definitions.
" function! CocCurrentFunction()
"   return get(b:, 'coc_current_function', '')
" endfunction
" function! CocNearestFunction()
"   return get(b:, 'vista_nearest_method_or_function', '')
" endfunction
" function! LightlineModified()
"   return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
" endfunction
" function! LightlineReadonly()
"   return &ft !~? 'help' && &readonly ? 'RO' : ''
" endfunction
" function! LightlineCocErrors() abort
"   return s:lightline_coc_diagnostic('error', 'error')
" endfunction
" function! LightlineCocWarnings() abort
"   return s:lightline_coc_diagnostic('warning', 'warning')
" endfunction
" function! LightlineCocInfos() abort
"   return s:lightline_coc_diagnostic('information', 'info')
" endfunction
" function! LightlineCocHints() abort
"   return s:lightline_coc_diagnostic('hints', 'hint')
" endfunction
" function! LightlineFilename()
"   let fname = expand('%:t')
"   return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
"         \ fname == '__Tagbar__' ? g:lightline.fname :
"         \ fname =~ '__Gundo\|NERD_tree' ? '' :
"         \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
"         \ &ft == 'unite' ? unite#get_status_string() :
"         \ &ft == 'vimshell' ? vimshell#get_status_string() :
"         \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
"         \ ('' != fname ? fname : '[No Name]') .
"         \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
" endfunction
" function! LightlineFugitive()
"   try
"     if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
"       let mark = ''  " edit here for cool mark
"       let branch = fugitive#head()
"       return branch !=# '' ? mark.branch : ''
"     endif
"   catch
"   endtry
"   return ''
" endfunction
" function! LightlineFileformat()
"   return winwidth(0) > 70 ? &fileformat : ''
" endfunction
" function! LightlineFiletype()
"   return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
" endfunction
" function! LightlineFileencoding()
"   return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
" endfunction
" function! LightlineMode()
"   let fname = expand('%:t')
"   return fname == '__Tagbar__' ? 'Tagbar' :
"         \ fname == 'ControlP' ? 'CtrlP' :
"         \ fname == '__Gundo__' ? 'Gundo' :
"         \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
"         \ fname =~ 'NERD_tree' ? 'NERDTree' :
"         \ &ft == 'unite' ? 'Unite' :
"         \ &ft == 'vimfiler' ? 'VimFiler' :
"         \ &ft == 'vimshell' ? 'VimShell' :
"         \ winwidth(0) > 60 ? lightline#mode() : ''
" endfunction
" function! s:lightline_coc_diagnostic(kind, sign) abort
"   let info = get(b:, 'coc_diagnostic_info', 0)
"   if empty(info) || get(info, a:kind, 0) == 0
"     return ''
"   endif
"   if a:sign == 'error'
"     let s = g:coc_status_error_sign
"   elseif a:sign == 'warning'
"     let s = g:coc_status_warning_sign
"   elseif a:sign == 'info'
"     let s = g:coc_status_info_sign
"   elseif a:sign == 'hint'
"     let s = g:coc_status_hint_sign
"   else
"     let s = ''
"   endif
"   return printf('%s %d', s, info[a:kind])
" endfunction

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
augroup setup_lightline
  autocmd!
  autocmd BufWritePost,TextChanged,TextChangedI * call s:MaybeUpdateLightline()
  " autocmd User CocDiagnosticChange call lightline#update()
augroup END
  
" Reload lightline on demand.
function! s:LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction
command! SetupLightline :call <SID>LightlineReload()

" Bufferline.
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#right_aligned = 1
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#number_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
  \ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'
\}

" Kwbd - a better 'bd': close buffer without closing window.
cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Kwbd' : 'bd')<cr>

" Autocomplete (for vim-lsp, etc.).
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 100

" vim-lsp & vim-lsp-settings.
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/.local/share/nvim/lsp/vim-lsp.log')
" let g:lsp_settings_servers_dir = expand('~/.local/share/nvim/lsp/')
" let g:lsp_completion_resolve_timeout = 10
" let g:lsp_diagnostics_echo_cursor = 1
" let g:lsp_virtual_text_enabled = 0
" let g:lsp_diagnostics_enabled = !&diff
" augroup lsp_diag_diff
"   autocmd!
"   autocmd OptionSet diff let g:lsp_diagnostics_enabled = !&diff
" augroup END

" vim-devicons.
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
"let g:WebDevIconsNerdTreeAfterGlyphPadding = ''
let g:WebDevIconsOS = 'Darwin'

" NERDTree.
let g:NERDTreeBookmarksFile = expand('~/.config/local/vim/nerdtree/bookmarks')
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoCenter = 1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeWinSize = 45
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

" Startify.
function! s:SortByChangedTickDesc(buf1, buf2)
  return -1 * 
        \ a:buf1.changedtick > a:buf2.changedtick ? 1 :
        \ a:buf1.changedtick < a:buf2.changedtick ? -1 :
        \ 0
endfunction
function! s:BufInfoToStartifyLine(key, value)
  let buf = a:value
  let name = len(buf.name) > 0 ? buf.name : '[No Name]'
  return { 'line': name, 'cmd': 'buffer ' .. buf.bufnr }
endfunction
function! s:ListBuffersByChangedTickDesc()
  let buffers = getbufinfo({'buflisted': 1}) 
  let buffers = sort(buffers, 's:SortByChangedTickDesc')
  return map(buffers, function('s:BufInfoToStartifyLine'))
endfunction
let g:startify_change_to_dir = 0
let g:startify_files_number = 7
let g:startify_enable_special = 0
" let g:startify_custom_header = [
"   \ '            _          ',
"   \ '    _   __ (_)____ ___ ',
"   \ '   | | / // // __ `__ \',
"   \ '   | |/ // // / / / / /',
"   \ '   |___//_//_/ /_/ /_/ ',
"   \ ' ',
" \ ]
let g:startify_lists = [
  \ { 'type': function('s:ListBuffersByChangedTickDesc'), 'header': ['   Buffers']        },
  \ { 'type': 'dir',                                      'header': ['   Files']          },
  \ { 'type': 'sessions',                                 'header': ['   Sessions']       },
  \ { 'type': 'bookmarks',                                'header': ['   Bookmarks']      },
  \ { 'type': 'commands',                                 'header': ['   Commands']       },
\ ]
function! s:SetupStartify()
  nnoremap <buffer> o <plug>(startify-open-buffers)
  nnoremap <buffer> e :EditVifm<cr>
endfunction
autocmd User Startified :call s:SetupStartify()

" Cursorcross.
let g:cursorcross_no_map_CR=1
let g:cursorcross_mappings=0

" Vimwiki.
let g:vimwiki_list = [{
  \ 'path': $HOME .. '/wiki',
  \ 'path_html': $HOME .. 'wiki/dist',
  \ 'auto_toc': 1,
  \ 'auto_tags': 1,
  \ 'auto_diary_index': 1,
  \ 'diary_rel_path': 'journal/',
  \ 'diary_index': 'journal',
  \ 'diary_header': 'Journal',
\ }]
" let g:vimwiki_listsym_rejected = '✗'
let g:vimwiki_listsyms = ' ○◐●✓'
let g:vimwiki_use_mouse = 1
let g:vimwiki_folding = 'expr'

" Goyo.
let g:goyo_width = '60%'
let g:goyo_height = '90%'
function! s:goyo_enter()
  setlocal nonumber norelativenumber
endfunction

function! s:goyo_leave()
  setlocal number relativenumber
endfunction

augroup setup_goyo
  autocmd!
  autocmd User GoyoEnter nested call <SID>goyo_enter()
  autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

" markdown-preview.nvim
"let g:mkdp_browser = 'Chrome'

" vim-orgmode
let g:org_heading_shade_leading_stars=1
let g:org_indent=0
let g:org_aggressive_conceal=1
if isdirectory(expand('~/notes'))
  let g:org_agenda_files = ['~/notes/*.org']
endif

" clever-f
"let g:clever_f_chars_match_any_signs = ':'

" Far
let g:far#source = 'rg'
noremap <localleader>f :F<space>
noremap <localleader>r :Far<space>

" Peekaboo
let g:peekaboo_window = "vert bo 65new"

" Exchange
" nnoremap cxc <Plug>(ExchangeClear)
" nnoremap cxx <Plug>(ExchangeLine)

" QF
" Enable ack-style mappings:
"  s - open entry in a new horizontal window
"  v - open entry in a new vertical window
"  t - open entry in a new tab
"  o - open entry and come back
"  O - open entry and close the location/quickfix window
"  p - open entry in a preview window
let g:qf_mapping_ack_style=1

" Smooth scrolling.
let g:SexyScroller_MinLines = 50
let g:SexyScroller_MinColumns = 200

" Plugin registry ---------------------------------------------------------{{{1

" NOTE: I try to keep this list pretty trimmed-down to lower the disk and memory
" footprint.

" Plug. 
"  execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" Favorite/essential plugins.
"  clever-f   = repeat f, F, t, or T more than once
"  commentary = advanced comment/uncomment with motions
"  delimitmate = automatic closing of quotes/parens/brackets/etc.
"  eunuch = vim sugar for unix shell commands
"  far        = find and replace
"  fzf        = fuzzy finder (cli integration)
"  kwbd       = don't close a window on last buffer close
"  paraglide  = better paragraph forward/backward
"  qf         = quickfix window powertools
"  surround   = operate on surrounding quotes/parens/brackets/etc.
"  targets    = adds lots of text targets
"  unimpaired = bracket aliases like ]a, ]q, ]b, etc.
"  vifm       = file explorer (cli integration)
"  vinegar    = better netrw
Plug 'asheq/close-buffers.vim'
Plug 'brooth/far.vim'
Plug 'camflint/vim-paraglide'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'mattesgroeger/vim-bookmarks'
Plug 'raimondi/delimitmate'
Plug 'rgarver/kwbd.vim'
Plug 'rhysd/clever-f.vim'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vifm/vifm.vim'
Plug 'wellle/targets.vim'

" Themes.
"Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
"Plug 'drewtempelmeyer/palenight.vim'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'rakr/vim-one'
"Plug 'morhetz/gruvbox'
"Plug 'tomasr/molokai'
Plug 'humanoid-colors/vim-humanoid-colorscheme'
Plug 'nice/sweater'
Plug 'zanglg/nova.vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'wimstefan/vim-artesanal'
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'

" Aesthetics.
Plug 'mhinz/vim-startify'
Plug 'ap/vim-css-color'
"Plug 'dougbeney/pickachu'

" Productivity.
"Plug 'itchyny/calendar.vim'
"Plug 'jceb/vim-orgmode'
"Plug 'mzlogin/vim-markdown-toc'

" Syntax and filetypes.
Plug 'sheerun/vim-polyglot'
Plug 'hiphish/info.vim'
Plug 'jparise/vim-graphql'
Plug 'plasticboy/vim-markdown'
Plug 'camflint/vim-superman'
"Plug 'vimwiki/vimwiki'

" Shell/environment integrations.
Plug 'christoomey/vim-tmux-navigator'
Plug 'knubie/vim-kitty-navigator'

" LSP and autocompletion.
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --ts-completer --cs-completer --go-completer' }
Plug 'Chiel92/vim-autoformat'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'

" IDE.
"Plug 'preservim/nerdtree'
"Plug 'puremourning/vimspector', {'for': ['typescript', 'javascript']}

" Other/infrequently used.
"  fugitive = git client
"  grepper = binary-agnostic :Grepper command
"  obsession = session management
"  rhubarb = github extras like :GBrowse
"  patternsontext = advanced substitution commands
"  diffconflicts = convert file with conflict markers into 2-way diff
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'inkarkat/vim-PatternsOnText'
Plug 'inkarkat/vim-ingo-library'
Plug 'whiteinge/diffconflicts'
Plug 'rhysd/conflict-marker.vim'

"Plug 'fcpg/vim-navmode'
"Plug 'junegunn/goyo.vim'
"Plug 'junegunn/vim-peekaboo'
"Plug 'mhinz/vim-grepper'

" Note: this needs to come last in the plugin list.
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Theme activation --------------------------------------------------------{{{1

" Background transparency.
"hi Normal guibg=NONE ctermbg=NONE

" Dracula pro.
" packadd! dracula_pro
" let g:dracula_colorterm = 0
" colorscheme dracula_pro

" Gruvbox.
" let g:gruvbox_bold=1
" let g:gruvbox_italic=1
" let g:gruvbox_underline=1
" let g:gruvbox_contrast_light = 'hard'
" colorscheme gruvbox

" Other.
"colorscheme humanoid
"colorscheme sweater
"colorscheme nova
"colorscheme papercolor
"colorscheme artesanal

" Seoul 256.
let g:seoul256_srgb = 1
colorscheme seoul256

set background=dark

" Theme fixups for Clap.
hi default link ClapCurrentSelection PmenuSel
hi default link ClapCurrentSelectionSign PmenuSel
hi default link ClapDefaultCurrentSelection PmenuSel
hi default link ClapDefaultPreview Normal
hi default link ClapDefaultSelected Normal
hi default link ClapDefaultShadow Normal
hi default link ClapDisplay Pmenu
hi default link ClapFile Pmenu
hi default link ClapPreview Visual
hi default link ClapInput Pmenu
hi default link ClapFuzzyMatches1 Normal
hi default link ClapFuzzyMatches10 Normal
hi default link ClapFuzzyMatches11 Normal
hi default link ClapFuzzyMatches12 Normal
hi default link ClapFuzzyMatches2 Normal
hi default link ClapFuzzyMatches3 Normal
hi default link ClapFuzzyMatches4 Normal
hi default link ClapFuzzyMatches5 Normal
hi default link ClapFuzzyMatches6 Normal
hi default link ClapFuzzyMatches7 Normal
hi default link ClapFuzzyMatches8 Normal
hi default link ClapFuzzyMatches9 Normal
