" vim: foldenable foldmethod=marker foldlevel=0
" General -----------------------------------------------------------------{{{1

" Use UTF-8 encoding by default.
set encoding=utf-8

" Make sure backspace/delete work as expected in INSERT mode.
set backspace=indent,eol,start

" Don't beep.
set visualbell

" Highlight the current row.
set cursorline

" Show line numbers.
set number
set relativenumber

" Keep the cursor column stable when moving around.
set nostartofline

" Allow the cursor to be positioned anywhere during visual block mode.
set virtualedit=block

" Break text at 120 characters per line, including when formatting.
set textwidth=120

" When a bracket is inserted, briefly jump to the matching one.
set showmatch

" Silence most enter-to-confirm prompts.
"  a = use a lot of abbreviations in messages (e.g. "[+]" instead of "modified")
"  c = don't give insert completion messages (recommended by asyncomplete)
"  I = don't give intro message when starting Vim.
"  T = truncate messages if they are too long to fit on the command line
set shortmess=acIT

" Give more space for displaying messages.
set cmdheight=2

" Read modelines (like the one at the top of this file).
set modelines=1

" Set leader keys (must be done before any mappings are made).
let g:mapleader = '\'
let g:maplocalleader = ','

" Indentation -------------------------------------------------------------{{{1

" Insert spaces instead of tabs, including when auto-indenting.
set expandtab

" Don't double-space.
set nojoinspaces

" Use 2 spaces in place of 1 tab.
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Copy indent from current line when starting a new line.
set autoindent

" Visually indent wrapped lines, with a ↳ symbol prefixed.
set breakindent
set breakindentopt=shift:2
set showbreak=↳

" Visually show tab characters.
set list
set listchars=tab:→-

" Folding -----------------------------------------------------------------{{{1

" Don't fold until enabled (e.g. with 'zi').
set nofoldenable

" Set default 'foldlevel'. (Ignored by diff-mode.)
set foldlevelstart=2

" Use indentation level to detect folds.
set foldmethod=indent

" Mapping: Close all folds except under cursor.
nnoremap <localleader>z zMzvzz

" Mapping: Automatically unfold to cursor when searching forward/backward.
nnoremap n nzzzv
nnoremap N Nzzzv

" Mouse and selection -----------------------------------------------------{{{1

" Enable mouse in all editing modes (normal, visual, insert, command, ...).
set mouse=a

" Right mouse button opens popup instead of extending the visual selection.
set mousemodel=popup

" Enter special SELECT mode instead of VISUAL mode when using the mouse.
set selectmode=mouse

" Scrolling ---------------------------------------------------------------{{{1

" Scroll N lines at a time rather than default, which is half-window.
set scroll=7

" Make sure we can always see 5 lines of context around the cursor.
set scrolloff=5

" Mapping: enter navmode for less-like scrolling (requires vim-navmode).
nnoremap <localleader>n :call Navmode()<cr>

" Saving and quitting -----------------------------------------------------{{{1

" Automatically save before commands like :next and :make.
set autowrite

" Don't automatically add <EOL> to the file (preserve existing).
if exists('&fixeol')
    set nofixeol
endif

" Mapping: Quick suspend.
nnoremap Z :suspend<cr>

" Mapping: Quick with <C-q>.
nnoremap <C-q> :q<cr>

" Mapping: Save with <C-s>. 
"  :update is more efficient than :w
inoremap <C-s> <C-O>:update<cr>
nnoremap <C-s>      :update<cr>

" Undo/redo ---------------------------------------------------------------{{{1

if has('persistent_undo')
  " Preserve undo/redo history even when switching buffers.
  set undofile

  " Save undofiles to XDG_DATA_HOME instead of cwd.
  "  Ensure the directory exists and is not readable to other users.
  set undodir=~/.local/share/vim/undo//
  call mkdir(&undodir, 'p', '0o700')
endif

" Backup and restore ------------------------------------------------------{{{1

" Disable backups when overwriting files.
set nobackup

" Save swapfiles only to XDG_DATA_HOME instead of cwd.
"  Ensure the directory exists and is not readable to other users.
set directory=~/.local/share/vim/backup//
call mkdir(&directory, 'p', '0o700')

" Rename-and-write instead of copy-and-write to preserve links when possible.
set backupcopy=auto

" Performance tweaks ------------------------------------------------------{{{1

" Reduce timeout length by half.
set timeoutlen=500

" Stop highlighting for long columns (like XML files).
set synmaxcol=1000

" Update swapfile more frequently to prevent long delays (?).
set updatetime=300

" Don't redraw when executing macros.
set lazyredraw

" Command-mode completion -------------------------------------------------{{{1

" Enable command-line completion with <Tab> char.
set wildmenu
set wildcharm=<Tab>

" Use a pop-up menu to display suggestions.
set wildoptions=pum

" Don't autocomplete files in these directories.
set wildignore+=*/node_modules/*,*.swp,*.*~

" Don't autoselect the first option (list first, then select full match).
"set wildmode=list,full

" Insert-mode completion --------------------------------------------------{{{1

" NOTE: The following rely on the asyncomplete plugin.

" Wait ever-so-slightly longer before showing the popup when typing.
let g:asyncomplete_popup_delay = 50

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Mapping: <Tab> and <S-Tab> to control popup menu selections.
"  <Tab> will also force-show completions if the pum isn't already visible.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Mapping: <Enter> accepts the selected candidate and closes the popup.
inoremap <expr> <cr>   pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Don't search include files (uncomment if needed for performance).
"set complete-=i

" See 'LSP' section below for advanced completion settings.

" Buffers -----------------------------------------------------------------{{{1

" Allow switching away from a dirty buffer without saving.
set hidden

" Automatically reload the buffer when the filsystem changes.
" Does not reload when the file is deleted, so in-memory changes aren't lost.
set autoread

" Mapping: quickly switch to next and prev buffers (requires vim-unimpaired).
"  ]b - next buffer
"  [b - prev buffer

" Mapping: Fuzzy-search buffers (requires fzf plugin).
nnoremap <leader>b :Buffers<cr>

" Mapping: Manipulate buffers (requires close-buffers plugin).
nnoremap <localleader>bo :Bdelete other<cr>
nnoremap <localleader>bc :Bdelete this<cr>
nnoremap <localleader>bx :Bdelete all<cr>
nnoremap <localleader>bi :Bdelete select<cr>

" Mapping: rewrite :bd to :Kwbd, so that current window doesn't close.
cabbrev bd <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Kwbd' : 'bd')<cr>

" Windows and splits ------------------------------------------------------{{{1

" More natural new split opening.
set splitright
set splitbelow

" Mapping: Split vertically.
nnoremap <localleader>s- <C-w>s<C-w>j

" Mapping: Split horizontally.
nnoremap <localleader>s<pipe> <C-w>v<C-w>l

" Mapping: Split horizontally (lazy fingers).
nnoremap <localleader>s\ <C-w>v<C-w>l

" Mapping: Kill split.
nnoremap <localleader>sx <C-w>q

" Mapping: Kill other splits ("only").
nnoremap <localleader>so <C-w>o

" Mapping: Zoom/maximize split.
nnoremap <localleader>sz <C-w>\|<C-w>_

" Mapping: Distribute splits equally.
nnoremap <localleader>s= :set equalalways<cr> \|
  \ <C-w>= \|
  \ :set noequalalways<cr>

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

" Mapping: Swap this and the last window.
nnoremap <localleader>ss <C-c>:call WinBufSwap()<cr> |

" Files -------------------------------------------------------------------{{{1

" NERDTree config.
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

" Special handling for two open/close situations:
"  1. if vim is opened to a directory, then automatically show the NERDTree.
"  2. if only remaining open buffer is NERDTree, then quit.
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
augroup files_setup
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * call s:handle_open_with_dir_arg()
  autocmd BufEnter * call s:handle_close_with_single_buffer_remaining()
augroup END

" Return to the last edit position when opening files.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Mapping: toggle NERDTree.
nnoremap <leader>n :MyToggleNERDTree<cr>

" Mapping: Toggle file explorer (requires vifm plugin and binary).
nnoremap - :Vifm<cr>

" Mapping: Fuzzy-find files (requires fzf plugin).
"  Also map <C-p> to fuzzy-find since that's idomatic.
nnoremap <leader>f :Files<cr>
nnoremap <C-p> :Files<cr>

" Mapping: Fuzzy-find git files (requires fzf plugin).
nnoremap <leader>g :GFiles<cr>

" Mapping: Fuzzy-find recent files (requires fzf plugin).
nnoremap <leader>r :History<cr>

" Mapping: Fuzzy-find files relative to current file's directory.
command! -bang RelativeFiles call fzf#vim#files(expand('%:p:h'), <bang>0)
nnoremap <leader><leader>f :RelativeFiles<cr>

" Filetypes ---------------------------------------------------------------{{{1

" Filetype: help
function! s:setup_filetype_help()
  " Don't show hidden chars, since helpfiles contain a lot of tabs.
  setlocal nolist
endfunction

" Filetype: vim
function! s:setup_filetype_vim()
  setlocal foldenable
  setlocal foldmethod=marker
  setlocal foldlevelstart=0
  setlocal foldlevel=0
  setlocal textwidth=80
  "call <SID>setup_code_general()
endfunction

augroup setup_filetypes
  autocmd!
  "autocmd FileType javascript,typescript :call <SID>setup_filetype_javascript()
  "autocmd FileType json                  :call <SID>setup_filetype_json()
  "autocmd FileType markdown              :call <SID>setup_filetype_markdown()
  "autocmd FileType org                   :call <SID>setup_filetype_org()
  "autocmd FileType typescript            :call <SID>setup_filetype_typescript()
  autocmd FileType help                  :call <SID>setup_filetype_help()
  autocmd FileType vim,vifm              :call <SID>setup_filetype_vim()
  "autocmd FileType python                :call <SID>setup_filetype_python()
augroup end

" Always re-apply filetype settings when .vimrc is sourced (because sourcing
"  .vimrc may potentially overwrite global settings).
execute 'set filetype=' . &filetype

" Copy and paste ----------------------------------------------------------{{{1

" In visual mode make Vim try to use the windowing system's global selection
" so that yanked text can be pasted into other programs.
set clipboard+=autoselect
set guioptions+=a

" Don't move cursor after yanking.
xmap y ygv<esc>

" Yank to system clipboard.
map <localleader>yy "+y

" Yank current buffer path to system clipboard.
map <localleader>yb :let @+=expand('%:p')<CR>

" Paste from the system clipboard, performing indentation.
map <localleader>pp "+[p

" Find and replace --------------------------------------------------------{{{1

" Ignore case unless mixed case is present in search query.
set ignorecase smartcase

" Use global substitution.
set gdefault

" Search as characters are typed rather than requiring <cr>.
set incsearch

" Only enable 'hlsearch' when focused on the command line.
augroup ModalHighlightSearch
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

" Mapping: Use very-magic search mode, so regular expressions are more intuitive.
nnoremap / /\v
vnoremap / /\v

" Find and replace (in files) ---------------------------------------------{{{1

" Mapping: fuzzy search (requires fzf plugin and rg binary).
nnoremap <leader>s :Rg<cr>

" Mapping: fuzzy search word under cursor.
command! -bang CurrentWordGrep
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(expand('<cword>')),
  \   1,
  \   fzf#vim#with_preview(),
  \   <bang>0
  \ )
nnoremap K :CurrentWordGrep<cr>

" Mapping: fuzzy search relative to current file's directory.
command! -bang -nargs=* RelativeGrep
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>).' '.expand('%:p:h'),
  \   1,
  \   fzf#vim#with_preview(),
  \   <bang>0
  \ )
nnoremap <leader><leader>s :RelativeGrep<cr>

" Mapping: Fuzzy search only files tracked by current git project.
command! -bang -nargs=* GitGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.fzf#shellescape(<q-args>),
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}),
  \   <bang>0
  \ )
nnoremap <leader><leader>g :GitGrep<cr>

" Diff and merge ----------------------------------------------------------{{{1

" Use vertical splits.
set diffopt+=vertical

" Don't show context lines.
set diffopt+=context:0

" Show filler lines in order to 'sync' text alignment between windows.
set diffopt+=filler

" Execute :diffoff when there is only one window remaining.
set diffopt+=closeoff

" Use bundled diffing algorithm if available. Note that Apple removes it.
if has('mac') && $VIM == '/usr/share/vim'
  set diffopt-=internal
elseif has("patch-8.1.0360")
  set diffopt+=algorithm:patience,indent-heuristic
endif

" Keymaps.
nnoremap dg1 :diffget 1<cr>
nnoremap dg2 :diffget 2<cr>
nnoremap dg3 :diffget 3<cr>
nnoremap <leader>do :diffoff<cr>

" Quickfix ----------------------------------------------------------------{{{1

" Mapping: show quickfix list.
nnoremap <localleader>q :copen<cr>

" Mapping: Close the {quickfix, location} windows, turn off highlighting, and reset editing states.
nnoremap <localleader>l :noh<cr> \|
  \ :cclose<cr> \|
  \ :lclose<cr>
  "\ <plug>(lsp-preview-close) \|

" Code navigation ---------------------------------------------------------{{{1

" Mapping: Fuzzy-search tags.
nnoremap <leader>t :Tags<cr>

" Mapping: Fuzzy-search tags scoped to current buffer.
nnoremap <leader><leader>t :BTags<cr>

" Code formatting ---------------------------------------------------------{{{1

" Smart comment formatting (when using 'gq').
set formatoptions=croqj

" Mapping: <F3> to run autoformat (requires vim-autoformat).
nnoremap <F3> :Autoformat<cr>

" Mapping: <F5> to compile.
nnoremap <F5> :Compile<cr><cr>

" Mapping: <F12> to go-to-definition
" TODO

" Status line -------------------------------------------------------------{{{1

" Always show the status line.
set laststatus=2

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

" Customize the status line.
set statusline=%-10.25(%#User1#%{StatuslineFilename()}%#TabLineFill#\ %{StatuslineBufferIndex()}%)%=%m%r\ %y\ %l:%c\ %p%%

" Tab line ----------------------------------------------------------------{{{1

" Only show the tab line if there are at least two tab pages.
set showtabline=1

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

" Customize the tab line.
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

" GUI ---------------------------------------------------------------------{{{1

if has("gui_running")
    " Use console tab pages and dialogs.
    guioptions-=e
    guioptions+=c

    " Remove toolbar and menubar.
    guioptions-=Tm

    " Set font.
    set guifont=BerkeleyMono\ Nerd\ Font\ 13,Berkeley\ Mono\ 13
endif

if has("gui_macvim")
    " Make the Option key act like Meta.
    set macmeta
endif

" External commands -------------------------------------------------------{{{1

" Mapping: search for pattern in files using ripgrep, then open result in
"  scratch buffer (requires vim-shout and rg binary)
command! -nargs=1 Find Sh! rg -nS --column "<args>" .

" Function: Redir
"  https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" General mappings --------------------------------------------------------{{{1

" Map ':' to ';'
nnoremap ; :
nnoremap <localleader>; ;
nnoremap <localleader>, ,

" More natural, i.e. visual linewise movement.
nnoremap <expr> j v:count ? (v:count > 5 ? "m'" . v:count : '') . 'j' : 'gj'
nnoremap <expr> k v:count ? (v:count > 5 ? "m'" . v:count : '') . 'k' : 'gk'

" Select only text and not prefix/suffix whitespace (contrast with V).
nnoremap vv ^v$

" Macros - qq to record, Q to replay.
"  Also overwrites ex mode shortcut, as I don't use it.
nnoremap Q @q

" Fast config editing and reloading.
" Note explicit path for editing, since $MYVIMRC only sources ~/.vimrc.
nnoremap <leader>ve :vsplit ~/.vimrc<cr>
nnoremap <leader>vr :so $MYVIMRC<cr>

" Command-mode history shortcuts (avoids using arrow keys).
cnoremap <c-n> <down>
cnoremap <c-p> <up>

" Uppercase the current word, without changing the cursor position or mode.
inoremap <c-u> <esc>viwU`^i

" Move lines up and down (disabled because conflicts with '-' to open file
" explorer).
" nnoremap - ddp
" nnoremap _ ddkP

" Readline-style key bindings (from rsi.vim).
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
cnoremap        <M-b> <S-Left>
cnoremap        <M-f> <S-Right>
silent! exe "set <S-Left>=\<Esc>b"
silent! exe "set <S-Right>=\<Esc>f"

" Plugin: Startify --------------------------------------------------------{{{1

let g:startify_change_to_dir = 0
let g:startify_files_number = 7
let g:startify_enable_special = 0
let g:startify_custom_header = [
  \ '            _          ',
  \ '    _   __ (_)____ ___ ',
  \ '   | | / // // __ `__ \',
  \ '   | |/ // // / / / / /',
  \ '   |___//_//_/ /_/ /_/ ',
  \ ' ',
\ ]

" Plugin: FZF -------------------------------------------------------------{{{1

" Use XDG_DATA_HOME for fzf history.
let g:fzf_history_dir = expand('~/.local/share/vim/fzf')

" Disable preview window for most commands (easier to see the file path).
let g:fzf_preview_window = ''

" Plugin: QF -------------------------------------------------------------{{{1

" QF
" Enable ack-style mappings:
"  s - open entry in a new horizontal window
"  v - open entry in a new vertical window
"  t - open entry in a new tab
"  o - open entry and come back
"  O - open entry and close the location/quickfix window
"  p - open entry in a preview window
let g:qf_mapping_ack_style=1

" Plugin: Easymotion ------------------------------------------------------{{{1

let g:EasyMotion_do_mapping = 0       " disable default mappings
let g:EasyMotion_startofline = 0      " keep cursor column when JK motion
let g:EasyMotion_use_upper = 1        " use uppercase target labels and type as a lower case
let g:EasyMotion_smartcase = 1        " type `l` and match `l`&`L`
let g:EasyMotion_use_smartsign_us = 1 " use smartsign (type `3` and match `3`&`#`)

" Mapping: Use <space> to trigger Easymotion.
nnoremap <space> <Plug>(easymotion-prefix)

" Plugin: LSP -------------------------------------------------------------{{{1

" NOTE: The following rely on vim-lsp, which complements asyncomplete. These
"  LSP settings overlap the basic insert-mode completion settings above.

" Configure basic LSP settings.
let g:lsp_settings_servers_dir = expand('~/.local/share/vim/lsp/')
let g:lsp_completion_resolve_timeout = 10
let g:lsp_format_sync_timeout = 500
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 0

" Disable LSP folding due to performance issues.
let g:lsp_fold_enabled = 0

function! s:setup_my_lsp()
    " Use LSP for insert-mode omni completion.
    setlocal omnifunc=lsp#complete

    " Use LSP for tag generation.
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

    " Make room for warning and error symbols.
    setlocal signcolumn=yes
    
    " Pop-up menu customizations for LSP.
    "  (Note that these override asynccomplete's).
    "  menuone = show pum even if there's only one option, in order to see contextual info.
    "  noinsert = don't auto-insert a suggestion.
    "  noselect = don't auto-select the first completion (exclude this one).
    "  preview = show contextual info about the currently-selected completion.
    setlocal completeopt=menuone,noinsert,preview

    " LSP mappings.
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
endfunction

" When LSP is enabled on a buffer, call setup_my_lsp().
augroup lsp_setup
    autocmd!
    autocmd User lsp_buffer_enabled call <SID>setup_my_lsp()
augroup end

" Uncomment these for debugging language servers.
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/.local/share/vim/lsp/vim-lsp.log')

let g:lsp_diagnostics_enabled = !&diff
augroup lsp_diag_diff
  autocmd!
  autocmd OptionSet diff let g:lsp_diagnostics_enabled = !&diff
augroup end

" Plugin: Tabularize ------------------------------------------------------{{{1

" Mappings: Convenience mappings for '=' and ':'.
nmap <localleader>t= :Tabularize /=<CR>
vmap <localleader>t= :Tabularize /=<CR>
nmap <localleader>t: :Tabularize /:\zs<CR>
vmap <localleader>t: :Tabularize /:\zs<CR>

" Plugins -----------------------------------------------------------------{{{1

" Plug plugin manager (bootstrap).
"  execute :PlugInstall to install the following list for the first time.
call plug#begin('~/.local/share/vim/plugged')

" vim-startify: welcome banner.
Plug 'mhinz/vim-startify'

" vim-commentary: advanced comment/uncomment with motions.
Plug 'tpope/vim-commentary'

" vim-eunuch: add Unix commands like :Remove, :Delete, :Move, :Chmod, etc.
Plug 'tpope/vim-eunuch'

" vim-repeat: let '.' work with commands that are mapped to plugin functions.
Plug 'tpope/vim-repeat'

" vim-surround: operate on surrounding quotes/parens/brackets/etc.
Plug 'tpope/vim-surround'

" vim-unimpaired: bracket-prefix mappings like ]a, ]q, ]b, etc.
Plug 'tpope/vim-unimpaired'

" vim-vinegar: better netrw.
Plug 'tpope/vim-vinegar'

" vim-speeddating: use <C-A>/<C-X> to manipulate dates.
Plug 'tpope/vim-speeddating'

" vim-navmode: modal navigation without the key chords (e.g. u instead of <C-u>).
Plug 'fcpg/vim-navmode'

" vim-qf: quickfix window powertools.
Plug 'romainl/vim-qf'

" vim-peekabo: preview contents of registers when pressing `"` or `@`.
Plug 'junegunn/vim-peekaboo'

" vim-easymotion: jump to anywhere in a buffer by typing characters.
Plug 'easymotion/vim-easymotion'
"Plug 'justinmk/vim-sneak'

" vim-shout: execute external commands and capture output into a scratch buffer.
Plug 'habamax/vim-shout', { 'branch': 'main' }

" vim-polyglot: ???
Plug 'sheerun/vim-polyglot'

" nerdtree: File explorer.
Plug 'preservim/nerdtree'

" vifm: Vim-like file explorer (requires vifm binary).
Plug 'vifm/vifm.vim'

" fzf and fzf.vim: fuzzy-finder integration (requires 'fzf' binary).
" See: https://github.com/junegunn/fzf/blob/master/README-VIM.md
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" targets: adds lots of text targets. ???
Plug 'wellle/targets.vim'

" close-buffers: adds :Bdelete command for manipulating buffers in bulk.
Plug 'asheq/close-buffers.vim'

" kwbd: don't close a window/split when its last buffer is closed.
Plug 'rgarver/kwbd.vim'

" Shell/environment integrations.
Plug 'christoomey/vim-tmux-navigator'
"Plug 'knubie/vim-kitty-navigator'

" vim-autoformat: code formatting support for various languages.
Plug 'Chiel92/vim-autoformat'

" Tabular: mappings to align text in columns.
Plug 'godlygeek/tabular'

" Async, Asynccomplete, vim-lsp, and vim-settings: LSP for code nav,
"  formatting, autocomplete, and more.
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" rose-pine: favorite light theme.
"  https://rosepinetheme.com/
Plug 'rose-pine/vim'

" Note: this needs to come last in the plugin list.
"Plug 'ryanoasis/vim-devicons'

call plug#end()

" Color scheme & themes ---------------------------------------------------{{{1

" Enable 24-bit (RGB) color support when available. When set, Vim issues RGB
" color escape codes with the values from gui, guifg, guibg, etc.
if exists('+termguicolors') && $TERM !~# '\v^(screen|rxvt)'
  set termguicolors
endif

set background=light
colorscheme rosepine_dawn
