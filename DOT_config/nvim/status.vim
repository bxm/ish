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
function! DefaultColour()
    highlight StatusLine ctermfg=white ctermbg=black cterm=bold
endfunction
function! InsertColour(mode)
  if     a:mode == 'i'
    highlight StatusLine ctermbg=56 ctermfg=white
  elseif a:mode == 'r'
    highlight StatusLine ctermbg=1 ctermfg=white
  endif
endfunction
augroup StatusLineColour
  autocmd!
  autocmd InsertEnter  * call InsertColour(v:insertmode)
  autocmd InsertChange * call InsertColour(v:insertmode)
  autocmd InsertLeave  * call DefaultColour()
augroup END
" no good for visual, duh
" https://stackoverflow.com/questions/15561132/run-command-when-vim-enters-visual-mode

let space=' '
set statusline= " clear
set statusline+=%1*[%t]%* " short filename
set statusline+=%3*%{&modified?'[+]':''}%* " mod'd
set statusline+=%4*%{&modified?'':'[=]'}%* " unmod'd

"set statusline+=%#Paste# " set paste

set statusline+=%9*%{space}%* " dead space
set statusline+=%= " expanding space
set statusline+=[%{tolower(g:modes[mode()])} " mode
set statusline+=%{&paste?':p':''}] " set paste
"set statusline+=%{mode()=='i'?&paste?'+pst':'':''}] " paste if in insert

set statusline+=%= " expanding space
set statusline+=%9*%{space}%* " dead space
"set statusline+=%2*[%{&ft}]%* " filetype
set statusline+=%2*%y%* " filetype
set statusline+=%3*%r%* " readonly
set statusline+=%5*[%c,%l/%L]%* " position


