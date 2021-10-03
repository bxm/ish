" https://jdhao.github.io/2019/11/03/vim_custom_statusline/
let g:modes={
  \ 'n'  : 'NORM',
  \ 'v'  : 'VIS',
  \ 'V'  : 'VLine',
  \ "\<C-V>" : 'VBlk',
  \ 'i'  : 'INS',
  \ 'R'  : 'Rep',
  \ 'r'  : 'Rep',
  \ 'Rv' : 'VRep',
  \ 'c'  : 'Cmd',
\} " g:modes

let space=' '
set statusline= " clear
set statusline+=%1*[%t]%* " short filename
set statusline+=%3*%{&modified?'[+]':''}%* " mod'd
set statusline+=%4*%{&modified?'':'[=]'}%* " unmod'd

set statusline+=%9*%{space}%* " dead space
set statusline+=%= " expanding space
set statusline+=[%{tolower(g:modes[mode()])} " mode
set statusline+=%{&paste?':p':''}] " set paste
set statusline+=%= " expanding space
set statusline+=%9*%{space}%* " dead space

set statusline+=%2*%y%* " filetype
set statusline+=%3*%r%* " readonly
set statusline+=%5*[%3l/%L]%* " position

" Colorise line numbers in insert and visual modes
" ------------------------------------------------
" https://stackoverflow.com/questions/15561132/run-command-when-vim-enters-visual-mode
function! SetStatusLineColorInsert(mode)
  if a:mode == "i"
    highlight StatusLine ctermbg=56

  elseif a:mode == "r"
    highlight StatusLine ctermbg=1

  endif
endfunction


function! SetStatusLineColorVisual()
  set updatetime=0

  highlight StatusLine ctermbg=202
  return 'lh'
endfunction


function! ResetStatusLineColor()
  set updatetime=4000
  highlight StatusLine ctermfg=15 ctermbg=0
endfunction

vnoremap <silent> <expr> <SID>SetStatusLineColorVisual SetStatusLineColorVisual()
nnoremap <silent> <script> v v<SID>SetStatusLineColorVisual
nnoremap <silent> <script> V V<SID>SetStatusLineColorVisual
nnoremap <silent> <script> <C-v> <C-v><SID>SetStatusLineColorVisual

augroup StatusLineColorSwap
  autocmd!
  autocmd InsertEnter * call SetStatusLineColorInsert(v:insertmode)
  autocmd InsertLeave * call ResetStatusLineColor()
  autocmd CursorHold * call ResetStatusLineColor()
augroup END
