" Basic options -----------------------------------------------------------{{{1
" Self-explanatory defaults.
set encoding=utf-8
set textwidth=120
set autoindent
set cursorline
set ruler
set mouse=a
set showmatch

" Backup settings.
set swapfile
set directory^=~/.local/share/vim/backup//
set writebackup
set nobackup
set backupcopy=auto

" Undo persistence.
set undofile
set undodir^=~/.local/share/vim/undo//

" Indentation rules (defaults).
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" Folding rules (defaults).
set foldmethod=indent
set foldnestmax=10
set foldlevel=2
set foldlevelstart=2
set nofoldenable

" Show certain invisibles.
set list
set listchars=tab:

" Performance tweaks.
set lazyredraw

" Keyword completion (autocomplete).
set complete-=i  " Don't search include files for every keyword completion.

" Make sure backspace/delete work as expected in INSERT mode.
set backspace=indent,eol,start

" Don't beep.
set visualbell

" Line numbers.
set number relativenumber

" Basic status bar visual options.
set showmode
set showcmd

" Always show the status bar, because I use the status bar as a bufferline.
set laststatus=2
set showtabline=2

" Make sure we can always see 3 lines of context around the cursor.
set scrolloff=3

" Allow switching away from a dirty buffer without saving.
set hidden

" More natural split opening.
set splitright
set splitbelow

" Search.
set ignorecase smartcase " ignore case unless mixed case is present in search query
set gdefault             " global substitution is default
set incsearch

" Show tab suggestions in the command bar.
set wildmenu
set wildmode=full
set wildcharm=<Tab>
set wildignore+=*/node_modules/*,*.swp,*.*~

" Visually indent wrapped lines, with a ↳ symbol prefixed.
set breakindent
set breakindentopt=shift:2
set showbreak=↳

" Smart comment formatting (gq).
set formatoptions=croqj

" Fix: number/relativenumber in Goyo
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END

" Help window positioning.
set helpheight=9999
augroup vert_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" Better man pages (when viewed with K or :Man <topic>).
runtime ftplugin/man.vim
set keywordprg=:Man

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
      \ :call system("tmux resize-pane -Z") \|
      \ :call system("tmux send-keys -t:.1 '\\s' 'c-l'")<cr>

" Color scheme & themes ---------------------------------------------------{{{1
" Use 256-color by default.
if !has('gui_running')
  set t_Co=256
endif

" 'termguicolors' works in consoles with 24-bit (RGB) color support only.  When set, 'termguicolors' instructs vim to
" issue RGB color escape codes with the colors from gui, guifg, guibg etc. (see :help :highlight).
if exists('+termguicolors') && $TERM !~# '^\%(screen\|tmux|rxvt\)'
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
else
  set notermguicolors
endif

" Base16 colorscheme.
function! s:base16_customize() abort
  " Use italic for comments.
  hi! Comment cterm=italic gui=italic

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

  call <SID>LightlineReload()
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call <SID>base16_customize()
augroup END

" See the very bottom of this file for the code that actually triggers the theme.


" Filetype customization --------------------------------------------------{{{1

" Filetype: javascript
function! s:setup_filetype_javascript()
  call <SID>setup_js_ts_snippets()
endfunction

" Filetype: json
function! s:setup_filetype_json()
  syntax match Comment +\/\/.\+$+
endfunction

" Filetype: markdown
function! s:setup_filetype_markdown()
  " Don't autoformat (esp. autowrap) text in some files.
  autocmd FileType markdown setlocal formatoptions-=c | setlocal textwidth=0
endfunction

" Filetype: org
function! s:setup_filetype_org()
  setlocal foldenable
  call <SID>setup_org_mode_mappings()
endfunction

" Filetype: typescript
function! s:setup_filetype_typescript()
  " makeprg
  let l:root = findfile('tsconfig.json', expand('%:p:h').';')
  let &makeprg = 'tsc -p ' . fnameescape(l:root)
endfunction

" Filetype: vim
function! s:setup_filetype_vim()
  setlocal foldenable
  setlocal foldmethod=marker
  setlocal foldlevelstart=0
  setlocal foldlevel=0
  setlocal textwidth=80
endfunction

augroup setup_filetypes
  autocmd!
  autocmd FileType javascript,typescript :call <SID>setup_filetype_javascript()
  autocmd FileType json                  :call <SID>setup_filetype_json()
  autocmd FileType markdown              :call <SID>setup_filetype_markdown()
  autocmd FileType org                   :call <SID>setup_filetype_org()
  autocmd FileType typescript            :call <SID>setup_filetype_typescript()
  autocmd FileType vim                   :call <SID>setup_filetype_vim()
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

" Folding.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <space> zA
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

" Move lines up and down.
nnoremap - ddp
nnoremap _ ddkP

" Command-mode history shortcuts (avoid using arrow keys).
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

" Disable arrow keys (no cheating!)
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

" Shortcut to close all temporary windows, turn off highlighting, and otherwise reset editing state.
nnoremap <localleader>l :noh<cr> \|
\ :cclose<cr> \|
\ :lclose<cr> \|
\ <plug>(ExchangeClear) \|
\ <plug>(lsp-preview-close) \|
\ <plug>(clever-f-reset)

" Shortcut to temporarily enable 'hlsearch' only when typing the search query.
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Copy/paste shortcuts.
" Don't move cursor after yanking. Related tip: use Ctrl+O to toggle between top and bottom of a visual selection.
xmap y ygv<esc>                               |" Don't move cursor after yanking.
map <localleader>yy "+y                       |" Yank to system clipboard.
map <localleader>pp "+[p                      |" Paste from the system clipboard, performing indentation.
map <localleader>yb :let @+=expand('%:p')<CR> |" Put current buffer path onto system clipboard.

" Buffer management.
nnoremap <localleader><tab> :Buffers<cr>
nnoremap <leader>b :Buffers<cr>

nnoremap <localleader>bo :Bdelete other<cr>
nnoremap <localleader>bc :Bdelete this<cr>
nnoremap <localleader>bx :Bdelete all<cr>
nnoremap <localleader>bi :Bdelete select<cr>

nnoremap <leader>r :FZFMru<cr>

" Buffer number keys.
nnoremap <localleader>1 <Plug>lightline#bufferline#go(1)
nnoremap <localleader>2 <Plug>lightline#bufferline#go(2)
nnoremap <localleader>3 <Plug>lightline#bufferline#go(3)
nnoremap <localleader>4 <Plug>lightline#bufferline#go(4)
nnoremap <localleader>5 <Plug>lightline#bufferline#go(5)
nnoremap <localleader>6 <Plug>lightline#bufferline#go(6)
nnoremap <localleader>7 <Plug>lightline#bufferline#go(7)
nnoremap <localleader>8 <Plug>lightline#bufferline#go(8)
nnoremap <localleader>9 <Plug>lightline#bufferline#go(9)
nnoremap <localleader>0 <Plug>lightline#bufferline#go(10)

" Tab management.
"nnoremap <localleader><tab> :tabnext<cr>

" Split management.
nnoremap <localleader>s- <C-w>s<C-w>j                                             |" Split vertically.
nnoremap <localleader>s<pipe> <C-w>v<C-w>l                                        |" Split horizontally.
nnoremap <localleader>s\ <C-w>v<C-w>l                                             |" Split horizontally (lazy fingers).
nnoremap <localleader>sx <C-w>q                                                   |" Kill split.
nnoremap <localleader>so <C-w>o                                                   |" Kill other splits ("only").
nnoremap <localleader>sz <C-w>\|<C-w>_                                            |" Zoom split.
nnoremap <localleader>s= :set equalalways<cr> \| <C-w>= \| :set noequalalways<cr> |" Distribute splits.
augroup split_resize
  autocmd!
  autocmd VimResized * wincmd =                                                   |" Redistribute windows when the client is resized.
augroup END

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
nnoremap <localleader>ss <C-c>:call WinBufSwap()<cr> |" Swap this and the last window.

" Home screen.
nnoremap <leader>h :Startify<cr>

" Fuzzy file finders.
nnoremap <c-p> :Files <c-r>=getcwd()<cr><cr>
nnoremap <m-p> :Files <c-r>=expand('%:h')<cr><cr>
nnoremap <leader>f :Files <c-r>=getcwd()<cr><cr>

" Project search.
nnoremap <c-s> :Grepper -tool rg<cr>
nnoremap <localleader>* :Grepper -tool rg -cword -noprompt<cr>

" File explorers.
nnoremap <leader>s <cmd>MyToggleNERDTree<cr>
nnoremap <leader>e :EditVifm<cr>

" Symbol explorers.
nnoremap <leader>o :Vista vim_lsp<cr>

" Intellisense (LSP) mappings.
function! s:setup_vim_lsp_keymaps()
  " Having serious performance issues with folding.
  "   https://github.com/prabirshrestha/vim-lsp/issues/671
  " set foldmethod=expr
  "   \ foldexpr=lsp#ui#vim#folding#foldexpr()
  "   \ foldtext=lsp#ui#vim#folding#foldtext()

  setlocal omnifunc=lsp#complete
  setlocal completeopt+=preview

  augroup lsp_close_popup
    autocmd!
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  augroup END
  
  "inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : lsp#complete()
  inoremap <expr> <cr>  pumvisible() ? "\<C-y>" : "\<cr>"
  inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
  inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

  function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ asyncomplete#force_refresh()

  if has("gui_running")
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  endif
  
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
  map <buffer> <localleader>gf <plug>(lsp-document-range-format)
endfunction
augroup myvimlsp
  autocmd!
  autocmd User lsp_buffer_enabled call <SID>setup_vim_lsp_keymaps()
augroup end
command! LspRefresh call <SID>setup_vim_lsp_keymaps()

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
nnoremap <Leader>mm <Plug>BookmarkToggle
nnoremap <Leader>mi  <Plug>BookmarkAnnotate
nnoremap <Leader>ma <Plug>BookmarkShowAll
nnoremap <Leader>mj <Plug>BookmarkNext
nnoremap <Leader>mk <Plug>BookmarkPrev
nnoremap <Leader>mc <Plug>BookmarkClear
nnoremap <Leader>mx <Plug>BookmarkClearAll
map <leader><leader>mj <Plug>BookmarkMoveDown
map <leader><leader>mk <Plug>BookmarkMoveUp

" Invoke Goyu for a distraction-free writing environment.
nnoremap <leader>q :Goyo<cr>
 
" Invoke Easymotion for rapid movement.
map <space> <Plug>(easymotion-prefix)

" Enter navmode for less-like scrolling.
nnoremap \n :call Navmode()<cr>

" Open the quickfix window.
nnoremap <localleader>q :copen<cr>

" Get hints on key sequences after a timeout, using vim-whichkey.  Needs to be kept in sync with the prefixes used in
" above mappings.
" nnoremap <silent> <leader> :<c-u>WhichKey '\'<cr>
" nnoremap <silent> <localleader> :<c-u>WhichKey ','<cr>
" nnoremap <silent> <leader>m :<c-u>WhichKey 'm'<cr>
" nnoremap <silent> <leader>f :<c-u>WhichKey '\f'<cr>
" nnoremap <silent> <leader>v :<c-u>WhichKey '\v'<cr>
" nnoremap <silent> <leader>y :<c-u>WhichKey '\y'<cr>
" nnoremap <silent> <leader>p :<c-u>WhichKey '\p'<cr>
" nnoremap <silent> <leader>w :<c-u>WhichKey '\v'<cr>
" nnoremap <silent> <leader>s :<c-u>WhichKey '\s'<cr>
" nnoremap <silent> <leader>q :<c-u>WhichKey '\k'<cr>

" Orgmode mappings.
function! s:setup_org_mode_mappings()
  nmap <buffer><silent> <localleader>1 <Cmd>OrgAgendaTimeline<CR>
  nmap <buffer><silent> <localleader>2 <Cmd>OrgAgendaTodo<CR>
  nmap <buffer><silent> <localleader>3 <Cmd>OrgAgendaWeek<CR>

  imap <buffer><silent> <c-m-h> <C-O><Plug>OrgDemoteOnHeadingInsert<CR>
  imap <buffer><silent> <c-m-l> <C-O><Cmd><Plug>OrgPromoteOnHeadingInsert<CR>
  imap <buffer><silent> <m-h> <Plug>OrgNewHeadingBelowAfterChildrenNormal<CR>
  imap <buffer><silent> <m-i> <C-O><Cmd>OrgPlainListItemNewBelow<CR>
  imap <buffer><silent> <m-I> <C-O><Cmd>OrgPlainListItemNewAbove<CR>
  imap <buffer><silent> <m-c> <C-O><Cmd>OrgCheckBoxNewBelow<CR>
  imap <buffer><silent> <m-C> <C-O><Cmd>OrgCheckBoxNewAbove<CR>
  imap <buffer><silent> <m-x> <C-O><Cmd>OrgCheckBoxToggle<CR>
  imap <buffer><silent> <m-d> <C-O><Cmd>OrgDateInsertTimestampActiveCmdLine<CR>
  imap <buffer><silent> <m-l> <C-O><Cmd>OrgHyperlinkInsert<CR>
  imap <buffer><silent> <m-t> <C-O><Cmd>OrgSetTags<CR>
endfunction
command! SetupOrgModeMappings :call <SID>setup_org_mode_mappings()

" Text snippets -----------------------------------------------------------{{{1
" A syntax for placeholders
" Pressing CTRL-n jumps to the next match.
inoremap <c-n> <Esc>/<++><CR><Esc>cf>

" Insert datetime.
inoremap <C-d> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

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

" Fzf-mru.
let g:fzf_mru_no_sort = 1

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

" Pydoc.
let g:pydoc_window_lines=0.5

" Tabularize.
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

" Bookmarks .
let g:bookmark_auto_save_file = expand('~/.local/share/vim/bookmarks/.vim-bookmarks')
let g:bookmark_auto_close = 1
let g:bookmark_center = 1
let g:bookmark_disable_ctrlp = 1
let g:bookmark_show_warning = 0
let g:bookmark_show_toggle_warning = 0
let g:bookmark_save_per_working_dir = 1
let g:bookmark_auto_save = 1

" COC.

" COC plugins.
" let g:coc_global_extensions = [
" \  'coc-explorer',
" \  'coc-git',
" \  'coc-gitignore',
" \ ]

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
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
" nnoremap <silent> K :call <SID>show_documentation()<CR>

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

" Lightline.
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

" Lightline component definitions.
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
augroup setup_lightline
  autocmd!
  autocmd BufWritePost,TextChanged,TextChangedI * call s:MaybeUpdateLightline()
  autocmd User CocDiagnosticChange call lightline#update()
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

" Vista.
let g:vista_default_executive = 'vim_lsp'
let g:vista_finder_alternative_executives = ['ctags']
let g:vista_fzf_preview = ['right:50%']
let g:vista_sidebar_width= 47
let g:vista_echo_cursor_strategy = 'scroll'
let g:vista#renderer#enable_icon = 1
augroup filetype_vista
  autocmd!
  autocmd FileType vista,vista_kind nnoremap <buffer><silent> / :<c-u>call vista#finder#fzf#Run(g:vista_default_executive)<cr>
augroup end

" Autocomplete (various).
let g:asyncomplete_auto_popup = 0
let g:asyncomplete_popup_delay = 100

" vim-lsp & vim-lsp-settings.
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.local/share/nvim/lsp/vim-lsp.log')
let g:lsp_settings_servers_dir = expand('~/.local/share/nvim/lsp/')
let g:lsp_completion_resolve_timeout = 10
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 0

" NERDTree.
let g:NERDTreeBookmarksFile = expand('~/.config/local/vim/nerdtree/bookmarks')
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeAutoCenter = 1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeWinSize = 75
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

" Startify.
let g:startify_change_to_dir = 0
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Cursorcross.
let g:cursorcross_no_map_CR=1
let g:cursorcross_mappings=0

" Vimwiki.
" let g:vimwiki_list = [{
"   \ 'path': '$HOME/notes',
"   \ 'path_html': '$HOME/notes/dist'
"   \ }]
" let g:vimwiki_listsym_rejected = '✗'
" let g:vimwiki_use_mouse = 1
" let g:vimwiki_folding = 'syntax'

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

augroup setup_goyo
  autocmd!
  autocmd User GoyoEnter nested call <SID>goyo_enter()
  autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

" vim-markdown-preview.
let vim_markdown_preview_hotkey = '<C-m>'
let vim_markdown_preview_browser = 'Firefox'
let vim_markdown_preview_github = 1

" vim-orgmode
let g:org_heading_shade_leading_stars=1
let g:org_indent=1
let g:org_aggressive_conceal=1
if isdirectory(expand('~/notes'))
  let g:org_agenda_files = ['~/notes/*.org']
endif

" clever-f
let g:clever_f_chars_match_any_signs = ';'

" Far
let g:far#source = 'rg'
noremap <localleader>f :F<space>
noremap <localleader>r :Far<space>

" Peekaboo
let g:peekaboo_window = "vert bo 65new"

" Exchange
" nnoremap cxc <Plug>(ExchangeClear)
" nnoremap cxx <Plug>(ExchangeLine)

" Plugin registry ---------------------------------------------------------{{{1

" Plug. 
"  execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" Essential plugins.
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'asheq/close-buffers.vim'
Plug 'brooth/far.vim'
Plug 'camflint/vim-superman'
Plug 'chriskempson/base16-vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'faceleg/delete-surrounding-function-call.vim'
Plug 'fcpg/vim-navmode'
Plug 'godlygeek/tabular'
Plug 'hiphish/info.vim'
Plug 'inkarkat/vim-PatternsOnText'
Plug 'inkarkat/vim-ingo-library'
Plug 'itchyny/calendar.vim'
Plug 'itchyny/lightline.vim'
Plug 'jceb/vim-orgmode'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'mattn/vim-lsp-settings'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
Plug 'mtth/cursorcross.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector', {'for': ['typescript', 'javascript']}
Plug 'raimondi/delimitmate'
Plug 'rgarver/kwbd.vim'
Plug 'rhysd/clever-f.vim'
Plug 'romainl/vim-qf'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-exchange'
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

" nvim-only plugins.
if has('nvim')
  Plug 'shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()

" This color scheme setup relies on a base16-shell alias having been run to modify the shell's 256-color palette. Doing
" so should generate the following file for vim. Make sure this statement comes last, as our customization hook higher
" in the file depends on plugins being loaded.
if filereadable(expand('~/.vimrc_background'))
  let base16colorspace=256
  source ~/.vimrc_background
endif
