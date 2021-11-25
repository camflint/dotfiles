" Font.
set guifont=UbuntuMono\ Nerd\ Font:h18

" Hide the GUI chrome.
set guioptions=ac

" Window dimensions.
set lines=50
set columns=140

function! s:updatetitlestring() 
  let name=has('gui_macvim') ? 'MacVim' : 'Vim'
  let dir=pathshorten(fnamemodify(getcwd(), ':~'))
  let buffer=expand('%:t')
  if !empty(dir)
    let base=name . ' [' . dir . ']'
  else
    let base=name
  endif
  if !empty(buffer)
    let &g:titlestring=base . ' - ' . buffer
  else
    let &g:titlestring=base
  endif
endfunction
augroup setup_titlestring
autocmd!
autocmd BufEnter,BufWritePost,DirChanged * call <SID>updatetitlestring()
augroup END

" Make fonts look better on Mac OS.
if has('mac')
  " Uncomment this line for PragmataProMono font, else leave as is.
  "set macthinstrokes
endif

if has ("gui_macvim")
  " Make the Option key act like Meta.
  set macmeta

  " Custom start text.
  let g:startify_custom_header = [
    \ '                           _',
    \ '                          (_)',
    \ '   ____  _____  ____ _   _ _ ____',
    \ '  |    \(____ |/ ___) | | | |    \',
    \ '  | | | / ___ ( (___ \ V /| | | | |',
    \ '  |_|_|_\_____|\____) \_/ |_|_|_|_|',
    \ '   ',
  \ ]
endif

" Scroll whichever window the mouse is over.
set scrollfocus

" Colorscheme override for GUI.
