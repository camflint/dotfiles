" Basic options -----------------------------------------------------------{{{1
" Self-explanatory defaults.
set encoding=utf-8
set textwidth=120
set autoindent
set cursorline
set noruler
set showmatch

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

" Update swapfile more frequently to prevent long delays (?).
set updatetime=300

" Make sure backspace/delete work as expected in INSERT mode.
set backspace=indent,eol,start

" Don't beep.
set visualbell

" Line numbers.
set number relativenumber

" Basic status bar visual options.
set showmode
set showcmd

" Give more space for displaying messages.
set cmdheight=2

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
    " let buflist = tabpagebuflist(i)
    " let winnr = tabpagewinnr(i)
    let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    let s .= '%' . i . 'T'
    " let s .= (i == t ? '%1*' : '%2*')
    let s .= ' '
    let s .= i
    " let s .= i . ':'
    " let s .= winnr . '/' . tabpagewinnr(i,'$')
    " let s .= ' %*'
    " let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
    " let bufnr = buflist[winnr - 1]
    " let file = bufname(bufnr)
    " let buftype = getbufvar(bufnr, 'buftype')
    " if buftype == 'nofile'
    "   if file =~ '\/.'
    "     let file = substitute(file, '.*\/\ze.', '', '')
    "   endif
    " else
    "   let file = fnamemodify(file, ':p:t')
    " endif
    " if file == ''
    "   let file = '[No Name]'
    " endif
    " let s .= file
    let s .= '%T '
    let i = i + 1
  endwhile
  let s .= '%#TabLine#'
  " let s .= (tabpagenr('$') > 1 ? ' %999XX ' : ' X ')
  return s
endfunction
set showtabline=1
set tabline=%!MyTabLine()

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
" <TODO>

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

" Base16 colorscheme.
function! s:base16_customize() abort
  if trim(execute('colorscheme')) !~ 'base16'
    return
  endif

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

" augroup on_change_colorschema
"   autocmd!
"   autocmd ColorScheme * call <SID>base16_customize()
" augroup END

" See the very bottom of this file for the code that actually triggers the theme.

" Filetype customization --------------------------------------------------{{{1

function! s:setup_code_general()
  " YouCompleteMe mappings.
  nnoremap <buffer> gd :YcmCompleter GoToDefinition<cr>
  nnoremap <buffer> gc :YcmCompleter GoToDeclaration<cr>
  nnoremap <buffer> gi :YcmCompleter GoToImplementation<cr>
  nnoremap <buffer> gt :YcmCompleter GoToType<cr>
  nnoremap <buffer> gr :YcmCompleter GoToReferences<cr>
  nnoremap <buffer> gh :YcmCompleter GetDoc<cr>
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

augroup setup_filetypes
  autocmd!
  autocmd FileType javascript,typescript :call <SID>setup_filetype_javascript()
  autocmd FileType json                  :call <SID>setup_filetype_json()
  autocmd FileType markdown              :call <SID>setup_filetype_markdown()
  autocmd FileType org                   :call <SID>setup_filetype_org()
  autocmd FileType typescript            :call <SID>setup_filetype_typescript()
  autocmd FileType vim,vifm              :call <SID>setup_filetype_vim()
  autocmd FileType help                  :call <SID>setup_filetype_help()
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

" Quick suspend.
nnoremap Z :suspend<cr>

" Folding.
nnoremap n nzzzv
nnoremap N Nzzzv
"nnoremap <space> zA
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
" nnoremap - ddp
" nnoremap _ ddkP

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

" Shortcut to close all temporary windows, turn off highlighting, and otherwise reset editing state.
nnoremap <localleader>l :noh<cr> \|
\ :cclose<cr> \|
\ :lclose<cr> \|
\ <plug>(ExchangeClear) \|
"\ <plug>(lsp-preview-close) \|
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
nmap <tab> <Plug>unimpairedBNext
nmap <S-tab> <Plug>unimpairedBPrevious
"nnoremap <leader>b :Buffers<cr>
nnoremap <leader>b :Clap buffers<cr>

nnoremap <localleader>bo :Bdelete other<cr>
nnoremap <localleader>bc :Bdelete this<cr>
nnoremap <localleader>bx :Bdelete all<cr>
nnoremap <localleader>bi :Bdelete select<cr>

" Buffer number keys.
nmap <leader>1 <Plug>lightline#bufferline#go(1)
nmap <leader>2 <Plug>lightline#bufferline#go(2)
nmap <leader>3 <Plug>lightline#bufferline#go(3)
nmap <leader>4 <Plug>lightline#bufferline#go(4)
nmap <leader>5 <Plug>lightline#bufferline#go(5)
nmap <leader>6 <Plug>lightline#bufferline#go(6)
nmap <leader>7 <Plug>lightline#bufferline#go(7)
nmap <leader>8 <Plug>lightline#bufferline#go(8)
nmap <leader>9 <Plug>lightline#bufferline#go(9)
nmap <leader>0 <Plug>lightline#bufferline#go(10)

" Recent files.
"nnoremap <leader>r :FZFMru<cr>
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

" Full-fledged file explorers.
nnoremap <leader>o :<c-u>MyToggleNERDTree<cr>
nnoremap - :Vifm<cr>

" Command history.
nnoremap <leader>c :<c-u>Clap command_history<cr>

" All commands.
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
"   setlocal completeopt+=preview

"   augroup lsp_close_popup
"     autocmd!
"     autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
"   augroup END
  
"   "inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : lsp#complete()
"   inoremap <expr> <cr>  pumvisible() ? "\<C-y>" : "\<cr>"
"   inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
"   inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

"   function! s:check_back_space() abort
"       let col = col('.') - 1
"       return !col || getline('.')[col - 1]  =~ '\s'
"   endfunction
"   inoremap <silent><expr> <TAB>
"     \ pumvisible() ? "\<C-n>" :
"     \ <SID>check_back_space() ? "\<TAB>" :
"     \ asyncomplete#force_refresh()

"   if has("gui_running")
"     inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"     inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"   endif
  
"   nmap <buffer> gd <plug>(lsp-definition)
"   nmap <buffer> gp <plug>(lsp-peek-definition)
"   nmap <buffer> gc <plug>(lsp-declaration)
"   nmap <buffer> gi <plug>(lsp-implementation)
"   nmap <buffer> gr <plug>(lsp-references)
"   nmap <buffer> gn <plug>(lsp-rename)
"   nmap <buffer> gh <plug>(lsp-hover)
"   nmap <buffer> gs <plug>(lsp-signature-help)
"   nmap <buffer> <localleader>o <plug>(lsp-document-symbol)
"   nmap <buffer> <localleader>O <plug>(lsp-workspace-symbol)
"   nmap <buffer> <localleader>q <plug>(lsp-document-diagnostics)
"   nmap <buffer> ]e <plug>(lsp-next-error)
"   nmap <buffer> [e <plug>(lsp-previous-error)
"   nmap <buffer> ]w <plug>(lsp-next-warning)
"   nmap <buffer> [w <plug>(lsp-previous-warning)
"   nmap <buffer> <localleader>a <plug>(lsp-code-action)
"   map <buffer> <localleader>gf <plug>(lsp-document-range-format)
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
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'WildMenu'],
  \ 'hl':      ['bg', 'Warning'],
  \ 'fg+':     ['fg', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['bg', 'Warning'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'WildMenu'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['bg', 'WildMenu'],
  \ 'gutter':  ['bg', 'WildMenu'] }
let g:fzf_preview_window = ''

autocmd! FileType fzf set laststatus=0 noshowmode noruler nonumber norelativenumber
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler number relativenumber

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
" if exists(":Tabularize")
"   nmap <teader>t= :Tabularize /=<CR>
"   vmap <teader>t= :Tabularize /=<CR>
"   nmap <teader>t: :Tabularize /:\zs<CR>
"   vmap <teader>t: :Tabularize /:\zs<CR>
" endif

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

" Vista.
let g:vista_default_executive = 'coc'

" Clap.
nnoremap <leader>t <c-u>:Clap tags<cr>

" COC.

" COC plugins.
let g:coc_global_extensions = [
\  'coc-explorer',
\  'coc-git',
\  'coc-gitignore',
\  'coc-yaml',
\  'coc-tsserver',
\  'coc-sql',
\  'coc-python',
\  'coc-prettier',
\  'coc-markdownlint',
\  'coc-lua',
\  'coc-json',
\  'coc-jest',
\  'coc-html',
\  'coc-docker',
\  'coc-xml',
\  'coc-webpack',
\  'coc-ultisnips',
\  'coc-toml',
\  'coc-yank',
\  'coc-tag',
\  'coc-swagger',
\  'coc-sh',
\  'coc-scssmodules',
\  'coc-rls',
\  'coc-omnisharp',
\  'coc-omni',
\  'coc-fsharp',
\  'coc-format-json',
\  'coc-emoji',
\ ]

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
       \ pumvisible() ? "\<C-n>" :
       \ <SID>check_back_space() ? "\<TAB>" :
       \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

 " Use <c-space> to trigger completion.
 if has('nvim')
   inoremap <silent><expr> <c-space> coc#refresh()
 else
   inoremap <silent><expr> <c-@> coc#refresh()
 endif
 
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for format selected region
xmap <leader>q  <Plug>(coc-format-selected)
nmap <leader>q  <Plug>(coc-format-selected)
 
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  "autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end


" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.3 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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

" Autocomplete (various).
let g:asyncomplete_auto_popup = 0
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

"let g:clap_layout = { 'relative': 'editor' }
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

" Smooth scrolling.
let g:SexyScroller_MinLines = 50
let g:SexyScroller_MinColumns = 200

" Plugin registry ---------------------------------------------------------{{{1

" Plug. 
"  execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" Essential plugins.
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'
Plug 'asheq/close-buffers.vim'
Plug 'brooth/far.vim'
Plug 'camflint/base16-vim'
"Plug 'camflint/onehalf', { 'rtp': 'vim' }
Plug 'camflint/vim-paraglide'
Plug 'camflint/vim-superman'
Plug 'chrisbra/Colorizer'
Plug 'christoomey/vim-tmux-navigator'
"Plug 'dkarter/bullets.vim' "Note: <CR> binding is conflicting with vim-clap
Plug 'dougbeney/pickachu'
Plug 'easymotion/vim-easymotion'
Plug 'faceleg/delete-surrounding-function-call.vim'
Plug 'fcpg/vim-fahrenheit'
Plug 'fcpg/vim-navmode'
Plug 'godlygeek/tabular'
Plug 'hiphish/info.vim'
Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'inkarkat/vim-PatternsOnText'
Plug 'inkarkat/vim-ingo-library'
Plug 'itchyny/calendar.vim'
Plug 'jceb/vim-orgmode'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
"Plug 'junegunn/vim-peekaboo'
"Plug 'liuchengxu/vim-clap'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'liuchengxu/vim-which-key'
Plug 'mattesgroeger/vim-bookmarks'
Plug 'mhinz/vim-grepper'
Plug 'mhinz/vim-startify'
" Plug 'ms-jpq/chadtree', { 'branch': 'chad' } "Note: getting err. on startup
Plug 'mtth/cursorcross.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'pbogut/fzf-mru.vim'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'puremourning/vimspector', {'for': ['typescript', 'javascript']}
Plug 'raimondi/delimitmate'
Plug 'rgarver/kwbd.vim'
Plug 'rhysd/clever-f.vim'
Plug 'romainl/vim-qf'
Plug 'sheerun/vim-polyglot'
Plug 'tomasr/molokai'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-endwise' "Note: <CR> binding is conflicting with vim-clap
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vifm/vifm.vim'
Plug 'vimwiki/vimwiki'
Plug 'wellle/targets.vim'
Plug 'whiteinge/diffconflicts'
Plug 'xolox/vim-misc'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --ts-completer' }
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'rakr/vim-one'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'morhetz/gruvbox'
"Plug 'joeytwiddle/sexy_scroller.vim'
Plug 'knubie/vim-kitty-navigator'
Plug 'liuchengxu/vista.vim'
"Plug 'ycm-core/lsp-examples', { 'do': './install.py --all', 'rtp': './lsp-examples/' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" For ycm-core/lsp-examples
"runtime './vimrc.generated'

" Note: this needs to come last in the plugin list.
Plug 'ryanoasis/vim-devicons'

" nvim-only plugins.
if has('nvim')
  Plug 'shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()


" Theme activation --------------------------------------------------------{{{1
"
" This color scheme setup relies on a base16-shell alias having been run to modify the shell's 256-color palette. Doing
" so should generate the following file for vim. Make sure this statement comes last, as our customization hook higher
" in the file depends on plugins being loaded.
" if filereadable(expand('~/.vimrc_background')) && !has('gui_running')
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" if !has('gui')
"   colorscheme tempus_summer

"   hi StatusLine ctermbg=07 ctermfg=08
"   hi StatusLineNC ctermbg=08 ctermfg=07
"   hi TabLineFill ctermfg=07 ctermbg=08
"   hi TabLineSel ctermfg=00 ctermbg=07
"   hi TabLine ctermfg=07 ctermbg=00
"   hi CursorLineNr ctermfg=253 ctermbg=08
"   hi User1 ctermfg=00 ctermbg=07
" endif

" Background transparency.
set background=dark
hi Normal guibg=NONE ctermbg=NONE

packadd! dracula_pro
let g:dracula_colorterm = 0
colorscheme dracula_pro

" let g:gruvbox_italic=1
" colorscheme gruvbox

